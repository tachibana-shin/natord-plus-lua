local expected_results = {
    "Chapter 3.014",
    "Chapter 3.12",
    "Hacking Digest v2",
    "Hacking Digest v99999999999999999999",
    "Vol 002: Ultra Rare",
    "Vol 02: Special Edition",
    "Vol 1: Prologue",
    "Vol   2: Extra Spaces",
    "vol 2: Lowercase Title",
    "Vol 2: The Beginning",
    "vol 3: Shin",
    "vol 3.1415: PI",
    "Vol 10: The End",
    "Vol 23",
    "Vol 23 Reverse"
}

local natord = require("natord.lua")
local function sortBooksNatord(books, order)
    order = (order and order:lower() == "desc") and "desc" or "asc"
    table.sort(books, function(bookA, bookB)
        local result = natord(bookA.name, bookB.name, true)
        return order == "desc" and result > 0 or result < 0
    end)
    return books
end

print("[INFO] Running sortBooksNatord test...")
sortBooksNatord(unbooks)

local all_passed = true

for i = 1, #expected_results do
    local actual = unbooks[i] and unbooks[i].name or "NIL (Missing item)"
    local expected = expected_results[i]
    
    if actual == expected then
        print(string.format("[ OK ] %02d: %s", i, actual))
    else
        all_passed = false
        print(string.format("[FAIL] Index %02d has a mismatch!", i))
        print(string.format("       -> Expected: %s", expected))
        print(string.format("       -> Actual:   %s", actual))
    end
end

print("\n==================================================")
if all_passed then
    print("[STATUS] TEST PASSED! Algorithm is 100% accurate.")
else
    print("[STATUS] TEST FAILED! Please check the number segmentation logic.")
end
print("==================================================")
