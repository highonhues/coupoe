#!/bin/bash
#SBATCH --job-name=rclone_copy
#SBATCH --mem=16G
#SBATCH --cpus-per-task=4
#SBATCH --error=logs/rclone_KO_%j.error
#SBATCH --output=logs/rclone_KO_%j.output
#SBATCH --time=01:00:00

#make a directory to store out and error
mkdir -p logs

source ~/.bashrc
conda activate rclone


# r clone copy source:sourcepath dest:destpath
# rclone copy google-drive:297data/ . --progress

rclone copy google-drive:297data/  ~/coup/ \
--transfers=8 \
--multi-thread-streams=4 \
--progress

echo "check, the script has run"





# to list files first: rclone ls google-drive:297data/
