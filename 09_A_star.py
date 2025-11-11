import heapq

# Heuristic function (Manhattan distance)
def heuristic(a, b):
    return abs(a[0] - b[0]) + abs(a[1] - b[1])

# Get valid neighboring cells (up, down, left, right)
def get_neighbors(pos, grid):
    neighbors = []
    directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]
    for dx, dy in directions:
        nx, ny = pos[0] + dx, pos[1] + dy
        if 0 <= nx < len(grid) and 0 <= ny < len(grid[0]):
            if grid[nx][ny] == 0:  # 0 = walkable, 1 = wall
                neighbors.append((nx, ny))
    return neighbors

# Reconstruct the path from goal to start
def reconstruct_path(came_from, current):
    path = [current]
    while current in came_from:
        current = came_from[current]
        path.append(current)
    path.reverse()
    return path

# A* Algorithm implementation
def a_star(grid, start, goal):
    open_set = []
    heapq.heappush(open_set, (0, start))
    came_from = {}
    g_score = {start: 0}

    while open_set:
        _, current = heapq.heappop(open_set)

        if current == goal:
            return reconstruct_path(came_from, current)

        for neighbor in get_neighbors(current, grid):
            tentative_g_score = g_score[current] + 1
            if neighbor not in g_score or tentative_g_score < g_score[neighbor]:
                came_from[neighbor] = current
                g_score[neighbor] = tentative_g_score
                f_score = tentative_g_score + heuristic(neighbor, goal)
                heapq.heappush(open_set, (f_score, neighbor))

    return None

# Main function
if __name__ == "__main__":
    print("=== A* Pathfinding Algorithm ===")
    rows = int(input("Enter number of rows in grid: "))
    cols = int(input("Enter number of columns in grid: "))

    grid = []
    print("Enter grid row by row (0 for free, 1 for wall):")
    for i in range(rows):
        row = list(map(int, input(f"Row {i+1}: ").split()))
        if len(row) != cols:
            print("Invalid row length! Try again.")
            exit()
        grid.append(row)

    start = tuple(map(int, input("Enter start position (row col): ").split()))
    goal = tuple(map(int, input("Enter goal position (row col): ").split()))

    path = a_star(grid, start, goal)
    if path:
        print("\nPath found:")
        print(path)
    else:
        print("\nNo path found.")
