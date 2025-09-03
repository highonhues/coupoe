#!/bin/bash
#SBATCH --job-name=sra_download
#SBATCH --output=/scratch/home/agupta1/coup/logs/sra_download_%j.out
#SBATCH --error=/scratch/home/agupta1/coup/logs/sra_download_%j.err
#SBATCH --cpus-per-task=16
#SBATCH --mem=32G
set -euo pipefail

# env
source /home/agupta1/miniconda3/etc/profile.d/conda.sh
conda activate sratools

OUTDIR=/scratch/home/agupta1/coup/data/published_coup
mkdir -p "$OUTDIR"

ACCESSIONS=(
  SRR22270424 SRR22270425 SRR22270426 SRR22270427 SRR22270428 SRR22270429
  SRR22270430 SRR22270431 SRR22270432 SRR22270433 SRR22270434 SRR22270435
)

for ACC in "${ACCESSIONS[@]}"; do
  echo "[$(date)] $ACC …"
  SRR_DIR="$OUTDIR/$ACC"
  mkdir -p "$SRR_DIR"

  # 1) Prefetch into OUTDIR (creates OUTDIR/ACC/ACC.sra)
  prefetch -O "$OUTDIR" "$ACC"

  # 2) Convert to FASTQ into the same SRR folder
  #    IMPORTANT: pass the directory (or bare accession), NOT the .sra file
  fasterq-dump \
    --split-files \
    --include-technical \
    --gzip \
    --threads "$SLURM_CPUS_PER_TASK" \
    -O "$SRR_DIR" \
    "$SRR_DIR"

  # (Optional) keep or delete the .sra; uncomment to delete and save space
  # rm -f "$SRR_DIR/$ACC.sra"
done

echo "All downloads complete."
