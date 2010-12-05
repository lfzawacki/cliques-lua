local utils = require 'utils'

-- new class Object
local Object = {}

function Object:tostring ()
    return self.name
end

function Object:new(n)

    -- metatable, __index = Object set to object means that an access
    -- to an inexistent member will be looked up in Object
	local met = { __index = Object, __tostring = Object.tostring }

	-- creates a new instance
	local ret = { name = n }

	-- sets the metatable of the instance to be met
	setmetatable(ret,met)

	return ret
end

function Object.sets2string(sets)
    ret = '('
    for _,s in pairs(sets) do
        ret = ret .. ' ( '
        for o,_ in pairs(s) do
            ret = ret .. o:tostring() .. ' '
        end
        ret = ret .. ' ) '
    end
    ret = ret .. ')'
    return ret
end

-- function to determine the heuristic value
-- of an object
function Object:utility()
    error("utility() is virtual, it must be implemented in derived class!")
end

function Object:is_alike(obj,threshold)
	return math.abs( self:utility() - obj:utility() ) <= threshold
end

function Object.cliques( array, threshold )

	local current = array[1]
	local groups = { {} }

	-- cria o primeiro grupo com o primeiro obj como inicio
	groups[1][current] = true

	for i=2, table.getn(array) do

		current = array[i]
		local alike = false

		for _, group in pairs(groups) do
			if not alike then
				alike = true

				for e in pairs(group) do
					alike = alike and current:is_alike(e, threshold)
				end

				-- adicionamos o elemento
				if alike then
					group[current] = true
				end
			end
		end

		-- criamos um novo grupo
		if not alike then
			table.insert(groups, { [current] = true } )
		end
	end

    -- quick metatable for printing
    local met = { __tostring = Object.sets2string }

	return setmetatable(groups,met)
end

return Object

