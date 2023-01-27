# pangeblocks-experiments
Experiments to evaluate graph constructions made with pangeblocks and other tools


```bash
mamba create -c bioconda -n .pbexp-env \ 
snakemake-minimal pandas seaborn biopython \
graphaligner vg pggb minigraph \
mmseqs2 clustalo emboss
```

```bash
mamba activate .pbexp-env
```

For make_prg, the snakemake pipeline downloads the executable

___
## E Coli experiment
this requires `data/ftp_links.txt`
```
snakemake -s rules/ecoli-experiment-cluster.smk -c16 
snakemake -s rules/ecoli-experiment-msa.smk -c16
```

___
## Graphs

### `make_prg`
```
snakemake -s rules/makeprg.smk -c16
```

### `minigraph`
```
snakemake -s rules/minigraph.smk -c16
```