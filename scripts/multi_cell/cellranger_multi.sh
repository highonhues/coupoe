#!/bin/bash
#SBATCH --job-name=cellranger_multi
#SBATCH --mem=120G
#SBATCH --cpus-per-task=28
#SBATCH --time=72:00:00
#SBATCH --partition=nodes                     
#SBATCH --output=/scratch/home/agupta1/coup/logs/cRm_%A_%j.output
#SBATCH --error=/scratch/home/agupta1/coup/logs/cRm_%A_%j.error

source /home/agupta1/miniconda3/etc/profile.d/conda.sh
conda activate cellranger

outdir=/scratch/home/agupta1/coup/results/cr_multi
mkdir -p "$outdir"


# https://www.biostars.org/p/9587394/ naming convention

cellranger multi --id=PP2_RBPJKO_multi --csv=/scratch/home/agupta1/coup/scripts/multi_cell/multiconfig.csv --localcores=$SLURM_CPUS_PER_TASK --localmem=$(( SLURM_MEM_PER_NODE / 1024 )) --output-dir="${outdir}"