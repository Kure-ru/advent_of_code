class Problem:
    def __init__(self, input):
        self.grid = [list(line) for line in input]
        self.rows = len(self.grid)
        self.cols = len(self.grid[0])
        self.initial_pos = None

        for row in range(self.rows):
            for col in range(self.cols):
                if self.grid[row][col] == '^':
                    self.initial_pos = (row, col)
                    self.pos = (row, col)

        self.directions = [(-1, 0), (0, 1), (1, 0), (0, -1)] #up, right, down, left
        self.direction_index = 0

    def reset_guard(self):
        self.pos = self.initial_pos
        self.direction_index = 0

    def move_guard(self):
        x, y = self.pos
        dx, dy = self.directions[self.direction_index]
        return (x + dx, y + dy)

    def change_direction(self):
        self.direction_index = (self.direction_index + 1) % 4

    def check_pos(self):
        visited = set([self.pos])
        states = set([(self.pos, self.direction_index)])

        while True:
            new_pos = self.move_guard()
            if 0 <= new_pos[0] < self.rows and 0 <= new_pos[1] < self.cols:
                if self.grid[new_pos[0]][new_pos[1]] == '#':
                    self.change_direction()
                else:
                    self.pos = new_pos
                    visited.add(new_pos)
                if (self.pos, self.direction_index) in states:
                    return 0
                states.add((self.pos, self.direction_index))
            else:
                return len(visited)


    def can_get_stuck(self, row, col):
        original_char = self.grid[row][col]
        self.grid[row][col] = '#'
        self.reset_guard()
        visited_count = self.check_pos()
        self.grid[row][col] = original_char
        return visited_count == 0

    def count_obstacles(self):
        count = 0
        for row in range(self.rows):
            for col in range(self.cols):
                if self.grid[row][col] == '.':
                    if self.can_get_stuck(row, col):
                        count += 1
        return count

def read_input(file_path):
    with open(file_path) as file:
        content = file.read().strip().split('\n')
    return content

def main():
    input = read_input('./06_input.txt')
    problem = Problem(input)
    print("Distinct positions #", problem.check_pos())
    print("Obstructions #", problem.count_obstacles())

if __name__ == "__main__":
    main()