# ==============================================
# N-Queens Problem using Backtracking and Branch & Bound
# ==============================================

# ---------- Backtracking Approach ----------
def is_safe_bt(board, row, col, n):
    # Check if a queen can be placed at (row, col)
    for i in range(row):
        for j in range(n):
            if board[i][j] == 1:
                if j == col or abs(i - row) == abs(j - col):
                    return False
    return True

def solve_n_queens_bt_util(board, row, n, solutions):
    if row == n:
        solutions.append([r.index(1) for r in board])
        return
    for col in range(n):
        if is_safe_bt(board, row, col, n):
            board[row][col] = 1
            solve_n_queens_bt_util(board, row + 1, n, solutions)
            board[row][col] = 0  # backtrack

def solve_n_queens_bt(n):
    board = [[0]*n for _ in range(n)]
    solutions = []
    solve_n_queens_bt_util(board, 0, n, solutions)
    return solutions

def print_solutions_bt(solutions, n):
    print(f"\nBacktracking - Total Solutions: {len(solutions)}\n")
    for idx, sol in enumerate(solutions, 1):
        print(f"Solution {idx}:")
        for i in range(n):
            row = ['.'] * n
            row[sol[i]] = 'Q'
            print(" ".join(row))
        print()


# ---------- Branch and Bound Approach ----------
def solve_n_queens_bb(n):
    solutions = []
    board = [-1] * n  # board[i] = column position of queen in row i
    cols = [False] * n
    diag1 = [False] * (2 * n - 1)  # row - col + (n - 1)
    diag2 = [False] * (2 * n - 1)  # row + col

    def backtrack(row):
        if row == n:
            solutions.append(board.copy())
            return
        for col in range(n):
            if not cols[col] and not diag1[row - col + n - 1] and not diag2[row + col]:
                board[row] = col
                cols[col] = diag1[row - col + n - 1] = diag2[row + col] = True
                backtrack(row + 1)
                # Undo / backtrack
                cols[col] = diag1[row - col + n - 1] = diag2[row + col] = False
                board[row] = -1

    backtrack(0)
    return solutions

def print_solutions_bb(solutions, n):
    print(f"\nBranch and Bound - Total Solutions: {len(solutions)}\n")
    for idx, sol in enumerate(solutions, 1):
        print(f"Solution {idx}:")
        for i in range(n):
            row = ['.'] * n
            row[sol[i]] = 'Q'
            print(" ".join(row))
        print()


# ---------- Main ----------
if __name__ == "__main__":
    print("=== N-Queens Problem ===")

    n = int(input("Enter N for Backtracking: "))
    solutions_bt = solve_n_queens_bt(n)
    print_solutions_bt(solutions_bt, n)

    n = int(input("Enter N for Branch and Bound: "))
    solutions_bb = solve_n_queens_bb(n)
    print_solutions_bb(solutions_bb, n)
