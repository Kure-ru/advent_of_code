def create_file_system(file_path):
    with open(file_path) as file:
        disk_map = file.read().strip()
    return disk_map

class Problem:
    def __init__(self, disk_map):
        self.disk_map = disk_map
        self.files = []
        self.file_ids = {}
        self.empty_spaces = []
        self.create_file_system()

    def create_file_system(self):
        is_file = True
        file_index = 0
        for pos, value in enumerate(self.disk_map):
            if is_file:
                self.file_ids[file_index] = int(value)
                self.files.extend([file_index] * int(value))
                is_file = False
            else:
                self.empty_spaces.append((len(self.files), int(value)))
                self.files.extend(['.'] * int(value))
                is_file = True
                file_index += 1

    def compact_whole_files(self):
        current_index = len(self.files) - 1
        while current_index >= 0:
            if self.files[current_index] != '.':
                file_len = self.file_ids[self.files[current_index]]
                empty_index = None
                for empty_space_index, empty_space in enumerate(self.empty_spaces):
                    if empty_space[1] >= file_len and empty_space[0] < current_index:
                        empty_index = empty_space_index
                        break
                if empty_index is not None:
                    start_index, space_length = self.empty_spaces.pop(empty_index)
                    for offset in range(file_len):
                        self.files[start_index] = self.files[current_index - offset]
                        self.files[current_index - offset] = '.'
                        start_index += 1
                    if file_len < space_length:
                        self.empty_spaces.insert(empty_index, (start_index, space_length - file_len))
                current_index -= file_len
            else:
                current_index -= 1

    def find_checksum(self):
        checksum = 0
        for index, value in enumerate(self.files):
            if value != '.':
                checksum += (index * int(value))
        return checksum

def main():
    input = create_file_system('./09_input.txt')
    problem = Problem(input)
    problem.compact_whole_files()
    result = problem.find_checksum()
    print(result)

if __name__ == "__main__":
    main()