process BAM_TO_FASTQ_10X {

    tag "${sample_id}"

    conda "${projectDir}/envs/bamtofastq.yaml"

    publishDir "${params.fastq_data}/${sample_id}_${condition}",
        mode: 'copy',
        pattern: "*.fastq.gz"

    input:
    tuple val(sample_id), val(condition), path(bam_file)
    
    output:
    tuple val(sample_id), val(condition), path("*.fastq.gz"), emit: fastqs
    
    script:
    """
    set -euo pipefail
    
    echo "Starting bamtofastq: ${bam_file} -> ${sample_id} ${condition}"
    echo "Timestamp: \$(date)"
    
    # bamtofastq creates temp_out/{prefix}_fastqs/ structure in the nextflow work directory
    bamtofastq \\
        --nthreads=${task.cpus} \\
        ${bam_file} \\
        temp_out
    
    # Find and rename all fastq.gz files to cellranger convention with metadata
    # bamtofastq names: bamtofastq_S1_L001_R1_001.fastq.gz
    # new names: {sample_id}_{condition}_S1_L001_R1_001.fastq.gz
    
    # Debug: show what bamtofastq created
    echo "bamtofastq output structure:"
    find temp_out -type f -name "*.fastq.gz" 
    
    #find and rename
    echo "Renaming fastq files"
    for fq in \$(find temp_out -type f -name "*.fastq.gz"); do
        [ -e "\$fq" ] || continue
        
        # Extract the filename
        fname=\$(basename "\$fq")
        
        # Replace 'bamtofastq' prefix with sample_id_condition
        newname=\$(echo "\$fname" | sed "s/^bamtofastq_/${sample_id}_${condition}_/")
        
        echo "  \$fname -> \$newname"
        mv "\$fq" "./\$newname"
    done
    
    # Cleanup temp directory
    rm -rf temp_out
    
    echo "Complete: ${sample_id}"
    ls -lh *.fastq.gz
    
    """
}
