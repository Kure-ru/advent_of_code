def parse_input(file_path):
    result = {}
    with open(file_path) as file:
        input_lines = file.read().strip().split('\n')
    for line in input_lines:
        key, values = line.split(':')
        key = int(key.strip())
        values = list(map(int, values.strip().split()))
        result[key] = values
    return result

def compute__loe(equation, target, index=0, current_result=0):
   if index == len(equation):
       return current_result == target
   if compute__loe(equation, target, index + 1, current_result + equation[index]):
       return True
   if compute__loe(equation, target, index + 1, current_result * equation[index]):
       return True
   if compute__loe(equation, target, index + 1, int(str(current_result) + str(equation[index]))):
       return True
   return False

def compute__e(result, equation):
    return compute__loe(equation, result)

def main():
    input = parse_input('./07_input.txt')
    total_calibration_result = 0
    for key, values in input.items():
        if compute__e(key, values):
            total_calibration_result += key

    print('Total calibration result: ', total_calibration_result)

if __name__ == "__main__":
    main()