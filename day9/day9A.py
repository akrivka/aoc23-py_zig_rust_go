def make_diff(seq):
	diff = []
	for i in range(0, len(seq)-1):
		diff.append(seq[i+1] - seq[i])
	return diff


def predict(seq):
	if not all([x == 0 for x in seq]):
		p = predict(make_diff(seq))
		return seq[-1] + p
	else:
		return 0


with open("input", "r") as file:
	# Parse seed numbers
	result = 0
	for line in file.readlines():
		seq = [int(x) for x in line.split(" ")]
		result += predict(seq)
	
	print(result)