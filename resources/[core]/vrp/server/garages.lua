function vRP.vehicleGlobal()
	return vehicles.list[name]
end

function vRP.vehicleName(name)
	if vehicles.list[name] then
		return vehicles.list[name].name
	end
end

function vRP.vehicleChest(name)
	if vehicles.list[name] then
		return vehicles.list[name].weight
	end
end

function vRP.vehicleSlots(name)
	if vehicles.list[name] then
		return vehicles.list[name].slots
	end
end

function vRP.vehiclePrice(name)
	if vehicles.list[name] then
		return vehicles.list[name].price
	end
end

function vRP.vehicleType(name)
	if vehicles.list[name] then
		return vehicles.list[name].type
	end
end