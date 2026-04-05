#!/usr/bin/env bash

# This script runs mosdepth on BAM files

# Use: bash mosdepth.sh <input.bam> <output_prefix>

set -euo pipefail

BAM="$1"
PREFIX="$2"

LOG_DIR="$(dirname "$PREFIX" | sed 's|^results/|logs/|')"
LOG="${LOG_DIR}/$(basename "$PREFIX")_mosdepth.log"

echo "Creating output directory if it doesn't exist..."
mkdir -p "$(dirname "$PREFIX")"
mkdir -p "$LOG_DIR"

echo "Running mosdepth on $BAM..."
mosdepth "$PREFIX" "$BAM" 2> "$LOG"

echo "Mosdepth coverage analysis done."
echo "Output prefix: $PREFIX."
echo "Log: $LOG."