import regex as re

spelledToNumber = {
	"one": "1",
	"two": "2",
	"three": "3",
	"four": "4",
	"five": "5",
	"six": "6",
	"seven": "7",
	"eight": "8",
	"nine": "9"
}
	
with open("inputB", "r") as f:
	result = 0
	i = 1
	for l in f.readlines():
		rawDigits = re.findall("[0-9]|one|two|three|four|five|six|seven|eight|nine", l, overlapped=True)
		numberDigits = [(spelledToNumber[x] if (x in spelledToNumber) else x) for x in rawDigits]
		number = int(numberDigits[0] + numberDigits[-1])
		print(i, number)
		result += number
		i += 1

print(result)
