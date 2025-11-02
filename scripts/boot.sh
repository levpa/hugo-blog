#!/usr/bin/env bash
set -euo pipefail

# install precommit hook
./scripts/hook.sh

sudo apt-get update && sudo apt-get install -y dnsutils net-tools tree time

# install markdownlint-cli
npm ci

make verify
