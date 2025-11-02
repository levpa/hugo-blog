#!/usr/bin/env bash
set -e

REPO_ROOT="$(git rev-parse --show-toplevel)"
HOOK_PATH="$REPO_ROOT/.git/hooks/pre-commit"

if [ "$REPO_ROOT" != "$(realpath .)" ]; then
  echo "❌ Please run this script from the root of your Git repository:"
  echo "   cd $REPO_ROOT"
  exit 1
fi

echo "🔧 Installing pre-commit hook..."

if [ -f "$HOOK_PATH" ]; then
  echo "⚠️ Existing pre-commit hook found. Overwriting..."
fi

cat > "$HOOK_PATH" <<'EOF'
#!/usr/bin/env bash
set -e

make update-phony
make verify
make lint

EOF

chmod +x "$HOOK_PATH"

echo "✅ Pre-commit hook installed at $HOOK_PATH"