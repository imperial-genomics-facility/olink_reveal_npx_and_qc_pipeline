## Image building steps

### Build docker image

* `docker build -t igf_olink_r_qc:v0.1 .`

### Convert to Singularity image

* Export Docker image:
    `docker image save igf_olink_r_qc:v0.1 -o igf_olink_r_qc_v0.1.tar`

* Build Singularity image
    `singularity build igf_olink_r_qc_v0.1.sif docker-archive:igf_olink_r_qc_v0.1.tar`

