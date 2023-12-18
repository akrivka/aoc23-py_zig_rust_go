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

	// Initialize result
	result := 0

	for scanner.Scan() {
		// Parse card
		card := s.Split(s.Split(scanner.Text(), ": ")[1], " | ")

		winningNumbers := parseListOfInts(card[0])
		ourNumbers := parseListOfInts(card[1])

		// Init card value
		cardVal := 0

		for _, our := range ourNumbers {
			for _, winning := range winningNumbers {
				if our == winning {
					if cardVal == 0 {
						cardVal = 1
					} else {
						cardVal *= 2
					}
				}
			}
		}

		result += cardVal
	}

	fmt.Println(result)
}
