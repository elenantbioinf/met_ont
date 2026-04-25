#!/usr/bin/env bash

#This script performs variant calling using DeepVariant on BAM markdup files.

#Use: bash variant_calling_deepvariant.sh <markdup.bam>

set -euo pipefail

BAM_MARKDUP="$1"

SAMPLE="$(basename "$BAM_MARKDUP" _markdup.bam)"

REF="resources/ref_genome/GRCh38.primary_assembly.genome.fa"
CONTAINER="resources/containers/deepvariant_1.10.0.sif"

OUT_DIR="results/06_variant_calling/variant_calling/deepvariant/${SAMPLE}"
INTERMEDIATE_DIR="${OUT_DIR}/intermediate_files"
LOG_DIR="logs/06_variant_calling/deepvariant"

LOG="${LOG_DIR}/${SAMPLE}_deepvariant.log"

FINAL_VCF="${OUT_DIR}/${SAMPLE}_deepvariant.vcf.gz"
FINAL_GVCF="${OUT_DIR}/${SAMPLE}_deepvariant.g.vcf.gz"

echo "Creating output directory for DeepVariant results if it doesn't exist..."
mkdir -p "$OUT_DIR"
mkdir -p "$INTERMEDIATE_DIR"
mkdir -p "$LOG_DIR"

echo "Running DeepVariant on $BAM_MARKDUP..."
apptainer run \
    -B "$PWD":"$PWD" \
    -B /tmp:/tmp \
    "$PWD/$CONTAINER" \
    /opt/deepvariant/bin/run_deepvariant \
    --model_type=ONT_R104 \
    --vcf_stats_report=true \
    --ref="$PWD/$REF" \
    --reads="$PWD/$BAM_MARKDUP" \
    --regions="chr22" \
    --output_vcf="$PWD/$FINAL_VCF" \
    --output_gvcf="$PWD/$FINAL_GVCF" \
    --intermediate_results_dir="$PWD/$INTERMEDIATE_DIR" \
    --num_shards=1 \
    > "$LOG" 2>&1

echo "DeepVariant run complete."
echo "Results saved to $FINAL_VCF and $FINAL_GVCF."
echo "Intermediate files: $INTERMEDIATE_DIR"
echo "Log: $LOG"
