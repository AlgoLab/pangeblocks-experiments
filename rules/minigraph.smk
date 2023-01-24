configfile: "params.yaml"
from pathlib import Path

TOOL="MINIGRAPH"
PATH_OUTPUT=config[TOOL]["PATH_OUTPUT"]
PATH_MSAS=config["PATH_MSAS"]
Path(PATH_OUTPUT).mkdir(exist_ok=True, parents=True)
NAMES = [path.stem for path in Path(PATH_MSAS).rglob("*.[fa][fasta]")]

rule all:
    input: 
        expand("{path_output}/{name_msa}.gfa", name_msa=NAMES, path_output=PATH_OUTPUT)

rule graph_construction:
    input: 
        path_msa=expand("{path_msa}/{{name_msa}}.{ext}", path_msa=PATH_MSAS, ext=["fa"])
    output:
        path_gfa=expand("{path_output}/{{name_msa}}.gfa", path_output=PATH_OUTPUT)
    shell:
        # "minigraph --ggen -l 1 -d 5 -L 2 {input} -o {output}"
        "minigraph -cxggs -t16 {input} > {output}"