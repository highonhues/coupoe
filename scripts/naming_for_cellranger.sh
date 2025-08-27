#!/bin/bash
#renames fastq files more descriptively if you optained them from running bamtofastq
# use it along with the --path argument giving the path to your main data dir

if [[ "$1" == "--path" ]]; then
  DATA_DIR=$2
else
  echo "usage: $0 --path ../data/"
  exit 1
fi

get_sample_name(){
    local file_path=$1
    local dir_name=$(basename "$(dirname "$file_path")")

    # If parent dir looks like Illumina run (contains HW), climb up
    if [[ "$dir_name" == *HW* ]]; then
        dir_name=$(basename "$(dirname "$(dirname "$file_path")")")
    fi

    # Remove "_fastq" suffix if present
    dir_name=$(echo "$dir_name" | sed 's/_fastq$//')

    echo "$dir_name"
}

# --- Main loop ---
find "$DATA_DIR" -name "*bamtofastq*.fastq.gz" -type f | while read file; do
    sample_name=$(get_sample_name "$file")
    file_dir=$(dirname "$file")
    original_name=$(basename "$file")
    new_name=$(echo "$original_name" | sed "s/bamtofastq/${sample_name}/g")

    mv "$file" "$file_dir/$new_name"
    echo "Renamed: $original_name -> $new_name"
done

echo "Renaming complete!"

