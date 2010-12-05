local utils = {}

utils.pad = function (n)
	local ret = ''
	for p = 0,n do ret = ret .. '\t' end
	return ret
end

utils.list2str = function (t)
    local ret = "( "
    for _,e in ipairs(t) do
        ret = ret .. tostring(e) .. ' '
    end
    ret = ret .. " )"
    return ret
end

utils.table2str = function (t,tabs)

		tabs = tabs or 0

		local ret = "{\n"

		for i,j in pairs(t) do
			local str1, str2

			if type(i) == 'table' then
				str1 = utils.table2str(i,tabs+1)
			else
				str1 = i
			end

	 		if type(j) == 'table' then
				str2 = utils.table2str(j,tabs+1)
			else
				str2 = j
			end

			ret = ret .. utils.pad(tabs) .. tostring(str1) .. ' => ' .. tostring(str2) .. ',\n'
		end

		ret = ret .. utils.pad(tabs-1)  .. '}'

		return ret
end

-- makes the copy of an object
-- for tables it works as a deepcopy
-- http://lua-users.org/wiki/CopyTable
function utils.copy(object)
    local lookup_table = {}

    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end

    return _copy(object)
end

return utils

