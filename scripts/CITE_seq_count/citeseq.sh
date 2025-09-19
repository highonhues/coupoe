#!/bin/bash
#SBATCH --job-name=citeseq_hashing_coupko
#SBATCH --mem=120G
#SBATCH --cpus-per-task=15                     
#SBATCH --time=72:00:00
#SBATCH --output=/scratch/home/agupta1/coup/logs/citeseqko_%j.output
#SBATCH --error=/scratch/home/agupta1/coup/logs/citeseqko_%j.error


source /home/agupta1/miniconda3/etc/profile.d/conda.sh
conda activate citeseqcount


outdir=/scratch/home/agupta1/coup/results/citeseq/coupko
mkdir -p "$outdir"


#got the tags from the multi features file using awk -F , 'NR > 1 {print $5","$2}' /scratch/home/agupta1/coup/scripts/multi_cell/feature_coupko.csv > /scratch/home/agupta1/coup/scripts/CITE_seq_count/TAG_LIST_COUPKO.csv

# docs of cite seq https://hoohm.github.io/CITE-seq-Count/Running-the-script/
# v3 chemistry has umis of len 12 hence umil 28 


CITE-seq-Count -R1 /scratch/home/agupta1/coup/data/COUPKO/COUPKO_hash/COUP-KO_S13_L001_R1_001.fastq.gz -R2 /scratch/home/agupta1/coup/data/COUPKO/COUPKO_hash/COUP-KO_S13_L001_R2_001.fastq.gz -t TAG_LIST_COUPKO.csv -cbf 1 -cbl 16 -umif 17 -umil 28 -max_error 2 -o "${outdir}"