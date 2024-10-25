import math 

def sub(int1, int2):
	[a1, b1] = int1
	[a2, b2] = int2

	# No overlap
	if b2 <= a1 or a2 >= b1:
		return [[a1, b1]], None
	# Full overlap inside [a2, b2] is in [a1, b1]
	if a2 >= a1 and b2 <= b1:
		return [[a1, a2], [b2, b1]], [a2, b2]
	# Full overlap outside [a1, b1] is in [a2, b2]
	if	a1 >= a2 and b1 <= b2:
		return [], [a1, b1]
	# Partial overlap beginning
	if b2 > a1 and b2 < b1:
		return [[b2, b1]], [a1, b2]
	# Partial overlap end
	if a2 >= a1 and a2 < b1:
		return [[a1, a2]], [a2, b1]

class IntervalSet:
	def __init__(self):
		self.intervals = []
	
	def normalize(self):
		# Sort by start
		self.intervals.sort(key = lambda x: x[0])

		newIntervals = []
		i = 0	
		n = len(self.intervals)

		while i < n:
			[a, b] = self.intervals[i]

			i += 1
			while i < n:
				[anext, bnext] = self.intervals[i]
				if anext <= b:
					b = max(b, bnext)
				else: 
					break
				i += 1
			
			newIntervals.append([a, b])
		self.intervals = newIntervals

	def append(self, a, b):
		if b <= a:
			return
		
		self.intervals.append([a, b])
		self.normalize()
	
	def subtract(self, a, b):
		newIntervals = []
		allOverlap = IntervalSet()

		for [ai, bi] in self.intervals:
			result, overlap = sub([ai, bi], [a, b])
			newIntervals += result
			if overlap:
				allOverlap.append(overlap[0], overlap[1])
		
		self.intervals = newIntervals
		return allOverlap

	def merge(self, iset):
		self.intervals += iset.intervals
		self.normalize()
	
	def shift(self, n):
		for interval in self.intervals:
			interval[0] += n
			interval[1] += n

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

with open("input", "r") as f:
	# Parse seed numbers
	seedsLine = f.readline()
	seedsInput = [int(x) for x in seedsLine.split(": ")[1].split(" ")]
	seedIset = IntervalSet()
	for i in range(len(seedsInput) // 2):
		start = seedsInput[2*i]
		length = seedsInput[2*i+1]

		seedIset.append(start, start + length)


	# Advance one line
	f.readline()

	# Read mappings
	line = ""
	while (line := f.readline()):
		src, dst = line.split(" ")[0].split("-to-")
		mapping = Mapping(src, dst)
		while (line := f.readline()):
			if line.isspace():
				break
			mapping.ranges.append([int(x) for x in line.split(" ")])
		
		mappings[src] = mapping
	
	currentCat = "seed"
	currentIset = seedIset
	while True:
		print(currentCat)
		if currentCat not in mappings:
			break
			
		mapping = mappings[currentCat]
		currentCat = mapping.dst
		newIset = IntervalSet()
		for [dstStart, srcStart, length] in mapping.ranges:
			overlap = currentIset.subtract(srcStart, srcStart + length)
			overlap.shift(dstStart - srcStart)
			newIset.merge(overlap)
		newIset.merge(currentIset)
		currentIset = newIset

	minLoc = math.inf
	for [a, b] in currentIset.intervals:
		if a < minLoc:
			minLoc = a

	print(minLoc)