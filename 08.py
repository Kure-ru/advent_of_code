import itertools

class Problem:
    def __init__(self, grid):
        self.grid = grid
        self.rows_length = len(self.grid)
        self.cols_length = len(self.grid[0])
        self.char_dict = {}

    def count_antinodes(self):
        return sum(char == '#' for row in self.grid for char in row)

    def is_in_bounds(self, pos):
        i, j = pos
        return 0 <= i < self.rows_length and 0 <= j < self.cols_length

    def generate_antinodes(self):
        all_antinodes = set()
        for positions in self.char_dict.values():
            pairs = list(itertools.combinations(positions, 2))

            for start_pos, end_pos in pairs:
                slope = [end_pos[0] - start_pos[0], end_pos[1] - start_pos[1]]
                antinodes = [start_pos, end_pos]

                for i in itertools.count(start=1):
                    antinode = [start_pos[0] - i * slope[0], start_pos[1] - i * slope[1]]
                    if not self.is_in_bounds(antinode):
                        break
                    antinodes.append(tuple(antinode))

                for i in itertools.count(start=1):
                    antinode = [end_pos[0] + i * slope[0], end_pos[1] + i * slope[1]]
                    if not self.is_in_bounds(antinode):
                        break
                    antinodes.append(tuple(antinode))

                for antinode in antinodes:
                    all_antinodes.add(tuple(antinode))

        for i, j in all_antinodes:
            self.grid[i][j] = '#'

    def generate_char_list(self):
        for row in range(self.rows_length):
            for col in range(self.cols_length):
                char = self.grid[row][col]
                if char != '.':
                    self.char_dict.setdefault(char, []).append((row, col))

def read_input(file_path):
    with open(file_path) as file:
        lines = file.read().strip().split('\n')
    return [[char for char in line] for line in lines]

def main():
    grid = read_input('./08_input.txt')
    problem = Problem(grid)
    problem.generate_char_list()
    problem.generate_antinodes()
    print("Antinodes# ", problem.count_antinodes())

if __name__ == "__main__":
    main()