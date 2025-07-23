#!/bin/bash
# tools/gcp_env_setup.sh
# ============================================================================
# GCP Environment Setup Script
#
# This script automates the installation of Google Cloud CLI components and
# (optionally) the creation of a service account for your project.
#
# Usage:
#   sudo ./gcp_env_setup.sh <PROJECT_ID> <SERVICE_ACCOUNT_NAME>
#
# Arguments:
#   PROJECT_ID            The GCP project ID (required)
#   SERVICE_ACCOUNT_NAME  The service account name (required)
#
# Example:
#   sudo ./gcp_env_setup.sh my-gcp-project arica-gcp-svc-accnt
#
# Notes:
#   - This script must be run as sudo.
#   - Service account creation steps are commented out by default; edit as needed.
#   - No secrets or keys are stored in version control.
# ============================================================================
# Usage: Run with sudo privileges if installing system packages

# Exit on error
set -e

# 1. Install Google Cloud CLI and components (if not already installed)
echo "Installing Google Cloud CLI and components..."
apt-get update
apt-get install -y google-cloud-cli \
  kubectl \
  google-cloud-cli-gke-gcloud-auth-plugin \
  google-cloud-cli-app-engine-python \
  google-cloud-cli-app-engine-python-extras \
  google-cloud-cli-cloud-build-local \
  google-cloud-cli-cloud-run-proxy \
  google-cloud-cli-firestore-emulator \
  google-cloud-cli-datastore-emulator \
  google-cloud-cli-pubsub-emulator \
  google-cloud-cli-bigtable-emulator \
  google-cloud-cli-spanner-emulator \
  google-cloud-cli-terraform-validator \
  google-cloud-cli-app-engine-go \
  google-cloud-cli-app-engine-java \
  google-cloud-cli-app-engine-grpc \
  google-cloud-cli-minikube \
  google-cloud-cli-nomos \
  google-cloud-cli-config-connector \
  google-cloud-cli-anthos-auth \
  google-cloud-cli-kpt \
  google-cloud-cli-skaffold \
  google-cloud-cli-tests \
  google-cloud-cli-local-extract

echo "Google Cloud CLI and components installed."


# 2. Parse script arguments
if [ "$#" -ne 2 ]; then
  echo "Usage: sudo $0 <PROJECT_ID> <SERVICE_ACCOUNT_NAME>"
  exit 1
fi
PROJECT_ID="$1"
SERVICE_ACCOUNT="$2"
SERVICE_ACCOUNT_EMAIL="$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com"

# Uncomment and edit the following lines as needed:
# echo "Creating service account..."
# gcloud iam service-accounts create $SERVICE_ACCOUNT \
#   --description="Service account for automation" \
#   --display-name="GCP Service Account"

# echo "Assigning Storage Admin role to service account..."
# gcloud projects add-iam-policy-binding $PROJECT_ID \
#   --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
#   --role="roles/storage.admin"

# echo "Creating service account key in ~/.gcp/ ..."
# mkdir -p ~/.gcp
# gcloud iam service-accounts keys create ~/.gcp/arica-gcp-svc-accnt-key.json \
#   --iam-account=$SERVICE_ACCOUNT_EMAIL

# echo "To use this service account locally, add this to your ~/.bashrc:"
# echo "export GOOGLE_APPLICATION_CREDENTIALS=\"$HOME/.gcp/arica-gcp-svc-accnt-key.json\""

echo "GCP environment setup script complete. Edit PROJECT_ID and uncomment service account steps as needed."
