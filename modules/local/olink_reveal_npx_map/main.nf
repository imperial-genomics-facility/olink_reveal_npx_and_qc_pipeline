import groovy.text.SimpleTemplateEngine
process OLINK_REVEAL_NPX_MAP_PROJECT_CREATE {
    tag "$meta.id"
    label 'process_medium'

    container "olink_ngs2count.sif"


    input:
    tuple val(meta), path(ngs2counts_out)
    tuple val(project_name),
          val(sample_type),
          val(indexPlate),
          val(dataAnalysisRefIds),
          path(plate_design_csv),
          path(panelDataArchive)

    output:
    tuple val(meta), path("project_dir"), emit: npx_map_project
    path  "versions.yml"                , emit: npx_version

    script:
    // Exit if running this module with -profile conda / -profile mamba / -profile docker / -profile podman
    if (workflow.profile.tokenize(',').intersect(['conda', 'mamba', 'docker', 'podman']).size() >= 1) {
        error("OLINK module only supports Singularity.")
    }
    def args = task.ext.args ?: ''
    // Get template and create json file
    def engine = new SimpleTemplateEngine()
    def template = file("${moduleDir}/templates/npx_config.json").text
    def conf = engine.createTemplate(template).make([
        project_name : project_name,
        sample_type: sample_type,
        indexPlate: indexPlate,
        design_csv_path: plate_design_csv,
        ngs2counts_out: ngs2counts_out,
        dataAnalysisRefIds: dataAnalysisRefIds
    ])
    def string_conf = conf.toString()
    """
    cat > npx_config.json <<'EOF'
${string_conf}
EOF
    /app/npx-map-cli/npx-map-cli \\
    project \\
      create \\
      ${args} \\
      -p $panelDataArchive \\
      -i npx_config.json \\
      -o project_dir
    
    cat <<-'END_VERSIONS' > versions.yml
"${task.process}":
    npx_map: \$( /app/npx-map-cli/npx-map-cli --version )
END_VERSIONS
    """

    stub:
    """
    mkdir -p "project_dir"
    touch versions.yml
    """
}

process OLINK_REVEAL_NPX_MAP_PROJECT_EXPORT {
    tag "$meta.id"
    label 'process_medium'

    container "olink_ngs2count.sif"


    input:
    tuple val(meta), path(npx_map_project)
    path panelDataArchive


    output:
    tuple val(meta), path("export_dir"), emit: npx_export
    path "export_dir/*.parquet"        , emit: parquet_file
    path "versions.yml"                , emit: npx_version

    script:
    // Exit if running this module with -profile conda / -profile mamba / -profile docker / -profile podman
    if (workflow.profile.tokenize(',').intersect(['conda', 'mamba', 'docker', 'podman']).size() >= 1) {
        error("OLINK module only supports Singularity.")
    }
    def args = task.ext.args ?: ''
    """
    /app/npx-map-cli/npx-map-cli \\
    project \\
      export \\
      ${args} \\
      -i $npx_map_project \\
      -o export_dir \\
      --npx \\
      --npx-csv \\
      --analysis-report \\
      -p $panelDataArchive
    
    cat <<-'END_VERSIONS' > versions.yml
"${task.process}":
    npx_map: \$( /app/npx-map-cli/npx-map-cli --version )
END_VERSIONS
    """

    stub:
    """
    mkdir -p export_dir
    touch export_dir/test.parquet
    touch versions.yml
    """
}