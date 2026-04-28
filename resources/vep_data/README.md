# VEP local data

This directory contains local Ensembl VEP cache and FASTA files used for offline variant annotation.

These files are required to run VEP locally with Apptainer/Singularity, but they are not versioned by Git because they are large external resources.

Expected content after installation includes the Ensembl VEP cache and the corresponding GRCh38 FASTA files for Homo sapiens.

First, the VEP Apptainer/Singularity image must be installed.

Then, the data can be installed with:

```bash
apptainer exec \
  -B "$PWD":"$PWD" \
  resources/containers/vep.sif \
  INSTALL.pl \
    -c "$PWD/resources/vep_data" \
    -a cf \
    -s homo_sapiens \
    -y GRCh38
```