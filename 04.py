counter = 0
chars = []
rows = 0
cols = 0
diagonalSearchA = []
diagonalSearchB = []

def findWord(array):
    print(array)
    global counter
    for row in array:
        for i in range(len(row) - 3):
            word = ''.join(row[i: i + 4])
            if (word == "XMAS" or word == "SAMX"):
                counter += 1

def XMas(chars):
    counter2 = 0
    for i in range(1, rows - 1):
        for j in range(1, cols - 1):
            topLeft = chars[i - 1][j - 1]
            topRight = chars[i - 1][j + 1]
            center = chars[i][j]
            bottomLeft = chars[i + 1][j - 1]
            bottomRight = chars[i + 1][j + 1]
            if ((topLeft == "M" and topRight == "S" and center == "A" and bottomLeft == "M" and bottomRight == "S") or
                (topLeft == "S" and topRight == "M" and center == "A" and bottomLeft == "S" and bottomRight == "M") or
                (topLeft == "S" and topRight == "S" and center == "A" and bottomLeft == "M" and bottomRight == "M") or
                (topLeft == "M" and topRight == "M" and center == "A" and bottomLeft == "S" and bottomRight == "S")):
                counter2 += 1
    print('problem 2', counter2)

def read_input(file_path):
    global rows, cols
    with open(file_path) as file:
        content = file.read()
        lines = content.split("\n")
        for line in lines:
            if line.strip():
                rows += 1
                cols = len(line)
                chars.append(list(line))

def construct_diagonals():
    for start in range(rows + cols - 1):
        diagonal = []
        for i in range(rows):
            j = start - i
            if (0 <= j < cols):
                diagonal.append(chars[i][j])
        diagonalSearchA.append(diagonal)

    for start in range(-rows + 1, cols):
        diagonal = []
        for i in range(rows):
            j = start + i
            if (0 <= j < cols):
                diagonal.append(chars[i][j])
        diagonalSearchB.append(diagonal)

def main():
    read_input("./04_input.txt")
    verticalSearch = list(map(list, zip(*chars)))
    construct_diagonals()

    findWord(chars)
    findWord(verticalSearch)
    findWord(diagonalSearchA)
    findWord(diagonalSearchB)
    XMas(chars)

    print('problem 1', counter)


main()