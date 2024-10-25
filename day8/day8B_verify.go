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

func all_end_z(ghosts []string) bool {
	for i := 0; i < len(ghosts); i++ {
		if ghosts[i][2] != 'Z' {
			return false
		}
	}
	return true
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

	divisor := 2491

	// Precompute graph
	seq_nodes := make(map[string]string)
	for i := 0; i < len(names); i++ {
		name := names[i]
		for d := 0; d < divisor; d++ {
			for s := 0; s < len(seq); s++ {
				if seq[s] == 'L' {
					name = nodes[name].left
				} else if seq[s] == 'R' {
					name = nodes[name].right
				} else {
					break
				}
			}
		}
		seq_nodes[names[i]] = name
	}

	// Find starting nodes
	var ghosts []string
	for i := 0; i < len(names); i++ {
		if names[i][2] == 'A' {
			ghosts = append(ghosts, names[i])
		}
	}

	// Total number of sequences
	total := 56787204941

	for i := 0; i < total/divisor; i++ {
		if i%10000 == 0 {
			fmt.Println(float64(i*divisor) / float64(total))
		}
		for g := 0; g < len(ghosts); g++ {
			ghosts[g] = seq_nodes[ghosts[g]]
		}
	}

	fmt.Println(ghosts)

	fmt.Println(total * len(seq))
}
