#!/usr/bin/env bash

#This script prepares the reference genome for the human genome assembly GRCh38.

#Use: bash prepare_ref_genome.sh <reference_fasta>

set -euo pipefail

REF_FASTA="$1"

echo "Indexing reference genome..."
samtools faidx "${REF_FASTA}"

echo "Reference genome preparation complete."
echo "FASTA: $REF_FASTA"
echo "Index: ${REF_FASTA}.fai"