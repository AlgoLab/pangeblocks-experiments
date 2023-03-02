def stats_gfa(gfa_path):
    nodes=dict()
    edges=[]
    with open(gfa_path) as fp:
        for line in fp.readlines():
            
            # nodes
            if line.startswith("S"):
                try:
                    _, nodeid, label = line.replace("\n","").split("\t")
                except:
                    _, nodeid, label, _ = line.replace("\n","").split("\t")
                nodes[nodeid] = {"label": label, "len": len(label)}

            # edges: L	4	+	86	+	0M
            if line.startswith("L"):
                _, nodeid1, _, nodeid2, _, _ = line.replace("\n","").split("\t") 
                edges.append((nodeid1, nodeid2))

            # paths
            if line.startswith("P"):
                continue

    len_graph = sum([v["len"] for v in nodes.values()])
    n_nodes = len(nodes)
    n_edges = len(edges)

    return {"len_graph": len_graph, "n_nodes": n_nodes, "n_edges": n_edges}