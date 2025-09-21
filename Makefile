SHELL 				:= /bin/bash
PHP_DIR				:= ${PWD}/php
PHP_STATIC_DIR 		:= ${PWD}/static
SKAFFOLD_DIR 		:= ${PWD}/skaffold
DOCKER_REGISTRY		:= ghcr.io/racastellanosm
AVAILABLE_PLATFORMS := linux/amd64,linux/arm64
TAGS				:= 8.4

help:
	@echo "---------------------- Available Targets ---------------------------"
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

#------ Working Targets ----------#
build-all: build-php-static build-php-mysql build-php-pgsql build-skaffold-slim build-php-chromium build-php-tester
build-php-tester:	## [Docker] Build and Push php image with ext for testing
	@$(MAKE) build-php variant=tester dir=${PHP_DIR}
build-php-chromium:	## [Docker] Build and Push php image with ext and chromium extension for testing
	@$(MAKE) build-php variant=chromium dir=${PHP_DIR}
build-php-static:	## [Docker] Build and Push php static image
	@$(MAKE) build-php variant=static.php.alpine dir=${PHP_DIR}
build-php-mysql:	## [Docker] Build and Push php image with roadrunner and mysql extension
	@$(MAKE) build-php variant=roadrunner.mysql dir=${PHP_DIR}
build-php-pgsql:	## [Docker] Build and Push php image with roadrunner and pgsql extension
	@$(MAKE) build-php variant=roadrunner.pgsql dir=${PHP_DIR}
build-php-full:		## [Docker] Build and Push php image with full extensions to be used with other tools
	@$(MAKE) build-php variant=all.extensions dir=${PHP_DIR}
build-skaffold-slim:	## [Docker] Build and Push skaffold image with slim variant for CI/CD pipelines
	@$(MAKE) build-others type=skaffold variant=slim version=latest dir=skaffold
build-postgres-postgis:	## [Docker] Build and Push postgres image with postgis extension for local development
	@$(MAKE) build-others type=postgres variant=postgis version=17-3.5 dir=postgres
build-postgres-pgvector: ## [Docker] Build and Push postgres image with pg_vector extension for local development
	@$(MAKE) build-others type=postgres variant=pgvector version=17-0.8 dir=postgres
build-php:
	@$(call validate_variant)
	@for tag in $(TAGS); do \
		docker build --platform=${AVAILABLE_PLATFORMS} --build-arg PHP_VERSION=$$tag -t ${DOCKER_REGISTRY}/php.$(variant):$$tag -f $(dir)/Dockerfile.$(variant) .; \
		echo "🎉 PHP image built successfully with tag ${DOCKER_REGISTRY}/php.$(variant):$$tag"; \
	done
	@echo "🎉 PHP images built successfully!"
build-others:
	@$(call validate_type)
	@$(call validate_variant)
	@docker build -t ${DOCKER_REGISTRY}/$(type).$(variant):$(version) -f $(dir)/Dockerfile.$(variant) $(dir)
	@echo "🎉 $(type) image built successfully with tag ${DOCKER_REGISTRY}/$(type).$(variant):$(version)"

#------ Helper Targets ----------#
define validate_type
	@if [ -z $(type) ]; then echo "😩 one of php|skaffold value is required on type argument"; exit 1; fi
endef

define validate_variant
	@if [ -z $(variant) ]; then echo "😩 one of roadrunner.mysql|roadrunner.pgsql|skaffold.slim value is required on variant argument"; exit 1; fi
endef