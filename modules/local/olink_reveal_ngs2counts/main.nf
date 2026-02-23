process OLINK_NGS2COUNTS {
    tag "$meta.id"
    label 'process_medium'

    container "olink_ngs2counts.sif"

    input:
    tuple val(meta), path(run_dir)
    
    output:
    tuple val(meta), path("${meta.id}_ngs2counts_out"), emit: ngs2counts
    path  "versions.yml"                              , emit: versions

    script:
    // Exit if running this module with -profile conda / -profile mamba / -profile docker / -profile podman
    if (workflow.profile.tokenize(',').intersect(['conda', 'mamba', 'docker', 'podman']).size() >= 1) {
        error("NGS2COUNT module does only support Singularity.")
    }
    def args = task.ext.args ?: ''
    """
    OLINK_LOG_LEVEL=debug \\
      ngs2counts \\
      ${args} \\
      --output-dir ${meta.id}_ngs2counts_out \\
      --split-by-library \\
      $run_dir &> ${meta.id}_logs.txt
    
    cat <<-'END_VERSIONS' > versions.yml
"${task.process}":
    ngs2counts: \$( ngs2counts --version|cut -d ',' -f1 )
END_VERSIONS
    """

    stub:
    """
    mkdir -p ${meta.id}_ngs2counts_out
    touch versions.yml
    """
}