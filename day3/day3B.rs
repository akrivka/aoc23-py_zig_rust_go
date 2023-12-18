// JANKYYYYY

/* Plan:
represent schematic as a 2d array
keep an array of numbers for each position, call it "gears", initialized to 0
loop over all positions and if position is number
    see if it is neighboring to a gear "*"
		if yes and the corresponding position in gears is
			0
				add the part number
			positive 
				multiply with it and make negative 
			smaller than -1 
				make it -1 */

use std::fs;

fn main() {
    let schematic_string = fs::read_to_string("input").expect("Not able to read");
    let schematic: Vec<Vec<char>> = schematic_string
        .split("\n")
        .map(|s| s.chars().collect())
        .collect();
    let width = schematic[0].len();
    let height = schematic.len();

	// Initialize gears array
	let mut gears: Vec<Vec<i32>> = vec![vec![0; width]; height];

	let mut result = 0;

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
				let mut next_to_gear = false;
				let mut gx = 0;
				let mut gy = 0;
                'outer: for yp in [if y > 0 { y-1 } else { height }, y, y+1] {
					'inner: for xp in (if xstart > 0 { xstart-1 } else { xstart })..(xend+1) {
						if (yp == y && xp >= xstart && xp < xend) ||
							(yp >= height) || (xp >= width) {
							continue 'inner;
						}
						else if schematic[yp][xp] == '*' { 
							next_to_gear = true;
							gx = xp;
							gy = yp;
							break 'outer;
						}
					}
				}

            	// Parse part number
				if next_to_gear {
					let part_number = schematic[y][xstart..xend]
					.into_iter()
					.collect::<String>()
					.parse::<i32>()
					.unwrap();

					gears[gy][gx] = if gears[gy][gx] < 0 { -1 } // More than three gears
									else if gears[gy][gx] == 0 { part_number } // First part
									else { -gears[gy][gx] * part_number } // Second part
				}
            } else {
                x += 1;
            }
        }
        y += 1;
    }

	for y in 0..height {
		for x in 0..width {
			if gears[y][x] < -1 {
				result += -gears[y][x];
			}
		}
	}

	println!("{}", result);
}
