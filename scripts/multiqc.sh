#!/bin/bash
#SBATCH --job-name=multiqc
#SBATCH --mem=8G
#SBATCH --cpus-per-task=6                  
#SBATCH --output=/scratch/home/agupta1/TB/logs/multiqc__%j.output
#SBATCH --error=/scratch/home/agupta1/TB/logs/multiqc_%j.error

source /home/agupta1/miniconda3/etc/profile.d/conda.sh
conda activate multiqc

# cd /scratch/home/agupta1/coup/results/Fastqc_res
# multiqc . -o /scratch/home/agupta1/coup/results/Multiqc_raw

# for specific read types
mkdir -p "/scratch/home/agupta1/coup/results/Multiqc_raw/R1_reads"
mkdir -p "/scratch/home/agupta1/coup/results/Multiqc_raw/R2_reads"

cd /scratch/home/agupta1/coup/results/Fastqc_res

multiqc . -o /scratch/home/agupta1/coup/results/Multiqc_raw/R1_reads --ignore "*R2*" --ignore "*I1*" --filename multiqc_report_R1_reads.html
multiqc . -o /scratch/home/agupta1/coup/results/Multiqc_raw/R2_reads --ignore "*R1*" --ignore "*I1*" --filename multiqc_report_R2_reads.html