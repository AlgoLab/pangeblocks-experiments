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
## Graphs

### `make_prg`
```
snakemake -s rules/makeprg.smk -c16
```

### `minigraph`
```
snakemake -s rules/minigraph.smk -c16
```

```
PATH_PANGEBLOCKS="../pangeblocks"
snakemake -s $PATH_PANGEBLOCKS/eda.smk -c 8 --config PATH_MSAS=msas PATH_OUTPUT=output/pangeblocks
snakemake -s $PATH_PANGEBLOCKS/pangeblock.smk -c 8 --config PATH_MSAS=msas PATH_OUTPUT=output/pangeblocks
```