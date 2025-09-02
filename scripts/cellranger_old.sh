#!/bin/bash
#SBATCH --job-name=cellranger
#SBATCH --mem=120G
#SBATCH --cpus-per-task=28
#SBATCH --partition=nodes
                             
#SBATCH --output=/scratch/home/agupta1/coup/logs/cr%j.output
#SBATCH --error=/scratch/home/agupta1/coup/logs/cr_%j.error

#=========================#
# USER CONFIGURATION      #
#=========================#
# OUTDIR=/scratch/home/agupta1/coup/results
# TRANSCRIPTOME=/scratch/home/agupta1/coup/data/ref_mm10/refdata-gex-mm10-2020-A
# #=========================#
source /home/agupta1/miniconda3/etc/profile.d/conda.sh
conda activate cellranger
#removed   SBATCH --array=1-3

# # Define arrays
# FASTQ_DIRS=(
# "/scratch/home/agupta1/coup/data/COUPOE_PP1/COUPOE_PP1_fastq/PP1_COUPOE-HW2FVBGXB_0_1_HW2FVBGXB"
# "/scratch/home/agupta1/coup/data/COUPOE_PP2/COUPOE_PP2_fastq/PP2_COUPOE-HW2FVBGXB_0_1_HW2FVBGXB"
# "/scratch/home/agupta1/coup/data/PP1_0_1_HVNFCBGX3_WT"

# )

# SAMPLES=("COUPOE_PP1" "COUPOE_PP2" "PP1_0_1_HVNFCBGX3_WT")
# # IDX=$SLURM_ARRAY_TASK_ID
# IDX=$((SLURM_ARRAY_TASK_ID - 1))
# echo "IDX: $IDX"
# echo "Sample: ${SAMPLES[$IDX]}"

# cellranger count \
#   --id=${SAMPLES[$IDX]} \
#   --transcriptome=$TRANSCRIPTOME \
#   --fastqs=${FASTQ_DIRS[$IDX]} \
#   --sample=${SAMPLES[$IDX]} \
#   --output-dir=$OUTDIR \
#   --create-bam=false \
#   --localcores=$SLURM_CPUS_PER_TASK \
#   --localmem=$(( SLURM_MEM_PER_NODE / 1024 ))  # Cell R uses GB units

cellranger count \
  --id=pp_wt_rn \
  --transcriptome=/scratch/home/agupta1/coup/data/ref_mm10/refdata-gex-mm10-2020-A \
  --fastqs=/scratch/home/agupta1/coup/data/PP1_0_1_HVNFCBGX3_WT \
  --sample=PP1_0_1_HVNFCBGX3_WT \
  --output-dir=/scratch/home/agupta1/coup/results \
  --create-bam=false \
  --localcores=$SLURM_CPUS_PER_TASK \
  --localmem=$(( SLURM_MEM_PER_NODE / 1024 ))  # Cell R uses GB units
