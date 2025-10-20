.PHONY: chlog precommit release verify

verify:
	@echo "🔍 Verifying Hugo environment..."
	@echo "Dart Sass: $(sass --version)"
	@echo "Go: $(go version)"
	@echo "Hugo: $(hugo version)"
	@echo "Node.js: $(node --version && npm --version)"
	@echo "✅ Environment verification complete."

lint:
	@echo "🔍 Linting YAML workflows..."
	@yamllint .github/workflows

	@echo "🧾 Linting Hugo config..."
	@yamllint config.yaml || true

	@echo "📝 Linting Markdown content..."
	@markdownlint content/

	@echo "🎨 Linting SCSS assets..."
	@stylelint "assets/**/*.scss"

	@echo "📄 Linting HTML templates..."
	@htmlhint layouts/ static/

	@echo "📦 Linting JSON data..."
	@jsonlint config.json

precommit:
	bash ./scripts/hook.sh

BUMP_TYPE ?= patch

release:
	@echo "🚀 Releasing version bump..."
	bash scripts/bump.sh $(BUMP_TYPE)

CHLOG_LENGTH ?= 20
BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
VERSION := $(shell git describe --tags --abbrev=0)

chlog:
	@printf "# Changelog for $(VERSION)\n" > CHANGELOG.md
	@printf "## Date: $(shell date '+%Y-%m-%d')\n\n" >> CHANGELOG.md
	@rm -f .chlog-seen

	@echo "\n### ✨ Features" >> CHANGELOG.md
	@git log -n $(CHLOG_LENGTH) --grep="^feat" --pretty=format:"- %h %d %s (%ad)" --date=relative \
	| tee -a CHANGELOG.md | cut -d' ' -f2 >> .chlog-seen
	@echo "" >> CHANGELOG.md

	@echo "\n### 🐛 Fixes" >> CHANGELOG.md
	@git log -n $(CHLOG_LENGTH) --grep="^fix" --pretty=format:"- %h %d %s (%ad)" --date=relative \
	| tee -a CHANGELOG.md | cut -d' ' -f2 >> .chlog-seen
	@echo "" >> CHANGELOG.md

	@echo "\n### 🧹 Chores & Refactors" >> CHANGELOG.md
	@git log -n $(CHLOG_LENGTH) --grep="^chore\|^refactor" --pretty=format:"- %h %d %s (%ad)" --date=relative \
	| tee -a CHANGELOG.md | cut -d' ' -f2 >> .chlog-seen
	@echo "" >> CHANGELOG.md

	@echo "\n### 📌 Other Commits" >> CHANGELOG.md
	@git log -n $(CHLOG_LENGTH) --pretty=format:"- %h %d %s (%ad)" --date=relative | while read line; do \
	  hash=$$(echo $$line | cut -d' ' -f2); \
	  grep -q $$hash .chlog-seen || echo "$$line" >> CHANGELOG.md; \
	done
	@echo "" >> CHANGELOG.md

	@sed -i -E \
		-e 's/HEAD -> [^,)]+,? ?//g' \
		-e 's/origin\/[^,)]+,? ?//g' \
		-e 's/HEAD,? ?//g' \
		-e 's/origin\/HEAD,? ?//g' \
		-e 's/ ,/,/g' \
		-e 's/, \)/)/g' \
		CHANGELOG.md

	@rm -f .chlog-seen
	@cat CHANGELOG.md