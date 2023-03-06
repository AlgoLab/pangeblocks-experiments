import networkx as nx

def load_graph(path_gfa):
    G = nx.DiGraph()


    for line in open(path_gfa):
        line = line.strip("\n").split("\t")
        if line[0] == "S":
            _, idx, seq = line
            seq = seq.replace("-","")
            G.add_node(idx, seq=seq)

    for line in open(path_gfa):
        line = line.strip("\n").split("\t")
        if line[0] == "L":
            _, idx1, _, idx2, _, _ = line
            G.add_edge(idx1, idx2)

    return G

def load_gfa(path_gfa):
    G = nx.DiGraph()
    # nodes=dict()
    # edges=[]
    with open(path_gfa, "r") as fp:
        for line in fp.readlines():    
            # nodes
            if line.startswith("S"):
                try:
                    _, nodeid, label = line.replace("\n","").split("\t")
                except:
                    _, nodeid, label, _ = line.replace("\n","").split("\t")
                G.add_node(nodeid, seq=label)
                # nodes[nodeid] = {"label": label, "len": len(label)}

            # edges: L	4	+	86	+	0M
            if line.startswith("L"):
                _, nodeid1, _, nodeid2, _, _ = line.replace("\n","").split("\t") 
                # edges.append((nodeid1, nodeid2))
                G.add_edge(nodeid1, nodeid2)

    return G 

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="Compute weakly connected components in a GFA")
    parser.add_argument('path_gfa', type=str, help="path to gfa")

    args = parser.parse_args()
    G = load_gfa(args.path_gfa)
    print(len([cc for cc in nx.weakly_connected_components(G)]))