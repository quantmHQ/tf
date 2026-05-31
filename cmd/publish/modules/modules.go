package modules

import (
	"archive/zip"
	"bytes"
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

type (
	Module struct {
		Cloud string
		Name  string
		Path  string
	}
)

func (m Module) Archive() (*bytes.Buffer, int, error) {
	buf := &bytes.Buffer{}
	w := zip.NewWriter(buf)

	var count int

	err := filepath.Walk(m.Path, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		if info.IsDir() {
			return nil
		}

		rel, err := filepath.Rel(m.Path, path)
		if err != nil {
			return err
		}

		if strings.HasPrefix(rel, ".") || strings.HasPrefix(rel, ".terraform") {
			return nil
		}

		data, err := os.ReadFile(path)
		if err != nil {
			return err
		}

		f, err := w.Create(rel)
		if err != nil {
			return err
		}

		if _, err := f.Write(data); err != nil {
			return err
		}

		count++

		return nil
	})
	if err != nil {
		return nil, 0, err
	}

	if err := w.Close(); err != nil {
		return nil, 0, err
	}

	return buf, count, nil
}

func Discover(root string) ([]Module, error) {
	var result []Module

	for _, cloud := range []string{"aws", "gcp"} {
		dir := filepath.Join(root, cloud)

		entries, err := os.ReadDir(dir)
		if err != nil {
			return nil, fmt.Errorf("read %s: %w", dir, err)
		}

		for _, entry := range entries {
			if !entry.IsDir() {
				continue
			}

			modPath := filepath.Join(dir, entry.Name())
			if !hasTerraformFiles(modPath) {
				continue
			}

			result = append(result, Module{
				Cloud: cloud,
				Name:  entry.Name(),
				Path:  modPath,
			})
		}
	}

	return result, nil
}

func hasTerraformFiles(dir string) bool {
	entries, err := os.ReadDir(dir)
	if err != nil {
		return false
	}

	for _, e := range entries {
		if strings.HasSuffix(e.Name(), ".tf") || strings.HasSuffix(e.Name(), ".tofu") {
			return true
		}
	}

	return false
}
