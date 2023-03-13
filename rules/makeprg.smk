configfile: "params.yaml"
from pathlib import Path
from os.path import join as pjoin

CONFLICT_MSAS=["DRB5-3127"]#, "DQA1-3117"]

PATH_MSAS   = config["PATH_MSAS"]
PATH_OUTPUT = config["MAKEPRG_OUTPUT"]
Path(PATH_OUTPUT).mkdir(exist_ok=True, parents=True)

list_fasta = list(Path(PATH_MSAS).glob("*.fa")) + list(Path(PATH_MSAS).glob("*.fasta")) 
EXT=str(list_fasta[0]).split(".")[-1]
NAMES = [path.stem for path in list_fasta if path.stem not in CONFLICT_MSAS]
print(NAMES)

rule all:
    input:
        expand(pjoin(PATH_OUTPUT, "{name_msa}.gfa"), name_msa=NAMES)

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
        makeprg="make_prg_0.4.0",
        path_msa=pjoin(PATH_MSAS, "{name_msa}"+f".{EXT}")
    output:
        f"{PATH_OUTPUT}/{{name_msa}}.prg.gfa"
    params:
        path_output=PATH_OUTPUT
    log:
        # out=f"{PATH_OUTPUT}/logs/{{name_msa}}-rule-generate_prg.out.log",
        err=f"{PATH_OUTPUT}/logs/{{name_msa}}-rule-generate_prg.err.log"
    shell:
        "/usr/bin/time --verbose ./{input.makeprg} from_msa -i {input.path_msa} -o {params.path_output}/{wildcards.name_msa} --output-type g 2> {log.err}"

rule postprocessing:
    input: 
        f"{PATH_OUTPUT}/{{name_msa}}.prg.gfa"
    output:
        f"{PATH_OUTPUT}/{{name_msa}}.gfa"
    log:
        # out=f"{PATH_OUTPUT}/logs/{{name_msa}}-rule-postprocessing.out.log",
        err=f"{PATH_OUTPUT}/logs/{{name_msa}}-rule-postprocessing.err.log"
    shell:
        """
        /usr/bin/time -v python3 utils/clean_gfa_from_ast.py {input} > {output} 2> {log.err}
        rm {input}
        """