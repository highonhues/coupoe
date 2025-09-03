#!/bin/bash
#SBATCH --job-name=multiqc
#SBATCH --mem=8G
#SBATCH --cpus-per-task=6                  
#SBATCH --output=/scratch/home/agupta1/TB/logs/multiqc__%j.output
#SBATCH --error=/scratch/home/agupta1/TB/logs/multiqc_%j.error

source /home/agupta1/miniconda3/etc/profile.d/conda.sh
conda activate multiqc

cd /scratch/home/agupta1/coup/results/Fastqc_res
multiqc . -o /scratch/home/agupta1/coup/results/Multiqc_raw