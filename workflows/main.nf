include { BCLCONVERT } from '../modules/nf-core/bclconvert/main'
include { FASTQC } from '../modules/nf-core/fastqc/main'
include { SEQTK_SAMPLE } from '../modules/nf-core/seqtk/sample/main'
include { OLINK_NGS2COUNTS } from '../modules/local/olink_reveal_ngs2counts/main'
include { OLINK_REVEAL_NPX_MAP_PROJECT_CREATE } from '../modules/local/olink_reveal_npx_map/main'
include { OLINK_REVEAL_NPX_MAP_PROJECT_EXPORT } from '../modules/local/olink_reveal_npx_map/main'
include { OLINK_REVEAL_R_QC } from '../modules/local/olink_reveal_r_qc/main'

workflow DEMULT_SUBSAMPLE_QC {
    take:
        run_id
        run_dir
        // run_ch  // [id: run], samplesheet, run_path
    main:
        run_ch = channel.of(tuple(
            [id: run_id],
            file("templates/samplesheet.csv"),
            file(run_dir)
        ))
        BCLCONVERT(run_ch)
        undetermined_fastqs = BCLCONVERT.out.undetermined
        formatted_fqs = undetermined_fastqs
                        .map { entry -> entry[1]
                        }
                        .flatMap()
                        .map { fq ->
                            def id = fq.baseName //.replaceAll(/\.fastq\.gz$/, '')
                            [[id: id], fq, 10000]
                        }
        SEQTK_SAMPLE(formatted_fqs)
        FASTQC(SEQTK_SAMPLE.out.reads)
    emit:
        bclconvert_report = BCLCONVERT.out.reports
        bclconvert_vr = BCLCONVERT.out.versions
        fastqc_html = FASTQC.out.html
        fastqc_vr = FASTQC.out.versions_fastqc
}

workflow OLINK_COUNT_QC {
    take:
        run_id
        run_dir
        plate_design_csv
        reveal_fixed_lod_csv
        project_name
        sample_type
        dataAnalysisRefIds
        panelDataArchive
    main:
        run_ch = channel.of(tuple([id:run_id], file(run_dir)))
        OLINK_NGS2COUNTS(run_ch)
        olink_project_ch = channel.of(tuple(
            project_name,
            sample_type,
            dataAnalysisRefIds,
            plate_design_csv,
            panelDataArchive
        ))
        OLINK_REVEAL_NPX_MAP_PROJECT_CREATE(
            OLINK_NGS2COUNTS.out.ngs2counts,
            olink_project_ch
        )
        OLINK_REVEAL_NPX_MAP_PROJECT_EXPORT(
            OLINK_REVEAL_NPX_MAP_PROJECT_CREATE.out.npx_map_project
        )
        OLINK_REVEAL_R_QC(
            OLINK_REVEAL_NPX_MAP_PROJECT_EXPORT.out.parquet_file,
            reveal_fixed_lod_csv
        )
    emit:
        ngs2count_out = OLINK_NGS2COUNTS.out.ngs2count
        ngs2count_vrt = OLINK_NGS2COUNTS.out.versions
        npx_map_out = OLINK_REVEAL_NPX_MAP_PROJECT_CREATE.out.npx_map_project
        npx_map_vr = OLINK_REVEAL_NPX_MAP_PROJECT_CREATE.out.npx_version
        npx_qc_html = OLINK_REVEAL_R_QC.out.npx_qc_html
}