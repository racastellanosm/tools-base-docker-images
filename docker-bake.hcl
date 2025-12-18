variable "DOCKER_REGISTRY" {
  default = "ghcr.io/racastellanosm"
}

variable "PHP_TAGS" {
  default = ["8.5", "8.4"]
}

variable "AVAILABLE_PLATFORMS" {
  default = ["linux/amd64", "linux/arm64"]
}

# ----------------------------------------------------------------
# Groups
# ----------------------------------------------------------------
group "default" {
  targets = ["php", "postgresql", "skaffold"]
}

group "php" {
  targets = ["php-roadruuner-mysql", "php-roadrunner-pgsql", "php-all-extensions"]
}

group "postgresql" {
  targets = ["postgres-postgis", "postgres-pgvector"]
}

group "skaffold" {
  targets = ["skaffold-slim"]
}

# ----------------------------------------------------------------
# Base Image
# ----------------------------------------------------------------
target "php-base-target" {
  name        = "php-base-${replace(version, ".", "-")}"
  platforms   = AVAILABLE_PLATFORMS
  context     = "./php"
  dockerfile  = "Dockerfile.base"
  matrix = {
    version = PHP_TAGS
  }
  tags = ["${DOCKER_REGISTRY}/php-base:${version}"]
}

# ----------------------------------------------------------------
# PHP Variants
# ----------------------------------------------------------------
target "php-roadruuner-mysql" {
  name        = "php-roadrunner-mysql-${replace(version, ".", "-")}"
  platforms   = AVAILABLE_PLATFORMS
  context     = "."
  dockerfile  = "./php/Dockerfile.roadrunner.mysql"
  matrix = {
    version = PHP_TAGS
  }
  contexts = {
    php_base_local = "target:php-base-${replace(version, ".", "-")}"
  }
  tags = ["${DOCKER_REGISTRY}/php.roadrunner.mysql:${version}"]
  args = { PHP_VERSION = version }
}

target "php-roadrunner-pgsql" {
  name        = "php-roadrunner-pgsql-${replace(version, ".", "-")}"
  platforms   = AVAILABLE_PLATFORMS
  context     = "."
  dockerfile  = "./php/Dockerfile.roadrunner.pgsql"
  matrix = {
    version = PHP_TAGS
  }
  contexts = {
    php_base_local = "target:php-base-${replace(version, ".", "-")}"
  }
  tags = ["${DOCKER_REGISTRY}/php.roadrunner.pgsql:${version}"]
  args = { PHP_VERSION = version }
}

target "php-all-extensions" {
  name        = "php-all-extensions-${replace(version, ".", "-")}"
  platforms   = AVAILABLE_PLATFORMS
  context     = "."
  dockerfile  = "./php/Dockerfile.all.extensions"
  matrix = {
    version = PHP_TAGS
  }
  contexts = {
    php_base_local = "target:php-base-${replace(version, ".", "-")}"
  }
  tags = ["${DOCKER_REGISTRY}/php.all.extensions:${version}"]
  args = { PHP_VERSION = version }
}

# ----------------------------------------------------------------
# PostgreSQL Variants
# ----------------------------------------------------------------
target "postgres-postgis" {
  platforms   = AVAILABLE_PLATFORMS
  context    = "./postgres"
  dockerfile = "Dockerfile.postgis"
  tags       = ["${DOCKER_REGISTRY}/postgres.postgis:17-3.5"]
}

target "postgres-pgvector" {
  platforms   = AVAILABLE_PLATFORMS
  context    = "./postgres"
  dockerfile = "Dockerfile.pgvector"
  tags       = ["${DOCKER_REGISTRY}/postgres.pgvector:17-0.8"]
}

# ----------------------------------------------------------------
# Skaffold Variants
# ----------------------------------------------------------------
target "skaffold-slim" {
  platforms   = AVAILABLE_PLATFORMS
  context    = "./skaffold"
  dockerfile = "Dockerfile.slim"
  tags       = ["${DOCKER_REGISTRY}/skaffold.slim:latest"]
}
