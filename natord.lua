-- @param c string
-- @return boolean
local function is_digit(c)
    return c >= "0" and c <= "9"
end

-- @param c string
-- @return boolean
local function is_space(c)
    return c == " " or c == "\t" or c == "\r" or c == "\n"
end

-- >> LEFT for group string first equal 0 (Fractional)
-- @param a string
-- @param b string
-- @param ai number
-- @param bi number
local function compare_left(a, b, ai, bi)
    while true do
        local ca = a:sub(ai, ai)
        local cb = b:sub(bi, bi)
        local da = is_digit(ca)
        local db = is_digit(cb)
        
        if not da and not db then return 0, ai, bi end
        if not da then return -1, ai, bi end
        if not db then return 1, ai, bi end
        
        if ca < cb then return -1, ai, bi end
        if ca > cb then return 1, ai, bi end
        
        ai = ai + 1
        bi = bi + 1
    end
end

-- << RIGHT for normal group string (Pure Integer)
-- @param a string
-- @param b string
-- @param ai number
-- @param bi number
local function compare_right(a, b, ai, bi)
    local bias = 0
    while true do
        local ca = a:sub(ai, ai)
        local cb = b:sub(bi, bi)
        local da = is_digit(ca)
        local db = is_digit(cb)
        
        if not da and not db then return bias, ai, bi end
        if not da then return -1, ai, bi end
        if not db then return 1, ai, bi end
        
        if ca < cb then
            if bias == 0 then bias = -1 end
        elseif ca > cb then
            if bias == 0 then bias = 1 end
        end
        
        ai = ai + 1
        bi = bi + 1
    end
end

-- active function upgrade state (after_digit)
-- @param a string
-- @param b string
-- @param ignore_case boolean
function natord(a, b, ignore_case)
    local ai, bi = 1, 1
    local lenA, lenB = #a, #b
    local after_digit = false
    
    while true do
        local ca = a:sub(ai, ai)
        local cb = b:sub(bi, bi)

        -- should skip space
        while ai <= lenA and is_space(ca) do
            ai = ai + 1
            ca = a:sub(ai, ai)
        end
        while bi <= lenB and is_space(cb) do
            bi = bi + 1
            cb = b:sub(bi, bi)
        end
        
        -- if all is number
        if is_digit(ca) and is_digit(cb) then
            local fractional
            if ca == "0" or cb == "0" then
                fractional, ai, bi = compare_left(a, b, ai, bi)
            else
                fractional, ai, bi = compare_right(a, b, ai, bi)
            end
            if fractional ~= 0 then return fractional end
            
            after_digit = true
        else
            -- if normal text of group ca or cb
            if ca == "" and cb == "" then return 0 end
            if ca == "" then return -1 end
            if cb == "" then return 1 end
            
            -- fixing float point
            if after_digit then
                -- if find match "," (end num)
                if ca == "." and cb ~= "." and is_digit(a:sub(ai+1, ai+1)) then
                    return 1 -- math if B first end -> B < A
                -- or else B first end -> A < B
                elseif cb == "." and ca ~= "." and is_digit(b:sub(bi+1, bi+1)) then
                    return -1 -- math if A first end -> A < B
                end
            end
            
            if ignore_case then
                ca = ca:lower()
                cb = cb:lower()
            end
            
            if ca < cb then return -1 end
            if ca > cb then return 1 end
            
            ai = ai + 1
            bi = bi + 1
            after_digit = false -- down state
        end
    end
end

return natord
