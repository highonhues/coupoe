#!/bin/bash
#SBATCH --job-name=citeseq_hashing_coupko
#SBATCH --mem=120G
#SBATCH --cpus-per-task=15                     
#SBATCH --time=72:00:00
#SBATCH --output=/scratch/home/agupta1/coup/logs/citeseqko_%j.output
#SBATCH --error=/scratch/home/agupta1/coup/logs/citeseqko_%j.error

## SPECIFICATIONS FOR CITE SEQ ####

#conda install -y -c conda-forge bioconda::cite-seq-count=1.4.5  
#go to /home/agupta1/miniconda3/envs/env_cite/lib/python3.1/site-packages/io.py
#change line 48 pandas_dense = pd.DataFrame(sparse_matrix.todense(), columns=list(columns), index=index)
# check iif it works by CITE-seq-Count --help

source /home/agupta1/miniconda3/etc/profile.d/conda.sh
conda activate env_cite


# docs of cite seq https://hoohm.github.io/CITE-seq-Count/Running-the-script/
# v3 chemistry has umis of len 12 hence umil 28 



######## COUPKO SAMPLE #############

#got the tags from the multi features file using awk -F , 'NR > 1 {print $5","$2}' /scratch/home/agupta1/coup/scripts/multi_cell/feature_coupko.csv > /scratch/home/agupta1/coup/scripts/CITE_seq_count/TAG_LIST_COUPKO.csv

# outdir=/scratch/home/agupta1/coup/results/citeseq/coupko
# mkdir -p "$outdir"

# CITE-seq-Count -R1 /scratch/home/agupta1/coup/data/COUPKO/COUPKO_hash/COUP-KO_S13_L001_R1_001.fastq.gz -R2 /scratch/home/agupta1/coup/data/COUPKO/COUPKO_hash/COUP-KO_S13_L001_R2_001.fastq.gz -t TAG_LIST_COUPKO.csv -cells 1500 -cbf 1 -cbl 16 -umif 17 -umil 28 --max-error 2 -o "${outdir}"






########### RBPJKO SAMPLE ########

outdir=/scratch/home/agupta1/coup/results/citeseq/PP2_RBPJKO
mkdir -p "$outdir"

#awk -F , 'NR > 1 {print $5","$2}' /scratch/home/agupta1/coup/scripts/multi_cell/feature.csv > TAGS_RBPJKO.csv
CITE-seq-Count -R1 /scratch/home/agupta1/coup/data/RBPJKO_PP2/PP2_RBPJKO_HTO_S4_L001_R1_001.fastq.gz -R2 /scratch/home/agupta1/coup/data/RBPJKO_PP2/PP2_RBPJKO_HTO_S4_L001_R2_001.fastq.gz -t TAGS_RBPJKO.csv -cells 1500 -cbf 1 -cbl 16 -umif 17 -umil 28 --max-error 2 -o "${outdir}"