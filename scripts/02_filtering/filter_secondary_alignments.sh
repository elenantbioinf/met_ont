#!/usr/bin/env bash

# This script runs samtools view on BAM files to filter out secondary alignments

# Use: bash filter_secondary_alignments.sh <input.bam>

set -euo pipefail

BAM_RAW="$1"
BAM_FILTERED="data/processed/$(basename "$BAM_RAW" .bam)_filtered.bam"
LOG="logs/02_filtering/$(basename "$BAM_FILTERED" .bam).log"

echo "Creating output directory if it doesn't exist..."
mkdir -p "$(dirname "$BAM_FILTERED")"
mkdir -p logs/02_filtering

echo "Filtering out secondary alignments from $BAM_RAW..."
samtools view -h -b -F 0x100 "$BAM_RAW" -o "$BAM_FILTERED" 2> "$LOG"
echo "Filtering done."

echo "Indexing the filtered BAM file..."
samtools index "$BAM_FILTERED" 2>> "$LOG"
echo "Indexing done."

echo "Output: $BAM_FILTERED."
echo "Index: ${BAM_FILTERED}.bai."
echo "Log: $LOG."