#!/bin/bash

set -e

# Perform all actions as $POSTGRES_USER
export PGUSER="$POSTGRES_USER"

# Create the 'template_postgis' template db
# shellcheck disable=SC2154
"${psql[@]}" <<- 'EOSQL'
CREATE EXTENSION vector;
EOSQL
