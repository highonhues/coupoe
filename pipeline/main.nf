#!/usr/bin/env nextflow

// some syntax is written similar to dsl 1
nextflow.enable.dsl=2 

// Import modules

include { SRA_DOWNLOAD } from './modules/sradownload.nf'
include { BAM_TO_FASTQ_10X } from './modules/bamtofastq10x.nf'
include { FASTQ_RENAME } from './modules/fastq_rename.nf'


// Create Channels
sra_channel = Channel.fromPath(params.samples_sra)
              .splitCsv(header:true)
              .map{row -> tuple(row.sample_id,row.condition, row.srr, row.lane)}

bam_channel = Channel.fromPath(params.samples_bam)
              .splitCsv(header:true)
              .map{row -> tuple(row.sample_id, row.condition, file(row.bam_path))}
fastq_channel = Channel
            .fromPath(params.samples_fastq)
            .splitCsv(header: true)
            .map { row -> 
                def r1 = file(row.r1_path)
                def r2 = file(row.r2_path)
                def i1 = file(row.i1_path)
                
                if (!r1.exists()) error "R1 file not found: ${row.r1_path}"
                if (!r2.exists()) error "R2 file not found: ${row.r2_path}"
                if (!i1.exists()) error "I1 file not found: ${row.i1_path}"
                
                tuple(row.sample_id, row.condition, r1, r2, i1, row.lane)
            }

// Workflow
workflow {
    if (params.input_mode == 'sra'){
       SRA_DOWNLOAD(sra_channel)   
    }
    else if (params.input_mode == "bam"){
        BAM_TO_FASTQ_10X(bam_channel)
    }
    else if (params.input_mode == 'fastq_copy' || params.input_mode == 'fastq_link'){
        FASTQ_RENAME(
            fastq_channel
        )
    }
}