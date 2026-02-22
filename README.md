# Nextflow pipeline for Olink Reveal data processing
A Nextflow pipeline for raw sequencing run to NPX file and QC report generation

## Steps for container image building

### BCLConvert

* Step 1: Go to BCLConvert module directory

    `cd modules/nf-core/bclconvert`

* Step 2: Download BCLConvert from [Illumina website](https://support.illumina.com/downloads/bcl-convert-v4-4-6-installers.html)
* Step 3: Build Docker image

    `docker build -t bclconvert:v4.4.6 .`

* Step 4: Export Docker image to tar

    `docker image save bclconvert:v4.4.6 -o bclconvert_v4.4.6.tar`

* Step 5: Build Singularity image

    `singularity build bclconvert_v4.4.6.sif docker-archive:bclconvert_v4.4.6.tar`

### Olink Reveal R

* Step 1: Go to olink_reveal_r_qc module directory

    `cd modules/local/olink_reveal_r_qc`

* Step 2: Build Docker image

    `docker build -t igf_olink_r_qc:v0.1 .`

* Step 4: Export Docker image to tar

    `docker image save igf_olink_r_qc:v0.1 -o igf_olink_r_qc_v0.1.tar`

* Step 5: Build Singularity image

    `singularity build igf_olink_r_qc_v0.1.sif docker-archive:igf_olink_r_qc_v0.1.tar`