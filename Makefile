#! /usr/bin/make 


.PHONY: help
help:  ## Print the help documentation
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: viz_silly_lock
viz_silly_lock: ## Create a lockfile for the viz_silly environment
	conda-lock lock -f ./viz_silly.yml  -p linux-64 -p osx-64 -p osx-arm64 -p linux-aarch64 --lockfile viz_silly_lock.yml

.PHONY: clean_locks
clean_locks: ## Clean lock files
	rm *_lock.yml
