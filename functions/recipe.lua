function ezlib.recipe.remove.ingredient (value, ingredient)
	local print = "ezlib.recipe.remove.ingredient\n---------------------------------------------------------------------------------------------\n"
	local recipe = table.deepcopy(data.raw.recipe[value])
	if recipe ~= nil then
		if recipe.normal ~= nil then
			local ingredients_normal = recipe.normal.ingredients
			for x,ing in ipairs(ingredients_normal) do
				if ingredients_normal[x][1] == ingredient or ingredients_normal[x]["name"] == ingredient then
					--ingredients_normal[x] = nil
					table.remove (ingredients_normal, x)
					print = print .. "Removed " .. ingredient .. " from recipe " .. value .. " (difficulty normal).\n"
				end
			end
			data.raw.recipe[value].normal.ingredients = ingredients_normal
			local ingredients_expensive = recipe.expensive.ingredients
			for x,ing in ipairs(ingredients_expensive) do
				if ingredients_expensive[x][1] == ingredient or ingredients_expensive[x]["name"] == ingredient then
					--ingredients_expensive[x] = nil
					table.remove (ingredients_expensive, x)
					print = print .. "Removed " .. ingredient .. " from recipe " .. value .. " (difficulty expensive).\n"
				end
			end
			data.raw.recipe[value].expensive.ingredients = ingredients_normal
		else
			local ingredients = recipe.ingredients
			for x,ing in ipairs(ingredients) do
				if ingredients[x][1] == ingredient or ingredients[x]["name"] == ingredient then
					--ingredients[x] = nil
					table.remove (ingredients, x)
					print = print .. "  Removed " .. ingredient .. " from recipe " .. value .. " (no difficulty).\n"
				end
			end
			data.raw.recipe[value].ingredients = ingredients
		end
		if not recipe.normal then recipe.normal = {} end if not recipe.expensive then recipe.expensive = {} end
		if recipe.normal.ingredients == ingredients_normal and recipe.expensive.ingredients == ingredients_expensive and recipe.ingredients == ingredients then
			print = print .. "  [Warning] Ingredient " .. ingredient .. " from recipe " .. value .. " wasnt removed.\n"
		end
		if ezlib.debug then
			log(print .. "---------------------------------------------------------------------------------------------")
		end
	else
		if ezlib.debug then
			log(print .. "  [Warning] Recipe with name " .. value .. " not found.\n---------------------------------------------------------------------------------------------")
		else
			log("  [Warning] Recipe with name " .. value .. " not found.")
		end
	end
end

function ezlib.recipe.add.ingredient (value, fingredient, famount, ftype)
	local print = "ezlib.recipe.add.ingredient\n---------------------------------------------------------------------------------------------\n"
	if ftype ~= nil and ftype ~= "item" or ftype == 1 then
		ftype = "fluid"
		print = print .. "  Type is fluid\n"
	else
		ftype = "item"
		print = print .. "  Type is item\n"
	end
	recipe = table.deepcopy(data.raw.recipe[value])
	if recipe ~= nil then
		if recipe.normal ~= nil then
			table.insert(recipe.normal.ingredients, {type=ftype, name=fingredient, amount=famount})
			table.insert(recipe.expensive.ingredients, {type=ftype, name=fingredient, amount=famount})
			data.raw.recipe[value].normal.ingredients = recipe.normal.ingredients
			data.raw.recipe[value].expensive.ingredients = recipe.expensive.ingredients
			print = print .. "  " .. famount .. "x" .. fingredient .. "added to " .. value .. "(normal and expensive).\n"
		else
			table.insert(recipe.ingredients, {type=ftype, name=fingredient, amount=famount})
			data.raw.recipe[value].ingredients = recipe.ingredients
			print = print .. "  " .. famount .. "x" .. fingredient .. "added to " .. value .. ".\n"
		end
	else
		print = print .. "  [Warning] Recipe with name " .. value .. " not found\n"
		if not ezlib.debug then
			log("  [Warning] Recipe with name " .. value .. " not found")
		end
	end
	log(print .. "---------------------------------------------------------------------------------------------")
end

function ezlib.recipe.replace.ingredient (value, ingredient, fingredient, famount, ftype)
	if ftype ~= nil and ftype ~= "item" or ftype == 1 then
		ftype = "fluid"
	else
		ftype = "item"
	end
	ezlib.recipe.remove.ingredient (value, ingredient)
	ezlib.recipe.add.ingredient (value, fingredient, famount, ftype)
