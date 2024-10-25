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

	// Precompute graph
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

	// Find starting nodes
	var ghosts []string
	for i := 0; i < len(names); i++ {
		if names[i][2] == 'A' {
			ghosts = append(ghosts, names[i])
		}
	}

	// Advance so all ghosts are definitely on a cycle
	for k := 0; k < 1000; k++ {
		for i := 0; i < len(ghosts); i++ {
			ghosts[i] = seq_nodes[ghosts[i]]
		}
	}

	// Calculate distances
	var ghost_distances [][]int
	var cycle_lengths []int
	for i := 0; i < len(ghosts); i++ {
		var distances []int

		start := ghosts[i]
		ghost := seq_nodes[ghosts[i]]

		if ghost == start {
			distances = append(distances, 0)
		}

		k := 1
		for ghost != start {
			if ghost[2] == 'Z' {
				distances = append(distances, k)
			}
			k += 1
			ghost = seq_nodes[ghost]
		}
		cycle_lengths = append(cycle_lengths, k)
		ghost_distances = append(ghost_distances, distances)
	}

	// Print distances
	for i := 0; i < len(ghost_distances); i++ {
		fmt.Println(cycle_lengths[i], ghost_distances[i])
	}

	// Initialize result
	result := 0

	fmt.Println(result * len(seq))
}
