configfile: "params.yaml"
from pathlib import Path
from os.path import join as pjoin

PATH_MSAS=config["PATH_MSAS"]

PATH_OUTPUT=config["PANPA_OUTPUT"]
Path(PATH_OUTPUT).mkdir(exist_ok=True, parents=True)

list_fasta = list(Path(PATH_MSAS).glob("*.fa")) + list(Path(PATH_MSAS).glob("*.fasta")) 
NAMES = [path.stem for path in list_fasta]
print(NAMES)

rule all:
    input:
        expand( pjoin(PATH_OUTPUT,"{name_msa}.gfa"), name_msa=NAMES)

rule graph_construction: 
    input: 
        path_msa=pjoin(PATH_MSAS, "{name_msa}.fasta")
    output: 
        path_gfa=pjoin(PATH_OUTPUT, "{name_msa}.gfa")
    log:
        out=pjoin(PATH_OUTPUT,"logs","{name_msa}-rule-graph_construction.out.log"),
        err=pjoin(PATH_OUTPUT,"logs","{name_msa}-rule-graph_construction.err.log"),
    params:
        path_msas=PATH_MSAS,
        path_output=PATH_OUTPUT
    shell:
        "/usr/bin/time -v PanPA build_gfa -d {params.path_msas} -o {params.path_output} 2> {log.err} > {log.out}"