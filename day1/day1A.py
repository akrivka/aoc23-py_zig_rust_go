import re

with open("input1", "r") as f:
	result = 0
	for l in f.readlines():
		digits = re.findall("[0-9]", l)
		number = int(digits[0] + digits[-1])
		result += number

print(result)