end

function ezlib.recipe.get.ingredient (value)
	local print = "ezlib.recipe.get.ingredient\n---------------------------------------------------------------------------------------------\n"
	local ftype, difficulty, fingredient
	if type(value) ~= "string" then
		if value["type"] == 1 or value["type"] == "item" then
			ftype = 1
		else
			if value["type"] == "fluid" or value["type"] == 2 then
				ftype = 2
			else
				ftype = 0
			end
		end
		if value["ingredient"] ~= nil then
			fingredient = value["ingredient"]
		else
			fingredient = 1
		end
		if value["difficulty"] ~= nil or value["difficulty"] == 0 or value["difficulty"] == "normal" then
			difficulty = 0
		else
			difficulty = 1
		end
		value = value["recipe_name"]
	else
		difficulty = 0
		fingredient = 1
		ftype = 0
	end
	local ingredients = {}
	local recipe = {}
	local out = {}
	recipe = table.deepcopy(data.raw.recipe[value])
	if recipe ~= nil then
		if difficulty == 0 then
			print = print .. "  Difficulty normal\n"
		else
			print = print .. "  Difficulty expensive (if possible)\n"
		end
		if fingredient == 1 then
			print = print .. "  No filter by ingredient\n"
		else
			print = print .. "  Ingredient filter active\n"
		end
		if ftype == 1 then
			print = print .. "  Filter by item\n"
		elseif ftype == 2 then
			print = print .. "  Filter by fluid\n"
		else
			print = print .. "  No filter by type\n"
		end
		if recipe.normal ~= nil then
			if difficulty == 1 or recipe.expensive == nil then
				ingredients = recipe.normal.ingredients
			else
				ingredients = recipe.expensive.ingredients
			end
		else
			ingredients = recipe.ingredients
		end
		if ftype == 0 then
			for x,ing in ipairs(ingredients) do
				if ingredients[x]["type"] == nil then
					table.insert(out, {type="item", name=ingredients[x][1], amount=ingredients[x][2]})
				else
					table.insert(out, {type=ingredients[x]["type"], name=ingredients[x]["name"], amount=ingredients[x]["amount"]})
				end
			end
		end
		if ftype == 1 then
			for x,ing in ipairs(ingredients) do
				if ingredients[x]["type"] == nil then
					table.insert(out, {type="item", name=ingredients[x][1], amount=ingredients[x][2]})
				else
					if ingredients[x]["type"] == "item" then
						table.insert(out, {type=ingredients[x]["type"], name=ingredients[x]["name"], amount=ingredients[x]["amount"]})
					end
				end
			end
		end
		if ftype == 2 then
			for x,ing in ipairs(ingredients) do
				if ingredients[x]["type"] == "fluid" then
					table.insert(out, {type=ingredients[x]["type"], name=ingredients[x]["name"], amount=ingredients[x]["amount"]})
				end
			end
		end
		if fingredient ~= 1 then
			for x,ing in ipairs(out) do
				if out[x]["name"] == fingredient then
					if ezlib.debug then
						log(print .. "  Renurning true\n---------------------------------------------------------------------------------------------")
					end
					return true
				end
			end
			if ezlib.debug then
				log(print .. "  Renurning false\n---------------------------------------------------------------------------------------------")
			end
			return false
		else
			if ezlib.debug then
				log(print .. "  Renurning:" .. ezlib.log.print(out, 0) .. "\n---------------------------------------------------------------------------------------------")
			end
			return out
		end
	else
		if ezlib.debug then
			log(print .. "  [Warning] Recipe with name " .. value .. " not found\n---------------------------------------------------------------------------------------------")
		else
			log("  [Warning] Recipe with name " .. value .. " not found")
		end
	end
end


