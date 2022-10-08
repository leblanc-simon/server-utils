help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

debug: ## Build a debug version
	@./build/build-include.sh
	@/snap/bin/nim-lang-nightly.nim --opt:none c app.nim
	@echo "Debug release done"

release: build-release generate-readme create-archive ## Generate a release version

build-release: ## Build a release version
	@./build/build-include.sh
	@/snap/bin/nim-lang-nightly.nim -d:release c app.nim
	@echo "Prod release done"

generate-readme: ## Generate the README.md with all commands
	@./build/server-utils -h 2>&1 | tail -n +5 | sed -e 's/\x1b\[[0-9;]*m//g' | sed -e 's/^ \([a-z]\)/\* \1/g' | sed -e 's/^  \([a-z]\)/  \* \`\1/g' | sed 's/\([a-z]\)\([ ]\+\)\([a-zA-Z]\)/\1\` \\\\\&rarr; \3/'> /tmp/output-server-utils
	@cat ./build/templates/README.md.template | awk -v r="$$(cat /tmp/output-server-utils)" "{gsub(\"__commands__\",r)}1" > ./README.md
	@rm /tmp/output-server-utils
	@echo "README done"

create-archive: ## Create the archive release
	@mkdir -p ./releases
	@mkdir -p ./releases/tmp
	@cp -pr ./README.md ./build/server-utils ./build/config ./build/templates ./releases/tmp/
	@mkdir -p ./releases/tmp/logs
	@tar -cjf ./releases/server-utils-$$(git tag -l | tail -n 1).tar.bz2 -C ./releases/tmp/ $$(ls ./releases/tmp/)
	@rm -fr ./releases/tmp/
	@echo "Archive done"

.PHONY: help
.DEFAULT_GOAL := help
