#!/bin/bash

path_gfa=$1
# path_odgi=$2
path_vcf="VCF.vg-deconstruct/$(dirname $path_gfa)/$(basename $path_gfa .gfa).vcf"
mkdir -p $(dirname $path_vcf)

# cambiar esto por la primera sequencia en orden alfabetico (para que sea la misma para todos)
reference=$(grep -P "^P" $path_gfa | cut -f2 | sort | cut -f1 -d" " | head -n1)
echo "Working on | $path_vcf"
vg deconstruct -e --path $reference $path_gfa > $path_vcf