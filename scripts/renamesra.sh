#!/bin/bash

prefix="PUB_COUPOE_PP1"
basepath="/scratch/home/agupta1/coup/data/published_coup"

# Map run dirs to lanes dict (associative arr) called lanes [key]=val
declare -A lanes=(
  [SRR22270428]=L001
  [SRR22270429]=L002
  [SRR22270430]=L003
  [SRR22270431]=L004
)

# loop over keys of lanes  ${array[@]}=values ; ${!array[@]}=keys ; 
for run in "${!lanes[@]}"; do
  lane="${lanes[$run]}"   #${array[key]}=a single value by key
  rundir="$basepath/$run"

  for f in "$rundir"/*_1.fastq "$rundir"/*_2.fastq "$rundir"/*_3.fastq; do
    [ -e "$f" ] || continue   #-e checks if file f exists. if this left side returns true do nothing. keep running loop. if left side returns false i.e f doesnt exist the test is false → run continue → skip to the next f.

    case "$f" in
      *_1.fastq) newname="${prefix}_S1_${lane}_I1_001.fastq" ;; #) marks end of pattern
      *_2.fastq) newname="${prefix}_S1_${lane}_R1_001.fastq" ;;  #The ;; means “end of this case branch, jump out of the case
      *_3.fastq) newname="${prefix}_S1_${lane}_R2_001.fastq" ;;
    esac
    echo "Renaming $f → $rundir/$newname"
    mv "$f" "$rundir/$newname"
  done
done
