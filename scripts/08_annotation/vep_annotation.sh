#!/usr/bin/env bash

#This script annotates variants using VEP.

#Use: bash vep_annotation.sh <vcf_phased> <caller>

set -euo pipefail

VCF_PHASED="$1"
CALLER="$2"

SAMPLE_NAME=$(basename "$VCF_PHASED" "_${CALLER}_phased.vcf.gz")

VEP_CACHE_DIR="resources/vep_data"
VEP_CONTAINER_IMAGE="resources/containers/vep.sif"

REF_GENOME="resources/ref_genome/GRCh38.primary_assembly.genome.fa"

OUT_DIR="results/08_annotation/vep_local/${CALLER}/${SAMPLE_NAME}"
LOG_DIR="logs/08_annotation/vep_local/${CALLER}/${SAMPLE_NAME}"

VCF_ANNOTATED="${OUT_DIR}/${SAMPLE_NAME}_${CALLER}_vep_annotated.vcf.gz"
LOG_FILE="${LOG_DIR}/${SAMPLE_NAME}_${CALLER}_vep_local.log"

echo "Creating output directory if it doesn't exist..."
mkdir -p "$OUT_DIR"
mkdir -p "$LOG_DIR"

echo "Running local VEP annotation on ${SAMPLE_NAME}..."

apptainer exec \
    -B "$PWD":"$PWD" \
    "$VEP_CONTAINER_IMAGE" \
    vep \
        --cache \
        --offline \
        --dir_cache "$PWD/$VEP_CACHE_DIR" \
        --fasta "$PWD/$REF_GENOME" \
        --species homo_sapiens \
        --assembly GRCh38 \
        --format vcf \
        --vcf \
        -i "$PWD/$VCF_PHASED" \
        -o "$PWD/$VCF_ANNOTATED" \
        --compress_output bgzip \
        --symbol \
        --canonical \
        --mane \
        --hgvs \
        --variant_class \
        --pick_allele \
        --force_overwrite \
        --fork 2 \
        > "$LOG_FILE" 2>&1

echo "Indexing annotated VCF..."

tabix -p vcf "$VCF_ANNOTATED" 2>> "$LOG_FILE"

echo "VEP annotation completed for ${SAMPLE_NAME}."
echo "Annotated VCF: ${VCF_ANNOTATED}"
echo "Index: ${VCF_ANNOTATED}.tbi"
echo "Log: ${LOG_FILE}"