.PHONY: chlog precommit release verify config

HUGO := blog

config:
	@hugo config -s $(HUGO) || echo "❌ Config validation failed"

new-post:
	@if [ -z "$(POST)" ]; then echo "Error: POST name required"; exit 1; fi
	hugo new post/$(POST).md -s $(HUGO)
new-note:
	hugo new note/$(NOTE).md -s $(HUGO)
new-tutorial:
	hugo new tutorial/$(TUTORIAL).md -s $(HUGO)
new-lab:
	hugo new lab/$(LAB).md -s $(HUGO)
new-insight:
	hugo new insight/$(INSIGHT).md -s $(HUGO)
new-toolbox:
	hugo new toolbox/$(TOOLBOX).md -s $(HUGO)

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
	@yamllint hugo.yaml

	@echo "📝 Linting Markdown content..."
	@markdownlint-cli "**/*.md" --config .markdownlint.json

precommit:
	bash ./scripts/hook.sh

BUMP_TYPE ?= patch

release:
	@echo "🚀 Releasing version bump..."
	@bash scripts/bump.sh $(BUMP_TYPE)

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

bench-dns:
	@dig levarc.com | grep "Query time" || echo "❌ dig failed"

bench-ssl:
	@openssl s_client -connect levarc.com:443 -servername levarc.com < /dev/null | grep "Verify return code" \
	|| echo "❌ SSL check failed"

cold-start:
	@echo "Cold-start latency:"
	@time curl -s https://levarc.com > /dev/null

dns-prop:
	@for server in 1.1.1.1 8.8.8.8 9.9.9.9; do \
		echo "Testing $$server..."; \
		dig levarc.com @$$server | grep "levarc.com"; \
	done

total-time:
	@curl -w "@data/curl-format.txt" -o /dev/null -s https://levarc.com

bench-all:
	@echo "DNS Lookup:"
	@dig levarc.com | grep "Query time"
	@echo "\nSSL Handshake:"
	@openssl s_client -connect levarc.com:443 -servername levarc.com < /dev/null | grep "Verify return code"
	@echo "\nCurl Breakdown:"
	@curl -w "@data/curl-format.txt" -o /dev/null -s https://levarc.com