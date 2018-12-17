function ezlib.remove (ftype, value)
	if not data.raw[ftype][value].icon and not data.raw[ftype][value].icons then
		log(data.raw[ftype][value].icon)
		data.raw[ftype][value].icon = "__core__/graphics/slot-icon-blueprint.png"
		log("  [Warning] " .. ftype .. " with name " .. value .. " has no icon adding...")
		data.raw[ftype][value].localised_description = "Icon not found"
	end
	if not data.raw[ftype][value].icon_size then
		data.raw[ftype][value].icon_size = 32
		log("  [Warning] " .. ftype .. " with name " .. value .. " has no icon_size adding...")
	end
end

local items = ezlib.item.get.list()
for x,y in ipairs(items) do
	ezlib.remove("item", y)
end
