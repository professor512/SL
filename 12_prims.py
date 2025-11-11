INF = 9999999

def prims_algorithm(graph):
    n = len(graph)
    selected = [False] * n
    selected[0] = True
    mst_edges = []

    for _ in range(n - 1):
        min_edge = (None, None, INF)
        for i in range(n):
            if selected[i]:
                for j in range(n):
                    if not selected[j] and graph[i][j] != 0:
                        if graph[i][j] < min_edge[2]:
                            min_edge = (i, j, graph[i][j])
        u, v, w = min_edge
        mst_edges.append((u, v, w))
        selected[v] = True

    return mst_edges

print("Roll No: 23173")
print("Name: Karan Salunkhe\n")

n = int(input("Enter number of vertices: "))
print("\nEnter adjacency matrix (0 if no edge):")
graph = [list(map(int, input().split())) for _ in range(n)]

mst = prims_algorithm(graph)
total = 0

print("\nEdges in the MST:")
for u, v, w in mst:
    print(f"{u} - {v} : {w}")
    total += w
print(f"\nTotal cost of MST: {total}")
