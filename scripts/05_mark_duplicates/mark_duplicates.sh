#!/usr/bin/env bash

# This script marks duplicates in aligned BAM files using Picard MarkDuplicates.

# Use: bash mark_duplicates.sh <input_bam>

set -euo pipefail

INPUT_BAM="$1"
SAMPLE="$(basename "$INPUT_BAM" .bam)"
OUTPUT_BAM="results/05_mark_duplicates/${SAMPLE}/${SAMPLE}_markdup.bam"
METRICS_FILE="results/05_mark_duplicates/${SAMPLE}/${SAMPLE}_markdup_metrics.txt"
LOG="logs/05_mark_duplicates/${SAMPLE}_mark_duplicates.log"

echo "Creating output directory for BAM files with duplicates marked if it doesn't exist..."
mkdir -p results/05_mark_duplicates/${SAMPLE}
mkdir -p logs/05_mark_duplicates

echo "Marking duplicates in $INPUT_BAM..."
picard MarkDuplicates \
    I="$INPUT_BAM" \
    O="$OUTPUT_BAM" \
    M="$METRICS_FILE" \
    CREATE_INDEX=true \
    VALIDATION_STRINGENCY=LENIENT \
    >> "$LOG" 2>&1

echo "Duplicates marked successfully"
echo "Output saved to $OUTPUT_BAM"
echo "Metrics saved to $METRICS_FILE"
echo "Index created: $OUTPUT_BAM.bai"

