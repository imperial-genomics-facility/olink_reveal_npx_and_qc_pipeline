import groovy.text.SimpleTemplateEngine
process OLINK_REVEAL_R_QC {
    tag "$meta.id"
    label 'process_medium'

    container "imperialgenomicsfacility/olink_r_qc:v0.1" 

    input:
    tuple val(meta), path(count2npx_out)
    path reveal_fixed_lod_csv

    output:
    tuple val(meta), path("olink_reveal_QC_report.html"), emit: npx_qc_html

    script:
    def engine = new SimpleTemplateEngine()
    def template = file("templates/olink_reveal_QC_report.ipynb").text
    def conf = engine.createTemplate(template).make([
        count2npx_out : count2npx_out,
        reveal_fixed_lod_csv: reveal_fixed_lod_csv.name
    ])
    def string_conf = conf.toString()
    """
    cat > olink_reveal_QC_report.ipynb <<'EOF'
${string_conf}
EOF

    jupyter nbconvert --to html --execute olink_reveal_QC_report.ipynb
    """

    stub:
    """
    touch olink_reveal_QC_report.html
    """
}