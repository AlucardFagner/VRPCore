local playerReady = false

function tvRP.playerReady()
	playerReady = true
end

Citizen.CreateThread(function()
	NetworkSetFriendlyFireOption(true)
	SetCanAttackFriendly(PlayerPedId(), true, true)

	while true do
		if playerReady then
			local coords = GetEntityCoords(PlayerPedId())
			vRPserver._updatePositions(coords.x, coords.y, coords.z)
		end

		Citizen.Wait(10000)
	end
end)

Citizen.CreateThread(function()
	while true do
		if playerReady then
			vRPserver._updateHealth(GetEntityHealth(PlayerPedId()))
			vRPserver._updateArmour(GetPedArmour(PlayerPedId()))
		end

		Citizen.Wait(30000)
	end
end)

function tvRP.getHealth()
	return GetEntityHealth(PlayerPedId())
end

function tvRP.setHealth(health)
	SetEntityHealth(PlayerPedId(), parseInt(health))
end

function tvRP.updateHealth(number)
	local ped = PlayerPedId()
	local health = GetEntityHealth(ped)
	if health > 101 then
		SetEntityHealth(ped, parseInt(health + number))
	end
end

function tvRP.downHealth(number)
	local ped = PlayerPedId()
	local health = GetEntityHealth(ped)

	SetEntityHealth(ped, parseInt(health - number))
end

function tvRP.getArmour()
	return GetPedArmour(PlayerPedId())
end

function tvRP.setArmour(amount)
	local ped = PlayerPedId()
	local armour = GetPedArmour(ped)
	SetPedArmour(ped, parseInt(armour + amount))
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if IsPlayerPlaying(PlayerId()) and playerReady then
			--vRPserver._updateWeapons(tvRP.getWeapons())
		end
	end
end)