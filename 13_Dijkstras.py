INF = 9999999

def dijkstra_algorithm(graph, src):
    n = len(graph)
    dist = [INF] * n
    dist[src] = 0
    visited = [False] * n

    for _ in range(n):
        # find vertex with smallest distance
        min_dist = INF
        u = -1
        for i in range(n):
            if not visited[i] and dist[i] < min_dist:
                min_dist = dist[i]
                u = i
        if u == -1:
            break
        visited[u] = True

        for v in range(n):
            if graph[u][v] != 0 and not visited[v]:
                if dist[u] + graph[u][v] < dist[v]:
                    dist[v] = dist[u] + graph[u][v]
    return dist

print("Roll No: 23173")
print("Name: Karan Salunkhe\n")

n = int(input("Enter number of vertices: "))
print("\nEnter adjacency matrix (0 if no edge):")
graph = [list(map(int, input().split())) for _ in range(n)]
src = int(input("\nEnter source vertex: "))

distances = dijkstra_algorithm(graph, src)

print(f"\nShortest distances from vertex {src}:")
for i in range(n):
    print(f"{src} → {i} = {distances[i]}")




# SAMPLE inputEnter number of vertices: 4
# Enter adjacency matrix:
# 0 3 0 7
# 3 0 2 0
# 0 2 0 1
# 7 0 1 0
# Enter source vertex: 0