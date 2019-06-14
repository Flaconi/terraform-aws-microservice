.PHONY: help gen lint test _gen-main _gen-examples _gen-modules

CURRENT_DIR     = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
TF_EXAMPLES     = $(sort $(dir $(wildcard $(CURRENT_DIR)examples/*/)))
TF_MODULES  = $(sort $(dir $(wildcard $(CURRENT_DIR)modules/*/)))

TF_VERSION      = 0.12.2
TF_DOCS_VERSION = 0.6.0

# Adjust your delimiter here or overwrite via make arguments
DELIM_START = <!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
DELIM_CLOSE = <!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

help:
	@echo "gen        Generate terraform-docs output and replace in all README.md's"
	@echo "lint       Static source code analysis"
	@echo "test       Integration tests"

gen:
	@echo "################################################################################"
	@echo "# Terraform-docs generate"
	@echo "################################################################################"
	@$(MAKE) _gen-main
	@$(MAKE) _gen-examples
	@$(MAKE) _gen-modules

lint:
	@# Lint all Terraform files
	@echo "################################################################################"
	@echo "# Terraform fmt"
	@echo "################################################################################"
	@if docker run -it --rm -v "$(CURRENT_DIR):/t:ro" --workdir "/t" hashicorp/terraform:$(TF_VERSION) \
		fmt -check=true -diff=true -write=false -list=true .; then \
		echo "OK"; \
	else \
		echo "Failed"; \
		exit 1; \
	fi;
	@echo

test:
	@$(foreach example,\
		$(TF_EXAMPLES),\
		DOCKER_PATH="/t/examples/$(notdir $(patsubst %/,%,$(example)))"; \
		echo "################################################################################"; \
		echo "# examples/$$( basename $${DOCKER_PATH} )"; \
		echo "################################################################################"; \
		echo; \
		echo "------------------------------------------------------------"; \
		echo "# Terraform init"; \
		echo "------------------------------------------------------------"; \
		if docker run -it --rm -v "$(CURRENT_DIR):/t" --workdir "$${DOCKER_PATH}" hashicorp/terraform:$(TF_VERSION) \
			init \
				-verify-plugins=true \
				-lock=false \
				-upgrade=true \
				-reconfigure \
				-input=false \
				-get-plugins=true \
				-get=true \
				.; then \
			echo "OK"; \
		else \
			echo "Failed"; \
			docker run -it --rm -v "$(CURRENT_DIR):/t" --workdir "$${DOCKER_PATH}" --entrypoint=rm hashicorp/terraform:$(TF_VERSION) -rf .terraform/ || true; \
			exit 1; \
		fi; \
		echo; \
		echo "------------------------------------------------------------"; \
		echo "# Terraform validate"; \
		echo "------------------------------------------------------------"; \
		if docker run -it --rm -v "$(CURRENT_DIR):/t" --workdir "$${DOCKER_PATH}" hashicorp/terraform:$(TF_VERSION) \
			validate \
				$(ARGS) \
				.; then \
			echo "OK"; \
			docker run -it --rm -v "$(CURRENT_DIR):/t" --workdir "$${DOCKER_PATH}" --entrypoint=rm hashicorp/terraform:$(TF_VERSION) -rf .terraform/ || true; \
		else \
			echo "Failed"; \
			docker run -it --rm -v "$(CURRENT_DIR):/t" --workdir "$${DOCKER_PATH}" --entrypoint=rm hashicorp/terraform:$(TF_VERSION) -rf .terraform/ || true; \
			exit 1; \
		fi; \
		echo; \
	)

_gen-main:
	@echo "------------------------------------------------------------"
	@echo "# Main module"
	@echo "------------------------------------------------------------"
	@if docker run --rm \
		-v $(CURRENT_DIR):/data \
		-e DELIM_START='$(DELIM_START)' \
		-e DELIM_CLOSE='$(DELIM_CLOSE)' \
		cytopia/terraform-docs:${TF_DOCS_VERSION} \
		terraform-docs-replace-012 --sort-inputs-by-required --with-aggregate-type-defaults md README.md; then \
		echo "OK"; \
	else \
		echo "Failed"; \
		exit 1; \
	fi

_gen-examples:
	@$(foreach example,\
		$(TF_EXAMPLES),\
		DOCKER_PATH="examples/$(notdir $(patsubst %/,%,$(example)))"; \
		echo "------------------------------------------------------------"; \
		echo "# $${DOCKER_PATH}"; \
		echo "------------------------------------------------------------"; \
		if docker run --rm \
			-v $(CURRENT_DIR):/data \
			-e DELIM_START='$(DELIM_START)' \
			-e DELIM_CLOSE='$(DELIM_CLOSE)' \
			cytopia/terraform-docs:${TF_DOCS_VERSION} \
			terraform-docs-replace-012 --sort-inputs-by-required --with-aggregate-type-defaults md $${DOCKER_PATH}/README.md; then \
			echo "OK"; \
		else \
			echo "Failed"; \
			exit 1; \
		fi; \
	)

_gen-modules:
	@$(foreach module,\
		$(TF_MODULES),\
		DOCKER_PATH="modules/$(notdir $(patsubst %/,%,$(module)))"; \
		echo "------------------------------------------------------------"; \
		echo "# $${DOCKER_PATH}"; \
		echo "------------------------------------------------------------"; \
		if docker run --rm \
			-v $(CURRENT_DIR):/data \
			-e DELIM_START='$(DELIM_START)' \
			-e DELIM_CLOSE='$(DELIM_CLOSE)' \
			cytopia/terraform-docs:${TF_DOCS_VERSION} \
			terraform-docs-replace-012 --sort-inputs-by-required --with-aggregate-type-defaults md $${DOCKER_PATH}/README.md; then \
			echo "OK"; \
		else \
			echo "Failed"; \
			exit 1; \
		fi; \
	)
