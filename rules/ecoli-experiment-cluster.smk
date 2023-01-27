from pathlib import Path
data_dir = "data"

rule all: 
    input: 
        # Path(data_dir).joinpath("all_proteins_cluster_cluster.tsv") 
        # Path(data_dir).joinpath("cluster_names.txt")
        # dir_clusters=Path(data_dir).joinpath("clusters")
        Path(data_dir).joinpath("clusters/cluster_names.txt")

rule download_data:
    input: 
        Path(data_dir).joinpath("ftp_links.txt")
    output:
        Path(data_dir).joinpath("all_proteins.fasta")
    shell:
        """
        bash scripts/download_ftp.sh {input}
        for f in *faa.gz;do gzip -cd $f >> {output} && rm $f;done
        """

rule cluster_mmseqs:
    input: 
        Path(data_dir).joinpath("all_proteins.fasta")
    output:
        Path(data_dir).joinpath("all_proteins_cluster_cluster.tsv")
    params:
        aux="all_proteins_cluster"
    shell: 
        f"""
        mmseqs easy-linclust {{input}} {data_dir}{{params.aux}} tmp --min-seq-id 0.4
        rm -r tmp/
        """

rule extract_clusters:
    input:
        clusters=Path(data_dir).joinpath("all_proteins_cluster_cluster.tsv"),
        seqs=Path(data_dir).joinpath("all_proteins_cluster_all_seqs.fasta")
    params:
        dir_clusters=Path(data_dir).joinpath("clusters"),
        txt=Path(data_dir).joinpath("cluster_names.txt")
    output:
        Path(data_dir).joinpath("clusters/cluster_names.txt")
    shell:
        f"""
        cut -f1 {{input.clusters}} | uniq > {{params.txt}}
        mkdir -p {{params.dir_clusters}}
        python3 scripts/extract_clusters.py {{params.txt}} {{input.seqs}} {{params.dir_clusters}}
        ls {{params.dir_clusters}} > {{output}}
        """