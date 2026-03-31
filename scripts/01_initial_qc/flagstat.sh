#!/usr/bin/env bash

# This script runs samtools flagstat on BAM files

# Use: bash flagstat.sh <input.bam> <output.txt>

set -euo pipefail

BAM="$1"
OUT="$2"
LOG="logs/01_initial_qc/$(basename "$OUT").log"

echo "Creating output directory if it doesn't exist..."
mkdir -p "$(dirname "$OUT")"
mkdir -p logs/01_initial_qc

echo "Running samtools flagstat on $BAM..."
samtools flagstat "$BAM" > "$OUT" 2> "$LOG"

echo "SAMtools flagstat analysis done."
echo "Output: $OUT."
echo "Log: $LOG."