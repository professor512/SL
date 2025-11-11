def find(parent, i):
    if parent[i] == i:
        return i
    return find(parent, parent[i])

def union(parent, rank, x, y):
    xroot = find(parent, x)
    yroot = find(parent, y)
    if rank[xroot] < rank[yroot]:
        parent[xroot] = yroot
    elif rank[xroot] > rank[yroot]:
        parent[yroot] = xroot
    else:
        parent[yroot] = xroot
        rank[xroot] += 1

def kruskal_algorithm(V, edges):
    # sort edges (Selection Sort)
    for i in range(len(edges)):
        min_idx = i
        for j in range(i + 1, len(edges)):
            if edges[j][2] < edges[min_idx][2]:
                min_idx = j
        edges[i], edges[min_idx] = edges[min_idx], edges[i]

    parent = [i for i in range(V)]
    rank = [0] * V
    result = []
    e = 0
    i = 0

    while e < V - 1 and i < len(edges):
        u, v, w = edges[i]
        i += 1
        x = find(parent, u)
        y = find(parent, v)
        if x != y:
            result.append((u, v, w))
            e += 1
            union(parent, rank, x, y)
    return result

print("Roll No: 23173")
print("Name: Karan Salunkhe\n")

V = int(input("Enter number of vertices: "))
E = int(input("Enter number of edges: "))

edges = []
print("\nEnter edges as: u v w")
for _ in range(E):
    edges.append(tuple(map(int, input().split())))

mst = kruskal_algorithm(V, edges)
total = 0

print("\nEdges in the MST:")
for u, v, w in mst:
    print(f"{u} - {v} : {w}")
    total += w
print(f"\nTotal cost of MST: {total}")



# SAMPLE OUTPUT
# Enter number of vertices: 4
# Enter number of edges: 5

# Enter edges as: u v w
# 0 1 2 
# 0 2 3
# 1 2 1
# 1 3 4
# 2 3 5