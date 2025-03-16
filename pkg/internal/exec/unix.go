//go:build unix

package exec

import (
	"context"

	"golang.org/x/sys/unix"
)

func Exec(ctx context.Context, argv []string, envv []string) error {
	return unix.Exec(argv[0], argv, envv)
}
