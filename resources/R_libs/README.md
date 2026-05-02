# R libraries

This directory is used to store project-local R libraries required by tools executed through Apptainer containers.

These libraries are not installed inside the `.sif` container image because Apptainer images are usually read-only. Instead, R packages are installed in this external project directory and loaded from the analysis scripts using `.libPaths()`.

## NanoMethViz

The NanoMethViz branch of module `10_methylation_visualization` uses the Bioconductor Apptainer container:

`resources/containers/bioconductor_3.19.sif`

The required R/Bioconductor packages are installed in:

`resources/R_libs/nanomethviz_bioc3.19/`

This local R library contains packages such as:

- NanoMethViz
- bsseq
- dmrseq
- edgeR
- limma
- plyranges

The installation is performed with:

`scripts/10_methylation_visualization/install_nanomethviz_packages.R`

The corresponding log is stored in:

`logs/10_methylation_visualization/install_nanomethviz_packages.log`

## Notes

This directory can become large and should not be tracked by Git.

Only this README file should be kept in the repository to document the expected structure and purpose of the directory.