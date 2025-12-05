#!/usr/bin/env bash
set -euo pipefail

# install precommit hook
./scripts/hook.sh

# install markdownlint-cli
export NPM_CONFIG_UPDATE_NOTIFIER=false
npm install

# htmltest for link checking
go install github.com/wjdp/htmltest@latest

make verify
