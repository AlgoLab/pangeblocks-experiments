# pangeblocks-experiments
Experiments to evaluate graph constructions made with pangeblocks and other tools.


> **HLA-zoo** Data was downloaded from here https://github.com/ekg/HLA-zoo. It contains 28 set of sequences. 
Some graphs generated with `pggb` ([path to the graphs](https://github.com/ekg/HLA-zoo/tree/master/graphs/pggb)) contain paths using the reverse and complement of the node labels (B-3106,C-3107,DMA-3108,DOA-3111,DOB-3112,DOB-3112,DPA1-3113,DQB1-3119,DRA-3122,DRB1-3123,TAP1-6890, and TAP2-6891), which lead to the conclusion that those sequences were not in the same direction as the other strands. We identified these sequences in each file [here](https://github.com/ekg/HLA-zoo/tree/master/seqs), and then removed them before running all the tools to create the graphs (including `pggb`, which was run with the same parameters reported in the original repository).


The input required by `pggb` is the set of sequences, no MSA is required, as opposed to `PanPA`, `makeprg` and `pangeblocks`

### MSAs
To create MSAs for a set of sequences edit `params-mafft.yaml`, `OP` and `EP` are the gap open penalty and offset (works like gap extension penalty), respectively (check `mafft --help` for details)

```
snakemake rules/msa.smk -c16 --use-conda 
```

when running `vg` for creating graphs, the header of the MSAs cause some problems when whitespaces are at the beginning `ls /data/msas-pangeblocks/msas-didelot/*/*.fa | while read f; do sed 's, ,,g' -i $f; done`


## Graphs

### `PanPA`
set `PATH_MSAS` and  `PANPA_OUTPUT` in `params.yaml`, and then run
```
snakemake -s rules/panpa.smk -c16 -k
```

### `makeprg`
set `PATH_MSAS` and  `MAKEPRG_OUTPUT` in `params.yaml`, and then run
```
snakemake -s rules/makeprg.smk -c16 -k
```

### `pggb`
set `PGGB_INPUT` (path where sequences are saved in .fa format) and  `PGGB_OUTPUT` in `params.yaml`, and then run
```
snakemake -s rules/pggb.smk -c16 --use-conda -k
```

### `pangeblocks`
clone repo https://github.com/AlgoLab/pangeblocks and follow instruction in the README file.

### `vg`
set `PATH_MSAS` and  `VG_OUTPUT` in `params.yaml`, and then run
```
snakemake -s rules/vg.smk -c16 --use-conda
```
___
## Stats

### Didelot graphs
```
echo -e "path_gfa\tn_nodes\tn_edges\tlen_graph\tis_acyclic\tweakly_connected_components\tlen_shared_nodes\tperc_len_shared_nodes" > notebooks/didelot-stats.gfa.csv
ls didelot-pggb/*/*.gfa | while read f; do ./scripts/stats_gfa_vg.sh $f ; done >> notebooks/didelot-stats.gfa.csv
ls didelot-PanPA/*/*.gfa | while read f; do ./scripts/stats_gfa_vg.sh $f ; done >> notebooks/didelot-stats.gfa.csv
ls didelot-makeprg/*/*.gfa | while read f; do ./scripts/stats_gfa_vg.sh $f ; done >> notebooks/didelot-stats.gfa.csv
ls didelot-pangeblocks/*/gfa-unchop/*/*/*.gfa | while read f; do ./scripts/stats_gfa_vg.sh $f ; done >> notebooks/didelot-stats.gfa.csv
ls didelot-vg/*/*.gfa | while read f; do ./scripts/stats_gfa_vg.sh $f ; done >> notebooks/didelot-stats.gfa.csv
```

### HLA-zoo graphs

```
echo -e "path_gfa\tn_nodes\tn_edges\tlen_graph\tis_acyclic\tweakly_connected_components\tlen_shared_nodes\tperc_len_shared_nodes" > notebooks/HLA-zoo-stats.gfa.csv
ls HLA-zoo-pggb/*/*.gfa | while read f; do ./scripts/stats_gfa_vg.sh $f ; done >> notebooks/HLA-zoo-stats.gfa.csv
ls HLA-zoo-PanPA/*/*.gfa | while read f; do ./scripts/stats_gfa_vg.sh $f ; done >> notebooks/HLA-zoo-stats.gfa.csv
ls HLA-zoo-makeprg/*/*.gfa | while read f; do ./scripts/stats_gfa_vg.sh $f ; done >> notebooks/HLA-zoo-stats.gfa.csv
ls HLA-zoo-pangeblocks/*/gfa-unchop/*/*/*.gfa | while read f; do ./scripts/stats_gfa_vg.sh $f ; done >> notebooks/HLA-zoo-stats.gfa.csv
ls HLA-zoo-vg/*/*.gfa | while read f; do ./scripts/stats_gfa_vg.sh $f ; done >> notebooks/HLA-zoo-stats.gfa.csv
```

___
## Experiment: read mapping

### Read Simulation
set `PATH_SEQS` and `PATH_OUTPUT` in `params-simulate-reads.yaml`. For each fasta in `PATH_SEQS` a reference (by default the first sequence in the file) will be extracted and reads will be simulated with `DWGSIM` using this sequence
```
snakemake -s rules/simulate_reads.smk -c16
```

### Read alignment
`params-alignment.yaml`

**GraphAligner**
```
snakemake -s rules/alignment_simreads_graphaligner.smk -c16
```

**Giraffe**
```
snakemake -s rules/alignment_simreads_giraffe.smk -c16 --use-conda -k
```
___
## VCF from GFA with `vg`

```
ls HLA-zoo-pangeblocks/*/gfa-unchop/*/*/*.gfa | while read f; do ./scripts/vcf_from_gfa.sh $f; done
ls HLA-zoo-pangeblocks-norevcomplement/*/gfa-unchop/*/*/*.gfa | while read f; do ./scripts/vcf_from_gfa.sh $f; done
<!-- ls HLA-zoo-PanPA-norevcomplement/*/*.gfa | while read f; do ./scripts/vcf_from_gfa.sh $f; done  -->
<!-- ls HLA-zoo-PanPA/*/*.gfa | while read f; do ./scripts/vcf_from_gfa.sh $f; done -->
ls HLA-zoo-pggb/*.gfa | while read f; do ./scripts/vcf_from_gfa.sh $f; done
```





___
TODO
- [ ] create env for PanPA
- [ ] fix rule pggb.smk: match gfa name