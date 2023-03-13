# pangeblocks-experiments
Experiments to evaluate graph constructions made with pangeblocks and other tools

# Stats
### Didelot graphs
```
echo -e "path_gfa\tn_nodes\tn_edges\tlen_graph\tis_acyclic\tweakly_connected_components" > notebooks/didelot-stats.gfa.csv
ls didelot-pggb-HLAzooparams/*/*.gfa | while read f; do ./scripts/stats_gfa_vg.sh $f ; done >> notebooks/didelot-stats.gfa.csv
ls didelot-PanPA/*/*.gfa | while read f; do ./scripts/stats_gfa_vg.sh $f ; done >> notebooks/didelot-stats.gfa.csv
ls didelot-pangeblocks/*/gfa-unchop/*/*/*.gfa | while read f; do ./scripts/stats_gfa_vg.sh $f ; done >> notebooks/didelot-stats.gfa.csv
ls didelot-makeprg/*/*.gfa | while read f; do ./scripts/stats_gfa_vg.sh $f ; done >> notebooks/didelot-stats.gfa.csv
```

### HLA-zoo graphs
```
echo -e "path_gfa\tn_nodes\tn_edges\tlen_graph\tis_acyclic\tweakly_connected_components" > notebooks/HLA-zoo-stats.gfa.csv
ls HLA-zoo-pggb/*.gfa | while read f; do ./scripts/stats_gfa_vg.sh $f ; done >> notebooks/HLA-zoo-stats.gfa.csv
ls HLA-zoo-PanPA/*/*.gfa | while read f; do ./scripts/stats_gfa_vg.sh $f ; done >> notebooks/HLA-zoo-stats.gfa.csv
ls HLA-zoo-pangeblocks/*/gfa-unchop/*/*/*.gfa | while read f; do ./scripts/stats_gfa_vg.sh $f ; done >> notebooks/HLA-zoo-stats.gfa.csv
ls HLA-zoo-makeprg/*/*.gfa | while read f; do ./scripts/stats_gfa_vg.sh $f ; done >> notebooks/HLA-zoo-stats.gfa.csv
```

```
out="notebooks/HLA-zoo-norevcomplement-stats.gfa.csv"
echo -e "path_gfa\tn_nodes\tn_edges\tlen_graph\tis_acyclic\tweakly_connected_components" > $out
ls HLA-zoo-pggb/*.gfa | while read f; do ./scripts/stats_gfa_vg.sh $f ; done >> $out
ls HLA-zoo-PanPA-norevcomplement/*/*.gfa | while read f; do ./scripts/stats_gfa_vg.sh $f ; done >> $out
find HLA-zoo-pangeblocks-norevcomplement -type f -wholename "*/gfa-unchop/*.gfa" | while read f; do ./scripts/stats_gfa_vg.sh $f ; done >> $out
ls HLA-zoo-makeprg-norevcomplement/*/*.gfa | while read f; do ./scripts/stats_gfa_vg.sh $f ; done >> $out
```

### VCF from GFA with `vg`

```
ls HLA-zoo-pangeblocks/*/gfa-unchop/*/*/*.gfa | while read f; do ./scripts/vcf_from_gfa.sh $f; done
ls HLA-zoo-pangeblocks-norevcomplement/*/gfa-unchop/*/*/*.gfa | while read f; do ./scripts/vcf_from_gfa.sh $f; done
<!-- ls HLA-zoo-PanPA-norevcomplement/*/*.gfa | while read f; do ./scripts/vcf_from_gfa.sh $f; done  -->
<!-- ls HLA-zoo-PanPA/*/*.gfa | while read f; do ./scripts/vcf_from_gfa.sh $f; done -->
ls HLA-zoo-pggb/*.gfa | while read f; do ./scripts/vcf_from_gfa.sh $f; done
```

# `makeprg`
set `PATH_MSAS` and  `MAKEPRG_OUTPUT` in `params.yaml`, and then run
```
snakemake -s rules/makeprg.smk -c16 -k
```

# `pggb`
set `PGGB_INPUT` (path where sequences are saved in .fa format) and  `PGGB_OUTPUT` in `params.yaml`, and then run
```
snakemake -s rules/pggb.smk -c16 --use-conda -k
```

# `PanPA`
set `PATH_MSAS` and  `PANPA_OUTPUT` in `params.yaml`, and then run
```
snakemake -s rules/panpa.smk -c16 -k
```
___
TODO
- [ ] create env for PanPA
- [ ] fix rule pggb.smk: match gfa name