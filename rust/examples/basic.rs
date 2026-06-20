use natord_plus::natord;
use std::cmp::Ordering;

fn main() {
    let items = vec![
        "Vol 10: The End",
        "Vol 23 Reverse",
        "Vol 02: Special Edition",
        "vol 3.1415: PI",
        "Chapter 3.12",
        "Vol 2: The Beginning",
    ];

    let mut sorted = items.clone();
    sorted.sort_by(|a, b| natord(a, b, true));

    println!("Sorted by natural order:");
    for item in sorted {
        println!("  {}", item);
    }
}
