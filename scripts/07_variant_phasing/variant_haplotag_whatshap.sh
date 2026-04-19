#!/usr/bin/env bash

#This script haplotags the BAM file using the phased VCF from WhatsHap.

#Use: bash variant_haplotag_whatshap.sh <bam_markdup> <phased_vcf>

set -euo pipefail

#Input parameters
BAM_MARKDUP="$1"
PHASED_VCF="$2"

#Reference genome
REF_GENOME="resources/ref_genome/GRCh38.primary_assembly.genome.fa"

#Sample name
SAMPLE_NAME=$(basename "$PHASED_VCF" _phased.vcf.gz)

#Output directory and file names
OUTPUT_DIR="results/07_variant_phasing/haplotag/${SAMPLE_NAME}"
HAPLOTAGGED_BAM="${OUTPUT_DIR}/${SAMPLE_NAME}_haplotagged.bam"

#Logging
LOG_FILE="logs/07_variant_phasing/${SAMPLE_NAME}_whatshap_haplotag.log"

echo "Creating output and log directories if they don't exist..."
mkdir -p "$OUTPUT_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

echo "Starting haplotagging with WhatsHap for sample ${SAMPLE_NAME}..."

whatshap haplotag \
    --reference "$REF_GENOME" \
    --ignore-read-groups \
    -o "$HAPLOTAGGED_BAM" \
    "$PHASED_VCF" \
    "$BAM_MARKDUP" \
    > "$LOG_FILE" 2>&1

echo "Indexing haplotagged BAM with samtools..."
samtools index "$HAPLOTAGGED_BAM" >> "$LOG_FILE" 2>&1

echo "Haplotagging completed for sample ${SAMPLE_NAME}"
echo "Haplotagged BAM: ${HAPLOTAGGED_BAM}"
echo "BAM index: ${HAPLOTAGGED_BAM}.bai"
echo "Log file: ${LOG_FILE}"