process OLINK_REVEAL_R_QC {
    tag "$meta.id"
    label 'process_medium'

    container "imperialgenomicsfacility/olink_r_qc:v0.1" 

    input:
    tuple val(meta), path(ngs2counts)
    path npx_parquet_file
    path reveal_fixed_lod_csv

    output:
    path "olink_reveal_QC_report.html" , emit: npx_qc_html

    script:
    // Exit if running this module with -profile conda / -profile mamba 
    if (workflow.profile.tokenize(',').intersect(['conda', 'mamba']).size() >= 1) {
        error("OLINK module only supports Docker, Podman and Singularity.")
    }
    """
    cp ${moduleDir}/templates/olink_reveal_QC_report.ipynb .

    sed -i \
    -e 's|\$npx_parquet_file|${npx_parquet_file.name}|g' \
    -e 's|\$reveal_fixed_lod_csv|${reveal_fixed_lod_csv.name}|g' \
    olink_reveal_QC_report.ipynb

    jupyter \\
      nbconvert \\
      ${args} \\
      --to html \\
      --ExecutePreprocessor.enabled=True \\
      --ExecutePreprocessor.timeout=1200 \\
      --ExecutePreprocessor.kernel_name=IR \\
      --execute olink_reveal_QC_report.ipynb
    """

    stub:
    """
    touch olink_reveal_QC_report.html
    """
}