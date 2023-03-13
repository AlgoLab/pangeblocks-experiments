#!/bin/bash
OUTDIR="didelot-pggb-HLAzooparams"
mkdir -p $OUTDIR

ls /data/didelot2/*.fa | while read f; do echo "$f,$(cat $f.gz.fai | wc -l)" ; \ 
bgzip -@ 16 -c $f > $f.gz; \
samtools faidx $f.gz; \
pggb -i $f.gz -t 16 -s 1000 -p 70 -n $(cat $f.gz.fai | wc -l) \
-G 2000,2000,2000,2000 -P 1,7,11,2,33,1 \
-k 19 -o "$OUTDIR/$(basename $f .fa)"; done