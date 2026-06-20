//
// Natural Order String Comparison Algorithm
// 
// An advanced strnatcmp algorithm with fixed-point support
// 
// Based on:
// - Martin Pool's Natural Order String Comparison (https://github.com/sourcefrog/natsort)
// - Tachibana Shin's fixed-point implementation
// 
// License: GNU GPL v3
//

import Foundation

public class NatordPlus {
    /// Determine if a character is a digit
    private static func isDigit(_ c: Character) -> Bool {
        return c >= "0" && c <= "9"
    }
    
    /// Determine if a character is whitespace
    private static func isSpace(_ c: Character) -> Bool {
        return c == " " || c == "\t" || c == "\r" || c == "\n"
    }
    
    /// Compare left (for fractional numbers starting with 0)
    private static func compareLeft(
        _ a: [Character],
        _ b: [Character],
        _ ai: inout Int,
        _ bi: inout Int
    ) -> Int {
        while true {
            let ca = ai < a.count ? a[ai] : "\0"
            let cb = bi < b.count ? b[bi] : "\0"
            let da = isDigit(ca)
            let db = isDigit(cb)
            
            if !da && !db { return 0 }
            if !da { return -1 }
            if !db { return 1 }
            
            if ca < cb { return -1 }
            if ca > cb { return 1 }
            
            ai += 1
            bi += 1
        }
    }
    
    /// Compare right (for normal integer numbers)
    private static func compareRight(
        _ a: [Character],
        _ b: [Character],
        _ ai: inout Int,
        _ bi: inout Int
    ) -> Int {
        var bias = 0
        while true {
            let ca = ai < a.count ? a[ai] : "\0"
            let cb = bi < b.count ? b[bi] : "\0"
            let da = isDigit(ca)
            let db = isDigit(cb)
            
            if !da && !db { return bias }
            if !da { return -1 }
            if !db { return 1 }
            
            if ca < cb {
                if bias == 0 { bias = -1 }
            } else if ca > cb {
                if bias == 0 { bias = 1 }
            }
            
            ai += 1
            bi += 1
        }
    }
    
    /// Natural order string comparison
    /// - Parameters:
    ///   - a: First string to compare
    ///   - b: Second string to compare
    ///   - ignoreCase: Whether to ignore case differences
    /// - Returns: Negative if a < b, 0 if a == b, positive if a > b
    public static func natord(
        _ a: String,
        _ b: String,
        ignoreCase: Bool = false
    ) -> Int {
        let aChars = Array(a)
        let bChars = Array(b)
        var ai = 0
        var bi = 0
        let lenA = aChars.count
        let lenB = bChars.count
        var afterDigit = false
        
        while true {
            var ca = ai < lenA ? aChars[ai] : "\0"
            var cb = bi < lenB ? bChars[bi] : "\0"
            
            // Skip spaces
            while ai < lenA && isSpace(ca) {
                ai += 1
                ca = ai < lenA ? aChars[ai] : "\0"
            }
            while bi < lenB && isSpace(cb) {
                bi += 1
                cb = bi < lenB ? bChars[bi] : "\0"
            }
            
            // Both are digits
            if isDigit(ca) && isDigit(cb) {
                let fractional: Int
                if ca == "0" || cb == "0" {
                    fractional = compareLeft(aChars, bChars, &ai, &bi)
                } else {
                    fractional = compareRight(aChars, bChars, &ai, &bi)
                }
                if fractional != 0 { return fractional }
                afterDigit = true
            } else {
                // Handle non-digit characters
                if ca == "\0" && cb == "\0" { return 0 }
                if ca == "\0" { return -1 }
                if cb == "\0" { return 1 }
                
                // Fix floating point handling
                if afterDigit {
                    if ca == "." && cb != "." && ai + 1 < lenA && isDigit(aChars[ai + 1]) {
                        return 1
                    } else if cb == "." && ca != "." && bi + 1 < lenB && isDigit(bChars[bi + 1]) {
                        return -1
                    }
                }
                
                var charA = ca
                var charB = cb
                if ignoreCase {
                    charA = charA.lowercased().first ?? "\0"
                    charB = charB.lowercased().first ?? "\0"
                }
                
                if charA < charB { return -1 }
                if charA > charB { return 1 }
                
                ai += 1
                bi += 1
                afterDigit = false
            }
        }
    }
}

// MARK: - Comparable Extension
extension String {
    /// Compare with another string using natural order
    public func naturalCompare(with other: String, ignoreCase: Bool = false) -> ComparisonResult {
        let result = NatordPlus.natord(self, other, ignoreCase: ignoreCase)
        if result < 0 {
            return .orderedAscending
        } else if result > 0 {
            return .orderedDescending
        } else {
            return .orderedSame
        }
    }
}
