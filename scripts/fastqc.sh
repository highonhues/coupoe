#!/bin/bash
#SBATCH --job-name=fastqc_coup
#SBATCH --mem=8G
#SBATCH --array=2-14
#SBATCH --cpus-per-task=6                  
#SBATCH --output=/scratch/home/agupta1/TB/logs/fastqc_%a_%j.output
#SBATCH --error=/scratch/home/agupta1/TB/logs/fastqc_%a_%j.error


# maybe at some point automate --array=2-$(($(wc -l < qc.csv)))
source /home/agupta1/miniconda3/etc/profile.d/conda.sh
conda activate fastqc

samp=$(awk -v qcv="${SLURM_ARRAY_TASK_ID}" -F "," 'NR==qcv {print $1}' qc.csv)
data_path=$(awk -v qcv="${SLURM_ARRAY_TASK_ID}" -F "," 'NR==qcv {print $2}' qc.csv)

result_dir=/scratch/home/agupta1/coup/results/Fastqc_res/${samp}_qc
mkdir -p "$result_dir"

fastqc  -t $SLURM_CPUS_PER_TASK -o "$result_dir" "${data_path}"/*.fastq*