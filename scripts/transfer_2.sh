#!/bin/bash
#SBATCH --job-name=rclone_copy_ver2
#SBATCH --mem=2G
#SBATCH --cpus-per-task=2
#SBATCH --error=logs/rclone_ver2_%j.error
#SBATCH --output=logs/rclone_ver2_%j.output
#SBATCH --time=00:20:00

### gets all the raw files from google drive to the hpc using rclone

source ~/.bashrc
conda activate rclone

echo "conda was activated here. Everything from here is rclone"
#echo "job id $(%j) at: $(date)"
echo "job id $SLURM_JOB_ID at: $(date)"


# measure timestamp
# current time in seconds since epoch before rclone
START=$(date +%s)


# i have coupko already
# multithread only for files > 64mb

time rclone copy google-drive:297data/  ~/coup/data \
--exclude "COUPKO/**" \
--transfers=12 \
--multi-thread-streams=4 \
--multi-thread-cutoff=64M \
--order-by size,ascending

END=$(date +%s)
DURATION=$((END - START))
#make it readable
HUMANTIME=$(printf "%02d:%02d:%02d" $((DURATION/3600)) $((DURATION%3600/60)) $((DURATION%60)))

echo "check, rclone has run."
echo "job ended at $(date)"
echo "total time taken ${HUMANTIME} (HH:MM:SS)"
echo "total space taken up by the current folder now:"
du -sh ~/coup/data
echo "done"