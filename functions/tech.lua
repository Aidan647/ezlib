ezlib.tech = {}
ezlib.tech.add = {}
ezlib.tech.find = {}
ezlib.tech.remove = {}
ezlib.tech.get = {}


function ezlib.tech.add.unlock_recipe (value, frecipe)
	local print = "ezlib.tech.add.unlock_recipe\n---------------------------------------------------------------------------------------------\n"
	if data.raw.technology[value] then
		table.insert(data.raw.technology[value].effects, {type = "unlock-recipe", recipe = frecipe})
		if debug then
			log(print .. "  Recipe " .. frecipe .. " added to technology " .. value .. "\n---------------------------------------------------------------------------------------------")
		end
	else
		if debug then
			log(print .. "  [Warning] Technology with name " .. value .. " not found\n---------------------------------------------------------------------------------------------")
		else
			log("[Warning] Technology with name " .. value .. " not found")
		end
	end
end

function ezlib.tech.add.unlock_modifer (value, ftype, fmodifier, fammo_category)
	local print = "ezlib.tech.add.unlock_modifer\n---------------------------------------------------------------------------------------------\n"
	if data.raw.technology[value] == value then
		if ftype == "ammo-damage" or ftype == "gun-speed" then
			table.insert(data.raw.technology[value].effects, {type = ftype, ammo_category = fammo_category, modifier = fmodifier})	
			if debug then		
				log(print .. "  Effect " .. ftype .. " with modifier " .. fmodifier .. " for ammo category " .. fammo_category .. " added to technology " .. value .. "\n---------------------------------------------------------------------------------------------")
			end
		else
			table.insert(data.raw.technology[value].effects, {type = ftype, modifier = fmodifier})
			if debug then
				log(print .. "  Effect " .. ftype .. " with modifier " .. fmodifier .. " added to technology " .. value .. "\n---------------------------------------------------------------------------------------------")
			end
		end
	else
		if debug then
			log(print .. "  [Warning] Technology with name " .. value .. " not found\n---------------------------------------------------------------------------------------------")
		else
			log("[Warning] Technology with name " .. value .. " not found")
		end
	end
end

function ezlib.tech.add.prerequisites (value, ftech)
	local print = "ezlib.tech.add.prerequisites\n---------------------------------------------------------------------------------------------\n"
	if data.raw.technology[value] and data.raw.technology[ftech] then
		table.insert(data.raw.technology[value].prerequisites, ftech)
		if debug then
			log(print .. "  Prerequisites " .. ftech .. " added to technology " .. value .. "\n---------------------------------------------------------------------------------------------")
		end
	else
		if debug then
			log(print .. "  [Warning] Technology with name " .. value .. " or " .. ftech .. " not found\n---------------------------------------------------------------------------------------------")
		else
			log("[Warning] Technology with name " .. value .. " or " .. ftech .. " not found")
		end
	end
end


function ezlib.tech.find.unlock_recipe (value)
	local print = "ezlib.tech.find.unlock_recipe\n---------------------------------------------------------------------------------------------\n"
	local tech = data.raw.technology
	local list = {}
	for x,ing in pairs(tech) do
		if tech[x].effects ~= nil then
			for y,ing in ipairs(tech[x].effects) do
			if tech[x].effects[y].type == "unlock-recipe" then
					if tech[x].effects[y].recipe == value then
						table.insert(list, tech[x].name)
					end
				end
			end
		end
	end
	if #list == 1 then
		list = list[1]
		print = print .. "  Found 1 technologies.\n"
		print = print .. "\n  Renurning: " .. list
	elseif #list == 0 or not list then
		list = nil
		print = print .. "  [Warning] Found 0 technologies."
	else
		print = print .. "  Found " .. #list .. " technologies.\n"
		print = print .. "\n  Renurning:"
		print = print .. ezlib.log.print(list, 0)
	end
	if debug then
		log(print .. "\n---------------------------------------------------------------------------------------------")
	end
	return list
end

function ezlib.tech.find.unlock_modifer (value, fmodifier)
	local print = "ezlib.tech.find.unlock_modifer\n---------------------------------------------------------------------------------------------\n"
	local tech = data.raw.technology
	local list = {}
	for x,ing in pairs(tech) do
		if tech[x].effects ~= nil then
			for y,ing in ipairs(tech[x].effects) do
				if tech[x].effects[y].type == value then
					if tech[x].effects[y].modifier == fmodifier or fmodifier == nil then
						table.insert(list, tech[x].name)
					end
				end
			end
		end
	end
	if #list == 1 then
		list = list[1]
		print = print .. "  Found " .. #list .. " technologies.\n"
		print = print .. "\n  Renurning: " .. list
	elseif #list == 0 or not list then
		list = nil
		print = print .. "  [Warning] Found 0 technologies."
	else
		print = print .. "  Found " .. #list .. " technologies.\n"
		print = print .. "\n  Renurning:"
		print = print .. ezlib.log.print(list, 0)
	end
	if debug then
		log(print .. "\n---------------------------------------------------------------------------------------------")
	end
	return list
