use std::fs;

#[derive(Clone)]
struct LightPresence {
    up: bool,
    down: bool,
    left: bool,
    right: bool,
}

#[derive(PartialEq)]
enum Dir {
    Up,
    Down,
    Left,
    Right,
}

struct LightHead {
    row: isize,
    col: isize,
    dir: Dir,
}

fn main() {
    let mut grid: Vec<Vec<char>> = Vec::new();

    // Read input
    for line in fs::read_to_string("input").unwrap().lines() {
        grid.push(line.chars().collect());
    }

    let num_rows = grid.len();
    let num_cols = grid[0].len();

    let mut light_presences: Vec<Vec<LightPresence>> = Vec::new();
    for row in &grid {
        light_presences.push(vec![
            LightPresence {
                up: false,
                down: false,
                left: false,
                right: false
            };
            row.len()
        ]);
    }

    let mut light_heads: Vec<LightHead> = vec![LightHead {
        row: 0,
        col: 0,
        dir: Dir::Right,
    }];

    loop {
        if light_heads.len() == 0 {
            break;
        }

        // Check current pos
		let num_heads = light_heads.len();
		let mut to_remove: Vec<usize> = Vec::new();
        for i in 0..num_heads {
			let head = &mut light_heads[i];
			// Check if outside grid
			if head.row < 0 || head.row >= (num_rows as isize) || head.col < 0 || head.col >= (num_cols as isize) {
				to_remove.push(i);
				continue;
			}

			// Get row and col as usize
			let row = head.row as usize;
			let col = head.col as usize;

			// Check if light already present here
			if match head.dir {
				Dir::Up => light_presences[row][col].up,
				Dir::Down => light_presences[row][col].down,
				Dir::Left => light_presences[row][col].left,
				Dir::Right => light_presences[row][col].right,
			} {
				to_remove.push(i);
				continue;
            // Else update light presences
			} else { 
                match head.dir {
                    Dir::Up => light_presences[head.row as usize][head.col as usize].up = true,
                    Dir::Left => light_presences[head.row as usize][head.col as usize].left = true,
                    Dir::Right => light_presences[head.row as usize][head.col as usize].right = true,
                    Dir::Down => light_presences[head.row as usize][head.col as usize].down = true,
                };    
            }

			// Act upon current tile
            match grid[row][col] {
                '/' => {
                    head.dir = match head.dir {
                        Dir::Up => Dir::Right,
                        Dir::Left => Dir::Down,
                        Dir::Right => Dir::Up,
                        Dir::Down => Dir::Left,
                    };
                }
                '\\' => {
                    head.dir = match head.dir {
                        Dir::Up => Dir::Left,
                        Dir::Left => Dir::Up,
                        Dir::Right => Dir::Down,
                        Dir::Down => Dir::Right,
                    };
                }
                '|' => {
                    if head.dir == Dir::Right || head.dir == Dir::Left {
                        // Deflect this light up
                        head.dir = Dir::Up;

                        // Create a new light going down
                        light_heads.push(LightHead {
                            row: row as isize,
                            col: col as isize,
                            dir: Dir::Down,
                        });
                    }
                }
                '-' => {
                    if head.dir == Dir::Up || head.dir == Dir::Down {
                        // Deflect this light left
                        head.dir = Dir::Left;

                        // Create a new light going right
                        light_heads.push(LightHead {
                            row: row as isize,
                            col: col as isize,
                            dir: Dir::Right,
                        });
                    }
                }
                '.' => {}
                _ => return println!("Invalid character"),
            }
        }

		// Remove lights that overlap with another light
		for i in to_remove.iter().rev() {
			light_heads.remove(*i);
		}

        // Move all heads
        for head in &mut light_heads {
            match head.dir {
                Dir::Up => {
                    head.row -= 1;
                }
                Dir::Down => {
                    head.row += 1;
                }
                Dir::Left => {
                    head.col -= 1;
                }
                Dir::Right => {
                    head.col += 1;
                }
            }
        }
    }

	let mut num_energized: usize = 0;
    for row in &light_presences {
        for lp in row {
            if lp.up || lp.down || lp.left || lp.right {
				num_energized += 1;
                print!("#");
            } else {
                print!(".");
            }
        }
        print!("\n");
    }
	println!("{}", num_energized);
}
