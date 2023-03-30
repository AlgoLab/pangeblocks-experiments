configfile: "params-alignment.yaml"
import json
from pathlib import Path
from os.path import join as pjoin
from collections import defaultdict
from itertools import product

PATH_GFAS=config["PATH_GFAS"]
PATH_REFERENCES=config["PATH_REFERENCES"] # PATH_REFERECES/{seqs_id}.fa
PATH_READS=config["PATH_READS"] # PATH_READS/{seqs_id}/{seqs_id}.bwa.read[1/2].fastq.gz
PATH_OUTPUT=config["PATH_OUTPUT"] # PATH_OUTPUT/{seqs_id}/*.gaf
Path(PATH_OUTPUT).mkdir(exist_ok=True, parents=True)

if "*" in PATH_GFAS: # this assumes PATH_GFAS is in the same directory 
    GFAS=[ str(g) for g in Path().rglob(PATH_GFAS)]
else:
    GFAS=[ str(g) for g in Path(PATH_GFAS).rglob("*.gfa") ]
SEQSID=[ s.stem for s in Path(PATH_REFERENCES).glob("*.fa")]

# associate GFA to the correct reference sequences
seqsid_to_gfa=defaultdict(list)
for seqs_id in SEQSID:
    for path_gfa in GFAS:
        if seqs_id in path_gfa:
            seqsid_to_gfa[seqs_id].append(path_gfa) 

gfa_to_id = {str(p): j for j,p in enumerate(GFAS)} 

# IDs for rule all 
AUXSEQSID=[]
AUXGFAID=[]
for seqs_id,v in seqsid_to_gfa.items(): 
    for gfa_id in v:
        AUXSEQSID.append(seqs_id)
        AUXGFAID.append(gfa_to_id[gfa_id])

id_to_gfa={path: gfaid for gfaid, path in gfa_to_id.items()}
print(id_to_gfa)

with open(pjoin(PATH_OUTPUT,"gfaid_to_paths.json"),"w") as fp:
    json.dump(id_to_gfa,fp, sort_keys=True, indent=2)

rule all:
    input: 
        expand( pjoin( PATH_OUTPUT, "{seqs_id}","{seqs_id}.gfaid{gfa_id}.alignment.gaf"), zip, seqs_id=AUXSEQSID, gfa_id=AUXGFAID )

rule alignment:
    input:
        path_gfa=lambda wildcards: id_to_gfa[int(wildcards.gfa_id)],
        path_reads=pjoin(PATH_READS, "{seqs_id}", "{seqs_id}.bwa.read1.fastq.gz"),
    output:
        outalignment=pjoin( PATH_OUTPUT, "{seqs_id}","{seqs_id}.gfaid{gfa_id}.alignment.gaf"),
        outcorrected=pjoin( PATH_OUTPUT, "{seqs_id}","{seqs_id}.gfaid{gfa_id}.corrected-reads.fa"),
        outcorrectedclipped=pjoin( PATH_OUTPUT, "{seqs_id}","{seqs_id}.gfaid{gfa_id}.corrected-clipped-reads.fa")
    threads:
        16
    log:
        out=pjoin(PATH_OUTPUT, "{seqs_id}", "logs", "{seqs_id}.gfaid{gfa_id}-rule-alignment.out.log"),
        err=pjoin(PATH_OUTPUT, "{seqs_id}", "logs", "{seqs_id}.gfaid{gfa_id}-rule-alignment.err.log"),
    conda:
        "../envs/graphaligner.yaml"
    shell:
        """
        /usr/bin/time -v GraphAligner --verbose -g {input.path_gfa} -f {input.path_reads} -a {output.outalignment} \
        --corrected-out {output.outcorrected} --corrected-clipped-out {output.outcorrectedclipped} \
        -t {threads} -x vg 2> {log.err} > {log.out}
        """