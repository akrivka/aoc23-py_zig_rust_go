import math 

class Mapping:
	def __init__(self, src, dst):
		self.src = src
		self.dst = dst
		self.ranges = []
	
	def get(self, x):
		for [dstStart, srcStart, length] in self.ranges:
			if x >= srcStart and x < srcStart + length:
				return dstStart + (x - srcStart)
		return x

mappings = {}

with open("test", "r") as f:
	# Parse seed numbers
	seedsLine = f.readline()
	seeds = [int(x) for x in seedsLine.split(": ")[1].split(" ")]

	# Advance one line
	f.readline()

	# Read mappings
	line = ""
	while (line := f.readline()):
		src, dst = line.split(" ")[0].split("-to-")
		print(src, dst)
		mapping = Mapping(src, dst)
		while (line := f.readline()):
			if line.isspace():
				break
			mapping.ranges.append([int(x) for x in line.split(" ")])
		
		mappings[src] = mapping
	
	minLoc = math.inf
	for seed in seeds:
		currentCat = "seed"
		currentNum = seed
		while True:
			if currentCat not in mappings:
				break

			mapping = mappings[currentCat]
			currentCat = mapping.dst
			currentNum = mapping.get(currentNum)
		
		print("seed:", seed, "num:", currentNum)
		if currentNum < minLoc:
			minLoc = currentNum
	
	print(minLoc)