function ezlib.recipe.remove.result (value, ingredient)
	local print = "ezlib.recipe.remove.result\n---------------------------------------------------------------------------------------------\n"
	local recipe = table.deepcopy(data.raw.recipe[value])
	if recipe ~= nil then
		if recipe.normal ~= nil then
			if recipe.normal.result ~= nil then
				if recipe.normal.result == ingredient then
					data.raw.recipe[value].normal.result = nil 
					print = print .. "  " .. ingredient .. "Removed from " .. value .. ".(Normal)\n"
				end
				if recipe.expensive.result == ingredient then
					data.raw.recipe[value].expensive.result = nil 
					print = print .. "  " .. ingredient .. "Removed from " .. value .. ".(Expensive)\n"
				end
			else
				local results_normal = recipe.normal.results
				for x,ing in ipairs(result_normal) do
					if results_normal[x][1] == ingredient or results_normal[x]["name"] == ingredient then
						--ingredients_normal[x] = nil
						table.remove (results_normal, x)
					end
				end
				data.raw.recipe[value].normal.results = results_normal
				print = print .. "  " .. ingredient .. "Removed from " .. value .. ".(Normal)\n"
				local results_expensive = recipe.expensive.ingredients
				for x,ing in ipairs(ingredients_expensive) do
					if results_expensive[x][1] == ingredient or results_expensive[x]["name"] == ingredient then
						--ingredients_expensive[x] = nil
						table.remove (results_expensive, x)	
					end
				end
				data.raw.recipe[value].expensive.results = results_expensive
				print = print .. "  " .. ingredient .. "Removed from " .. value .. ".(Expensive)\n"
			end
		else
			if recipe.result == ingredient then
				data.raw.recipe[value].result = nil 
				print = print .. "  " .. ingredient .. "Removed from " .. value .. ".\n"
			else
				local results = recipe.results
				for x,ing in ipairs(results) do
					if results[x][1] == ingredient or results[x]["name"] == ingredient then
						--ingredients[x] = nil
						table.remove (results, x)
					end
				end
				data.raw.recipe[value].results = results
				print = print .. "  " .. ingredient .. "Removed from " .. value .. ".\n"
			end
		end
		if ezlib.debug then
			log(print .. "---------------------------------------------------------------------------------------------")
		end
	else
		if ezlib.debug then
			log(print .. "  [Warning] Recipe with name " .. value .. " not found\n---------------------------------------------------------------------------------------------")
		else
			log("  [Warning] Recipe with name " .. value .. " not found")
		end
	end
end

function ezlib.recipe.add.result (value, fingredient, famount, ftype)
	local print = "ezlib.recipe.add.result\n---------------------------------------------------------------------------------------------\n"
	if ftype ~= nil and ftype ~= "item" or ftype == 1 then
		ftype = "fluid"
		print = print .. "  Type is fluid\n"
	else
		ftype = "item"
		print = print .. "  Type is item\n"
	end
	local recipe = table.deepcopy(data.raw.recipe[value])
	if recipe ~= nil then
		if recipe.normal ~= nil then
			if recipe.normal.results == nil then
				print = print .. "  Recipe " .. value .. " have no results... adding\n"
				recipe.normal.results = {}
				recipe.expensive.results = {}
				data.raw.recipe[value].normal.result = nil
				data.raw.recipe[value].expensive.result = nil
				data.raw.recipe[value].icon = data.raw.item[value].icon
				data.raw.recipe[value].icon_size = data.raw.item[value].icon_size
				data.raw.recipe[value].subgroup = data.raw.item[value].subgroup
				--if recipe.normal.result_count == nil then recipe.normal.result_count = 1 end
				--if recipe.expensive.result_count == nil then recipe.expensive.result_count = 1 end
				if recipe.normal.result ~= nil then
					table.insert(recipe.normal.results, {type="item", name=recipe.normal.result, amount=recipe.normal.result_count or 1})
				end
				if recipe.expensive.result ~= nil then
					table.insert(recipe.expensive.results, {type="item", name=recipe.expensive.result, amount=recipe.expensive.result_count or 1})
				end
			end
			table.insert(recipe.normal.results, {type=ftype, name=fingredient, amount=famount})
			table.insert(recipe.expensive.results, {type=ftype, name=fingredient, amount=famount})
			data.raw.recipe[value].normal.results = recipe.normal.results
			data.raw.recipe[value].expensive.results = recipe.expensive.results
			print = print .. "  " .. famount .. "x" .. fingredient .. "added to " .. value .. "(normal and expensive).\n"
		else
			if recipe.results == nil then
				recipe.results = {}
				data.raw.recipe[value].result = nil
				data.raw.recipe[value].icon = data.raw.item[value].icon
				data.raw.recipe[value].icon_size = data.raw.item[value].icon_size
				data.raw.recipe[value].subgroup = data.raw.item[value].subgroup
				if recipe.result ~= nil then
					print = print .. "  Recipe " .. value .. " have no results... adding\n"
					table.insert(recipe.results, {type="item", name=recipe.result, amount=recipe.result_count or 1})
				end
			end
			if recipe.category == nil and ftype == "fluid" then data.raw.recipe[value].category = "crafting-with-fluid" end
			table.insert(recipe.results, {type=ftype, name=fingredient, amount=famount})
			data.raw.recipe[value].results = recipe.results
			print = print .. "  " .. famount .. "x" .. fingredient .. "added to " .. value .. ".\n"
		end
		if ezlib.debug then
			log(print .. "---------------------------------------------------------------------------------------------")
		end
	else
		if ezlib.debug then
			log(print .. "  [Warning] Recipe with name " .. value .. " not found\n---------------------------------------------------------------------------------------------")
		else
			log("  [Warning] Recipe with name " .. value .. " not found")
		end
	end
