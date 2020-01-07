#!/usr/bin/env bash
set -e
set -x

echo "VARS: $*"
STORE_TYPE=$1
STORE_ADDRESS=$2
PREFIX=$3
SHOULD_DELETE=$4
CHANGES_ONLY=$5
export GIT_TERMINAL_PROMPT=0

if [ "${CHANGES_ONLY}" == "true" ]; then
  CONFIGS_TO_INSERT=$(git diff --name-only --diff-filter=ACMR HEAD~1 HEAD | sed -n 's/^materialized_config\/\(.*\.materialized_JSON\)$/\1/p')
else
  CONFIGS_TO_INSERT=$(find . -name *.materialized_JSON | sed -n 's/^.\/materialized_config\/\(.*\.materialized_JSON\)$/\1/p')
fi
if [ -z "$CONFIGS_TO_INSERT" ]; then
    exit 0
fi
DELETE=""
if [ "${SHOULD_DELETE}" == "true" ]; then
  DELETE="-d"
fi

echo $CONFIGS_TO_INSERT | xargs /protoconf insert \
  -store ${STORE_TYPE} \
  -address ${STORE_ADDRESS} \
  -prefix ${PREFIX} \
  ${DELETE} \
  "$GITHUB_WORKSPACE"
