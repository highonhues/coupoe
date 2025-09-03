#!/bin/bash
#SBATCH --job-name=download_fastqs
#SBATCH --output=logs/download_fastqs_%j.out
#SBATCH --error=logs/download_fastqs_%j.err
#SBATCH --cpus-per-task=12
#SBATCH --mem=16G
#SBATCH --partition=nodes   # adjust if your cluster uses different partitions


# Move into fastq directory so files don’t scatter everywhere
cd /scratch/home/agupta1/coup/data/published

# Download FASTQ files (-nc means "no clobber", won’t re-download if present)
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR222/034/SRR22270434/SRR22270434.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR222/029/SRR22270429/SRR22270429.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR222/033/SRR22270433/SRR22270433.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR222/026/SRR22270426/SRR22270426.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR222/030/SRR22270430/SRR22270430.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR222/025/SRR22270425/SRR22270425.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR222/027/SRR22270427/SRR22270427.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR222/024/SRR22270424/SRR22270424.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR222/031/SRR22270431/SRR22270431.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR222/028/SRR22270428/SRR22270428.fastq.gz

echo "Download complete!"