end

function ezlib.recipe.replace.result (value, ingredient, fingredient, famount, ftype)
	if ftype ~= nil and ftype ~= "item" or ftype == 1 then
		ftype = "fluid"
	else
		ftype = "item"
	end
	ezlib.recipe.remove.result (value, ingredient)
	ezlib.recipe.add.result (value, fingredient, famount, ftype)
end

function ezlib.recipe.get.result (value)
	local print = "ezlib.recipe.get.result\n---------------------------------------------------------------------------------------------\n"
	local ftype, difficulty, fingredient
	if type(value) ~= "string" then
		if value["type"] == 1 or value["type"] == "item" then
			ftype = 1
		else
			if value["type"] ~= nil then
				ftype = 2
			else
				ftype = 0
			end
		end
		if value["ingredient"] ~= nil then
			fingredient = value["ingredient"]
		else
			fingredient = 1
		end
		if value["difficulty"] ~= nil or value["difficulty"] == 0 or value["difficulty"] == "normal" then
			difficulty = 0
		else
			difficulty = 1
		end
		value = value["recipe_name"]
	else
		difficulty = 0
		fingredient = 1
		ftype = 0
	end
	local ingredients = {}
	local recipe = {}
	local out = {}
	recipe = table.deepcopy(data.raw.recipe[value])
	if recipe ~= nil then
		if difficulty == 0 then
			print = print .. "  Difficulty normal\n"
		else
			print = print .. "  Difficulty expensive (if possible)\n"
		end
		if fingredient == 1 then
			print = print .. "  No filter by ingredient\n"
		else
			print = print .. "  Ingredient filter active\n"
		end
		if ftype == 1 then
			print = print .. "  Filter by item\n"
		elseif ftype == 2 then
			print = print .. "  Filter by fluid\n"
		else
			print = print .. "  No filter by type\n"
		end
		print = print .. value
		if recipe.normal ~= nil then
			if difficulty == 1 or recipe.expensive == nil then
				if recipe.normal.result ~= nil then
					table.insert(ingredients, {recipe.normal.result, recipe.normal.result_count or 1})
				else
					ingredients = recipe.normal.results
				end
			else
				if recipe.expensive.result ~= nil then
					table.insert(ingredients, {recipe.expensive.result, recipe.expensive.result_count or 1})
				else
					ingredients = recipe.expensive.results
				end
			end
		else
			if recipe.result ~= nil then
				table.insert(ingredients, {recipe.result, recipe.result_count or 1})
			else
				ingredients = recipe.results
			end
		end
		if ftype == 0 then
			for x,ing in ipairs(ingredients) do
				if ingredients[x]["type"] == nil then
					table.insert(out, {type="item", name=ingredients[x][1], amount=ingredients[x][2]})
				else
					table.insert(out, {type=ingredients[x]["type"], name=ingredients[x]["name"], amount=ingredients[x]["amount"]})
				end
			end
		end
		if ftype == 1 then
			for x,ing in ipairs(ingredients) do
				if ingredients[x]["type"] == nil then
					table.insert(out, {type="item", name=ingredients[x][1], amount=ingredients[x][2]})
				else
					if ingredients[x]["type"] == "item" then
						table.insert(out, {type=ingredients[x]["type"], name=ingredients[x]["name"], amount=ingredients[x]["amount"]})
					end
				end
			end
		end
		if ftype == 2 then
			for x,ing in ipairs(ingredients) do
				if ingredients[x]["type"] == "fluid" then
					table.insert(out, {type=ingredients[x]["type"], name=ingredients[x]["name"], amount=ingredients[x]["amount"]})
				end
			end
		end
		if fingredient ~= 1 then
			for x,ing in ipairs(out) do
				if out[x]["name"] == fingredient then
					if ezlib.debug then
						log(print .. "  Renurning false\n---------------------------------------------------------------------------------------------")
					end
					return true
				end
			end
			if ezlib.debug then
				log(print .. "  Renurning false\n---------------------------------------------------------------------------------------------")
			end
			return false
		else
			if ezlib.debug then
				log(print .. "  Renurning:" .. ezlib.log.print(out, 0) .. "\n---------------------------------------------------------------------------------------------")
			end
			return out
		end
	else
		log("  [Warning] Recipe with name " .. value .. " not found")
	end