end


function ezlib.tech.remove.unlock_recipe (value, frecipe)
	local print = "ezlib.tech.remove.unlock_recipe\n---------------------------------------------------------------------------------------------"
	if data.raw.technology[value] then
		for y,ing in ipairs(data.raw.technology[value].effects) do
			if data.raw.technology[value].effects[y].type == "unlock-recipe" then
				if data.raw.technology[value].effects[y].recipe == frecipe then
					table.remove(data.raw.technology[value].effects, y)
					print = print .. "\n  Recipe " .. frecipe .. " removed from technology " .. value
				end
			end
		end
		if debug then
			log(print .. "\n---------------------------------------------------------------------------------------------")
		end
	else
		if debug then
			log(print .. "  [Warning] Technology with name " .. value .. " not found\n---------------------------------------------------------------------------------------------")
		else
			log("[Warning] Technology with name " .. value .. " not found")
		end
	end
end

function ezlib.tech.remove.unlock_modifer (value, ftype, fammo_category)
	local print = "ezlib.tech.remove.unlock_modifer\n---------------------------------------------------------------------------------------------\n"
	if data.raw.technology[value] then
		for y,ing in ipairs(data.raw.technology[value].effects) do
			if fammo_category ~= nil then
				if data.raw.technology[value].effects.ammo_category == fammo_category and data.raw.technology[value].effects.type == ftype then
					table.remove(data.raw.technology[value].effects, y)
					print = print .. "\n  Effect " .. ftype .. " removed from technology " .. value
				end
			else
				if data.raw.technology[value].effects.type == ftype then
					table.remove(data.raw.technology[value].effects, y)
					print = print .. "\n  Effect " .. ftype .. " removed from technology " .. value
				end
			end
		end
		if debug then
			log(print .. "\n---------------------------------------------------------------------------------------------")
		end
	else
		if debug then
			log(print .. "  [Warning] Technology with name " .. value .. " not found\n---------------------------------------------------------------------------------------------")
		else
			log("[Warning] Technology with name " .. value .. " not found")
		end
	end
end

function ezlib.tech.remove.prerequisites (value, ftech)
	local print = "ezlib.tech.remove.prerequisites\n---------------------------------------------------------------------------------------------\n"
	if data.raw.technology[value] and data.raw.technology[ftech] then
		for y,ing in ipairs(data.raw.technology[value].prerequisites) do
			if data.raw.technology[value].prerequisites[y] == ftech then
				table.remove(data.raw.technology[value].prerequisites, y)
				print = print .. "\n  Prerequisites " .. ftech .. " removed from technology " .. value
			end
		end
		if debug then
			log(print .. "\n---------------------------------------------------------------------------------------------")
		end
	else
		if debug then
			log(print .. "  [Warning] Technology with name " .. value .. " or " .. ftech .. " not found\n---------------------------------------------------------------------------------------------")
		else
			log("[Warning] Technology with name " .. value .. " or " .. ftech .. " not found")
		end
	end
end

function ezlib.tech.get.list (value)
	local freturn = 0
	local tech = data.raw.technology
	local list = {}
	local list = {}
	for x,ing in pairs(tech) do
		table.insert(list, tech[x].name)
	end
	if value ~= nil and type(value) == "table" then
		for a,ing in pairs(value) do
			if value[a] ~= nil then
				if type(value[a]) == "string" then
					for x,ing2 in ipairs(list) do
						if tech[list[x]][a] ~= value[a] or tech[list[x]][a] == nil then
							table.insert(del_list, ing2)
						end
					end
				elseif type(value[a]) == "table" then
					for b,ing3 in pairs(value[a]) do
						if type(value[a][b]) == "string" then
							for c,ing2 in ipairs(list) do
								if tech[list[x]][a][b] ~= value[a][b]  or tech[list[x]][a][b] == nil then
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
		print = print .. "ezlib.tech.get.list\n---------------------------------------------------------------------------------------------\n"
		if type(list) == "table" then
			print = print .. "  Found " .. #list .. " technologies."
		elseif type(list) == "string" then
			print = print .. "  Found technology " .. list .. "."
		else
			print = print .. "  [Warning] Found 0 technologies in type."
		end
		if type(list) == "table" then
			print = print .. "\n  List of technologies:"
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