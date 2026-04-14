#!/usr/bin/env bash

#This script downloads the reference genome for the human genome assembly GRCh38.

set -euo pipefail

REF_URL="https://ftp.ensembl.org/pub/current_fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz"
REF_DIR="resources/ref_genome"
REF_ARCHIVE="Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz"
REF_FASTA="Homo_sapiens.GRCh38.dna.primary_assembly.fa"
REF_FINAL="GRCh38.primary_assembly.genome.fa"

echo "Creating directory for reference genome if it doesn't exist..."
mkdir -p "${REF_DIR}"

cd "${REF_DIR}"

echo "Downloading reference genome from ${REF_URL}..."
wget -O "${REF_ARCHIVE}" "${REF_URL}"

echo "Decompressing reference genome..."
gunzip -f "${REF_ARCHIVE}"

echo "Renaming reference genome..."
mv "${REF_FASTA}" "${REF_FINAL}"

echo "Indexing reference genome..."
samtools faidx "${REF_FINAL}"

echo "Download complete. Reference genome files are in ${REF_DIR}."
echo "The reference genome is ${REF_FINAL}."