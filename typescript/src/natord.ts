/**
 * Natural Order String Comparison Algorithm
 * An advanced strnatcmp algorithm with fixed-point support
 * 
 * Based on:
 * - Martin Pool's Natural Order String Comparison (https://github.com/sourcefrog/natsort)
 * - Tachibana Shin's fixed-point implementation
 * 
 * License: GNU GPL v3
 */

function isDigit(c: string): boolean {
    return c >= '0' && c <= '9';
}

function isSpace(c: string): boolean {
    return c === ' ' || c === '\t' || c === '\r' || c === '\n';
}

/**
 * Compare left (for fractional numbers starting with 0)
 */
function compareLeft(a: string, b: string, ai: number, bi: number): [number, number, number] {
    while (true) {
        const ca = a[ai] || '';
        const cb = b[bi] || '';
        const da = isDigit(ca);
        const db = isDigit(cb);

        if (!da && !db) return [0, ai, bi];
        if (!da) return [-1, ai, bi];
        if (!db) return [1, ai, bi];

        if (ca < cb) return [-1, ai, bi];
        if (ca > cb) return [1, ai, bi];

        ai++;
        bi++;
    }
}

/**
 * Compare right (for normal integer numbers)
 */
function compareRight(a: string, b: string, ai: number, bi: number): [number, number, number] {
    let bias = 0;
    while (true) {
        const ca = a[ai] || '';
        const cb = b[bi] || '';
        const da = isDigit(ca);
        const db = isDigit(cb);

        if (!da && !db) return [bias, ai, bi];
        if (!da) return [-1, ai, bi];
        if (!db) return [1, ai, bi];

        if (ca < cb) {
            if (bias === 0) bias = -1;
        } else if (ca > cb) {
            if (bias === 0) bias = 1;
        }

        ai++;
        bi++;
    }
}

/**
 * Natural order string comparison
 * @param a First string to compare
 * @param b Second string to compare
 * @param ignoreCase Whether to ignore case differences
 * @returns Negative if a < b, 0 if a === b, positive if a > b
 */
export function natord(a: string, b: string, ignoreCase: boolean = false): number {
    let ai = 0;
    let bi = 0;
    const lenA = a.length;
    const lenB = b.length;
    let afterDigit = false;

    while (true) {
        let ca = a[ai] || '';
        let cb = b[bi] || '';

        // Skip spaces
        while (ai < lenA && isSpace(ca)) {
            ai++;
            ca = a[ai] || '';
        }
        while (bi < lenB && isSpace(cb)) {
            bi++;
            cb = b[bi] || '';
        }

        // Both are digits
        if (isDigit(ca) && isDigit(cb)) {
            let fractional: number;
            if (ca === '0' || cb === '0') {
                [fractional, ai, bi] = compareLeft(a, b, ai, bi);
            } else {
                [fractional, ai, bi] = compareRight(a, b, ai, bi);
            }
            if (fractional !== 0) return fractional;
            afterDigit = true;
        } else {
            // Handle non-digit characters
            if (!ca && !cb) return 0;
            if (!ca) return -1;
            if (!cb) return 1;

            // Fix floating point handling
            if (afterDigit) {
                if (ca === '.' && cb !== '.' && isDigit(a[ai + 1] || '')) {
                    return 1; // B ended first, B < A
                } else if (cb === '.' && ca !== '.' && isDigit(b[bi + 1] || '')) {
                    return -1; // A ended first, A < B
                }
            }

            let charA = ca;
            let charB = cb;
            if (ignoreCase) {
                charA = ca.toLowerCase();
                charB = cb.toLowerCase();
            }

            if (charA < charB) return -1;
            if (charA > charB) return 1;

            ai++;
            bi++;
            afterDigit = false;
        }
    }
}

/**
 * Create a comparator function for use with Array.sort()
 */
export function createNatordComparator(ignoreCase: boolean = false): (a: string, b: string) => number {
    return (a: string, b: string) => natord(a, b, ignoreCase);
}

export default natord;
