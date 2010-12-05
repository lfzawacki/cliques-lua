local utils = require 'utils'

-- Nil is the empty list
local Nil = {}
Nil.__index = Nil

local metatable = {}

function metatable:__tostring ()
    return utils.list2str(self)
end

function metatable:__eq (t)

    if table.getn(self) ~= table.getn(t) then
        return false
    end

    local eq = true

    for i in ipairs(self) do
        eq = eq and self[i] == t[i]
    end

    return eq
end

setmetatable(Nil,metatable)

-- converts an array to a list
local tolist = function (list)
    return setmetatable( utils.copy(list), metatable )
end

local empty = function ( list )
    return table.getn(list) == 0
end

local cons = function ( elem, list )
    -- constructs a new table
    local ret = utils.copy(list)
    table.insert(ret, 1 , elem)

    return ret
end

local head = function ( list )
    -- make a copy of the first element
    return utils.copy(list[1])
end

local tail = function ( list )
    -- make a copy, erase the first element and return
    new_list = utils.copy(list)
    table.remove(new_list, 1)
    return new_list
end

function append( l1, l2 )
    if empty(l1) then return l2 end

    return cons( head(l1) , append( tail(l1), l2 ) )
end

function map( list , foo )
    if empty(list) then return list end

    return cons( foo( head(list) ) , map( tail(list) , foo ) )
end

function filter( list, foo )
    if empty(list) then return list end

    if foo( head(list) ) then
        return cons( head(list) , filter( tail(list) ) )
    else
        return filter( tail(list) )
    end
end


function cliques(list, threshold, sets)

    -- hidden functions, nobody needs to now they exist

    function is_alike( e1, e2 )
        -- the heuristic value of an element is obtained
        -- by calling his function
        return math.abs( e1[2]() - e2[2]() ) <= threshold
    end

    function all_alike( element, list )

        if empty(list) then
            return true
        end

        return is_alike( element , head(list) ) and all_alike(element, tail(list) )
    end

    function add_element( element , sets )

        -- if the sets are empty we make a new one with just the element
        if empty(sets) then return cons( cons(element,Nil) , sets ) end

        -- tests if current head set is alike the element
        if all_alike( element , head(sets) ) then
            -- insert it in the head
            return cons ( cons( element, head(sets) ) , tail(sets) )
        else
            -- tries to insert it in the next
            return cons(  head(sets) , add_element( element, tail(sets) ) )
        end
    end

    -- start of algorithm
    -- tries to add each element to the set until
    -- the list is empty, and then returns the set

    -- default
    sets = sets or Nil

    -- trivial
    if empty(list) then return sets end

    return cliques( tail(list) , threshold, add_element( head(list), sets ) )

end

-- this is a little ingenious, receives 'foo', a function, and it's parameters
-- and returns a function calling 'foo'.
-- This will work because of closures and thus we'll have polymorphic
-- functions being called in cliques

-- EDIT, now it returns a tuple for the sake of pretty printing it

-- can't think of a good name for it
local obj = function ( name, foo, ... )
    -- this syntax is an ugly way to pass all the parameters
    -- to the newly created function
    local params = {...}
    local o = { name , function () return foo( unpack(params) ) end }

    -- quick metatable to print only the name
    setmetatable( o, { __tostring = function (self) return self[1] end} )

    return o
end

-- utility functions
local value = function (v) return v end

local magnet = function (x,y) return math.sqrt( math.pow(x,2), math.pow(y,2) ) end

local text = function  (t) return #t end

local tweet = function (p,t)
    local v = 0
    for c = 1,#p do
        v = v + string.byte(p,c)
    end
    return v
end

return {

    tolist = tolist,
    cons = cons,
    head = head,
    tail = tail,
    empty = empty,
    map = map,
    filter = filter,
    append = append,
    Nil = Nil,
    value = value,
    magnet = magnet,
    text = text,
    obj = obj,
    tweet = tweet,
    cliques = cliques

}