end

function ezlib.recipe.find.ingredient (value)
	local print = "ezlib.recipe.find.ingredient\n---------------------------------------------------------------------------------------------\n"
	local recipe = data.raw.recipe
	local list = {}
	for x,ing in pairs(recipe) do
		if ezlib.recipe.ingredient.get({recipe_name = recipe[x].name, ingredient = value}) then
			table.insert(list, recipe[x].name)
		end 
	end
	if #list == 1 then
		list = list[1]
		print = print .. "  Found " .. #list .. " recipes.\n"
		print = print .. "\n  Renurning:"
		print = print .. ezlib.log.print(list, 0)
	elseif #list == 0 or not list then
		list = nil
		print = print .. "  [Warning] Found 0 recipes."
	else
		print = print .. "  Found " .. #list .. " recipes.\n"
		print = print .. "\n  Renurning:" .. list
	end
	log(print .. "\n---------------------------------------------------------------------------------------------")
	return list
end

function ezlib.recipe.find.result (value)
	local print = "ezlib.recipe.find.result\n---------------------------------------------------------------------------------------------\n"
	local recipe = data.raw.recipe
	local list = {}
	for x,ing in pairs(recipe) do
		if ezlib.recipe.result.get({recipe_name = recipe[x].name, ingredient = value}) then
			table.insert(list, recipe[x].name)
		end 
	end
	if #list == 1 then
		list = list[1]
		print = print .. "  Found " .. #list .. " recipes in type."
		print = print .. "\n  Renurning:"
		print = print .. ezlib.log.print(list, 0)
	elseif #list == 0 or not list then
		list = nil
		print = print .. "  [Warning] Found 0 recipes in type."
	else
		print = print .. "  Found " .. #list .. " recipes in type."
		print = print .. "\n  Renurning:" .. list
	end
	log(print .. "\n---------------------------------------------------------------------------------------------")
	return list
end

function ezlib.recipe.get.list (value)
	local freturn = 0
	local recipe = data.raw.recipe
	local list = {}
	local del_list = {}
	if recipe ~= nil then
		for x,ing in pairs(recipe) do
			table.insert(list, recipe[x].name)
		end
	end
	if value ~= nil and type(value) == "table" then
		for a,ing in pairs(value) do
			if value[a] ~= nil then
				if type(value[a]) == "string" then
					for x,ing2 in ipairs(list) do
						if recipe[list[x]][a] ~= value[a] or recipe[list[x]][a] == nil then
							table.insert(del_list, ing2)
						end
					end
				elseif type(value[a]) == "table" then
					for b,ing3 in pairs(value[a]) do
						if type(value[a][b]) == "string" then
							for c,ing2 in ipairs(list) do
								if recipe[list[x]][a][b] ~= value[a][b]  or recipe[list[x]][a][b] == nil then
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
	if ezlib.debug then	
		local print = ""
		print = print .. "ezlib.recipes.get.list\n---------------------------------------------------------------------------------------------\n"
		if type(list) == "table" then
			print = print .. "  Found " .. #list .. " recipes."
		elseif type(list) == "string" then
			print = print .. "  Found recipe " .. list .. "."
		else
			print = print .. "  [Warning] Found 0 recipes in type."
		end
		if type(list) == "table" then
			print = print .. "\n  List of recipes:"
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
