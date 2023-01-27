from pathlib import Path
data_dir = "data"

IDs = Path(data_dir).joinpath("clusters").glob("*.[fa]*")
IDs = [p.stem for p in IDs][:10]
# IDs = ["NP_001294551.1"]
# print(IDs, sep="\n")

rule all:
    input:
        expand("{data_dir}/msas-dna/{id_cluster}.fasta", data_dir=data_dir, id_cluster=IDs)

rule backtranseq: 
    input:
        Path(data_dir).joinpath("clusters/{id_cluster}.fasta")
    output:
        Path(data_dir).joinpath("clusters-dna/{id_cluster}.fasta")
    log:
        err="logs/{id_cluster}.backtranseq.err.log",
        out="logs/{id_cluster}.backtranseq.out.log"
    shell:
        """
        /usr/bin/time --verbose backtranseq -sequence {input} -outfile {output} 2>  {log.err} > log.out
        """

rule msas_clustalo:
    input:
        Path(data_dir).joinpath("clusters-dna/{id_cluster}.fasta")
    output:
        Path(data_dir).joinpath("msas-dna/{id_cluster}.fasta")
    log:
        err="logs/{id_cluster}.clustalo.err.log",
        out="logs/{id_cluster}.clustalo.out.log"
    shell:
        """
        if [ $(grep "^>" {input} | wc -l) -gt 1 ]
            then
                /usr/bin/time --verbose clustalo --in {input} --out {output} 2>  {log.err} > log.out
            else
                cp {input} {output} 
        fi
        """