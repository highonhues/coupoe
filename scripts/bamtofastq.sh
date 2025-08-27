#!/bin/bash
#SBATCH --job-name=bamtofastq
#SBATCH --mem=20G
#SBATCH --array=1-4                                                      #Submits this as a job array of 4 tasks (task IDs = 1, 2, 3, 4)
#SBATCH --cpus-per-task=16                  
#SBATCH --output=/scratch/home/agupta1/coup/logs/bamtofastq_%j.output
#SBATCH --error=/scratch/home/agupta1/coup/logs/bamtofastq_%j.error


# Define your BAM files and sample names
BAM_FILES=(
    "/scratch/home/agupta1/coup/data/COUPOE_MLN/possorted_genome_bam.bam"
    "/scratch/home/agupta1/coup/data/COUPOE_PP1/possorted_genome_bam.bam" 
    "/scratch/home/agupta1/coup/data/COUPOE_PP2/possorted_genome_bam.bam"
    "/scratch/home/agupta1/coup/data/COUPWT_MLN_NEG1/possorted_genome_bam.bam"
)

# Get current array task
BAM_FILE=${BAM_FILES[$SLURM_ARRAY_TASK_ID-1]} #indexing the array to grab items from 0 to 3

# Get the directory where the BAM file is located
BAM_DIR=$(dirname "$BAM_FILE")
# Extract sample name from the directory path
SAMPLE_NAME=$(basename "$BAM_DIR")

# Activate conda environment
source ~/miniconda3/etc/profile.d/conda.sh
conda activate bamtofastq


# CRITICAL: Remove any existing fastq directory
# bamtofastq MUST create this directory itself
rm -rf ${BAM_DIR}/fastq


# Create output directory name with sample name prefix
OUTPUT_DIR="${BAM_DIR}/${SAMPLE_NAME}_fastq"

# Run bamtofastq - output goes to the fastq folder in the same directory
bamtofastq \
    --nthreads=8 \
    ${BAM_FILE} \
    ${OUTPUT_DIR}

echo "Completed processing ${SAMPLE_NAME} -> ${OUTPUT_DIR}"