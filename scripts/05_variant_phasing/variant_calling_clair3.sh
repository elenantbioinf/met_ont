#!/usr/bin/env bash

#This script runs Clair3 for variant calling on filtered BAM files.

#Use: bash variant_calling_clair3.sh <filtered.bam>

set -euo pipefail

BAM_FILTERED="$1"
SAMPLE="$(basename "$BAM_FILTERED" .bam)"
REF="resources/ref_genome/GRCh38.primary_assembly.genome.fa"
MODEL="resources/clair3_model/r1041_e82_400bps_hac_v500"
OUTDIR="results/05_variant_phasing/variant_calling/${SAMPLE}"
LOG="logs/05_variant_phasing/${SAMPLE}_clair3.log"
FINAL_VCF="${OUTDIR}/${SAMPLE}_clair3.vcf.gz"
FINAL_TBI="${OUTDIR}/${SAMPLE}_clair3.vcf.gz.tbi"

echo "Creating output directory for Clair3 results if it doesn't exist..."
mkdir -p "$OUTDIR"
mkdir -p logs/05_variant_phasing

echo "Running Clair3 on $BAM_FILTERED..."
run_clair3.sh \
    --bam_fn="$BAM_FILTERED" \
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


