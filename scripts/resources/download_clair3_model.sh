#!/usr/bin/env bash

#This script downloads the Clair3 model for variant calling and phasing.

set -euo pipefail

MODEL_URL="https://cdn.oxfordnanoportal.com/software/analysis/models/clair3/r1041_e82_400bps_hac_v500.tar.gz"
MODEL_DIR="resources/clair3_model"
MODEL_ARCHIVE="r1041_e82_400bps_hac_v500.tar.gz"
MODEL_NAME="${MODEL_ARCHIVE%.tar.gz}"

echo "Creating directory for Clair3 model if it doesn't exist..."
mkdir -p "${MODEL_DIR}"

cd "${MODEL_DIR}"

echo "Downloading Clair3 model from ${MODEL_URL}..."
wget -O "${MODEL_ARCHIVE}" "${MODEL_URL}"
tar -xzf "${MODEL_ARCHIVE}"

echo "Download complete. Model files are in ${MODEL_DIR}."
echo "The model is ${MODEL_NAME}."