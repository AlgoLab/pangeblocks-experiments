# pangeblocks-experiments
Experiments to evaluate graph constructions made with pangeblocks and other tools

TODO
- [ ] create env for makeprg
- [ ] create env for PanPA
- [ ] create env for pggb

# Stats
### Didelot graphs
```
echo -e "path_gfa\tn_nodes\tn_edges\tlen_graph\tis_acyclic\tweakly_connected_components" > notebooks/didelot-stats.gfa.csv
ls didelot-pggb/*/*.smooth.fix.gfa | while read f; do ./scripts/stats_gfa_vg.sh $f ; done >> notebooks/didelot-stats.gfa.csv
ls didelot-PanPA/*/*.gfa | while read f; do ./scripts/stats_gfa_vg.sh $f ; done >> notebooks/didelot-stats.gfa.csv
ls didelot-pangeblocks/*/gfa-unchop/*/*/*.gfa | while read f; do ./scripts/stats_gfa_vg.sh $f ; done >> notebooks/didelot-stats.gfa.csv
```

### HLA-zoo graphs
```
echo -e "path_gfa\tn_nodes\tn_edges\tlen_graph\tis_acyclic\tweakly_connected_components" > notebooks/HLA-zoo-stats.gfa.csv
ls didelot-pggb/*/*.smooth.fix.gfa | while read f; do ./scripts/stats_gfa_vg.sh $f ; done >> notebooks/HLA-zoo-stats.gfa.csv
ls didelot-PanPA/*/*.gfa | while read f; do ./scripts/stats_gfa_vg.sh $f ; done >> notebooks/HLA-zoo-stats.gfa.csv
ls didelot-pangeblocks/*/gfa-unchop/*/*/*.gfa | while read f; do ./scripts/stats_gfa_vg.sh $f ; done >> notebooks/HLA-zoo-stats.gfa.csv
```