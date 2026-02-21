process OLINK_NGS2COUNT {
    tag "$meta.id"

    input:
    tuple val(meta), path(run_dir)
    
    output:
    tuple val(meta), path("${meta.id}_ngs2count_out"), emit: ngs2count

    script:
    """
    ngs2counts \
      --output-dir ${meta.id}_ngs2counts_out \
      --split-by-library \
      $run_dir &> ${meta.id}_logs.txt
    """

    stub:
    """
    mkdir -p ${meta.id}_ngs2counts_out
    """
}