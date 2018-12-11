ezlib.tbl = {}
ezlib.hidden = {}


function ezlib.log_tbl (tbl, indent)
	if not indent then indent = 0 end
	local toprint = string.rep(" ", indent) .. "{\r\n"
	indent = indent + 2 
	if type(tbl) == "table" then
		for k, v in pairs(tbl) do
			toprint = toprint .. string.rep(" ", indent)
			if (type(k) == "number") then
				toprint = toprint .. "[" .. k .. "] = "
			elseif (type(k) == "string") then
				toprint = toprint	.. k ..	" = "
			end
			if (type(v) == "number") then
				toprint = toprint .. v .. ",\r\n"
			elseif (type(v) == "string") then
				toprint = toprint .. "" .. v .. ",\r\n"
			elseif (type(v) == "table") then
				toprint = toprint .. ezlib.log_tbl(v, indent + 2) .. ",\r\n"
			else
				toprint = toprint .. "" .. tostring(v) .. ",\r\n"
			end
		end	
		toprint = toprint .. string.rep(" ", indent-2) .. "}"
		log(toprint)
	else
		log(tbl)
	end
end

function ezlib.tbl.remove(list1, list2)
	if list2 ~= nil then
		local list3 = {}
		for x,ing in ipairs(list1) do
			table.insert(list3, ing)
		end
		local z = 0
		for x,ing in ipairs(list1) do
			if type(list2) ~= "string" then
				for y,ing2 in pairs(list2) do
					if ing == ing2 then
						table.remove(list3, (x - z))
						z = z + 1
						break
					end
				end
			else
				if list1[x] == list2 then
					table.remove(list, x)
				end
			end
		end
		return list3
	else
		return list1
	end
end

function ezlib.tbl.add(list1, list2, list3, list4, list5)
	local list = {}	
	if list1 ~= nil and type(list1) == "table" then
		for y,ing in pairs(list1) do
			table.insert(list, ing)
		end
	elseif type(list1) == "string" then
		table.insert(list, list1)
	end	

	if list2 ~= nil and type(list2) == "table" then
		for y,ing in pairs(list2) do
			table.insert(list, ing)
		end
	elseif type(list2) == "string" then
		table.insert(list, list2)
	end	

	if list3 ~= nil and type(list3) == "table" then
		for y,ing in pairs(list3) do
			table.insert(list, ing)
		end
	elseif type(list3) == "string" then
		table.insert(list, list3)
	end

	if list4 ~= nil and type(list) == "table" then
		for y,ing in pairs(list) do
			table.insert(list, ing)
		end
	elseif type(list) == "string" then
		table.insert(list, list)
	end

	if list5 ~= nil and type(list5) == "table" then
		for y,ing in pairs(list5) do
			table.insert(list, ing)
		end
	elseif type(list5) == "string" then
		table.insert(list, list5)
	end
	return list
end