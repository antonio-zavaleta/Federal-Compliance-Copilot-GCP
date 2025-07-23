#!/bin/bash
# =============================================================================
# GCP Logging and Monitoring Setup Script
#
# This script enables Cloud Logging and Monitoring APIs, and configures
# basic logging and monitoring for a GCP project.
#
# Usage:
#   chmod +x gcp_logging_monit_config.sh
#   ./gcp_logging_monit_config.sh <PROJECT_ID> [REGION] [--dry-run]
#
# Arguments:
#   PROJECT_ID    The GCP project ID (required)
#   REGION        The GCP region (optional, for region-specific resources)
#   --dry-run     Print commands instead of executing them (optional)
#
# Example:
#   chmod +x gcp_logging_monit_config.sh
#   ./gcp_logging_monit_config.sh my-gcp-project us-east4 --dry-run
# =============================================================================

set -euo pipefail

# Parse arguments and check for --dry-run
DRY_RUN=false
ARGS=()
for arg in "$@"; do
  if [ "$arg" = "--dry-run" ]; then
    DRY_RUN=true
  else
    ARGS+=("$arg")
  fi
done

if [ "${#ARGS[@]}" -lt 1 ]; then
  echo "Usage: $0 <PROJECT_ID> [REGION] [--dry-run]"
  exit 1
fi

PROJECT_ID="${ARGS[0]}"
REGION="${ARGS[1]:-}"

run_cmd() {
  if $DRY_RUN; then
    echo "[DRY RUN] $*"
  else
    eval "$*"
  fi
}

# Set project
run_cmd "gcloud config set project '$PROJECT_ID'"

# Enable required APIs
run_cmd "gcloud services enable logging.googleapis.com monitoring.googleapis.com"

echo "Cloud Logging and Monitoring APIs enabled."

# (Optional) Create a log sink to a GCS bucket (edit BUCKET_NAME as needed)
# SINK_NAME="my-log-sink"
# BUCKET_NAME="my-logging-bucket"
# run_cmd "gcloud logging sinks create $SINK_NAME storage.googleapis.com/$BUCKET_NAME --location=global"

# (Optional) Create a basic uptime check (edit parameters as needed)
# run_cmd "gcloud monitoring uptime-checks create http my-uptime-check --host=example.com --path=/ --port=80"

# (Optional) Create a basic alerting policy (edit parameters as needed)
# run_cmd "gcloud monitoring policies create --notification-channels=<CHANNEL_ID> --policy-from-file=policy.json"

# (Optional) List log entries
# run_cmd "gcloud logging read 'resource.type=project' --limit 5"

echo "GCP logging and monitoring setup complete."
