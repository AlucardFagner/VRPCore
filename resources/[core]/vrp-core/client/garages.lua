function tvRP.getNearVehicles(radius)
	local r = {}
	local coords = GetEntityCoords(PlayerPedId())

	local vehs = {}
	local it, veh = FindFirstVehicle()
	if veh then
		table.insert(vehs, veh)
	end
	local ok
	repeat
		ok, veh = FindNextVehicle(it)
		if ok and veh then
			table.insert(vehs, veh)
		end
	until not ok
	EndFindVehicle(it)
	for _, veh in pairs(vehs) do
		local coordsVeh = GetEntityCoords(veh)
		local distance = #(coords - coordsVeh)
		if distance <= radius then
			r[veh] = distance
		end
	end
	return r
end

function tvRP.getNearVehicle(radius)
	local veh
	local vehs = tvRP.getNearVehicles(radius)
	local min = radius + 0.0001
	for _veh, dist in pairs(vehs) do
		if dist < min then
			min = dist
			veh = _veh
		end
	end
	return veh 
end

function tvRP.inVehicle()
	return IsPedSittingInAnyVehicle(PlayerPedId())
end

function tvRP.vehList(radius)
	local ped = PlayerPedId()
	local veh = GetVehiclePedIsUsing(ped)

	if not IsPedInAnyVehicle(ped) then
		veh = tvRP.getNearVehicle(radius)
	end

	if IsEntityAVehicle(veh) then
		local trunk = GetVehicleDoorAngleRatio(v, 5)
		local x, y, z = table.unpack(GetEntityCoords(ped))
		for k, v in pairs(vehicles.list) do
			if v.hash == GetEntityModel(veh) then
				if k then
					local tuning = { GetNumVehicleMods(veh, 13), GetNumVehicleMods(veh, 12), GetNumVehicleMods(veh, 15), GetNumVehicleMods(veh, 11), GetNumVehicleMods(veh, 16) }
					return veh, VehToNet(veh), GetVehicleNumberPlateText(veh), k, GetVehicleDoorsLockedForPlayer(veh, PlayerId()), v.banned, trunk, GetDisplayNameFromVehicleModel(k), GetStreetNameFromHashKey(GetStreetNameAtCoord(x, y, z)), tuning
				end
			end
		end
	end
end

function tvRP.vehiclePlate()
	local ped = PlayerPedId()
	local veh = GetVehiclePedIsUsing(ped)
	if IsEntityAVehicle(veh) then
		return GetVehicleNumberPlateText(veh)
	end
end

function tvRP.getModelName(veh)
	if IsEntityAVehicle(veh) then
		local modelName = nil
		for k, v in pairs(vehicles.list) do
			if v.hash == GetEntityModel(veh) then
				modelName = k
			end
		end
		return modelName
	end
end