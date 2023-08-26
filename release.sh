#!/usr/bin/env bash
set -Eeu -o pipefail

GIT_BRANCH_CURRENT=$(git rev-parse --abbrev-ref HEAD)
GIT_TAG_LATEST=$(git describe --tags --abbrev=0)

git checkout main
git checkout "${GIT_TAG_LATEST:?}"
gh release upload "${GIT_TAG_LATEST:?}" bin/*
git checkout "${GIT_BRANCH_CURRENT}"
