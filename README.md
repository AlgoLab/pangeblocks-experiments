# pangeblocks-experiments
Experiments to evaluate graph constructions made with pangeblocks and other tools

TODO
- [ ] create env for makeprg
- [ ] create env for PanPA
- [ ] create env for pggb

# Connected components
```
ls didelot-pggb/*/*.smooth.fix.gfa | while read f; do X=$(python3 utils/components.py $f) && echo "$f,$X" ; done >> notebooks/didelot-connected_components.csv
ls didelot-PanPA/*/*.gfa | while read f; do X=$(python3 utils/components.py $f) && echo "$f,$X" ; done >> notebooks/didelot-connected_components.csv
ls didelot-pangeblocks/*/gfa-unchop/*/*/*.gfa | while read f; do X=$(python3 utils/components.py $f) && echo "$f,$X"; done >> notebooks/didelot-connected_components.csv
```

```
ls HLA-zoo-pggb/*.smooth.fix.gfa | while read f; do X=$(python3 utils/components.py $f) && echo "$f,$X" ; done >> notebooks/HLA-zoo-connected_components.csv
ls HLA-zoo-PanPA/*/*.gfa | while read f; do X=$(python3 utils/components.py $f) && echo "$f,$X" ; done >> notebooks/HLA-zoo-connected_components.csv
ls HLA-zoo-pangeblocks/*/gfa-unchop/*/*/*.gfa | while read f; do X=$(python3 utils/components.py $f) && echo "$f,$X"; done >> notebooks/HLA-zoo-connected_components.csv
```