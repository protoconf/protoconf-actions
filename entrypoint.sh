#!/usr/bin/env bash
set -e
set -x

if [ -z "${STORE_ADDRESS}" ]; then
  echo "STORE_ADDRESS is unset"
  exit 1
fi

echo "VARS: $*"
STORE_TYPE=$1
PREFIX=$2
SHOULD_DELETE=$3
CHANGES_ONLY=$4
BULK_SIZE=$5

export GIT_TERMINAL_PROMPT=0

if [ "${CHANGES_ONLY}" == "true" ]; then
  CONFIGS_TO_INSERT=$(git diff --name-only --diff-filter=ACMR ${AFTER_COMMIT:-HEAD} ${BEFORE_COMMIT:-HEAD~1} | sed -n 's/^materialized_config\///p')
else
  CONFIGS_TO_INSERT=$(find . -name *.materialized_JSON | sed -n 's/^.\/materialized_config\///p')
fi
if [ -z "$CONFIGS_TO_INSERT" ]; then
    exit 0
fi
DELETE=""
if [ "${SHOULD_DELETE}" == "true" ]; then
  DELETE="-d"
fi

echo $CONFIGS_TO_INSERT | xargs -n${BULK_SIZE} /protoconf insert \
  -store "${STORE_TYPE}" \
  -store-address "${STORE_ADDRESS}" \
  -prefix "${PREFIX}/" \
  ${DELETE} \
  "$GITHUB_WORKSPACE"
