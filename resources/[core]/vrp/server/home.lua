function vRP.updateHomePosition(user_id,x,y,z)
	if user_id then
		local data = vRP.getUserDataTable(user_id)
		if data then
			data.position = { x = tvRP.mathLegth(x), y = tvRP.mathLegth(y), z = tvRP.mathLegth(z) }
		end
	end
end

function vRP.housesList()
	return homes.list
end

function vRP.housesName(name)
	return homes.list[name]
end

function vRP.housesType(name)
	return homes.list[name].type
end

function vRP.housesPrice(name)
	return homes.list[name].price
end

function vRP.housesResidents(name)
	return homes.list[name].residents
end

function vRP.housesWeight(name)
	return homes.list[name].weight
end

function vRP.housesMaxWeight(name)
	return homes.list[name].maxweight
end

function vRP.housesSlots(name)
	return homes.list[name].slots
end

function vRP.housesMaxSlots(name)
	return homes.list[name].maxslots
end

function vRP.housesCoords(name)
	return homes.list[name].x, homes.list[name].y, homes.list[name].z
end