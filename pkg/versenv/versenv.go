package versenv

import (
	"context"
	"errors"
	"fmt"
	"os"
	"strings"

	"github.com/hakadoriya/z.go/cliz"
	"github.com/hakadoriya/z.go/errorz"
	"github.com/versenv/versenv/pkg/internal/exec"
	"gopkg.in/yaml.v3"
)

var (
	ErrRepositoryHasNoContent = errors.New("versenv: repository has no content")
	ErrRepositoriesNotFound   = errors.New("versenv: repositories not found")
)

func Exec(ctx context.Context) error {
	cmd := cliz.Command{
		Name:        "versenv",
		Description: "versenv is a tool for managing your environment variables",
		SubCommands: []*cliz.Command{},
		ExecFunc:    f,
	}

	if err := cmd.Exec(ctx, os.Args); err != nil {
		if cliz.IsHelp(err) {
			return nil
		}

		return errorz.Errorf("cmd.Exec: %w", err)
	}

	return nil
}

func f(c *cliz.Command, args []string) error {
	f, err := os.ReadFile("examples/registory/hakadoriya/ddlctl/registory.yml")
	if err != nil {
		return errorz.Errorf("os.ReadFile: %w", err)
	}

	var v Registory
	if err := yaml.Unmarshal(f, &v); err != nil {
		return errorz.Errorf("yaml.Unmarshal: %w", err)
	}

	for _, repository := range v.Repositories {
		fmt.Printf("%+v\n", repository)
	}

	return nil
}

type Registory struct {
	Repositories []repository `yaml:"repositories"`
}

var _ yaml.Unmarshaler = (*Registory)(nil)

func extractRepositories(value *yaml.Node) (repositories []*yaml.Node, err error) {
	for i, node := range value.Content {
		if node.Kind == yaml.ScalarNode && node.Value == "repositories" {
			if len(value.Content) <= i+1 {
				return nil, ErrRepositoryHasNoContent
			}

			return value.Content[i+1].Content, nil
		}
	}

	return nil, ErrRepositoriesNotFound
}

func (r *Registory) UnmarshalYAML(value *yaml.Node) error {
	type registory struct {
		Repositories []struct {
			Type RepositoryType `yaml:"type"`
		} `yaml:"repositories"`
	}

	var v registory
	if err := value.Decode(&v); err != nil {
		return errorz.Errorf("value.Decode: %w", err)
	}

	repositories, err := extractRepositories(value)
	if err != nil {
		return errorz.Errorf("extractRepositories: %w", err)
	}

	r.Repositories = make([]repository, len(v.Repositories))
	for i, repository := range v.Repositories {
		switch repository.Type.ToLower() {
		case ArtifactRepositoryTypeHTTP:
			var v HTTPArtifactRepository
			if err := repositories[i].Decode(&v); err != nil {
				return errorz.Errorf("value.Decode: %w", err)
			}
			r.Repositories[i] = &v
		}
	}

	exec.Exec()

	return nil
}

type RepositoryType string

const (
	ArtifactRepositoryTypeHTTP RepositoryType = "http"
)

func (r RepositoryType) ToLower() RepositoryType {
	return RepositoryType(strings.ToLower(string(r)))
}

type repository interface {
	GetRepositoryType() RepositoryType
	GetBase() *Version
}

type HTTPArtifactRepository struct {
	parent *Registory `yaml:"-"`

	Type     RepositoryType `yaml:"type"`
	URL      string         `yaml:"url"`
	Base     *Version       `yaml:"base"`
	Versions []Version      `yaml:"versions"`
}

var _ repository = (*HTTPArtifactRepository)(nil)

func (r *HTTPArtifactRepository) GetRepositoryType() RepositoryType {
	return r.Type
}

func (r *HTTPArtifactRepository) GetBase() *Version {
	return r.Base
}

type Version struct {
	parent repository `yaml:"-"`

	Override repository `yaml:"override"`

	Latest      bool        `yaml:"latest"`
	PreRelease  bool        `yaml:"pre_release"`
	URLTemplate string      `yaml:"url_template"`
	Version     string      `yaml:"version"`
	Artifacts   []*Artifact `yaml:"artifacts"`
}

type Artifact struct {
	parent *Version `yaml:"-"`

	Override *Version `yaml:"override"`

	Prefix string `yaml:"prefix"` //
	OS     string `yaml:"os"`     // e.g. "linux", "darwin", "windows"
	Arch   string `yaml:"arch"`   // e.g. "amd64", "arm64", "x86_64"
	Suffix string `yaml:"suffix"` //
	Ext    string `yaml:"ext"`    // e.g. "tar.gz", "zip"
}

type HashAlgorithm string

const (
	HashAlgorithmSHA256 HashAlgorithm = "sha256"
	HashAlgorithmSHA512 HashAlgorithm = "sha512"
)

type Hash struct {
	Algorithm HashAlgorithm `yaml:"algorithm"` // e.g. "sha256", "sha512"
	Value     string        `yaml:"value"`     // e.g. "1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef"
}
