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

func hash(s string) int {
	x := 0
	for _, c := range s {
		x += int(c)
		x *= 17
		x %= 256
	}
	return x
}

func remove(slice []lens, s int) []lens {
	return append(slice[:s], slice[s+1:]...)
}

type lens struct {
	label       string
	focalLength int
}

func main() {
	// Open file
	file, err := os.Open("input")
	check(err)
	defer file.Close()

	// Get input
	scanner := bufio.NewScanner(file)
	scanner.Scan()
	steps := s.Split(scanner.Text(), ",")

	var hashmap [256][]lens

StepLoop:
	for _, step := range steps {
		if s.Contains(step, "-") {
			label := s.Split(step, "-")[0]

			boxNumber := hash(label)

			// Remove lens with label
			for i, lens := range hashmap[boxNumber] {
				if lens.label == label {
					hashmap[boxNumber] = remove(hashmap[boxNumber], i)
					break
				}
			}
		} else if s.Contains(step, "=") {
			parts := s.Split(step, "=")
			label := parts[0]
			focalLength, _ := strconv.Atoi(parts[1])

			boxNumber := hash(label)

			// See if lense already there
			for i, lens := range hashmap[boxNumber] {
				if lens.label == label {
					hashmap[boxNumber][i].focalLength = focalLength
					continue StepLoop
				}
			}

			// If not
			hashmap[boxNumber] = append(hashmap[boxNumber], lens{label, focalLength})
		} else {
			fmt.Println("Invalid instruction")
			return
		}

		//for boxNumber, box := range hashmap {
		//	if len(box) != 0 {
		//		fmt.Println(boxNumber, box)
		//	}
		//}
		//fmt.Println()
	}

	// Initialize result
	result := 0

	for boxNumber, box := range hashmap {
		for slot, lens := range box {
			result += (boxNumber + 1) * (slot + 1) * lens.focalLength
		}
	}

	fmt.Println(result)
}
