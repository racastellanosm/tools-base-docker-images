SHELL 				:= /bin/bash

help:
	@echo "---------------------- Available Targets ---------------------------"
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

#------ Working Targets ----------#
build-all:	## [Docker] Build and Push all images
	@docker buildx bake -f docker-bake.hcl
build-php-based:	## [Docker] Build and Push php based images
	@docker buildx bake -f docker-bake.hcl php
build-postgresql-based:	## [Docker] Build and Push PostgreSQL based images
	@docker buildx bake -f docker-bake.hcl postgresql
build-skaffold-based:	## [Docker] Build and Push Skaffold based images
	@docker buildx bake -f docker-bake.hcl skaffold