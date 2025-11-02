.PHONY: chlog lint new-page new-post publish-drafts release serve update-phony verify

update-phony:
	@echo "🔄 Updating .PHONY line in Makefile..."
	@targets="$$(grep -E '^[a-zA-Z0-9_-]+:' Makefile | grep -vE '^\.PHONY:' | sed 's/:.*//' | sort | uniq | xargs)"; \
	sed -i "s/^\.PHONY:.*/.PHONY: $$targets/" Makefile; \
	echo "✅ .PHONY updated with: $$targets"

HUGO_WORKDIR := blog

serve:
	@hugo serve --buildDrafts --cleanDestinationDir --disableFastRender -s $(HUGO_WORKDIR)

publish-drafts:
	@echo "🚀 Publishing all drafts..."
	@find $(HUGO_WORKDIR)/content/post/$(YEAR) -name '*.md' | while read file; do \
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
	hugo new "posts/$(YEAR)/$(MONTH)/$$slug_sanitized/index.md" -s $(HUGO_WORKDIR)

new-page:
	@read -p "Enter page slug: " slug; \
	$(sanitize_slug); \
	hugo new "page/$$slug_sanitized/index.md" -s $(HUGO_WORKDIR)

verify:
	@echo "🔍 Verifying DNS/network tools..."
	@bash -c 'echo "✅ dig: $$(dig -v 2>&1 | head -n1)"'
	@bash -c 'echo "✅ nslookup: $$(nslookup -version 2>&1 | head -n1)"'
	@bash -c 'echo "✅ host: $$(host -V 2>&1 | head -n1)"'
	@bash -c 'echo "✅ ifconfig: $$(ifconfig -V 2>&1 | head -n1)"'
	@echo ""
	@echo "🔍 Verifying system tools..."
	@bash -c 'echo "✅ tree: $$(tree --version | awk '\''{print $$2}'\'')"'
	@bash -c 'echo "✅ make: $$(make --version | head -n1 | awk '\''{print $$3}'\'')"'
	@bash -c 'echo "✅ bash: $$(bash --version | head -n1 | awk '\''{print $$4}'\'')"'
	@bash -c 'echo "✅ $$(git --version)"'
	@bash -c 'echo "✅ yamllint: $$(yamllint --version)"'
	@bash -c 'echo "✅ markdownlint: $$(markdownlint --version)"'
	@bash -c 'echo "✅ hugo: $$(hugo version | awk '\''{split($$2,a,"-"); print $$1, a[1]}'\'')"'
	@bash -c 'echo "✅ convert: $$(convert --version | head -n1 | cut -d" " -f3)"'
	@bash -c 'echo "✅ Node: $$(node -v)"'
	@bash -c 'echo "✅ npm: $$(npm -v)"'
	@bash -c 'echo "✅ Python: $$(pip3 --version | awk '\''{print $$2}'\'')"'
	@echo ""
	@echo "✅ Environment verification complete."

lint:
	@echo "🔍 Linting GitHub workflows..."
	@yamllint .github/workflows

	@echo "🧾 Linting hugo.yaml config ..."
	@yamllint $(HUGO_WORKDIR)/hugo.yaml

	@echo "📝 Linting Markdown content..."
	@npx markdownlint-cli "**/*.md" --config .markdownlint.json

BUMP_TYPE ?= patch

release:
	@echo "🚀 Releasing version bump..."
	@bash scripts/bump.sh $(BUMP_TYPE)

chlog:
	@CHLOG_LENGTH=20 bash scripts/chlog.sh
