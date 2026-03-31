#!/usr/bin/env bash

# This script runs mosdepth on BAM files

# Use: bash mosdepth.sh <input.bam> <output_prefix>

set -euo pipefail

BAM="$1"
PREFIX="$2"
LOG="logs/01_initial_qc/$(basename "$PREFIX")_mosdepth.log"

echo "Creating output directory if it doesn't exist..."
mkdir -p "$(dirname "$PREFIX")"
mkdir -p logs/01_initial_qc

echo "Running mosdepth on $BAM..."
mosdepth "$PREFIX" "$BAM" 2> "$LOG"

echo "Mosdepth coverage analysis done."
echo "Output prefix: $PREFIX."
echo "Log: $LOG."