#!/usr/bin/env nextflow
nextflow.enable.dsl=2

process TEST_SLURM {
    executor 'slurm'
    queue 'nodes'
    cpus 1
    memory '1.GB'
    time '1m'
    
    output:
    stdout
    
    script:
    """
    echo "Running on: \$(hostname)"
    echo "SLURM_JOB_ID: \${SLURM_JOB_ID:-NOT_SET}"
    echo "Executor working!"
    sleep 5
    """
}

workflow {
    TEST_SLURM() | view
}