"Load gaf file from alignment"
import pandas as pd 
from .load_gfa import load_gfa

# meaning of some tags
ABBV = dict(
    NM="edit distance to the reference",
    AS="alignment score generated by aligner",
    id="residue matches / alignment block length"
)

# Load GAF (Graph alignment format)
COLS=[
    "query_seq_name","query_seq_len", "query_start", "query_end", "strand_rel_path",
    "path_matching","path_len", "start_pos_path", "end_pos_path","num_residue_matches","alignment_block_len", 
    "mapping_quality", "NM", "AS", "dv",    
    "id", "cigar"
]

def load_gaf(path_gaf, path_gfa=None):
    
    gaf=pd.read_csv(path_gaf, sep="\t", header=None)
    gaf.columns = COLS
    
    # get values from some tags
    gaf["AS"] = gaf["AS"].apply(lambda v: float(v.split(":")[-1]))
    gaf["NM"] = gaf["NM"].apply(lambda v: int(v.split(":")[-1]))
    gaf["id"] = gaf["id"].apply(lambda v: float(v.split(":")[-1]))
    
    if path_gfa: 
        # check paths 
        # load GFA
        path_gfa="/data/pangeblocks-experiments/HLA-zoo-pangeblocks/output-HLA-zoo-mafft.op1.53-ep0/gfa-unchop/nodes/penalization0-min_len0/DMA-3108.gfa"
        nodes, edges, paths=load_gfa(path_gfa, return_nodes_path=True)

        # paths in GFA format for direct comparison
        paths = {pid: "".join([">"+n for n in nodes]) for pid,nodes in paths.items()}
        
        gaf["num_alignment_subpath_gfa"] = gaf["path_matching"].apply(lambda subpath: sum([subpath in p for p in paths.values()]))

    return gaf