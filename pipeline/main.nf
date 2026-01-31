#!/usr/bin/env nextflow



include { SRA_DOWNLOAD } from './modules/sradownload.nf'

sra_channel = Channel.fromPath(params.samples_sra)
              .splitCsv(header:true)
              .map{row -> tuple(row.sample_id,row.condition, row.srr, row.lane)}
workflow {
    SRA_DOWNLOAD(sra_channel)
}