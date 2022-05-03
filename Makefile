help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

debug: ## Build a debug version
	@./build/build-include.sh
	@/snap/bin/nim-lang-nightly.nim --opt:none c app.nim
	@echo "Debug release done"

release: ## Build a release version
	@./build/build-include.sh
	@/snap/bin/nim-lang-nightly.nim -d:release c app.nim
	@echo "Prod release done"

.PHONY: help
.DEFAULT_GOAL := help