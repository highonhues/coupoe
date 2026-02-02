#!/usr/bin/env nextflow

// Import modules

include { SRA_DOWNLOAD } from './modules/sradownload.nf'
include { BAM_TO_FASTQ_10X } from './modules/bamtofastq10x.nf'


// Create Channels
sra_channel = Channel.fromPath(params.samples_sra)
              .splitCsv(header:true)
              .map{row -> tuple(row.sample_id,row.condition, row.srr, row.lane)}

bam_channel = Channel.fromPath(params.samples_bam)
              .splitCsv(header:true)
              .map{row -> tuple(row.sample_id, row.condition, file(row.bam_path))}


// Workflow
workflow {
    if (params.input_mode == 'sra'){
       SRA_DOWNLOAD(sra_channel)   
    }
    else if (params.input_mode == "bam"){
        BAM_TO_FASTQ_10X(bam_channel)
    }
}