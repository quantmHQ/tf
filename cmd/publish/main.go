package main

import (
	"bytes"
	"context"
	"fmt"
	"log"
	"os"
	"os/exec"
	"strings"

	ocispec "github.com/opencontainers/image-spec/specs-go/v1"
	"golang.org/x/oauth2"
	"golang.org/x/oauth2/google"
	"oras.land/oras-go/v2"
	"oras.land/oras-go/v2/content/memory"
	"oras.land/oras-go/v2/registry/remote"
	"oras.land/oras-go/v2/registry/remote/auth"

	"go.breu.io/tfmods/cmd/publish/modules"
)

type (
	Config struct {
		projectID    string
		region       string
		registryName string
	}
)

func loadConfig() Config {
	return Config{
		projectID:    envordie("PROJECT_ID"),
		region:       envordie("REGION"),
		registryName: envordie("REGISTRY_NAME"),
	}
}

func envordie(key string) string {
	v := os.Getenv(key)
	if v == "" {
		log.Fatalf("required env var %s is not set", key)
	}

	return v
}

func (c Config) registryHost() string {
	return fmt.Sprintf("%s-docker.pkg.dev", c.region)
}

func (c Config) repositoryBase() string {
	return fmt.Sprintf("%s/%s/%s", c.registryHost(), c.projectID, c.registryName)
}

func shorthash() string {
	out, err := exec.Command("git", "rev-parse", "--short", "HEAD").Output()
	if err != nil {
		log.Fatalf("failed to get git short hash: %v", err)
	}

	return strings.TrimSpace(string(out))
}

func newAuthClient(ctx context.Context) (*auth.Client, error) {
	creds, err := google.FindDefaultCredentials(ctx, "https://www.googleapis.com/auth/cloud-platform")
	if err != nil {
		return nil, fmt.Errorf("failed to find default credentials: %w", err)
	}

	ts := oauth2.ReuseTokenSource(nil, creds.TokenSource)

	return &auth.Client{
		Credential: func(ctx context.Context, hostport string) (auth.Credential, error) {
			tok, err := ts.Token()
			if err != nil {
				return auth.EmptyCredential, err
			}

			return auth.Credential{
				AccessToken: tok.AccessToken,
			}, nil
		},
	}, nil
}

func push(ctx context.Context, cfg Config, mod modules.Module, zipData *bytes.Buffer, tag string, authClient *auth.Client) error {
	repoRef := fmt.Sprintf("%s/%s/%s", cfg.repositoryBase(), mod.Cloud, mod.Name)

	repo, err := remote.NewRepository(repoRef)
	if err != nil {
		return fmt.Errorf("create repo ref: %w", err)
	}

	repo.Client = authClient

	store := memory.New()

	blob, err := oras.PushBytes(ctx, store, "archive/zip", zipData.Bytes())
	if err != nil {
		return fmt.Errorf("stage blob: %w", err)
	}

	manifest, err := oras.PackManifest(ctx, store, oras.PackManifestVersion1_1,
		"application/vnd.opentofu.modulepkg",
		oras.PackManifestOptions{
			Layers: []ocispec.Descriptor{blob},
		},
	)
	if err != nil {
		return fmt.Errorf("pack manifest: %w", err)
	}

	_, err = oras.Copy(ctx, store, manifest.Digest.String(), repo, tag, oras.CopyOptions{})
	if err != nil {
		return fmt.Errorf("push to registry: %w", err)
	}

	return nil
}

func run(ctx context.Context) error {
	cfg := loadConfig()
	tag := shorthash()

	root, err := os.Getwd()
	if err != nil {
		return err
	}

	mods, err := modules.Discover(root)
	if err != nil {
		return err
	}

	if len(mods) == 0 {
		return fmt.Errorf("no modules found")
	}

	fmt.Printf("discovered %d modules\n", len(mods))

	authClient, err := newAuthClient(ctx)
	if err != nil {
		return err
	}

	var failed int

	for _, mod := range mods {
		zipBuf, fileCount, err := mod.Archive()
		if err != nil {
			fmt.Printf("  x %s/%s: zip failed: %v\n", mod.Cloud, mod.Name, err)

			failed++

			continue
		}

		if err := push(ctx, cfg, mod, zipBuf, tag, authClient); err != nil {
			fmt.Printf("  x %s/%s: push failed: %v\n", mod.Cloud, mod.Name, err)

			failed++

			continue
		}

		fmt.Printf("  ok %s/%s (%d files, %.1f KB) -> :%s\n",
			mod.Cloud, mod.Name, fileCount, float64(zipBuf.Len())/1024, tag)
	}

	fmt.Printf("\npublished %d/%d modules as :%s\n", len(mods)-failed, len(mods), tag)

	if failed > 0 {
		return fmt.Errorf("%d modules failed", failed)
	}

	return nil
}

func main() {
	ctx := context.Background()
	if err := run(ctx); err != nil {
		log.Fatal(err)
	}
}
