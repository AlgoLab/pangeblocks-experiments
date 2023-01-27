configfile: "params.yaml"
from pathlib import Path

PATH_MSAS   = config["PATH_MSAS"]
TOOL="MAKEPRG"
PATH_OUTPUT = config[TOOL]["PATH_OUTPUT"]
Path(PATH_OUTPUT).mkdir(exist_ok=True, parents=True)
NAMES = [path.stem for path in Path(PATH_MSAS).rglob("*.fa")]

rule all:
    input:
        expand("{path_output}/{name_msa}.gfa", name_msa=NAMES, path_output=PATH_OUTPUT)

rule download_make_prg:
    output:
        "make_prg_0.4.0"
    shell:
        """
        wget https://github.com/iqbal-lab-org/make_prg/releases/download/0.4.0/make_prg_0.4.0
        chmod +x make_prg_0.4.0
        """

rule generate_prg:
    input:
        "make_prg_0.4.0"
    output:
        f"{PATH_OUTPUT}/.prg.gfa.zip"
    benchmark:
        f"{PATH_OUTPUT}/benchmarks/make_prg.benchmark.txt"
    log:
        f"{PATH_OUTPUT}/logs/make_prg.log"
    shell:
        f"/usr/bin/time --verbose ./{{input}} from_msa -i {PATH_MSAS} -o {PATH_OUTPUT}/ --output-type g 2> {{log}}"

rule extract_gfa: 
    input:
        path_zip=expand("{path_output}/.prg.gfa.zip",path_output=PATH_OUTPUT),
        path_output=PATH_OUTPUT
    output: 
        expand("{path_output}/{name_msa}.gfa", name_msa=NAMES,path_output=PATH_OUTPUT)
    shell:
        "unzip {input.path_zip} -d {input.path_output}"