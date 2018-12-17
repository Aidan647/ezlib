function ezlib.item.get.list (value)
	if type(value) == "table" then 
		if value.not_items then
		not_items = ezlib.item.not_item
		value.not_items = nil
		else
			not_items = "item"
		end
	else
		not_items = "item"
	end
	local freturn = 0
	local item = {}
	local list = {}
	local del_list = {}
	if type(not_items) == "table" then
		for a,ing in ipairs(not_items) do
			if data.raw[ing] then
				for b,ing2 in pairs(data.raw[ing]) do
					if data.raw[ing][b] then
						table.insert(list, {data.raw[ing][b].name, data.raw[ing][b].type})
					end
				end
			end
		end
		if value ~= nil and type(value) == "table" then
			for c,ing in ipairs(list) do
				for a,ing2 in pairs(value) do
					if value[a] ~= nil then
						if type(value[a]) == "string" or type(value[a]) == "number" then
							if data.raw[ing[2]][ing[1]][a] ~= value[a] or data.raw[ing[2]][ing[1]][a] == nil then
								table.insert(del_list, ing)
							end
						elseif type(value[a]) == "table" then
							for b,ing3 in pairs(value[a]) do
								if type(value[a][b]) == "string" or type(value[a][b]) == "number" then
									if data.raw[ing[2]][ing[1]][a][b] ~= value[a][b]  or data.raw[ing[2]][ing[1]][a][b] == nil then
										table.insert(del_list, ing)
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
		end
	else
		item = data.raw.item
		if item ~= nil then
			for k,ing in pairs(item) do
				table.insert(list, item[k].name)
			end
		end
		if value ~= nil and type(value) == "table" then
			for a,ing in pairs(value) do
				if value[a] ~= nil then
					if type(value[a]) == "string" or type(value[a]) == "number" then
						for x,ing2 in ipairs(list) do
							if item[list[x]][a] ~= value[a] or item[list[x]][a] == nil then
								table.insert(del_list, ing2)
							end
						end
					elseif type(value[a]) == "table" then
						for b,ing3 in pairs(value[a]) do
							if type(value[a][b]) == "string" or type(value[a][b]) == "number" then
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
	if ezlib.debug then	
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

function ezlib.item.add.flag (value, flag)
	local print = "ezlib.item.add.flag\n---------------------------------------------------------------------------------------------\n"
	if data.raw.item[value] then
		if data.raw.item[value].flags then
			table.insert(data.raw.item[value].flags, flag)
		else
			data.raw.item[value].flags = flag
		end
		if ezlib.debug then
			log(print .. "  Flag " .. flag .. " added to " .. value .. ".\n---------------------------------------------------------------------------------------------")
		end
	else
		if ezlib.debug then
			log(print .. "  [Warning] Item with name " .. value .. " not found.\n---------------------------------------------------------------------------------------------")
		else
			log("  [Warning] Item with name " .. value .. " not found.")
		end
	end
end

function ezlib.item.remove.flag (value, flag)
	local print = "ezlib.item.remove.flag\n---------------------------------------------------------------------------------------------\n"
	if data.raw.item[value] then
		if data.raw.item[value].flags then
			for i,v in ipairs(data.raw.item[value].flags) do
				if data.raw.item[value].flags[i] == v then
					table.remove(data.raw.item[value].flags, i)
				end
			end
		end
		if ezlib.debug then
			log(print .. "  Flag " .. flag .. " removed from " .. value .. ".\n---------------------------------------------------------------------------------------------")
		end
	else
		if ezlib.debug then
			log(print .. "  [Warning] Item with name " .. value .. " not found.\n---------------------------------------------------------------------------------------------")
		else
			log("  [Warning] Item with name " .. value .. " not found.")
		end
	end
end
