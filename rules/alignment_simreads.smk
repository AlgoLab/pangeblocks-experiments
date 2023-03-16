configfile: "params-alignment.yaml"
from pathlib import Path
from os.path import join as pjoin
from collections import defaultdict

PATH_GFAS=config["PATH_GFAS"]
PATH_REFERENCES=config["PATH_REFERENCES"] # PATH_REFERECES/{seqs_id}.fa
PATH_READS=config["PATH_READS"] # PATH_READS/{seqs_id}/{seqs_id}.bwa.read[1/2].fastq.gz
PATH_OUTPUT=config["PATH_OUTPUT"] # PATH_OUTPUT/{seqs_id}/*.gaf

GFAS=[ str(g) for g in Path(PATH_GFAS).rglob("*.gfa") ]
SEQSID=[ s.stem for s in Path(PATH_REFERENCES).glob("*.fa")]

print(SEQSID)

seqsid_to_gfa=defaultdict(list)
for seqs_id in SEQSID:
    for path_gfa in GFAS:
        if seqs_id in path_gfa:
            seqsid_to_gfa[seqs_id].append(path_gfa) 

print(seqsid_to_gfa)
print(len(SEQSID), len(seqsid_to_gfa))

#TODO: include the graph as a wildcard
rule all:
    input: 
        expand( pjoin( PATH_OUTPUT, "{seqs_id}","{seqs_id}.alignment.gaf"), seqs_id=SEQSID )

rule alignment:
    input:
        path_gfa=lambda wildcards: \
                    seqsid_to_gfa[wildcards.seqs_id][0],
        path_reads=pjoin(PATH_READS, "{seqs_id}", "{seqs_id}.bwa.read1.fastq.gz"),
    output:
        outalignment=pjoin( PATH_OUTPUT, "{seqs_id}","{seqs_id}.alignment.gaf"),
        outcorrected=pjoin( PATH_OUTPUT, "{seqs_id}","{seqs_id}.corrected-reads.fa"),
        outcorrectedclipped=pjoin( PATH_OUTPUT, "{seqs_id}","{seqs_id}.corrected-clipped-reads.fa")
    threads:
        16
    log:
        out=pjoin(PATH_OUTPUT, "{seqs_id}", "logs", "{seqs_id}-rule-alignment.out.log"),
        err=pjoin(PATH_OUTPUT, "{seqs_id}", "logs", "{seqs_id}-rule-alignment.err.log"),
    conda:
        "../envs/graphaligner.yaml"
    shell:
        """
        GraphAligner --verbose -g {input.path_gfa} -f {input.path_reads} -a {output.outalignment} \
        --corrected-out {output.outcorrected} --corrected-clipped-out {output.outcorrectedclipped} \
        -t {threads} -x vg 2> {log.err} > {log.out}
        """