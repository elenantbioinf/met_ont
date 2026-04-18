#!/usr/bin/env bash

#This script filters the variants based on PASS status.

#Use: bash variant_filtering.sh <input_vcf.gz>

set -euo pipefail

INPUT_VCF="$1"
SAMPLE="$(basename "$INPUT_VCF" .vcf.gz)"
OUTPUT_VCF="results/06_variant_phasing/variant_filtering/${SAMPLE}_pass.vcf.gz"
LOG="logs/06_variant_phasing/variant_filtering/${SAMPLE}.log"

echo "Creating output and log directories if they don't exist..."
mkdir -p "$(dirname "$OUTPUT_VCF")"
mkdir -p "$(dirname "$LOG")"

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