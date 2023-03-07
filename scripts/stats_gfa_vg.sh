#!/bin/bash
path_gfa=$1

# vg stats: [number of nodes, number of edges, length of the graph, is acyclic?]
VG=$(vg stats --node-count --edge-count --length --is-acyclic $path_gfa | tr $"\n" $"\t" | cut -f1,2,4,5) 

# number of connected components of the graph
CC=$(python3 utils/components.py $path_gfa | xargs -n2 -d"\n")

echo -e "$path_gfa\t$VG\t$CC"