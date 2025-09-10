#!/bin/bash
#SBATCH --job-name=cellranger_array
#SBATCH --mem=120G
#SBATCH --cpus-per-task=28
#SBATCH --partition=nodes   
#SBATCH --array=2-4                      
#SBATCH --output=/scratch/home/agupta1/coup/logs/cR_%A_%j.output
#SBATCH --error=/scratch/home/agupta1/coup/logs/cR_%A_%j.error

    
#for more on array jobs https://github.com/hbc/knowledgebase/blob/master/rc/arrays_in_slurm.md
#for more on cellranger with array https://github.com/bcbio/singlecell-reports/blob/418ca1a7838adfa02f3e81576396c14faf5ea348/pre-process-w-cellranger.md?plain=1#L159

source /home/agupta1/miniconda3/etc/profile.d/conda.sh
conda activate cellranger

#the csv has header with sample_name,path to fastq folder hence array should always start with 2

samp=$(awk -v awkv="${SLURM_ARRAY_TASK_ID}" -F "," 'NR==awkv {print $1}' samplegiver.csv)
samp_path=$(awk -v awkv="${SLURM_ARRAY_TASK_ID}" -F "," 'NR==awkv {print $2}' samplegiver.csv)

# Make a dedicated output directory for this sample
outdir=/scratch/home/agupta1/coup/results/${samp}_cr
mkdir -p "$outdir"

cellranger count \
  --id=${samp}_cr \
  --transcriptome=/scratch/home/agupta1/coup/data/ref_mm10/refdata-gex-mm10-2020-A \
  --fastqs=${samp_path} \
  --sample=${samp} \
  --output-dir="${outdir}" \
  --create-bam=true \
  --localcores=$SLURM_CPUS_PER_TASK \
  --localmem=$(( SLURM_MEM_PER_NODE / 1024 ))  # Cell R uses GB units