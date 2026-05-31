// Package modules discovers and archives OpenTofu/OCI module directories.
//
// A module is any directory containing files with .tf or .tofu extensions.
// Modules are organized under cloud-provider subdirectories (e.g., aws/, gcp/).
package modules

import (
	"archive/zip"
	"bytes"
	"fmt"
	"log/slog"
	"os"
	"path/filepath"
	"strings"
)

// Module represents a discovered infrastructure module directory.
type (
	Module struct {
		// Cloud is the cloud provider subdirectory (e.g., "aws", "gcp").
		Cloud string
		// Name is the directory name of the module.
		Name string
		// Path is the absolute filesystem path to the module directory.
		Path string
	}
)

// Archive creates an in-memory zip of the module directory contents.
// It returns the zip buffer, the number of files archived, or an error.
// Dotfiles and .terraform directories are excluded.
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

// Discover scans the root directory for cloud-provider subdirectories (aws/, gcp/)
// and collects all module directories containing .tf or .tofu files.
// Each discovered module is logged via slog.Info.
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
			if !hastf(modPath) {
				continue
			}

			result = append(result, Module{
				Cloud: cloud,
				Name:  entry.Name(),
				Path:  modPath,
			})

			slog.Info("discovered module", "cloud", cloud, "name", entry.Name())
		}
	}

	return result, nil
}

// hastf reports whether a directory contains .tf or .tofu files.
func hastf(dir string) bool {
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
