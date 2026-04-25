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