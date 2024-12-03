safe_report_num = 0

def check_report(nums):
    is_safe = True
    if all(i < j for i, j in zip(nums, nums[1:])) or all(i > j  for i, j in zip(nums, nums[1:])):
        for i in range(len(nums) - 1):
            if not (1 <= abs(nums[i] - nums[i + 1]) <= 3):
                is_safe = False
                break
    else:
        is_safe = False

    return is_safe

with open("./02_input.txt") as f:
#with open("./test.txt") as f:
    lines = f.readlines()
    for line in lines:
        report = list(map(int, line.split()))
        if (check_report(report)):
            safe_report_num += 1
        else:
            for i in range(len(report)):
                spliced = report[:i] + report[i + 1:]
                if (check_report(spliced)):
                    safe_report_num += 1
                    break


print("safe reports: ", safe_report_num)

