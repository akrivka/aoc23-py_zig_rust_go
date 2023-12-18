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

func parseListOfInts(str string) []int {
	stringArray := s.Split(str, " ")
	var intArray []int
	for _, v := range stringArray {
		if v == "" {
			continue
		}
		var number, _ = strconv.Atoi(v)
		intArray = append(intArray, number)
	}
	return intArray
}

func main() {
	file, err := os.Open("input")
	check(err)
	defer file.Close()

	scanner := bufio.NewScanner(file)

	// Init slice to hold the number of matching numbers in each card
	var matchingCounts []int

	for scanner.Scan() {
		// Parse card
		card := s.Split(s.Split(scanner.Text(), ": ")[1], " | ")

		winningNumbers := parseListOfInts(card[0])
		ourNumbers := parseListOfInts(card[1])

		// Init card value
		numMatching := 0

		for _, our := range ourNumbers {
			for _, winning := range winningNumbers {
				if our == winning {
					numMatching += 1
				}
			}
		}

		matchingCounts = append(matchingCounts, numMatching)
	}

	// Init slice to hold the number of copies, init to 1
	copyCounts := make([]int, len(matchingCounts))
	for i := range copyCounts {
		copyCounts[i] = 1
	}

	for i := range copyCounts {
		for j := 1; j <= matchingCounts[i]; j++ {
			copyCounts[i+j] += copyCounts[i]
		}
	}

	// Find result
	result := 0
	for i := range copyCounts {
		result += copyCounts[i]
	}

	fmt.Println(result)
}
