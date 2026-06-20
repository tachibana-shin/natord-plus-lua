/**
 * Natural Order String Comparison Algorithm
 * 
 * An advanced strnatcmp algorithm with fixed-point support
 * 
 * Based on:
 * - Martin Pool's Natural Order String Comparison (https://github.com/sourcefrog/natsort)
 * - Tachibana Shin's fixed-point implementation
 * 
 * License: GNU GPL v3
 */

package dev.tachibana.natord

object NatordPlus {
    private fun isDigit(c: Char): Boolean {
        return c in '0'..'9'
    }

    private fun isSpace(c: Char): Boolean {
        return c == ' ' || c == '\t' || c == '\r' || c == '\n'
    }

    /**
     * Compare left (for fractional numbers starting with 0)
     */
    private fun compareLeft(
        a: String,
        b: String,
        ai: Int,
        bi: Int
    ): Triple<Int, Int, Int> {
        var i = ai
        var j = bi
        while (true) {
            val ca = if (i < a.length) a[i] else '\u0000'
            val cb = if (j < b.length) b[j] else '\u0000'
            val da = isDigit(ca)
            val db = isDigit(cb)

            if (!da && !db) return Triple(0, i, j)
            if (!da) return Triple(-1, i, j)
            if (!db) return Triple(1, i, j)

            if (ca < cb) return Triple(-1, i, j)
            if (ca > cb) return Triple(1, i, j)

            i++
            j++
        }
    }

    /**
     * Compare right (for normal integer numbers)
     */
    private fun compareRight(
        a: String,
        b: String,
        ai: Int,
        bi: Int
    ): Triple<Int, Int, Int> {
        var bias = 0
        var i = ai
        var j = bi
        while (true) {
            val ca = if (i < a.length) a[i] else '\u0000'
            val cb = if (j < b.length) b[j] else '\u0000'
            val da = isDigit(ca)
            val db = isDigit(cb)

            if (!da && !db) return Triple(bias, i, j)
            if (!da) return Triple(-1, i, j)
            if (!db) return Triple(1, i, j)

            if (ca < cb) {
                if (bias == 0) bias = -1
            } else if (ca > cb) {
                if (bias == 0) bias = 1
            }

            i++
            j++
        }
    }

    /**
     * Natural order string comparison
     * @param a First string to compare
     * @param b Second string to compare
     * @param ignoreCase Whether to ignore case differences
     * @return Negative if a < b, 0 if a == b, positive if a > b
     */
    fun natord(a: String, b: String, ignoreCase: Boolean = false): Int {
        var ai = 0
        var bi = 0
        val lenA = a.length
        val lenB = b.length
        var afterDigit = false

        while (true) {
            var ca = if (ai < lenA) a[ai] else '\u0000'
            var cb = if (bi < lenB) b[bi] else '\u0000'

            // Skip spaces
            while (ai < lenA && isSpace(ca)) {
                ai++
                ca = if (ai < lenA) a[ai] else '\u0000'
            }
            while (bi < lenB && isSpace(cb)) {
                bi++
                cb = if (bi < lenB) b[bi] else '\u0000'
            }

            // Both are digits
            if (isDigit(ca) && isDigit(cb)) {
                val (fractional, newAi, newBi) = if (ca == '0' || cb == '0') {
                    compareLeft(a, b, ai, bi)
                } else {
                    compareRight(a, b, ai, bi)
                }
                ai = newAi
                bi = newBi
                if (fractional != 0) return fractional
                afterDigit = true
            } else {
                // Handle non-digit characters
                if (ca == '\u0000' && cb == '\u0000') return 0
                if (ca == '\u0000') return -1
                if (cb == '\u0000') return 1

                // Fix floating point handling
                if (afterDigit) {
                    if (ca == '.' && cb != '.' && ai + 1 < lenA && isDigit(a[ai + 1])) {
                        return 1  // B ended first
                    } else if (cb == '.' && ca != '.' && bi + 1 < lenB && isDigit(b[bi + 1])) {
                        return -1  // A ended first
                    }
                }

                var charA = ca
                var charB = cb
                if (ignoreCase) {
                    charA = charA.lowercaseChar()
                    charB = charB.lowercaseChar()
                }

                if (charA < charB) return -1
                if (charA > charB) return 1

                ai++
                bi++
                afterDigit = false
            }
        }
    }

    /**
     * Create a comparator function for use with sorting
     */
    fun createComparator(ignoreCase: Boolean = false): Comparator<String> {
        return Comparator { a, b -> natord(a, b, ignoreCase) }
    }
}

// Extension function for easy usage
fun String.natordCompare(other: String, ignoreCase: Boolean = false): Int {
    return NatordPlus.natord(this, other, ignoreCase)
}
