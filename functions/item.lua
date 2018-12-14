ezlib.item = {}
ezlib.item.get = {}

function ezlib.item.get.list (value)
	local freturn = 0
	local item = data.raw.item
	local list = {}
	local del_list = {}
	if item ~= nil then
		for k,ing in pairs(item) do
			table.insert(list, item[k].name)
		end
	end
	if value ~= nil and type(value) == "table" then
		for a,ing in pairs(value) do
			if value[a] ~= nil then
				if type(value[a]) == "string" then
					for x,ing2 in ipairs(list) do
						if item[list[x]][a] ~= value[a] or item[list[x]][a] == nil then
							table.insert(del_list, ing2)
						end
					end
				elseif type(value[a]) == "table" then
					for b,ing3 in pairs(value[a]) do
						if type(value[a][b]) == "string" then
							for c,ing2 in ipairs(list) do
								if item[list[x]][a][b] ~= value[a][b]  or item[list[x]][a][b] == nil then
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
	end
	list = ezlib.tbl.remove(list, del_list)
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
	if debug then	
		local print = ""
		print = print .. "ezlib.item.get.list\n---------------------------------------------------------------------------------------------\n"
		if type(list) == "table" then
			print = print .. "  Found " .. #list .. " items."
		elseif type(list) == "string" then
			print = print .. "  Found item " .. list .. "."
		else
			print = print .. "  [Warning] Found 0 items in type."
		end
		if type(list) == "table" then
			print = print .. "\n  List of items:"
			print = print .. ezlib.log.print(list, 0)
		end
		if type(value) == "table" then
			print = print .. "\n  List of filters:"
			print = print .. ezlib.log.print(value, 0)
		end
		log(print .. "\n---------------------------------------------------------------------------------------------")
	end
	if freturn == 0 then 
		return nil
	else
		return list
	end
end