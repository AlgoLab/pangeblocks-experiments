"Compute number of weakly connected components from a GFA"
import networkx as nx

def load_gfa(path_gfa):
    G = nx.DiGraph()
    
    with open(path_gfa, "r") as fp:
        for line in fp.readlines():    
            # nodes
            if line.startswith("S"):
                try:
                    _, nodeid, label = line.replace("\n","").split("\t")
                except:
                    _, nodeid, label, _ = line.replace("\n","").split("\t")
                G.add_node(nodeid, seq=label)
        
            # edges
            if line.startswith("L"):
                _, nodeid1, _, nodeid2, _, _ = line.replace("\n","").split("\t") 
                G.add_edge(nodeid1, nodeid2)

    return G 

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="Compute weakly connected components in a GFA")
    parser.add_argument('path_gfa', type=str, help="path to gfa")

    args = parser.parse_args()
    G = load_gfa(args.path_gfa)
    print(len([cc for cc in nx.weakly_connected_components(G)]))