/*
 * Takes existing FASTQs and renames to Cell Ranger format. Supports copy or symlink modes.
 */

 process FASTQ_RENAME {
    tag "${sample_id}_${condition}_${lane}"
    
    publishDir "${params.fastq_data}/${sample_id}_${condition}",
        mode: params.input_mode == 'fastq_copy' ? 'copy' : 'link',  // 'copy' or 'link'
        pattern: "*.fastq.gz"
    
    input:
    tuple val(sample_id), val(condition), path(r1), path(r2), path(i1), val(lane)
    
    output:
    tuple val(sample_id), val(condition), path("*.fastq.gz"), emit: fastqs
    
    script:
    def prefix = condition ? "${sample_id}_${condition}" : "${sample_id}"
    def r1_out = "${prefix}_S1_${lane}_R1_001.fastq.gz"
    def r2_out = "${prefix}_S1_${lane}_R2_001.fastq.gz"
    def i1_out = "${prefix}_S1_${lane}_I1_001.fastq.gz"
    
    """
    set -euo pipefail
    
    echo "Renaming FASTQs for ${sample_id} ${condition} ${lane}"
    echo "Mode: ${params.input_mode}"
    echo "Timestamp: \$(date)"
    
    # Validate input files exist and are readable
    for f in "${r1}" "${r2}" "${i1}"; do
        if [[ ! -r "\$f" ]]; then
            echo "ERROR: Cannot read file: \$f"
            exit 1
        fi
    done
    
    # Copy and rename to Cell Ranger format
    cp "${r1}" "${r1_out}"
    cp "${r2}" "${r2_out}"
    cp "${i1}" "${i1_out}"
    
    echo "Complete: ${sample_id} ${condition} ${lane}"
    ls -lh *.fastq.gz
    """
}