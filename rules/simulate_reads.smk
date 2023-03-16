configfile: "params-simulate-reads.yaml"
from pathlib import Path
from os.path import join as pjoin

PATH_SEQS=config["PATH_SEQS"]
PATH_OUTPUT=config["PATH_OUTPUT"]

SEQSID=[ s.stem for s in Path(PATH_SEQS).glob("*.fa")]

rule all:
    input: 
        # expand( pjoin(PATH_OUTPUT, "reference", "{seqs_id}.fa") , seqs_id=SEQSID),
        expand( pjoin(PATH_OUTPUT, "{seqs_id}", "{seqs_id}.bwa.read1.fastq.gz"), seqs_id=SEQSID),
        expand( pjoin(PATH_OUTPUT, "{seqs_id}", "{seqs_id}.bwa.read2.fastq.gz"), seqs_id=SEQSID)

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

rule simulate_reads:
    input:
        path_reference=pjoin(PATH_OUTPUT, "reference", "{seqs_id}.fa")
    output:
        pjoin(PATH_OUTPUT, "{seqs_id}", "{seqs_id}.bwa.read1.fastq.gz"),
        pjoin(PATH_OUTPUT, "{seqs_id}", "{seqs_id}.bwa.read2.fastq.gz")
    params:
        outprefix=pjoin(PATH_OUTPUT, "{seqs_id}", "{seqs_id}")
    shell:
        """
        ./DWGSIM/dwgsim -e 0.01 -E 0.01 -d 150 -C 15 -1 150 -2 150 -r 0 -F 0 -R 0 -X 0 -y 0 -A 1 -o 1 {input.path_reference} {params.outprefix}
        """