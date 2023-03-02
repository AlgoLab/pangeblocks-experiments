#!/bin/bash

# define params
path_fasta="/data/didelot/coli27-86.fasta"
n_haplotypes=$(grep ">" $path_fasta | wc -l)
echo "haplotypes $n_haplotypes"
outdir="/data/pangeblocks-experiments/didelot-pggb/slpa-simu"
mkdir -p $outdir

# indexing
bgzip -@ 16 -c $path_fasta > $path_fasta.gz
samtools faidx $path_fasta.gz

# run pggb
pggb -i $path_fasta.gz  \
    -n $n_haplotypes \
    --output-dir $outdir \
    --temp-dir tmp-pggb \
    --threads 16 \
    --poa-threads 16 \
    --keep-temp-files \
