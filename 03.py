import re

result = 0
pattern = r"mul\((\d+),(\d+)\)"
# Match any characters after don't() up to a do() or the end of the string
pattern2 = r"don't\(\)[\s\S]*?(do\(\)|$)"

def mul (num1, num2):
    try:
        return int(num1) * int(num2)
    except:
        return 0

#print(mul(2,4))
#print(mul(4,"*"))

with open("./03_input.txt") as file:
    content = file.read()

# remove instructions between a don't and a do
cleaned_content = re.sub(pattern2, "✅", content)

multiplications = re.findall(pattern, cleaned_content)

for nums in multiplications:
    result += mul(nums[0], nums[1])

print(cleaned_content)
print("RESULT", result)