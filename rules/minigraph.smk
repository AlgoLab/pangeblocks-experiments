configfile: "params.graphaligner.yaml"
from pathlib import Path

TOOL="MINIGRAPH"
PATH_OUTPUT=config[TOOL]["PATH_OUTPUT"]

rule all:
    pass

rule download_graph_aligner:
    pass

rule graph_construction:
    pass
