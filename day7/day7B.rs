use std::convert::TryInto;
use std::fs;

struct Hand {
    cards: [u8; 5],
    bid: i64,
}

const CARD_ORDER: &[u8] = "J23456789TQKA".as_bytes();

const TYPE_HIGH: i64 = 0;
const TYPE_ONE_PAIR: i64 = 1;
const TYPE_TWO_PAIRS: i64 = 2;
const TYPE_THREE_OF_KIND: i64 = 3;
const TYPE_FULL_HOUSE: i64 = 4;
const TYPE_FOUR_OF_KIND: i64 = 5;
const TYPE_FIVE_OF_KIND: i64 = 6;

fn get_order(card: u8) -> usize {
    let mut i: usize = 0;
    while i < 13 {
        if CARD_ORDER[i] == card {
            return i;
        } else {
			i += 1;
            continue;
        }
    }
	println!("here");
	1000
}

fn card_freq(cards: [u8; 5]) -> [i64; 13] {
    let mut freqs: [i64; 13] = [0; 13];
    for card in cards {
        freqs[get_order(card)] += 1;
    }
    freqs
}

fn hand_key(hand: &Hand) -> i64 {
    let mut freqs = card_freq(hand.cards);
	let num_joker = freqs[get_order(b'J')];
	freqs[get_order(b'J')] = 0;
	freqs.sort();
	freqs.reverse();
	
	let num_joker0 = std::cmp::min(5 - freqs[0], num_joker);
	freqs[0] += num_joker0;
	freqs[1] += num_joker - num_joker0;

    let hand_type = if freqs[0] == 5 {
        TYPE_FIVE_OF_KIND
    } else if freqs[0] == 4 {
        TYPE_FOUR_OF_KIND
    } else if freqs[0] == 3 && freqs[1] == 2 {
        TYPE_FULL_HOUSE
    } else if freqs[0] == 3 {
        TYPE_THREE_OF_KIND
    } else if freqs[0] == 2 && freqs[1] == 2 {
        TYPE_TWO_PAIRS
    } else if freqs[0] == 2 {
        TYPE_ONE_PAIR
    } else {
        TYPE_HIGH
    };

	let mut key: i64 = 0;
	let mut i: usize = 0;
	let mut m: i64 = 1;
	while i < 5 {
		key += (get_order(hand.cards[4-i]) as i64) * m;
		i += 1;
		m *= 13;
	}

	key += hand_type * m;

	println!("hand {} type {} key {}", std::str::from_utf8(&hand.cards).unwrap(), hand_type, key);

	key
}

fn wtf(v: &Vec<Hand>) -> usize {
	v.len()
}

fn main() {
    let mut hands: Vec<Hand> = Vec::new();

    for line in fs::read_to_string("input").unwrap().lines() {
        let parts: Vec<&str> = line.split(" ").collect();
        let hand = Hand {
            cards: parts[0].as_bytes().try_into().unwrap(),
            bid: parts[1].parse::<i64>().unwrap(),
        };
        hands.push(hand);
    }


	// Sort from smallest to highest
    hands.sort_by(|a, b| hand_key(a).partial_cmp(&hand_key(b)).unwrap());
	let mut rank: i64 = 1;
	let mut result: i64 = 0;
	for hand in &hands {
		println!("{} {} {}", std::str::from_utf8(&hand.cards).unwrap(), hand.bid, rank);
		result += rank * hand.bid;
		rank += 1;
	};

	println!("{}", result);
}
