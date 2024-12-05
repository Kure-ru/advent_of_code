import functools
import math

rules, reports, correct_reports, incorrect_reports, corrected_reports = [], [], [], [], []

def add_middle(reports):
    result = 0
    for report in reports:
        result += report[(len(report) // 2)]
    print('result: ', result)

def compare(a, b):
    if (a, b) in rules:
        return -1
    elif (b, a) in rules:
        return 1
    else:
        return 0

with open("./05_input.txt") as file:
    content = file.read()

sections = content.split("\n\n")
section1 = sections[0].split("\n")
section2 = sections[1].split("\n")

for line in section1:
    x, y = line.split("|")
    rules.append((int(x), int(y)))

for line in section2:
    if line.strip():
        nums = list(map(int, line.split(",")))
        reports.append(nums)

for report in reports:
    sorted_report = sorted(report, key=functools.cmp_to_key(compare))
    if sorted_report == report:
         correct_reports.append(report)
    else:
        incorrect_reports.append(sorted_report)

add_middle(correct_reports)
add_middle(incorrect_reports)
