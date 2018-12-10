ezlib.item = {}
ezlib.item.get = {}

function ezlib.item.get.list ()
	local item = data.raw.item
	local list = {}
	for x,ing in pairs(item) do
		table.insert(list, item[x].name)
	end
	if #list == 1 then
		list = list[1]
	end
	return list
end