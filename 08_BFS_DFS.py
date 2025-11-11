from collections import deque

# Function to create graph from user input
def create_graph():
    graph = {}
    n = int(input("Enter the number of vertices: "))
    for i in range(n):
        vertex = input(f"Enter vertex {i+1} name: ")
        neighbors = input(f"Enter neighbors of {vertex} (comma separated): ").split(',')
        neighbors = [nbr.strip() for nbr in neighbors if nbr.strip() != '']
        graph[vertex] = neighbors
    return graph

# Recursive Depth First Search
def dfs_recursive(graph, vertex, visited=None):
    if visited is None:
        visited = set()
    visited.add(vertex)
    print(vertex, end=' ')
    for neighbor in graph.get(vertex, []):
        if neighbor not in visited:
            dfs_recursive(graph, neighbor, visited)
    return visited

# Iterative Breadth First Search
def bfs_iterative(graph, start):
    visited = set([start])
    queue = deque([start])
    while queue:
        vertex = queue.popleft()
        print(vertex, end=' ')
        for neighbor in graph.get(vertex, []):
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append(neighbor)
    return visited

# Running the searches
if __name__ == "__main__":
    print("=== Graph Traversal using DFS and BFS ===")
    graph = create_graph()
    print("\nGraph you entered:", graph)
    
    start = input("\nEnter the starting vertex: ")

    print("\nDFS Recursive Traversal:")
    dfs_recursive(graph, start)
    
    print("\n\nBFS Iterative Traversal:")
    bfs_iterative(graph, start)
    print()
