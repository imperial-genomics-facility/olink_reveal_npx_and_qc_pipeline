#!/usr/bin/env nextflow
nextflow.enable.dsl = 2
/*
* PARAMS
*/
params.run_id = null
params.run_dir = null
params.project_name = null
params.sample_type = null
params.plate_design_csv = null
params.reveal_fixed_lod_csv = null
params.dataAnalysisRefIds = null
params.panelDataArchive = null
/*
* IMPORT
*/
include { DEMULT_SUBSAMPLE_QC } from './workflows/main'
include { OLINK_COUNT_QC } from './workflows/main'
/*
* WORKFLOW
*/

workflow {
    main:
        // Validate params first
        def required_params = [
            'run_id',
            'run_dir',
            'project_name',
            'sample_type',
            'plate_design_csv',
            'reveal_fixed_lod_csv',
            'dataAnalysisRefIds',
            'panelDataArchive'
        ]
        def missing_params = required_params.findAll { param -> params[param] == null }
        if (missing_params) {
            error "Missing required parameters:\n${missing_params.collect { "  --${it}" }.join('\n')}"
        }
        // run demultiplexing
        DEMULT_SUBSAMPLE_QC(
            params.run_id,
            params.run_dir
        )
        // run olink processing
        OLINK_COUNT_QC(
            params.run_dir,
            params.plate_design_csv,
            params.reveal_fixed_lod_csv,
            params.project_name,
            params.sample_type,
            params.dataAnalysisRefIds,
            params.panelDataArchive
        )
    publish:
        bclconvert_report = DEMULT_SUBSAMPLE_QC.out.bclconvert_report
        npx_export = OLINK_COUNT_QC.out.npx_map_out
        npx_qc_html = OLINK_COUNT_QC.out.npx_qc_html
}

output {
    bclconvert_report {
        path "bclconvert"
    }
    npx_qc_html {
        path "npx_qc_report"
    }
    npx_export {
        path "npx_export"
    }
}