#!/usr/bin/lua

utils = require 'utils'

-- env is not set
local __env = nil
__data = {}

function initialize(environment)

    if environment == 'functional' then
        __env = environment
        local f = require "functional"
        Object,Derived = nil,nil
        Functional = f
--        cons, head, tail, tolist = f.cons, f.head, f.tail, f.tolist
--        empty, map, filter = f.empty, f.map, f.filter

    elseif environment == 'oo' then
        __env = environment
        Functional = nil
        Object = require "object"
        Derived = require "derived_objects"
    else
        print("Environment failed to be initialized.")
        print("Acceptable values are 'functional' and 'oo'.")
    end
end

function load_data (filename)

    if __env == nil then
        print('Please set an environment first.')
        return
    end
    io.input(filename)
    local content = io.read('*all')
    __data = loadstring(content)()
    io.input(stdin)
    print(filename .. ' loaded succesfully.')
    available_data()
    convert_data()

end

function to_save (elem)
    if __env == 'functional' then
        return tostring(elem) .. ';' .. tostring(elem[2]())
    end

    if __env == 'oo' then
        return elem.name .. ';' .. elem:utility()
    end
end

function save_data (filename,data)
    local file, err = io.open(filename, "w")

    if __env == 'functional' then
        for i,g in ipairs(data) do
            file:write('__g;' .. i .. '\n')
            for _,elem in ipairs(g) do
                file:write(to_save(elem) .. '\n')
            end
        end
    end

    if __env == 'oo' then
        for i,g in ipairs(data) do
            file:write('__g;' .. i .. '\n')
            for elem,_ in pairs(g) do
                file:write(to_save(elem) .. '\n')
            end
        end
    end
    file:close()
end

function available_data ()
    print('The available data is: ')
    for d,_ in pairs(__data) do
        print(' ' .. d)
    end
end

function convert_data()

    for k,v in pairs(__data) do
        for i,obj in ipairs(v) do
            v[i] = make_object(obj)
        end
    end

end

function make_object(obj)
    if __env == 'oo' then
        local types = {
            value = Derived.Scalar,
            point = Derived.Point,
            tweet = Derived.Tweet,
            text = Derived.Text
        }

        utils.table2str(types)

        local name =  table.remove(obj,1)
        local class = types[table.remove(obj,1)]

        return class:new(name,unpack(obj))

    elseif __env == 'functional' then
        local types = {
            value = Functional.value,
            point = Functional.magnet,
            tweet = Functional.tweet,
            text = Functional.text
        }

        local name =  table.remove(obj,1)
        local class = types[table.remove(obj,1)]

        return Functional.obj( name,class,unpack(obj))
    end

end

function func_help()
    local functions = ''
    for n,f in pairs(Functional) do
        if type(f) == 'function' then
            functions = functions .. n .. '\n'
        end
    end

return ([[
Functions are inside the Functional table and can be
accessed as 'Functional.fooname()'

Lists can be constructed with cons and accessed with tail and head

    l = cons( 1, cons( 2, cons(3 , Nil ) ) ) -- { 1,2,3 }
    cons( 5, tail(l) ) -- { 5, 2, 3}

To call cliques use: Functional.cliques(data,threshold)

Available functions are:

]] .. functions)

end

function oo_help()
    local classes = ''

return [[
The following classes have been defined:
]] .. classes ..[[
Object is the parent class and has the static method
used to run cliques: Object.cliques(data,threshold)
]]

end
function help()

    local help_strings = {

    functional = func_help,

    oo = oo_help

    }

    print [[
The cliques shell is a set of utilities that run inside
the Lua REPL shell and implement the Cliques algorithm.

You can load .lua files with data to analyze using.
    load_data "data.lua"

Where "data.lua" is the name of the file.
    ]]


    if __env then
        print("The environment is currently set to " .. __env)
        print( help_strings[__env]() )
    else
        print("Before you start you might want to initialize the environment.")
        print("Use initialize 'env' to set it.")
        print("Acceptable values are 'functional' and 'oo'.")
    end

end

print('Welcome to the cliques shell!')
print('Use help() to obtain help')

