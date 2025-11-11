# Alpha-Beta Pruning Algorithm (Simple Implementation)

def alpha_beta(node, depth, alpha, beta, maximizingPlayer):
    # Base case: if at leaf node or depth limit reached
    if depth == 0 or not isinstance(node, list):
        return node  # static evaluation value (number)

    if maximizingPlayer:
        max_eval = float('-inf')
        for child in node:
            eval = alpha_beta(child, depth - 1, alpha, beta, False)
            max_eval = max(max_eval, eval)
            alpha = max(alpha, eval)
            if beta <= alpha:
                break  # β cut-off
        return max_eval

    else:
        min_eval = float('inf')
        for child in node:
            eval = alpha_beta(child, depth - 1, alpha, beta, True)
            min_eval = min(min_eval, eval)
            beta = min(beta, eval)
            if beta <= alpha:
                break  # α cut-off
        return min_eval


# Main program
if __name__ == "__main__":
    print("=== Alpha-Beta Pruning Algorithm ===")
    print("Example input format: [[3,5,6],[9,1,2],[0,-1,7]]")
    
    tree_str = input("Enter game tree: ")
    try:
        game_tree = eval(tree_str)
    except:
        print("Invalid format! Exiting.")
        exit()

    depth = int(input("Enter search depth (e.g., 2): "))

    result = alpha_beta(
        game_tree,
        depth=depth,
        alpha=float('-inf'),
        beta=float('inf'),
        maximizingPlayer=True
    )

    print("\nOptimal value (with Alpha-Beta Pruning):", result)
