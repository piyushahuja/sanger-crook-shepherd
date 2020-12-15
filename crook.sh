#!/usr/bin/env bash

set -euo pipefail
declare ROOT="/lustre/scratch119/humgen/teams/hgi"
declare CROOK_ROOT="${ROOT}/crook-shepherd/crook"
declare VAULT_ROOT="${ROOT}/vault"

# Logging
exec 1>>"${VAULT_ROOT}/var/log/crook.log"
exec 2>&1
echo "## Start: $(date) ##"

cd "${CROOK_ROOT}"
source "${CROOK_ROOT}/.venv/bin/activate"
python "${CROOK_ROOT}/crook.py" "$@"
