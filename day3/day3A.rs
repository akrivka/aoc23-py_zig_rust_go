/* Plan:
represent schematic as a 2d array
loop over all positions and if position is number
    "look around" */

use std::fs;

fn main() {
    let schematic_string = fs::read_to_string("input").expect("Not able to read");
    let schematic: Vec<Vec<char>> = schematic_string
        .split("\n")
        .map(|s| s.chars().collect())
        .collect();
    let width = schematic[0].len();
    let height = schematic.len();

	let mut result = 0usize;

    let mut x;
    let mut y = 0;
    while y < height {
		x = 0;
        while x < width {
            if schematic[y][x].is_digit(10) {
                let xstart = x;
                while x < width && schematic[y][x].is_digit(10) {
                    x += 1;
                }
                let xend = x;

                // "Look around"
				let mut included = false;
                'outer: for yp in [if y > 0 { y-1 } else { height }, y, y+1] {
					'inner: for xp in (if xstart > 0 { xstart-1 } else { xstart })..(xend+1) {
						if (yp == y && xp >= xstart && xp < xend) ||
							(yp >= height) || (xp >= width) {
							continue 'inner;
						}
						else if schematic[yp][xp] != '.' { 
							included = true;
							break 'outer;
						}
					}
				}

            	// Parse part number
				if included {
					let part_number: String = schematic[y][xstart..xend]
						.into_iter()
						.collect();
					result += part_number.parse::<usize>().unwrap();
				}
            } else {
                x += 1;
            }
        }
        y += 1;
    }

	println!("{}", result);
}
