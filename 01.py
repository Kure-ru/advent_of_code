left, right = [], []
res = 0

with open("./01_input.txt") as f:
    lines = f.readlines()

    for line in lines:
        x, y = line.split("   ")
        left.append(int(x))
        right.append(int(y))

left.sort()
right.sort()

for i in range(len(left)):
    res += abs( left[i] - right[i])

print(res)

d = dict()
result = 0

for value in right:
    if value in d:
        d[value] += 1
    else:
        d[value] = 1

for value in left:
    if value in d:
        result += d[value] * value

print(result)