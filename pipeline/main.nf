#!/usr/bin/env nextflow

params.samplesheet = "samples.csv"

workflow {
    println "=== Starting workflow ==="
    
    Channel.fromPath(params.samplesheet)
        .splitCsv(header: true)
        .view { "After splitCsv: $it" }
        .map { row ->
            def meta = [id: row.sample, condition: row.condition]
            def reads = [row.fastq_1, row.fastq_2]
                .findAll { it }
                .collect { file(it) }
            return [meta, reads]
        }
        .view { "After first map: $it" }
        .groupTuple(by: [0])
        .view { "After groupTuple: $it" }
        .map { meta, reads_list ->
            // Flatten the nested lists
            def all_reads = reads_list.flatten()
            return [meta, all_reads]
        }
        .view { "Final result: $it" }
}