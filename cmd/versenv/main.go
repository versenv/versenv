package main

import (
	"context"
	"fmt"
	"io"
	"os"

	"github.com/versenv/versenv/pkg/versenv"
)

func main() {
	ctx := context.Background()

	if err := versenv.Exec(ctx); err != nil {
		io.WriteString(os.Stderr, fmt.Sprintf("%+v\n", err))
		os.Exit(1)
	}
}
