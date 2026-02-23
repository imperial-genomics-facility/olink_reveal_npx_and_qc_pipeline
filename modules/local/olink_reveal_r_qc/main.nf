import groovy.text.SimpleTemplateEngine
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
    // check args
    def args = task.ext.args ?: ''
    // generate template
    def engine = new SimpleTemplateEngine()
    def template = file("${moduleDir}/templates/olink_reveal_QC_report.ipynb").text
    def conf = engine.createTemplate(template).make([
        count2npx_out : npx_parquet_file,
        reveal_fixed_lod_csv: reveal_fixed_lod_csv.name
    ])
    def string_conf = conf.toString()
    """
    cat > olink_reveal_QC_report.ipynb <<'EOF'
${string_conf}
EOF

    jupyter \\
      nbconvert \\
      ${args} \\
      --to html \\
      --execute olink_reveal_QC_report.ipynb
    """

    stub:
    """
    touch olink_reveal_QC_report.html
    """
}