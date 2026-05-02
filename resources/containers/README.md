# Containers

This directory contains Singularity/Apptainer container images for tools that are executed through containers instead of Conda environments.

Singularity/Apptainer must be installed to run the following tools:

## DeepVariant

DeepVariant is executed using an Apptainer container generated from the official Docker image.

To download the DeepVariant container image, run the following command from the root of the project:

```bash
apptainer pull resources/containers/deepvariant_1.10.0.sif \
  docker://google/deepvariant:1.10.0
```

The generated image will be stored as:

`resources/containers/deepvariant_1.10.0.sif`

## VEP 

Ensembl VEP is executed using an Apptainer container generated from the official Ensembl Docker image.

To download the VEP container image, run the following command from the root of the project:

```bash
apptainer pull resources/containers/vep.sif docker://ensemblorg/ensembl-vep
```

The generated image will be stored as: 

`resources/containers/vep.sif` 

## Bioconductor

NanoMethViz is executed through this Bioconductor Apptainer container instead of a Conda environment because recent NanoMethViz versions were not resolved correctly in the local linux-64 Conda environment.

To download the Bioconductor container image, run the following command from the root of the project:

```bash
apptainer pull resources/containers/bioconductor_3.19.sif \
  docker://bioconductor/bioconductor_docker:RELEASE_3_19
```

The generated image will be stored as:

`resources/containers/bioconductor_3.19.sif`

NanoMethViz and related R packages are installed outside the container in:

`resources/R_libs/nanomethviz_bioc3.19/`

This is done because the .sif image is treated as a read-only execution environment.