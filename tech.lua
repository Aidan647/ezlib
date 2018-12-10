ezlib.tech = {}
ezlib.tech.add = {}
ezlib.tech.find = {}
ezlib.tech.remove = {}
ezlib.tech.get = {}


function ezlib.tech.add.unlock_recipe (value, frecipe)
	if data.raw.technology[value].name == value then
		table.insert(data.raw.technology[value].effects, {type = "unlock-recipe", recipe = frecipe})
	else
		log("Tech with name " .. value .. " not found")
	end
end

function ezlib.tech.add.unlock_modifer (value, ftype, fmodifier, fammo_category)
	if data.raw.technology[value].name == value then
		if ftype == "ammo-damage" or ftype == "gun-speed" then
			table.insert(data.raw.technology[value].effects, {type = ftype, ammo_category = fammo_category, modifier = fmodifier})
		else
			table.insert(data.raw.technology[value].effects, {type = ftype, modifier = fmodifier})
		end
	else
		log("Tech with name " .. value .. " not found")
	end
end

function ezlib.tech.add.prerequisites (value, ftech)
	if data.raw.technology[value].name == value and data.raw.technology[ftech].name == ftech then
		table.insert(data.raw.technology[value].prerequisites, ftech)
	else
		log("Tech with name " .. value .. " or " .. ftech .." not found")
	end
end


function ezlib.tech.find.unlock_recipe (value)
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
	end
	return list
end

function ezlib.tech.find.unlock_modifer (value, fmodifier)
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
	end
	return list
end


function ezlib.tech.remove.unlock_recipe (value, frecipe)
	if data.raw.technology[value].name == value then
		for y,ing in ipairs(data.raw.technology[value].effects) do
			if data.raw.technology[value].effects[y].type == "unlock-recipe" then
				if data.raw.technology[value].effects[y].recipe == frecipe then
					table.remove(data.raw.technology[value].effects, y)
				end
			end
		end
	else
		log("Tech with name " .. value .. " not found")
	end
end

function ezlib.tech.remove.unlock_modifer (value, ftype, fammo_category)
	if data.raw.technology[value].name == value then
		for y,ing in ipairs(data.raw.technology[value].effects) do
			if fammo_category ~= nil then
				if data.raw.technology[value].effects.ammo_category == fammo_category or data.raw.technology[value].effects.type == ftype then
					table.remove(data.raw.technology[value].effects, y)
				end
			else
				if data.raw.technology[value].effects.type == ftype then
					table.remove(data.raw.technology[value].effects, y)
				end
			end
		end
	else
		log("Tech with name " .. value .. " not found")
	end
end

function ezlib.tech.remove.prerequisites (value, ftech)
	if data.raw.technology[value].name == value then
		for y,ing in ipairs(data.raw.technology[value].prerequisites) do
			if data.raw.technology[value].prerequisites[y] == ftech then
				table.remove(data.raw.technology[value].prerequisites, y)
			end
		end
	else
		log("Tech with name " .. value .. " not found")
	end
end

function ezlib.tech.get.list ()
	local tech = data.raw.technology
	local list = {}
	for x,ing in pairs(tech) do
		table.insert(list, technology[x].name)
	end
	if #list == 1 then
		list = list[1]
	end
	return list
end