#!/usr/bin/env bash

#This script runs Clair3 for variant calling on BAM files with duplicates marked.

#Use: bash variant_calling_clair3.sh <markdup.bam>

set -euo pipefail

BAM_MARKDUP="$1"

SAMPLE="$(basename "$BAM_MARKDUP" _markdup.bam)"

REF="resources/ref_genome/GRCh38.primary_assembly.genome.fa"
MODEL="resources/clair3_model/r1041_e82_400bps_hac_v500"

OUTDIR="results/06_variant_calling/variant_calling/clair3/${SAMPLE}"
LOG_DIR="logs/06_variant_calling/clair3"
LOG="${LOG_DIR}/${SAMPLE}_clair3.log"

FINAL_VCF="${OUTDIR}/${SAMPLE}_clair3.vcf.gz"
FINAL_TBI="${OUTDIR}/${SAMPLE}_clair3.vcf.gz.tbi"

echo "Creating output directory for Clair3 results if it doesn't exist..."
mkdir -p "$OUTDIR"
mkdir -p "$LOG_DIR"

echo "Running Clair3 on $BAM_MARKDUP..."
run_clair3.sh \
    --bam_fn="$BAM_MARKDUP" \
    --ref_fn="$REF" \
    --model_path="$MODEL" \
    --threads=8 \
    --platform=ont \
    --output="$OUTDIR" \
    > "$LOG" 2>&1

mv "${OUTDIR}/merge_output.vcf.gz" "$FINAL_VCF"
mv "${OUTDIR}/merge_output.vcf.gz.tbi" "$FINAL_TBI"

echo "Clair3 run complete."
echo "Results saved to $FINAL_VCF and $FINAL_TBI."
echo "Log saved to $LOG."


