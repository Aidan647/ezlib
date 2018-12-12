ezlib.entity = {}
ezlib.entity.get = {}

function ezlib.entity.get.list (type,value)
	if type ~= nil then
		local entity = data.raw[type]
		local list = {}
		local del_list = {}
		for k,ing in pairs(entity) do
			table.insert(list, entity[k].name)
		end
		if value ~= nil and type(value) == "table" then
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
			del_list = ezlib.tbl.remove(list, del_list)
			if del_list ~= nil then
				if #del_list == 1 then
					del_list = del_list[1]
				end
				return del_list
			else
				return nil
			end
		end
		if #list == 1 then
			list = list[1]
		end
		return list
	end
end