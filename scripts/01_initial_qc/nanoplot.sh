#!/usr/bin/env bash

# This script runs nanoplot on BAM files

# Use: bash nanoplot.sh <input.bam> <output_directory> 

set -euo pipefail

BAM="$1"
OUTDIR="$2"
SAMPLE="$(basename "$BAM" .bam)"
LOG="logs/01_initial_qc/${SAMPLE}_nanoplot.log"

echo "Creating output directory if it doesn't exist..."
mkdir -p "$OUTDIR"
mkdir -p logs/01_initial_qc

echo "Running NanoPlot on $BAM..."
NanoPlot --bam "$BAM" -o "$OUTDIR" -p "$SAMPLE" 2> "$LOG"

echo "NanoPlot analysis done."
echo "Output directory: $OUTDIR."
echo "Log: $LOG."