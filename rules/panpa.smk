configfile: "params.yaml"
from pathlib import Path

TOOL="PANPA"
PATH_OUTPUT=config[TOOL]["PATH_OUTPUT"]
PATH_MSAS=config["PATH_MSAS"]

rule all:
    input:
        expand("{path_output}/{{name_msa}}.gfa", path_output=PATH_OUTPUT)

rule graph_construction: 
    input: 
        path_msa=expand("{path_msas}/{{name_msa}}.{ext}", path_msas=PATH_MSAS, ext=["fa","fasta"])
    output: 
        path_gfa=expand("{path_output}/{{name_msa}}.gfa", path_output=PATH_OUTPUT)
    shell:
        f"PanPA build_gfa -d {PATH_MSAS} -o {PATH_OUTPUT}"