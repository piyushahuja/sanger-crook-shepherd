#!/usr/bin/env bash

set -euo pipefail

# Setup
declare FARM="$(lsclusters | awk 'NR == 2 { print $1 }')"
case "${FARM}" in
  "farm3" | "farm5")
    # baton already available from .bashrc
    ;;

  "farm4")
    # Add Singularity from ISG modules
    export MODULEPATH="/software/modules/ISG:${MODULEPATH}"
    module add singularity/3.2.0

    # Make containerised baton available
    export PATH="/software/hgi/containers/singularity-baton:${PATH}"
    ;;

  *)
    >&2 echo "I don't know anything about ${FARM}"
    exit 1
    ;;
esac

declare _ROOT="/lustre/scratch119/realdata/mdt3/teams/hgi/crook-shepherd"

# Become mercury#humgen
export IRODS_ENVIRONMENT_FILE="/nfs/users/nfs_m/mercury/.irods/irods_environment.humgen.json"

# Our pet PostgreSQL instance
export PG_HOST="172.27.19.11"
export PG_DATABASE="shepherd"
export PG_USERNAME="postgres"
export PG_PASSWORD="postgres"

# LSF configuration
export LSF_CONFIG="/usr/local/lsf/conf/lsbatch/${FARM}/configdir"
export LSF_GROUP="hgi-archive"

# Transfer options
export PREP_QUEUE="${PREP_QUEUE-normal}"
export TRANSFER_QUEUE="${TRANSFER_QUEUE-long}"

main() {
  local mode="$1"

  source "${_ROOT}/.venv/bin/activate"

  case "${mode}" in
    "submit")
      local subcollection="$2"
      local run_dir="${_ROOT}/run/${subcollection}"
      local fofn="${run_dir}/fofn"
      local metadata="${run_dir}/metadata.json"
      export SHEPHERD_LOG="${run_dir}"

      "${_ROOT}/shepherd/shepherd" submit "${fofn}" "${subcollection}" "${metadata}"
      ;;

    "resume")
      ## local job_id="$2"
      ## export SHEPHERD_LOG="$(pwd)"

      ## # TODO Make this less shit
      ## if (( $# == 3 )) && [[ "$3" == "--force" ]]; then
      ##   shepherd/shepherd resume "${job_id}" --force
      ## else
      ##   shepherd/shepherd resume "${job_id}"
      ## fi
      >&2 echo "This is broken. Use resume.sh, but only if you know what you're doing\!"
      exit 1
      ;;

    "status")
      local job_id="$2"
      export SHEPHERD_LOG="$(pwd)"

      "${_ROOT}/shepherd/shepherd" status "${job_id}"
      ;;

    *)
      >&2 echo "Usage: shepherd.sh ( submit RUN_DIR | resume JOB_ID [--force] | status JOB_ID )"
      exit 1
      ;;
  esac
}

main "$@"
