ezlib.recipe = {}
ezlib.recipe.ingredient = {}
ezlib.recipe.result = {}
ezlib.recipe.find = {}
ezlib.recipe.get = {}

function ezlib.recipe.ingredient.remove (value, ingredient)
	local recipe = table.deepcopy(data.raw.recipe[value])
	if recipe ~= nil then
		if recipe.normal ~= nil then
			local ingredients_normal = recipe.normal.ingredients
			for x,ing in ipairs(ingredients_normal) do
				if ingredients_normal[x][1] == ingredient or ingredients_normal[x]["name"] == ingredient then
					--ingredients_normal[x] = nil
					table.remove (ingredients_normal, x)
				end
			end
			data.raw.recipe[value].normal.ingredients = ingredients_normal
			local ingredients_expensive = recipe.expensive.ingredients
			for x,ing in ipairs(ingredients_expensive) do
				if ingredients_expensive[x][1] == ingredient or ingredients_expensive[x]["name"] == ingredient then
					--ingredients_expensive[x] = nil
					table.remove (ingredients_expensive, x)
				end
			end
			data.raw.recipe[value].expensive.ingredients = ingredients_normal
		else
			local ingredients = recipe.ingredients
			for x,ing in ipairs(ingredients) do
				if ingredients[x][1] == ingredient or ingredients[x]["name"] == ingredient then
					--ingredients[x] = nil
					table.remove (ingredients, x)
				end
			end
			data.raw.recipe[value].ingredients = ingredients
		end
	else
		log("Recipe with name " .. value .. " not found")
	end
end

function ezlib.recipe.ingredient.add (value, fingredient, famount, ftype)
	if ftype ~= nil and ftype ~= "item" or ftype == 1 then
		ftype = "fluid"
	else
		ftype = "item"
	end
	recipe = table.deepcopy(data.raw.recipe[value])
	if recipe ~= nil then
		if recipe.normal ~= nil then
			table.insert(recipe.normal.ingredients, {type=ftype, name=fingredient, amount=famount})
			table.insert(recipe.expensive.ingredients, {type=ftype, name=fingredient, amount=famount})
			data.raw.recipe[value].normal.ingredients = recipe.normal.ingredients
			data.raw.recipe[value].expensive.ingredients = recipe.expensive.ingredients
		else
			table.insert(recipe.ingredients, {type=ftype, name=fingredient, amount=famount})
			data.raw.recipe[value].ingredients = recipe.ingredients
		end
	else
		log("Recipe with name " .. value .. " not found")
	end
end

function ezlib.recipe.ingredient.replace (value, ingredient, fingredient, famount, ftype)
	if ftype ~= nil and ftype ~= "item" or ftype == 1 then
		ftype = "fluid"
	else
		ftype = "item"
	end
	ezlib.recipe.ingredient.remove (value, ingredient)
	ezlib.recipe.ingredient.add (value, fingredient, famount, ftype)
end

function ezlib.recipe.ingredient.get (value)
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
					return true
				end
			end
			return false
		else
			return out
		end
	else
		log("Recipe with name " .. value .. " not found")
	end
end


function ezlib.recipe.result.remove (value, ingredient)
	local recipe = table.deepcopy(data.raw.recipe[value])
	if recipe ~= nil then
		if recipe.normal ~= nil then
			if recipe.normal.result ~= nil then
				if recipe.normal.result == ingredient then
					data.raw.recipe[value].normal.result = nil 
				end
				if recipe.expensive.result == ingredient then
					data.raw.recipe[value].expensive.result = nil 
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
				local results_expensive = recipe.expensive.ingredients
				for x,ing in ipairs(ingredients_expensive) do
					if results_expensive[x][1] == ingredient or results_expensive[x]["name"] == ingredient then
						--ingredients_expensive[x] = nil
						table.remove (results_expensive, x)	
					end
				end
				data.raw.recipe[value].expensive.results = results_expensive
			end
		else
			if recipe.result == ingredient then
				data.raw.recipe[value].result = nil 
			else
				local results = recipe.results
				for x,ing in ipairs(results) do
					if results[x][1] == ingredient or results[x]["name"] == ingredient then
						--ingredients[x] = nil
						table.remove (results, x)
					end
				end
				data.raw.recipe[value].results = results
			end
		end
	else
		log("Recipe with name " .. value .. " not found")
	end
end

function ezlib.recipe.result.add (value, fingredient, famount, ftype)
	if ftype ~= nil and ftype ~= "item" or ftype == 1 then
		ftype = "fluid"
	else
		ftype = "item"
	end
	local recipe = table.deepcopy(data.raw.recipe[value])
	if recipe ~= nil then
		if recipe.normal ~= nil then
			if recipe.normal.results == nil then
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
				if recipe.normal.result ~= nil then
					table.insert(recipe.expensive.results, {type="item", name=recipe.expensive.result, amount=recipe.expensive.result_count or 1})
				end
			end
			table.insert(recipe.normal.results, {type=ftype, name=fingredient, amount=famount})
			table.insert(recipe.expensive.results, {type=ftype, name=fingredient, amount=famount})
			data.raw.recipe[value].normal.results = recipe.normal.results
			data.raw.recipe[value].expensive.results = recipe.expensive.results
		else
			if recipe.results == nil then
				recipe.results = {}
				data.raw.recipe[value].result = nil
				data.raw.recipe[value].icon = data.raw.item[value].icon
				data.raw.recipe[value].icon_size = data.raw.item[value].icon_size
				data.raw.recipe[value].subgroup = data.raw.item[value].subgroup
				if recipe.result ~= nil then
					table.insert(recipe.results, {type="item", name=recipe.result, amount=recipe.result_count or 1})
				end
			end
			if recipe.category == nil and ftype == "fluid" then data.raw.recipe[value].category = "crafting-with-fluid" end
			table.insert(recipe.results, {type=ftype, name=fingredient, amount=famount})
			data.raw.recipe[value].results = recipe.results
		end
	else
		log("Recipe with name " .. value .. " not found")
	end
end

function ezlib.recipe.result.replace (value, ingredient, fingredient, famount, ftype)
	if ftype ~= nil and ftype ~= "item" or ftype == 1 then
		ftype = "fluid"
	else
		ftype = "item"
	end
	ezlib.recipe.result.remove (value, ingredient)
	ezlib.recipe.result.add (value, fingredient, famount, ftype)
end

function ezlib.recipe.result.get (value)
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
					return true
				end
			end
			return false
		else
			return out
		end
	else
		log("Recipe with name " .. value .. " not found")
	end
end

function ezlib.recipe.find.ingredient (value)
	local recipe = data.raw.recipe
	local list = {}
	for x,ing in pairs(recipe) do
		if ezlib.recipe.ingredient.get({recipe_name = recipe[x].name, ingredient = value}) then
			table.insert(list, recipe[x].name)
		end 
	end
	if #list == 1 then
		list = list[1]
	end
	return list
end

function ezlib.recipe.find.result (value)
	local recipe = data.raw.recipe
	local list = {}
	for x,ing in pairs(recipe) do
		if ezlib.recipe.result.get({recipe_name = recipe[x].name, ingredient = value}) then
			table.insert(list, recipe[x].name)
		end 
	end
	if #list == 1 then
		list = list[1]
	end
	return list
end

function ezlib.recipe.get.list ()
	local recipe = data.raw.recipe
	local list = {}
	for x,ing in pairs(recipe) do
		table.insert(list, recipe[x].name)
	end
	if #list == 1 then
		list = list[1]
	end
	return list
end
