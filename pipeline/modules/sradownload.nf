process SRA_DOWNLOAD {
  tag "${sample_id}_${srr}" // Associate process with custom srr label from samples_sra
  
  conda "${projectDir}/envs/sratools.yaml"

  // Files go to: fastq_data/{sample_id}/
  publishDir "${params.fastq_data}/${sample_id}", 
        mode: 'copy',
        pattern: "*.fastq.gz"

  input:
  tuple val(sample_id), val(condition), val(srr), val(lane)

  output:
  tuple val(sample_id), val(condition), path("*.fastq.gz"), emit: fastqs
  tuple val(sample_id), val(srr), path("*.fastq.gz"), emit: fastqs_by_srr 

  script:
  """
  set -euo pipefail
    
  echo "Starting to download ${srr} -> ${sample_id} ${condition} ${lane}"
  echo "[SRA_DOWNLOAD] Timestamp: \$(date)"

  # intermediate files to remain in work dir for caching/resuming
  prefetch -O . "${srr}" 
  
  echo "Running fastrq-dump" # outputs srr_1.fastq (I1), srr_2.fastq (R1), srr_3.fastq (R2)
  fasterq-dump \\
    --split-files \\
    --include-technical \\
    --threads "${task.cpus}" \\
    -O . \\
    "./${srr}"

  # rename and gzip : {sample_id}_{condition}_S1_{lane}_{read}_001.fastq
  mv "${srr}_1.fastq" "${sample_id}_${condition}_S1_${lane}_I1_001.fastq"
  mv "${srr}_2.fastq" "${sample_id}_${condition}_S1_${lane}_R1_001.fastq"
  mv "${srr}_3.fastq" "${sample_id}_${condition}_S1_${lane}_R2_001.fastq"

  # Parallel gzip (pigz) - uses all available CPUs
  pigz -p ${task.cpus} *.fastq

  echo "removing intermediate files .sra"
  rm -rf "./${srr}"

  echo "Complete: ${srr} -> ${sample_id} ${condition} ${lane}"
  ls -lh *.fastq.gz

  """
  // stub:
  // """
  // # Stub for testing pipeline structure without actual downloads
  // touch "${sample_id}_S1_${lane}_I1_001.fastq.gz"
  // touch "${sample_id}_S1_${lane}_R1_001.fastq.gz"
  // touch "${sample_id}_S1_${lane}_R2_001.fastq.gz"
  // """



}

