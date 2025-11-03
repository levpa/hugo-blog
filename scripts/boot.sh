#!/usr/bin/env bash
set -euo pipefail

# install precommit hook
./scripts/hook.sh

# install markdownlint-cli
npm ci

# htmltest for link checking
go install github.com/wjdp/htmltest@latest

make verify
