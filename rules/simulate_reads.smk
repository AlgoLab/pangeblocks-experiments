configfile: "params-simulate-reads.yaml"
from pathlib import Path
from os.path import join as pjoin

PATH_SEQS=config["PATH_SEQS"]
PATH_OUTPUT=config["PATH_OUTPUT"]

SEQSID=[ s.stem for s in Path(PATH_SEQS).glob("*.fa")]

rule all:
    input: 
        expand( pjoin(PATH_OUTPUT, "reference", "{seqs_id}.fa") , seqs_id=SEQSID)

rule get_reference:
    input:
        path_seqs=pjoin(PATH_SEQS, "{seqs_id}.fa")
    output:
        path_reference=pjoin(PATH_OUTPUT, "reference", "{seqs_id}.fa")
    conda:
        "../envs/biopython.yaml"
    shell:
        """
        python3 utils/extract_reference.py {input} {output}
        """