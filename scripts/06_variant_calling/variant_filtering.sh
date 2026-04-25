#!/usr/bin/env bash

#This script filters the variants based on PASS status.

#Use: bash variant_filtering.sh <input_vcf.gz> <caller_name>

set -euo pipefail

INPUT_VCF="$1"
CALLER_NAME="$2"

SAMPLE="$(basename "$INPUT_VCF" _${CALLER_NAME}.vcf.gz)"

OUTPUT_DIR="results/06_variant_calling/variant_filtering/${CALLER_NAME}/${SAMPLE}"
LOG_DIR="logs/06_variant_calling/variant_filtering/${CALLER_NAME}"

OUTPUT_VCF="${OUTPUT_DIR}/${SAMPLE}_${CALLER_NAME}_pass.vcf.gz"
LOG="${LOG_DIR}/${SAMPLE}_${CALLER_NAME}_pass.log"

echo "Creating output and log directories if they don't exist..."
mkdir -p "$OUTPUT_DIR"
mkdir -p "$LOG_DIR"

echo "Filtering PASS variants from ${INPUT_VCF}..."
bcftools view \
    -f PASS \
    -Oz \
    -o "${OUTPUT_VCF}" \
    "${INPUT_VCF}" \
    2> "${LOG}"

echo "Indexing filtered VCF..."
bcftools index -t "${OUTPUT_VCF}" 2>> "${LOG}"

echo "Variant filtering complete."
echo "Output VCF with PASS variants: $OUTPUT_VCF"
echo "Index: ${OUTPUT_VCF}.tbi"
echo "Log: $LOG"