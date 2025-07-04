RegisterNetEvent("zSounds:source")
AddEventHandler("zSounds:source", function(sound, volume)
	SendNUIMessage({ transactionType = "playSound", transactionFile = sound, transactionVolume = volume })
end)

RegisterNetEvent("zSounds:distance")
AddEventHandler("zSounds:distance", function(playerid, maxdistance, sound, volume)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local coordsPed = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerid)))
	local distance = #(coords - coordsPed)

	if distance <= maxdistance then
		SendNUIMessage({ transactionType = "playSound", transactionFile = sound, transactionVolume = volume })
	end
end)

RegisterNetEvent("zSounds:fixed")
AddEventHandler("zSounds:fixed", function(playerid, x2, y2, z2, maxdistance, sound, volume)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local distance = #(coords - vector3(x2, y2, z2))
	if distance <= maxdistance then
		SendNUIMessage({ transactionType = "playSound", transactionFile = sound, transactionVolume = volume })
	end
end)