local function parse_part(key)
	if type(key) == "string" and string.sub(key,1,1) == "p" then
		return true,tonumber(string.sub(key,2))
	else
		return false,tonumber(key)
	end
end

function tvRP.playSound(dict, name)
	PlaySoundFrontend(-1, dict, name, false)
end

function tvRP.getModelPlayer()
	local ped = PlayerPedId()
	if GetEntityModel(ped) == GetHashKey('mp_m_freemode_01') then
		return 'mp_m_freemode_01'
	elseif GetEntityModel(ped) == GetHashKey('mp_f_freemode_01') then
		return 'mp_f_freemode_01'
	elseif GetEntityModel(ped) == GetHashKey('s_f_y_scrubs_01') then
		return 's_f_y_scrubs_01'
	end
end

function tvRP.getPositions()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	return vRPserver.mathLegth(coords.x), vRPserver.mathLegth(coords.y), vRPserver.mathLegth(coords.z), vRPserver.mathLegth(GetEntityHeading(ped))
end

function tvRP.getDrawables(part)
	local isprop, index = parse_part(part)
	if isprop then
		return GetNumberOfPedPropDrawableVariations(PlayerPedId(),index)
	else
		return GetNumberOfPedDrawableVariations(PlayerPedId(),index)
	end
end

function tvRP.applySkin(model)
	local mHash = model
	RequestModel(mHash)
	while not HasModelLoaded(mHash) do
		RequestModel(mHash)
		Citizen.Wait(10)
	end

	if HasModelLoaded(mHash) then
		SetPlayerModel(PlayerId(), mHash)
		SetModelAsNoLongerNeeded(mHash)
	end
	SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 2)
end

function tvRP.getCustomization()
	local ped = PlayerPedId()
	local custom = {}
	custom.modelhash = GetEntityModel(ped)

	for i = 0, 20 do
		custom[i] = {GetPedDrawableVariation(ped, i), GetPedTextureVariation(ped, i), GetPedPaletteVariation(ped, i)}
	end

	for i = 0, 10 do
		custom['p'..i] = {GetPedPropIndex(ped, i), math.max(GetPedPropTextureIndex(ped, i), 0)}
	end
	return custom
end