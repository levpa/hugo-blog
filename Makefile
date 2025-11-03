.PHONY: chlog lint release serve update-phony verify

update-phony:
	@echo "🔄 Updating .PHONY line in Makefile..."
	@targets="$$(grep -E '^[a-zA-Z0-9_-]+:' Makefile | grep -vE '^\.PHONY:' | sed 's/:.*//' | sort | uniq | xargs)"; \
	sed -i "s/^\.PHONY:.*/.PHONY: $$targets/" Makefile; \
	echo "✅ .PHONY updated with: $$targets"

HUGO_WORKDIR := blog

serve:
	@hugo serve --buildDrafts --cleanDestinationDir --disableFastRender -s $(HUGO_WORKDIR)

YEAR := $(shell date +%Y)
MONTH := $(shell date +%m)

define sanitize_slug
slug_sanitized=$$(echo "$$slug" | tr '[:upper:]' '[:lower:]' \
  | sed -e 's/[^a-z0-9 ]//g' -e 's/[[:space:]]\+/-/g' -e 's/-\+$$//')
endef

verify:
	@echo "🔍 Verifying system tools..."
	@echo ""
	@echo "✅ make: $(shell make --version | head -n1 | awk '{print $$3}')"
	@echo "✅ bash: $(shell bash --version | head -n1 | awk '{print $$4}')"
	@echo "✅ $(shell git --version)"
	@echo "✅ yamllint: $(shell yamllint --version)"
	@echo "✅ markdownlint: $(shell markdownlint --version)"
	@echo "✅ hugo: $(shell hugo version | awk '{split($$2,a,"-"); print $$1, a[1]}')"
	@echo "✅ convert: $(shell convert --version | head -n1 | cut -d" " -f3)"
	@echo "✅ Node: $(shell node -v)"
	@echo "✅ npm: $(shell npm -v)"
	@echo "✅ GoLang: $(shell go version | cut -d" " -f3)"
	@echo "✅ Python: $(shell pip3 --version | awk '{print $$2}')"
	@echo "✅ htmltest: $(shell htmltest -v)"
	@echo ""
	@echo "✅ Verification complete."

lint:
	@echo "🔍 Linting GitHub workflows..."
	@yamllint .github/workflows

	@echo "🧾 Linting hugo.yaml config ..."
	@yamllint $(HUGO_WORKDIR)/hugo.yaml

	@echo "📝 Linting Markdown content..."
	@npx markdownlint-cli "**/*.md" --config .markdownlint.json

	@rm -rf $(HUGO_WORKDIR)/public && hugo -s $(HUGO_WORKDIR) --quiet

	@echo "🔍 Broken links check with htmltest ..."
	@htmltest --conf .htmltest.yml

BUMP_TYPE ?= patch

release:
	@echo "🚀 Releasing version bump..."
	@bash scripts/bump.sh $(BUMP_TYPE)

chlog:
	@CHLOG_LENGTH=20 bash scripts/chlog.sh
