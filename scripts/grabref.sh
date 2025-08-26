#!/bin/bash
#SBATCH --job-name=ref_mm10
#SBATCH --mem=8G
#SBATCH --cpus-per-task=6                  
#SBATCH --output=/scratch/home/agupta1/coup/logs/ref__%j.output
#SBATCH --error=/scratch/home/agupta1/coup/logs/ref_%j.error

#=========================#
# USER CONFIGURATION      #
#=========================#
OUTDIR="/scratch/home/agupta1/TB/tb-data/ref_mm10"
URL="https://cf.10xgenomics.com/supp/cell-exp/refdata-gex-mm10-2020-A.tar.gz"
FILENAME=$(basename $URL)
#=========================#

mkdir -p "$OUTDIR"
cd "$OUTDIR"


echo "Downloading $FILENAME to $OUTDIR..."

# -C resumes if it it gets stuck, -o gives the filename, 
wget -c -O "$FILENAME" "$URL"

echo "Extracting $FILENAME ..."
tar -zxvf "$FILENAME"

echo "Done. go to $OUTDIR" for your reference."
