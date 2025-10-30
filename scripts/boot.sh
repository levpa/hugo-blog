#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update
sudo apt-get install -y dnsutils net-tools tree time

echo "✅ DNS/network tools:"
echo "$(dig -v && nslookup -version && host -V && mdig -v && ifconfig -V)"

echo "✅ System tools:"
echo "tree $(tree --version | awk '{print $2}')"
echo "make $(make --version | head -n1 | awk '{print $3}')"
echo "bash $(bash --version | head -n1 | awk '{print $4}')"


echo "✅ $(git --version)"
echo "✅ $(yamllint --version)"
echo "✅ markdownlint: $(markdownlint --version)"
echo "✅ $(hugo version | awk '{split($2,a,"-"); print $1, a[1]}')"
echo -e "✅ Node: $(node -v)\n✅ npm: $(npm -v)"
echo "✅ Python: $(pip3 --version | awk '{print $2}')"
