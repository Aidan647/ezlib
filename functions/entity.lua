ezlib.entity = {}
ezlib.entity.get = {}

function ezlib.entity.get.list (ftype,value)
	local freturn = 0
	local list = {}
	if ftype ~= nil then
		local entity = data.raw[ftype]
		local del_list = {}
		if entity ~= nil then
			for k,ing in pairs(entity) do
				table.insert(list, entity[k].name)
			end
		end
		if value ~= nil and type(value) == "table" and list ~= nil then
			for a,ing in pairs(value) do
				if value[a] ~= nil then
					if type(value[a]) == "string" then
						for x,ing2 in ipairs(list) do
							if entity[list[x]][a] ~= value[a] or entity[list[x]][a] == nil then
								table.insert(del_list, ing2)
							end
						end
					elseif type(value[a]) == "table" then
						for b,ing3 in pairs(value[a]) do
							if type(value[a][b]) == "string" then
								for c,ing2 in ipairs(list) do
									if entity[list[x]][a][b] ~= value[a][b]  or entity[list[x]][a][b] == nil then
										table.insert(del_list, ing2)
									end
								end
							elseif type(value[a][b]) == "table" then
								log("You can't mine so deap")	
							else
								break
							end
						end
					else
						break
					end
				end
			end
			list = ezlib.tbl.remove(list, del_list)
		end
		if list then
			if #list == 1 then
				list = list[1]
				freturn = 1
			elseif #list == 0 then
				list = nil
			else
				freturn = 1
			end
		end
	end
	if debug then	
		local print = ""
		print = print .. "ezlib.entity.get.list\n---------------------------------------------------------------------------------------------\n"
		if ftype == nil then
			lprint = print .. "  Type is empty"
		else
			if type(list) == "table" then
				print = print .. "  Found " .. #list .. " entities in type " .. ftype .. "."
			elseif type(list) == "string" then
				print = print .. "  Found entity " .. list .. " in type " .. ftype .. "."
			else
				print = print .. "  [Warning] Found 0 entities in type " .. ftype .. "."
			end
			if type(list) == "table" then
				print = print .. "\n  List of entities:"
				print = print .. ezlib.log.print(list, 0)
			end
			if type(value) == "table" then
				print = print .. "\n  List of filters:"
				print = print .. ezlib.log.print(value, 0)
			end
		end
		log(print .. "\n---------------------------------------------------------------------------------------------")
	end
	if freturn == 0 then 
		return nil
	else
		return list
	end
end