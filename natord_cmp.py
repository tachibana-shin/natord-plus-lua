def natord(ignore_case=True):
    '''
    Return a sort key function that implements natural order comparison
    based on the Lua natord algorithm.
    '''
    from functools import cmp_to_key

    def is_digit(c):
        return '0' <= c <= '9'

    def is_space(c):
        return c in ' \t\r\n'

    def compare_left(a, b, ai, bi):
        while True:
            ca = a[ai] if ai < len(a) else ''
            cb = b[bi] if bi < len(b) else ''
            da = is_digit(ca)
            db = is_digit(cb)
            if not da and not db:
                return 0, ai, bi
            if not da:
                return -1, ai, bi
            if not db:
                return 1, ai, bi
            if ca < cb:
                return -1, ai, bi
            if ca > cb:
                return 1, ai, bi
            ai += 1
            bi += 1

    def compare_right(a, b, ai, bi):
        bias = 0
        while True:
            ca = a[ai] if ai < len(a) else ''
            cb = b[bi] if bi < len(b) else ''
            da = is_digit(ca)
            db = is_digit(cb)
            if not da and not db:
                return bias, ai, bi
            if not da:
                return -1, ai, bi
            if not db:
                return 1, ai, bi
            if ca < cb:
                if bias == 0:
                    bias = -1
            elif ca > cb:
                if bias == 0:
                    bias = 1
            ai += 1
            bi += 1

    def natord(a, b):
        ai = bi = 0
        lenA, lenB = len(a), len(b)
        after_digit = False
        while True:
            ca = a[ai] if ai < lenA else ''
            cb = b[bi] if bi < lenB else ''

            while ai < lenA and is_space(ca):
                ai += 1
                ca = a[ai] if ai < lenA else ''
            while bi < lenB and is_space(cb):
                bi += 1
                cb = b[bi] if bi < lenB else ''

            if is_digit(ca) and is_digit(cb):
                if ca == '0' or cb == '0':
                    fractional, ai, bi = compare_left(a, b, ai, bi)
                else:
                    fractional, ai, bi = compare_right(a, b, ai, bi)
                if fractional != 0:
                    return fractional
                after_digit = True
            else:
                if ca == '' and cb == '':
                    return 0
                if ca == '':
                    return -1
                if cb == '':
                    return 1

                if after_digit:
                    if ca == '.' and cb != '.' and ai + 1 < lenA and is_digit(a[ai + 1]):
                        return 1
                    if cb == '.' and ca != '.' and bi + 1 < lenB and is_digit(b[bi + 1]):
                        return -1

                if ignore_case:
                    ca = ca.lower()
                    cb = cb.lower()

                if ca < cb:
                    return -1
                if ca > cb:
                    return 1

                ai += 1
                bi += 1
                after_digit = False

    return cmp_to_key(natord)

