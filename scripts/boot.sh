#!/usr/bin/env bash
set -euo pipefail

echo "✅ $(gh version)"
echo "✅ $(yamllint --version) markdownlint: $(markdownlint --version)"

echo "✅ $(hugo version)"
echo "✅ $(go version)"
echo "✅ $(sass --version)"

echo "✅ Node: $(node -v) NPM: $(npm -v)"

echo "✅ $(python3 --version)"
echo "✅ $(pip3 --version)"
