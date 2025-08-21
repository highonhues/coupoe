#!/bin/bash
#SBATCH --job-name=rename
#SBATCH --error=logs/rename%j.error
#SBATCH --output=logs/rename%j.output

find . -type f -name "Copy of *" | while read -r file; do
  
  # Extract the directory path the file is in
  dir=$(dirname "$file")
  
  # Extract just the filename (without the path)
  base=$(basename "$file")
  
  # Remove the "Copy of " prefix using bash string slicing
  newname="${base#Copy of }"
  
  # Rename the file to remove the prefix
  mv "$file" "$dir/$newname"

done