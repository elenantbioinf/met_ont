#!/usr/bin/env bash

# This script runs samtools flagstat on BAM files

# Use: bash flagstat.sh <input.bam> <output.txt> [log_dir]

set -euo pipefail

BAM="$1"
OUT="$2"

LOG_DIR="$(dirname "$OUT" | sed 's|^results/|logs/|')"
LOG="${LOG_DIR}/$(basename "$OUT" .txt).log"

echo "Creating output directory if it doesn't exist..."
mkdir -p "$(dirname "$OUT")"
mkdir -p "$LOG_DIR"

echo "Running samtools flagstat on $BAM..."
samtools flagstat "$BAM" > "$OUT" 2> "$LOG"

echo "SAMtools flagstat analysis done."
echo "Output: $OUT."
echo "Log: $LOG."