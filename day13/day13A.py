def process_pattern(pattern):
    num_rows = len(pattern)
    num_cols = len(pattern[0])

    # Check rows
    for r in range(num_rows - 1):
        i = 0
        found = True
        while r - i >= 0 and r + i + 1 < num_rows:
            if pattern[r - i] != pattern[r + i + 1]:
                found = False
                break
            else:
                i += 1
        
        if found:
            return 100 * (r+1)

    # Check cols
    for c in range(num_cols - 1):
        i = 0
        found = True
        while c - i >= 0 and c + i + 1 < num_cols:
            c1 = [row[c-i] for row in pattern]
            c2 = [row[c+i+1] for row in pattern]
            if c1 != c2:
                found = False
                break
            else:
                i += 1
        
        if found:
            return c+1
    
    return 0


with open("input", "r") as file:
    pattern = []
    result = 0
    for line in file.readlines():
        if line == "\n" or line == "":
            result += process_pattern(pattern)
            pattern = []
        else:
            pattern.append(line.strip())

    print(result)
