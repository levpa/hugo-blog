#!/usr/bin/env bash
set -euo pipefail

echo "✅ $(yamllint --version)"
echo "✅ markdownlint: $(markdownlint --version)"

echo "✅ $(hugo version)"
echo "✅ $(gh version)"

echo "✅ Node: $(node -v) NPM: $(npm -v)"

echo "✅ $(python3 --version)"
echo "✅ $(pip3 --version)"
