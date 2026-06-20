//! Natural Order String Comparison Algorithm
//! 
//! An advanced strnatcmp algorithm with fixed-point support
//! 
//! Based on:
//! - Martin Pool's Natural Order String Comparison (https://github.com/sourcefrog/natsort)
//! - Tachibana Shin's fixed-point implementation
//! 
//! License: GNU GPL v3

use std::cmp::Ordering;

fn is_digit(c: u8) -> bool {
    c >= b'0' && c <= b'9'
}

fn is_space(c: u8) -> bool {
    c == b' ' || c == b'\t' || c == b'\r' || c == b'\n'
}

/// Compare left (for fractional numbers starting with 0)
fn compare_left(a: &[u8], b: &[u8], mut ai: usize, mut bi: usize) -> (Ordering, usize, usize) {
    loop {
        let ca = if ai < a.len() { a[ai] } else { 0 };
        let cb = if bi < b.len() { b[bi] } else { 0 };
        let da = is_digit(ca);
        let db = is_digit(cb);

        if !da && !db {
            return (Ordering::Equal, ai, bi);
        }
        if !da {
            return (Ordering::Less, ai, bi);
        }
        if !db {
            return (Ordering::Greater, ai, bi);
        }

        if ca < cb {
            return (Ordering::Less, ai, bi);
        }
        if ca > cb {
            return (Ordering::Greater, ai, bi);
        }

        ai += 1;
        bi += 1;
    }
}

/// Compare right (for normal integer numbers)
fn compare_right(a: &[u8], b: &[u8], mut ai: usize, mut bi: usize) -> (Ordering, usize, usize) {
    let mut bias = Ordering::Equal;
    loop {
        let ca = if ai < a.len() { a[ai] } else { 0 };
        let cb = if bi < b.len() { b[bi] } else { 0 };
        let da = is_digit(ca);
        let db = is_digit(cb);

        if !da && !db {
            return (bias, ai, bi);
        }
        if !da {
            return (Ordering::Less, ai, bi);
        }
        if !db {
            return (Ordering::Greater, ai, bi);
        }

        if ca < cb {
            if bias == Ordering::Equal {
                bias = Ordering::Less;
            }
        } else if ca > cb {
            if bias == Ordering::Equal {
                bias = Ordering::Greater;
            }
        }

        ai += 1;
        bi += 1;
    }
}

/// Natural order string comparison
/// 
/// # Arguments
/// * `a` - First string to compare
/// * `b` - Second string to compare
/// * `ignore_case` - Whether to ignore case differences
/// 
/// # Returns
/// `Ordering` indicating the relationship between a and b
pub fn natord(a: &str, b: &str, ignore_case: bool) -> Ordering {
    let a_bytes = a.as_bytes();
    let b_bytes = b.as_bytes();
    let mut ai = 0;
    let mut bi = 0;
    let len_a = a_bytes.len();
    let len_b = b_bytes.len();
    let mut after_digit = false;

    loop {
        let mut ca = if ai < len_a { a_bytes[ai] } else { 0 };
        let mut cb = if bi < len_b { b_bytes[bi] } else { 0 };

        // Skip spaces
        while ai < len_a && is_space(ca) {
            ai += 1;
            ca = if ai < len_a { a_bytes[ai] } else { 0 };
        }
        while bi < len_b && is_space(cb) {
            bi += 1;
            cb = if bi < len_b { b_bytes[bi] } else { 0 };
        }

        // Both are digits
        if is_digit(ca) && is_digit(cb) {
            let (fractional, new_ai, new_bi) = if ca == b'0' || cb == b'0' {
                compare_left(a_bytes, b_bytes, ai, bi)
            } else {
                compare_right(a_bytes, b_bytes, ai, bi)
            };
            ai = new_ai;
            bi = new_bi;
            if fractional != Ordering::Equal {
                return fractional;
            }
            after_digit = true;
        } else {
            // Handle non-digit characters
            if ca == 0 && cb == 0 {
                return Ordering::Equal;
            }
            if ca == 0 {
                return Ordering::Less;
            }
            if cb == 0 {
                return Ordering::Greater;
            }

            // Fix floating point handling
            if after_digit {
                if ca == b'.' && cb != b'.' && ai + 1 < len_a && is_digit(a_bytes[ai + 1]) {
                    return Ordering::Greater; // B ended first
                } else if cb == b'.' && ca != b'.' && bi + 1 < len_b && is_digit(b_bytes[bi + 1]) {
                    return Ordering::Less; // A ended first
                }
            }

            let mut char_a = ca;
            let mut char_b = cb;
            if ignore_case {
                if char_a >= b'A' && char_a <= b'Z' {
                    char_a += 32;
                }
                if char_b >= b'A' && char_b <= b'Z' {
                    char_b += 32;
                }
            }

            if char_a < char_b {
                return Ordering::Less;
            }
            if char_a > char_b {
                return Ordering::Greater;
            }

            ai += 1;
            bi += 1;
            after_digit = false;
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_basic_comparison() {
        assert_eq!(natord("a", "b", false), Ordering::Less);
        assert_eq!(natord("b", "a", false), Ordering::Greater);
        assert_eq!(natord("a", "a", false), Ordering::Equal);
    }

    #[test]
    fn test_numeric_comparison() {
        assert_eq!(natord("a1", "a2", false), Ordering::Less);
        assert_eq!(natord("a10", "a2", false), Ordering::Greater);
        assert_eq!(natord("a2", "a10", false), Ordering::Less);
    }

    #[test]
    fn test_fractional_numbers() {
        assert_eq!(natord("3", "3.14", false), Ordering::Less);
        assert_eq!(natord("3.14", "3", false), Ordering::Greater);
    }
}
