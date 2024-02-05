#! /usr/bin/make 


SHELL := /bin/bash
VALID_ENVS := $(shell ls *.yml | grep -v lock)

.PHONY: help
help:  ## Print the help documentation
	@grep -E '^[a-zA-Z_-]+.*?:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo
	@echo "Valid env names: $(VALID_ENVS)"
	@echo


.PHONY: validate-envs
validate-envs:
	@if [ -z "$(env)" ]; then \
		echo "Please run with 'make <target> env=<env-name>'   where <env-name> is one of: $(VALID_ENVS)" >&2; \
		exit 1; \
	fi

	@echo $(VALID_ENVS) | grep -qw $(env) || (echo "Error: Invalid env '$(env)'. Choose from: $(VALID_ENVS)" >&2; exit 1)

.PHONY: lock
lock: validate-envs ## Create lock file:  make lock env=<env-name>
	conda-lock lock -f ./$(env).yml  -p linux-64 -p osx-64 -p osx-arm64 -p linux-aarch64 --lockfile $(env)_lock.yml

.PHONY: checkout
checkout: validate-envs ## Checkout lockfile from repo:  make checkout env=<env-name>
	-git checkout $(env)_lock.yml

.PHONY: nuke
nuke: validate-envs ## Nuke lockfile and env:  make nuke env=<env-name>
	-conda env remove -n $(env)
	-rm ./$(env)_lock.yml

.PHONY: install
install: validate-envs ## Create environment from lockfile: make install env=<env-name>
	-conda env remove -n $(env)
	conda-lock install -n $(env) ./$(env)_lock.yml
