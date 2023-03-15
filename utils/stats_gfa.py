import sys
from collections import defaultdict
def len_nodes_used_all_paths(gfa_path):
    """
    Return len of the nodes that are common to all paths
    and the percentage of this len w.r.t the total len of the graph
    """
    nodes_usage=defaultdict(list)
    nodes = dict()
    with open(gfa_path) as fp:
        num_paths=0
        for line in fp.readlines():

            # nodes
            if line.startswith("S"):
                try:
                    _, nodeid, label = line.replace("\n","").split("\t")
                except:
                    _, nodeid, label, _ = line.replace("\n","").split("\t")
                
                nodes[nodeid] = {"label": label, "len": len(label)}

            # paths
            if line.startswith("P"):
                num_paths += 1

                _, seq_id, path, *_ = line.replace("\n","").split("\t")
                for node in path.split(","):
                    if "-" in node: # reverse label '-' next to node
                        nodeid = node.replace("-","")

                    else: # forward label '+' next to node
                        nodeid = node.replace("+","")

                    nodes_usage[nodeid].append(seq_id)
    
    # nodes shared by all paths
    if num_paths>0:
        len_nodes_shared=sum(feats["len"] for nodeid, feats in nodes.items() if len(nodes_usage[nodeid])==num_paths)
        # total len of the graph
        len_all_nodes=sum(feats["len"] for nodeid, feats in nodes.items())
        perc_nodes_shared = (len_nodes_shared/len_all_nodes)*100
    else:
        len_nodes_shared=-1
        perc_nodes_shared=-1
    return len_nodes_shared, perc_nodes_shared

if __name__ == "__main__":

    gfa_path=sys.argv[1]
    len_nodes_shared, perc_nodes_shared=len_nodes_used_all_paths(gfa_path)  
    print(len_nodes_shared, perc_nodes_shared, sep="\t")