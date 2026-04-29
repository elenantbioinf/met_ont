#!/usr/bin/env bash

#This script summarizes base modification calls from BAM files.
#Recommended BAM input: haplotagged BAM files.

#Use: bash modkit_summary.sh <bam_haplotagged> <caller>

set -euo pipefail

BAM_HAPLOTAGGED="$1"
CALLER="$2"

SAMPLE_NAME=$(basename "$BAM_HAPLOTAGGED" "_${CALLER}_haplotagged.bam")

OUT_DIR="results/09_methylation_extraction/${CALLER}/${SAMPLE_NAME}"
LOG_DIR="logs/09_methylation_extraction/${CALLER}/${SAMPLE_NAME}"

SUMMARY_FILE="${OUT_DIR}/${SAMPLE_NAME}_${CALLER}_methylation_summary.tsv"
LOG_FILE="${LOG_DIR}/${SAMPLE_NAME}_${CALLER}_methylation_summary.log"

echo "Creating output directory if it doesn't exist..."
mkdir -p "$OUT_DIR"
mkdir -p "$LOG_DIR"

echo "Summarizing base modification calls for ${SAMPLE_NAME}..."
modkit modbam summary \
    --tsv \
    --no-sampling \
    --log-filepath "$LOG_FILE" \
    "$BAM_HAPLOTAGGED" \
    > "$SUMMARY_FILE" \
    2>> "$LOG_FILE"

echo "Modkit summary completed for ${SAMPLE_NAME}."
echo "Summary file: ${SUMMARY_FILE}"
echo "Log: ${LOG_FILE}"

