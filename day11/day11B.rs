use std::convert::TryInto;
use std::fs;

fn main() {
    let mut data: Vec<Vec<char>> = Vec::new();

	// Read input
    for line in fs::read_to_string("input").unwrap().lines() {
        data.push(line.chars().collect());
    }
	let expansion_rate = 1000000;

	// Find all empty rows and columns
	let mut empty_rows: Vec<i64> = Vec::new();
	// Rows
	for i in 0..data.len() {
		let row = &data[i];
		if row.iter().all(|x| *x == '.') {
			empty_rows.push(i.try_into().unwrap());
		}
	}

	// Columns
	let mut empty_cols: Vec<i64> = Vec::new();
	'outer: for j in 0..data[0].len() {
		// Check if all equal .
		for row in &data {
			// If not continue to next column
			if row[j] != '.' {
				continue 'outer;
			}
		}
		// If yes, store
		empty_cols.push(j.try_into().unwrap());
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
			let g1 = galaxies[i];
			let g2 = galaxies[j];

			let ai = std::cmp::min(g1[0], g2[0]);
			let aj = std::cmp::min(g1[1], g2[1]);
			let bi = std::cmp::max(g1[0], g2[0]);
			let bj = std::cmp::max(g1[1], g2[1]);

			// Add raw distances
			result += (bi - ai) + (bj - aj);

			// Check for expanded rows
			for r in &empty_rows {
				if *r > ai && *r < bi {
					result += expansion_rate - 1;
				}
			}

			// Check for expanded cols
			for c in &empty_cols {
				if *c > aj && *c < bj {
					result += expansion_rate - 1;
				}
			}
		}
	}

	println!("{}", result);
}
