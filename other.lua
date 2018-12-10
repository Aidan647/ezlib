ezlib.tbl = {}


function ezlib.log_tbl (tbl, indent)
	if not indent then indent = 0 end
	local toprint = string.rep(" ", indent) .. "{\r\n"
	indent = indent + 2 
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
end

function ezlib.tbl.remove(list1, list2)
	for x,ing in ipairs(list1) do
		if type(list2) ~= "string" then
			for y,ing in ipairs(list2) do
				if list1[x] == list2[y] then
					table.remove(list1, x)
					break
				end
			end
		else
			if list1[x] == list2 then
				table.remove(list1, x)
			end
		end
	end
	return list1
end

function ezlib.tbl.add(list1, list2)
	if type(list2) ~= "string" then
		for y,ing in ipairs(list2) do
			table.insert(list1, x)
		end
	else
		table.insert(list1, x)
	end
	return list1
end