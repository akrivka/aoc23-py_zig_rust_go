// Divide-and-conquer

package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	s "strings"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func num_arrangements(springs string, segments []int) int {
	// Early return
	// Calculate slices
	var slices []string
	start := 0
	in := false
	more := false
	for i, c := range springs {
		if c == '?' {
			in = false
			more = true
			break
		} else if c == '#' && in == false {
			start = i
			in = true
		} else if c == '.' && in == true {
			slices = append(slices, springs[start:i])
			in = false
		}
	}
	if in == true {
		slices = append(slices, springs[start:])
	}

	// If more slices than segments return early
	if len(slices) > len(segments) {
		return 0
	}

	// If any of the slices in the prefix don't equal return early
	for i := range slices {
		if len(slices[i]) != segments[i] {
			return 0
		}
	}

	// If no more ? and slices match segments
	if !more && len(slices) == len(segments) {
		return 1
	} else if more {
		// If more ?
		for i, c := range springs {
			if c == '?' {
				springs1 := springs[:i] + "." + springs[i+1:]
				springs2 := springs[:i] + "#" + springs[i+1:]

				return num_arrangements(springs1, segments) + num_arrangements(springs2, segments)
			}
		}
	} else {
		return 0
	}
	return 0
}

func main() {
	// Open file
	file, err := os.Open("test")
	check(err)
	defer file.Close()

	// Initialize result
	result := 0

	// Process each line
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		parts := s.Split(scanner.Text(), " ")
		springs := parts[0]
		var segments []int
		for _, x := range s.Split(parts[1], ",") {
			var number, _ = strconv.Atoi(x)
			segments = append(segments, number)
		}

		// Expand
		for i := 0; i < 4; i++ {
			springs += "?" + springs
			segments = append(segments, segments...)
		}

		result += num_arrangements(springs, segments)
		fmt.Println("processed line", result)
	}

	fmt.Println(result)
}
