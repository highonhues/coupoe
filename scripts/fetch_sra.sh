#!/bin/bash
#SBATCH --job-name=sra_download
#SBATCH --output=/scratch/home/agupta1/coup/logs/sra_download_%j.out
#SBATCH --error=/scratch/home/agupta1/coup/logs/sra_download_%j.err
#SBATCH --cpus-per-task=16
#SBATCH --mem=32G

# Activate conda env with sra-tools
source /home/agupta1/miniconda3/etc/profile.d/conda.sh
conda activate sratools

OUTDIR=/scratch/home/agupta1/coup/data/published_coup
TMPDIR=/scratch/home/agupta1/coup/data/tmp_sra

# Make sure they exist
mkdir -p $OUTDIR $TMPDIR

# List of SRR accessions to download
ACCESSIONS=(
    SRR22270424
    SRR22270425
    SRR22270426
    SRR22270427
    SRR22270428
    SRR22270429
    SRR22270430
    SRR22270431
    SRR22270432
    SRR22270433
    SRR22270434
    SRR22270435
)

# Download and convert
for ACC in "${ACCESSIONS[@]}"; do
    echo "Downloading and converting $ACC ..."
    
    # Create directory for this accession
    mkdir -p $OUTDIR/$ACC
    
    # Prefetch SRA file with max size 300 GB
    prefetch --max-size 300G --output-directory $TMPDIR $ACC
    
    # Convert to FASTQ (paired + index if present)
    fasterq-dump $TMPDIR/$ACC/$ACC.sra \
        --outdir $OUTDIR/$ACC \
        --split-files \
        --threads $SLURM_CPUS_PER_TASK \
        --temp $TMPDIR
    
    # Compress FASTQs in the accession directory
    pigz -p $SLURM_CPUS_PER_TASK $OUTDIR/$ACC/${ACC}_*.fastq
    
    # Remove .sra to save space after conversion
    rm -rf $TMPDIR/$ACC
done

echo "All downloads complete."
