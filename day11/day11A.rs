use std::convert::TryInto;
use std::fs;

fn main() {
    let mut data: Vec<Vec<char>> = Vec::new();

	// Read input
    for line in fs::read_to_string("input").unwrap().lines() {
        data.push(line.chars().collect());
    }

	// Expand
	// Rows
	let mut i = 0;
	while i < data.len() {
		let row = &data[i];
		if row.iter().all(|x| *x == '.') {
			data.insert(i, row.to_vec());
			i += 1;
		}
		i += 1;
	}

	// Columns
	let mut j = 0;
	'outer: while j < data[0].len() {
		// Check if all equal .
		for row in &data {
			// If not continue to next column
			if row[j] != '.' {
				j += 1;
				continue 'outer;
			}
		}
		// If yes clone
		for row in &mut data {
			row.insert(j, '.');
		}
		j += 2;
	}

	// Find all locations of galaxies
	let mut galaxies: Vec<[i64; 2]> = Vec::new();
	for i in 0..data.len() {
		for j in 0..data[0].len() {
			if data[i][j] == '#' {
				galaxies.push([i.try_into().unwrap(), j.try_into().unwrap()]);
			}
		}
	}

	// Find sum of distances
	let mut result: i64 = 0;
	for i in 0..galaxies.len() {
		for j in (i+1)..galaxies.len() {
			result += (galaxies[i][0] - galaxies[j][0]).abs() + (galaxies[i][1] - galaxies[j][1]).abs();
		}
	}

	println!("{}", result);
}
