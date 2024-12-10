from collections import deque

def parse_input(file_path):
    with open(file_path) as file:
        lines = file.read().strip().split('\n')

    lines = [[int(char) for char in line] for line in lines]
    grid = {}
    for y, line in enumerate(lines):
        for x, char in enumerate(line):
            grid[(y, x)] = int(char)
    return grid

def find_trails(grid, trailhead):
    dirs = [(-1, 0), (1, 0), (0, -1), (0, 1)]
    score = 0
    queue = deque([trailhead])
    encountered_pos = set()
    while queue:
        pos = queue.popleft()
        if pos in encountered_pos:
            continue
        elevation = grid[pos]
        if elevation == 9:
            score += 1
            continue
        surrounding_pos = [(pos[0] + dir[0], pos[1] + dir[1]) for dir in dirs if (pos[0] + dir[0], pos[1] + dir[1]) in grid and grid[(pos[0] + dir[0], pos[1] + dir[1])] == elevation + 1]
        queue.extend(surrounding_pos)
    return score

def main():
    grid = parse_input('./10_input.txt')
    trailheads = [key for key, value in grid.items() if value == 0]
    paths_num = sum(find_trails(grid, trailhead) for trailhead in trailheads)

    print("Paths# ", paths_num)

if __name__ == "__main__":
    main()