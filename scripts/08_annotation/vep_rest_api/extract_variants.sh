#!/usr/bin/env bash

#This script extracts variants from the vcf and saves them in a tsv file.

#Use: bash extract_variants.sh <vcf_file> <output_tsv>

set -euo pipefail

#Input parameters
VCF_FILE="$1"
OUTPUT_TSV="$2"

#Sample name and log file
SAMPLE_NAME=$(basename "$VCF_FILE" _phased.vcf.gz)
LOG_FILE="logs/08_annotation/${SAMPLE_NAME}_variant_extraction.log"

echo "Creating output directory if it doesn't exist..."
mkdir -p "$(dirname "$OUTPUT_TSV")"
mkdir -p "$(dirname "$LOG_FILE")"

echo "Adding header for output TSV file..."

echo -e "CHROM\tPOS\tID\tREF\tALT\tQUAL\tGENOTYPE\tPHASE_SET" > "$OUTPUT_TSV"

echo "Extracting variants from ${VCF_FILE} and saving to ${OUTPUT_TSV}..."

bcftools query -f '%CHROM\t%POS\t%ID\t%REF\t%ALT\t%QUAL\t[%GT]\t[%PS]\n' \
    "$VCF_FILE" >> "$OUTPUT_TSV" \
    2> "$LOG_FILE"

echo "Variant extraction completed for sample ${SAMPLE_NAME}"
echo "Output TSV: ${OUTPUT_TSV}"
echo "Log file: ${LOG_FILE}"