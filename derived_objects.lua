Object = require "object"

-- thanks to http://lua-users.org/wiki/InheritanceTutorial
-- for the cool insights on inheritance
function derivedClass( base )

    local new_class = {}
    local met = { __index = new_class }

    -- kind of a "private" constructor to be used by
    -- the real constructor
    function new_class:__new()
        local new_obj = {}
        setmetatable( new_obj, met )
        return new_obj
    end

    setmetatable( new_class, { __index = base } )

    return new_class
end

-- a class that calculates the utility
-- function for texts
local Text = derivedClass(Object)

function Text:new( name, text)
    -- the private constructor
    local obj = Text:__new()
    obj.name = name
    obj.text = text
    return obj
end

function Text:utility()
    return #self.text
end

local Scalar = derivedClass(Object)

function Scalar:new( name, value )
    -- the private constructor
    local obj = Scalar:__new()
    obj.name = name
    obj.value = value
    return obj
end

function Scalar:utility()
    return self.value
end

local Point = derivedClass(Object)

function Point:new( name, x,y)
    -- the private constructor
    local obj = Point:__new()
    obj.name = name
    obj.x , obj.y = x,y
    return obj
end

function Point:utility()
    return math.sqrt( math.pow(self.x,2), math.pow(self.y,2) )
end

local Tweet = derivedClass(Object)

function Tweet:new( name, person, text)
    -- the private constructor
    local obj = Tweet:__new()
    obj.name = name
    obj.person = person
    obj.text = text
    return obj
end

function Tweet:utility()
    local v = 0

    for c = 1,#self.person do
        v = v + string.byte(self.person,c)
    end

    return v
end


return {Tweet = Tweet, Text = Text, Scalar = Scalar, Point = Point}

