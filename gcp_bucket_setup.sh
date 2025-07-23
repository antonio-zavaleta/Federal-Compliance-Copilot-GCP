#!/bin/bash
# =============================================================================
# GCP Bucket Setup Script
#
# This script creates and configures a Google Cloud Storage (GCS) bucket with
# best practices for security, compliance, and lifecycle management.
#
# Usage:
#   chmod +x gcp_bucket_setup.sh
#   ./gcp_bucket_setup.sh <BUCKET_NAME> <REGION> [PROJECT_ID] [LIFECYCLE_CONFIG] [--dry-run]
#
# Arguments:
#   BUCKET_NAME         The name of the GCS bucket to create (required)
#   REGION              The GCP region for the bucket (required)
#   PROJECT_ID          The GCP project ID (optional, uses default if omitted)
#   LIFECYCLE_CONFIG    Path to a lifecycle YAML/JSON file (optional)
#   --dry-run           Print commands instead of executing them (optional)
#
# Example:
#   chmod +x gcp_bucket_setup.sh
#   ./gcp_bucket_setup.sh my-bucket us-central1 my-gcp-project lifecycle.json --dry-run
#
# Sample lifecycle configuration (lifecycle.json):
# {
#   "rule": [
#     {
#       "action": {"type": "Delete"},
#       "condition": {"age": 365}
#     }
#   ]
# }
# This example deletes objects older than 365 days.
#
# Default lifecycle settings: By default, a new GCS bucket has no lifecycle rules set. Objects remain in the bucket until you delete them manually or configure a lifecycle rule.
#   or
# ./gcp_bucket_setup.sh rfp-data-src us-east4 federal-compliance-copilot-gcp --dry-run
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

if [ "${#ARGS[@]}" -lt 2 ]; then
  echo "Usage: $0 <BUCKET_NAME> <REGION> [PROJECT_ID] [LIFECYCLE_CONFIG] [--dry-run]"
  exit 1
fi

BUCKET_NAME="${ARGS[0]}"
REGION="${ARGS[1]}"
PROJECT_ID="${ARGS[2]:-}"
LIFECYCLE_CONFIG="${ARGS[3]:-}"

run_cmd() {
  if $DRY_RUN; then
    echo "[DRY RUN] $*"
  else
    eval "$*"
  fi
}

# Set project if provided
if [ -n "$PROJECT_ID" ]; then
  run_cmd "gcloud config set project '$PROJECT_ID'"
fi

# Create the bucket
if gsutil ls -b "gs://$BUCKET_NAME" >/dev/null 2>&1; then
  echo "Bucket gs://$BUCKET_NAME already exists. Skipping creation."
else
  run_cmd "gsutil mb -l '$REGION' 'gs://$BUCKET_NAME'"
  echo "Bucket gs://$BUCKET_NAME created."
fi

# Enable uniform bucket-level access
run_cmd "gsutil uniformbucketlevelaccess set on 'gs://$BUCKET_NAME'"

# Enable versioning
run_cmd "gsutil versioning set on 'gs://$BUCKET_NAME'"

echo "GCS bucket setup complete."

# Apply lifecycle config if provided
if [ -n "$LIFECYCLE_CONFIG" ]; then
  run_cmd "gsutil lifecycle set '$LIFECYCLE_CONFIG' 'gs://$BUCKET_NAME'"
  echo "Lifecycle configuration applied from $LIFECYCLE_CONFIG."
else
  echo "No lifecycle configuration provided. Skipping."
fi

# (Optional) Set default encryption (Google-managed by default)
# To use a CMEK, uncomment and edit the following:
# run_cmd "gsutil encryption -k projects/PROJECT_ID/locations/LOCATION/keyRings/KEYRING/cryptoKeys/KEY 'gs://$BUCKET_NAME'"

# (Optional) Add labels
# run_cmd "gsutil label ch -l environment:dev -l owner:team 'gs://$BUCKET_NAME'"

