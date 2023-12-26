#! /usr/bin/make 


.PHONY: help
help:  ## Print the help documentation
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: viz_debug_lock
viz_debug_lock: ## Create a lockfile for the viz_debug environment
	conda-lock lock -f ./viz_debug.yml  -p linux-64 -p osx-64 -p osx-arm64 -p linux-aarch64 --lockfile viz_debug_lock.yml

.PHONY: viz_debug_install
viz_debug_install: ## Create a lockfile for the viz_debug environment
	-conda env remove -n viz_debug
	conda-lock install -n viz_debug ./viz_debug_lock.yml

.PHONY: viz_debug_nuke
viz_debug_nuke: ## Nuke everything about viz_debug except the env file
	-conda env remove -n viz_debug
	-rm ./viz_debug_lock.yml

.PHONY: clean_locks
clean_locks: ## Clean lock files
	rm *_lock.yml
