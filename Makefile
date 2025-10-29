.PHONY: bench-all chlog config lint new-post precommit publish-drafts release serve update-phony verify

update-phony:
	@echo "🔄 Updating .PHONY line in Makefile..."
	@targets="$$(grep -E '^[a-zA-Z0-9_-]+:' Makefile | grep -vE '^\.PHONY:' | sed 's/:.*//' | sort | uniq | xargs)"; \
	sed -i "s/^\.PHONY:.*/.PHONY: $$targets/" Makefile; \
	echo "✅ .PHONY updated with: $$targets"

HUGO_WORKDIR := blog

config:
	@hugo config -s $(HUGO_WORKDIR) || echo "❌ Config validation failed"

serve:
	@hugo serve -D -s blog

publish-drafts:
	@echo "🚀 Publishing all drafts..."
	@find blog/content/post/$(YEAR) -name '*.md' | while read file; do \
		if grep -q '^draft: true' "$$file"; then \
			sed -i 's/^draft: true/draft: false/' "$$file"; \
			echo "✅ Published: $$file"; \
		fi \
	done

YEAR := $(shell date +%Y)
MONTH := $(shell date +%m)

define sanitize_slug
slug_sanitized=$$(echo "$$slug" | tr '[:upper:]' '[:lower:]' \
  | sed -e 's/[^a-z0-9 ]//g' -e 's/[[:space:]]\+/-/g' -e 's/-\+$$//')
endef

new-post:
	@read -p "Enter post slug: " slug; \
	$(sanitize_slug); \
	hugo new "post/$(YEAR)/$(MONTH)/$$slug_sanitized/index.md" -s blog

new-page:
	@read -p "Enter page slug: " slug; \
	$(sanitize_slug); \
	hugo new "page/$$slug_sanitized/index.md" -s blog

new-service:
	@read -p "Enter service slug: " slug; \
	$(sanitize_slug); \
	hugo new "services/$$slug_sanitized/index.md" -s blog

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

	@echo "🔍 Linting YAML front matter in Markdown files..."
	@find blog/content -name '*.md' | while read file; do \
		echo "--- $$file ---"; \
		awk '/^---$$/,/^---$$/' "$$file" | sed '1d;$$d' | yamllint -f parsable - || true; \
	done

	@echo "🧾 Linting Hugo config..."
	@yamllint blog/hugo.yaml

	@echo "📝 Linting Markdown content..."
	@markdownlint-cli "**/*.md" --config .markdownlint.json

precommit:
	bash ./scripts/hook.sh

BUMP_TYPE ?= patch

release:
	@echo "🚀 Releasing version bump..."
	@bash scripts/bump.sh $(BUMP_TYPE)

CHLOG_LENGTH ?= 20

chlog:
	@CHLOG_LENGTH=$(CHLOG_LENGTH) bash scripts/chlog.sh


bench-all:
	@bash scripts/bench-all.sh
