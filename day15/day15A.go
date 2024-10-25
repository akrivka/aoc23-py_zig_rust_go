package main

import (
	"bufio"
	"fmt"
	"os"
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

func main() {
	// Open file
	file, err := os.Open("input")
	check(err)
	defer file.Close()

	// Get input
	scanner := bufio.NewScanner(file)
	scanner.Scan()
	steps := s.Split(scanner.Text(), ",")

	// Initialize result
	result := 0

	for _, s := range steps {
		result += hash(s)
	}

	fmt.Println(result)
}
