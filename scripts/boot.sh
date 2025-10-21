#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update && sudo apt-get install -y dnsutils traceroute net-tools tree time

echo "✅ DNS and net utils:"
echo "$(dig -v && nslookup -version && host -V && mdig -v && traceroute -V && ifconfig -V)"
echo "✅ system utils:"
echo "$(tree --version)"

echo "✅ $(gh version)"
echo "✅ $(yamllint --version)"
echo "✅ markdownlint: $(markdownlint --version)"
echo "✅ $(hugo version | awk '{print $1, $2}')"
echo "✅ $(go version)"
echo "✅ Node: $(node -v) NPM: $(npm -v)"
echo "✅ Python: $(pip3 --version)"
