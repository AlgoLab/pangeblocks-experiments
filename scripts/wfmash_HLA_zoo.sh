#!/bin/bash

# : '
#  from logs /home/avila/HLA-zoo/graphs/pggb/A-3105/A-3105.fa.353ea42.34ee7b1.1576367.12-24-2021_13:40:35.log
#   mapping-tool:       wfmash
#   no-splits:          false
#   segment-length:     1000
#   block-length:       3000
#   no-merge-segments:  false *
#   map-pct-id:         70
#   n-mappings:         11 *
#   mash-kmer:          16
#   exclude-delim:      false * --skip-self in wfmash
# '

# input params 
name_seqs=$1
path_seqs="/home/avila/HLA-zoo/seqs/$name_seqs.fa"
# name_seqs=$(basename -s .fa $path_seqs)

# wfmash: all-to-all alignment
path_sam="/home/avila/HLA-zoo/wfmash/$name_seqs/$name_seqs.sam"
mkdir -p $(dirname $path_sam)

wfmash $path_seqs --no-split \
    --segment-length 1000 \
    --block-length 3000 \
    --map-pct-id 70 \
    --kmer 16 \
    --skip-self \
    --no-merge \
    --num-mappings-for-segment 11 \
    --sam-format > $path_sam

# convert to bam
path_bam="$(dirname $path_sam)/$name_seqs.bam"
samtools view -S -b $path_sam > $path_bam

# sort bam
path_sort_bam="$(dirname $path_sam)/$name_seqs.sort.bam"
samtools sort $path_bam -o $path_sort_bam

# index bam
samtools index $path_sort_bam

# bam2sam
path_msa="$(dirname $path_sam)/$name_seqs.msa.fa"
python3 utils/bam2msa.py $path_sort_bam > $path_msa