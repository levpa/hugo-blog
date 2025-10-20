#!/usr/bin/env bash
set -eo pipefail

echo "🔧 Bootstrapping Node.js LTS environment..."

# Ensure curl is available
if ! command -v curl >/dev/null 2>&1; then
  echo "❌ curl not found. Please install curl before proceeding."
  exit 1
fi

# Install nvm if not present
if [ ! -d "$HOME/.nvm" ]; then
  echo "📦 Installing nvm ..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install --lts
nvm use --lts

echo "✅ Node.js version: $(node -v)"
echo "✅ npm version: $(npm -v)"
