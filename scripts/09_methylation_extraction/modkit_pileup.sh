#!/usr/bin/env bash

#This script extracts methylation information from BAM files using modkit.
#Recommended BAM input: haplotagged BAM files.

#Use: bash modkit_pileup.sh <bam_haplotagged> <caller>

set -euo pipefail

BAM_HAPLOTAGGED="$1"
CALLER="$2"

SAMPLE_NAME=$(basename "$BAM_HAPLOTAGGED" "_${CALLER}_haplotagged.bam")

REF_GENOME="resources/ref_genome/GRCh38.primary_assembly.genome.fa"

OUT_DIR="results/09_methylation_extraction/${CALLER}/${SAMPLE_NAME}/bedmethyl_phased"
LOG_DIR="logs/09_methylation_extraction/${CALLER}/${SAMPLE_NAME}"

LOG_FILE="${LOG_DIR}/${SAMPLE_NAME}_${CALLER}_modkit_pileup.log"

echo "Creating output directory if it doesn't exist..."
mkdir -p "$OUT_DIR"
mkdir -p "$LOG_DIR"

echo "Extracting methylation information for ${SAMPLE_NAME} using modkit pileup..."
modkit pileup \
    --threads 4 \
    --phased \
    --modified-bases 5mC 5hmC \
    --reference "$REF_GENOME" \
    --bgzf \
    --log-filepath "$LOG_FILE" \
    "$BAM_HAPLOTAGGED" \
    "$OUT_DIR" \
    2>> "$LOG_FILE"

echo "Phased Modkit pileup completed for ${SAMPLE_NAME}."
echo "Output directory: ${OUT_DIR}"
echo "Log: ${LOG_FILE}"
