#!/usr/bin/env bash

#This script performs variant phasing using WhatsHap.

#Use: bash variant_phasing_whatshap.sh <bam_markdup> <vcf_pass>

set -euo pipefail

#Input parameters
BAM_MARKDUP="$1"
VCF_PASS="$2"

#Reference genome
REF_GENOME="resources/ref_genome/GRCh38.primary_assembly.genome.fa"

#Sample name
SAMPLE_NAME=$(basename "$VCF_PASS" _clair3_pass.vcf.gz)

#Output directory and file names
OUTPUT_DIR="results/07_variant_phasing/whatshap/${SAMPLE_NAME}"
PHASED_VCF="${OUTPUT_DIR}/${SAMPLE_NAME}_phased.vcf.gz"

#Logging
LOG_FILE="logs/07_variant_phasing/${SAMPLE_NAME}_whatshap_phasing.log"

echo "Creating output and log directories if they don't exist..."

mkdir -p "$OUTPUT_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

echo "Starting variant phasing with WhatsHap for sample ${SAMPLE_NAME}..."

whatshap phase \
    --reference "$REF_GENOME" \
    --ignore-read-groups \
    --indels \
    --tag=PS \
    -o "$PHASED_VCF" \
    "$VCF_PASS" \
    "$BAM_MARKDUP" \
    > "$LOG_FILE" 2>&1

echo "Indexing phased VCF with tabix..."
tabix -p vcf "$PHASED_VCF" >> "$LOG_FILE" 2>&1

echo "Variant phasing completed for sample ${SAMPLE_NAME}"
echo "Phased VCF: ${PHASED_VCF}"
echo "Index file: ${PHASED_VCF}.tbi"
echo "Log file: ${LOG_FILE}"