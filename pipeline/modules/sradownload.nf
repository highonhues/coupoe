process SRA_DOWNLOAD {
  tag "$srr" // Associate process with custom srr label from samples_sra
  conda 

  input:
  tuple val(sample_id), val(srr)

  output:
  tuple val(sample_id)

  script:
  """
  echo $code
  """
}