package main

import (
	"bufio"
	"fmt"
	"os"
	s "strings"
)

type node struct {
	left  string
	right string
}

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func main() {
	file, err := os.Open("input")
	check(err)
	defer file.Close()

	scanner := bufio.NewScanner(file)

	// Get the sequence
	scanner.Scan()
	seq := scanner.Text()

	// Get the graph
	nodes := make(map[string]node)
	var names []string
	scanner.Scan()
	for scanner.Scan() {
		line := s.Split(scanner.Text(), " = ")
		children := s.Split(line[1][1:len(line[1])-1], ", ")

		root := line[0]
		left := children[0]
		right := children[1]

		nodes[root] = node{left, right}
		names = append(names, root)
	}

	seq_nodes := make(map[string]string)
	for i := 0; i < len(names); i++ {
		name := names[i]
		for s := 0; s < len(seq); s++ {
			if seq[s] == 'L' {
				name = nodes[name].left
			} else if seq[s] == 'R' {
				name = nodes[name].right
			} else {
				break
			}
		}
		seq_nodes[names[i]] = name
	}

	// Initialize result
	result := 0

	name := "AAA"
	for name != "ZZZ" {
		name = seq_nodes[name]
		result += len(seq)
	}

	fmt.Println(result)
}
