#! /usr/bin/make 


.PHONY: help
help:  ## Print the help documentation
	@grep -E '^[a-zA-Z_-]+.*?:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: clean_locks
clean_locks: ## Clean lock files
	rm *_lock.yml

.PHONY: lock_viz_debug
lock_viz_debug: ## Create a lockfile for the environment
	conda-lock lock -f ./viz_debug.yml  -p linux-64 -p osx-64 -p osx-arm64 -p linux-aarch64 --lockfile viz_debug_lock.yml

.PHONY: checkout_viz_debug_lock
checkout_viz_debug_lock: ## Check out the lockfile from the repo overwriting local changes
	- git checkout viz_debug_lock.yml

.PHONY: install_viz_debug
install_viz_debug: ## Create and install the environment
	-conda env remove -n viz_debug
	conda-lock install -n viz_debug ./viz_debug_lock.yml

.PHONY: nuke_viz_debug
nuke_viz_debug: ## Nuke everything about the env except the its env file
	-conda env remove -n viz_debug
	-rm ./viz_debug_lock.yml

.PHONY: lock_viz_experiment
lock_viz_experiment: ## Create a lockfile for the environment
	conda-lock lock -f ./viz_experiment.yml  -p linux-64 -p osx-64 -p osx-arm64 -p linux-aarch64 --lockfile viz_experiment_lock.yml

.PHONY: checkout_viz_experiment_lock
checkout_viz_experiment_lock: ## Check out the lockfile from the repo overwriting local changes
	-git checkout viz_experiment_lock.yml

.PHONY: install_viz_experiment
install_viz_experiment: ## Create and install the environment
	-conda env remove -n viz_experiment
	conda-lock install -n viz_experiment ./viz_experiment_lock.yml

.PHONY: nuke_viz_experiment
nuke_viz_experiment: ## Nuke everything about the env except the its env file
	-conda env remove -n viz_experiment
	-rm ./viz_experiment_lock.yml


VALID_ENVS := viz_debug viz_experiment viz_debug

.PHONY: validate-envs
validate-envs:
	@if [ -z "$(env)" ]; then \
		echo "Please run with 'make <target> env=<env-name>'   where <env-name> is one of: $(VALID_ENVS)" >&2; \
		exit 1; \
	fi

	@echo $(VALID_ENVS) | grep -qw $(env) || (echo "Error: Invalid env '$(env)'. Choose from: $(VALID_ENVS)" >&2; exit 1)

.PHONY: lock
lock: validate-envs ## Create lock file with make lock <env-name>
	conda-lock lock -f ./$(env).yml  -p linux-64 -p osx-64 -p osx-arm64 -p linux-aarch64 --lockfile $(env)_lock.yml

.PHONY: checkout
checkout: validate-envs ## Check out the lockfile from repo overwriting local changes
	-git checkout $(env)_lock.yml

# target2: check-arg
# 	@echo "Executing target2 with valid argument: $(arg)"

