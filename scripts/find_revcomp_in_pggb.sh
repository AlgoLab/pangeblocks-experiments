#!/bin/bash
ls /data/pangeblocks-experiments/HLA-zoo-pggb/*.gfa | \
while read f; do \
SEQID_RC=$(grep -P "[-][,]" $f | cut -f2 | wc -l); \
if [ $SEQID_RC -gt 0 ]; then \
nameseqs=$(basename $f | cut -d"." -f1)
# echo "$f,$SEQID_RC,$(basename $f | cut -d"." -f1)";\
grep -P "[-][,]" $f | cut -f2 | while read seqid; do echo $f,$nameseqs,$seqid; done; \
fi; \
done

