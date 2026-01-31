#!/usr/bin/env nextflow

process FASTQC {

    tag "${meta.id}"

    conda 'bioconda::fastqc=0.12.1'

    
    input:
    tuple val(meta), path(reads)

    output:
    tuple val(meta), path("*.html"), emit: html
    tuple val(meta), path("*.zip") , emit: zip
    path  "versions.yml"           , emit: versions

    script:
    def args  = task.ext.args ?: ''





}