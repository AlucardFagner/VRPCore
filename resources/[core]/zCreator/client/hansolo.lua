RegisterNetEvent('zCreator:normalSpawn')
RegisterNetEvent('zCreator:characterCreate')

local cam = nil
local freezedOnTop = true
local doStatus = -1
local continuousFadeOutNetwork = false
local altura
local sub_b0b5 = {
    [0] = 'MP_Plane_Passenger_1',
    [1] = 'MP_Plane_Passenger_2',
    [2] = 'MP_Plane_Passenger_3',
    [3] = 'MP_Plane_Passenger_4',
    [4] = 'MP_Plane_Passenger_5',
    [5] = 'MP_Plane_Passenger_6',
    [6] = 'MP_Plane_Passenger_7'
}

RegisterCommand('zcreator',function(source)
	TriggerCreateCharacter()
end)

function sub_b747(ped, a_1)
    if a_1 == 0 then
        SetPedComponentVariation(ped, 0, 21, 0, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 9, 0, 0)
        SetPedComponentVariation(ped, 3, 1, 0, 0)
        SetPedComponentVariation(ped, 4, 9, 0, 0)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 4, 8, 0)
        SetPedComponentVariation(ped, 7, 0, 0, 0)
        SetPedComponentVariation(ped, 8, 15, 0, 0)
        SetPedComponentVariation(ped, 9, 0, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 10, 0, 0)
        ClearPedProp(ped, 0)
        ClearPedProp(ped, 1)
        ClearPedProp(ped, 2)
        ClearPedProp(ped, 3)
        ClearPedProp(ped, 4)
        ClearPedProp(ped, 5)
        ClearPedProp(ped, 6)
        ClearPedProp(ped, 7)
        ClearPedProp(ped, 8)
    elseif a_1 == 1 then
        SetPedComponentVariation(ped, 0, 13, 0, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 5, 4, 0)
        SetPedComponentVariation(ped, 3, 1, 0, 0)
        SetPedComponentVariation(ped, 4, 10, 0, 0)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 10, 0, 0)
        SetPedComponentVariation(ped, 7, 11, 2, 0)
        SetPedComponentVariation(ped, 8, 13, 6, 0)
        SetPedComponentVariation(ped, 9, 0, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 10, 0, 0)
        ClearPedProp(ped, 0)
        ClearPedProp(ped, 1)
        ClearPedProp(ped, 2)
        ClearPedProp(ped, 3)
        ClearPedProp(ped, 4)
        ClearPedProp(ped, 5)
        ClearPedProp(ped, 6)
        ClearPedProp(ped, 7)
        ClearPedProp(ped, 8)
    elseif a_1 == 2 then
        SetPedComponentVariation(ped, 0, 15, 0, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 1, 4, 0)
        SetPedComponentVariation(ped, 3, 1, 0, 0)
        SetPedComponentVariation(ped, 4, 0, 1, 0)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 1, 7, 0)
        SetPedComponentVariation(ped, 7, 0, 0, 0)
        SetPedComponentVariation(ped, 8, 2, 9, 0)
        SetPedComponentVariation(ped, 9, 0, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 6, 0, 0)
        ClearPedProp(ped, 0)
        ClearPedProp(ped, 1)
        ClearPedProp(ped, 2)
        ClearPedProp(ped, 3)
        ClearPedProp(ped, 4)
        ClearPedProp(ped, 5)
        ClearPedProp(ped, 6)
        ClearPedProp(ped, 7)
        ClearPedProp(ped, 8)
    elseif a_1 == 3 then
        SetPedComponentVariation(ped, 0, 14, 0, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 5, 3, 0)
        SetPedComponentVariation(ped, 3, 3, 0, 0)
        SetPedComponentVariation(ped, 4, 1, 6, 0)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 11, 5, 0)
        SetPedComponentVariation(ped, 7, 0, 0, 0)
        SetPedComponentVariation(ped, 8, 2, 0, 0)
        SetPedComponentVariation(ped, 9, 0, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 3, 12, 0)
        ClearPedProp(ped, 0)
        ClearPedProp(ped, 1)
        ClearPedProp(ped, 2)
        ClearPedProp(ped, 3)
        ClearPedProp(ped, 4)
        ClearPedProp(ped, 5)
        ClearPedProp(ped, 6)
        ClearPedProp(ped, 7)
        ClearPedProp(ped, 8)
    elseif a_1 == 4 then
        SetPedComponentVariation(ped, 0, 18, 0, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 15, 3, 0)
        SetPedComponentVariation(ped, 3, 15, 0, 0)
        SetPedComponentVariation(ped, 4, 2, 5, 0)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 4, 6, 0)
        SetPedComponentVariation(ped, 7, 4, 0, 0)
        SetPedComponentVariation(ped, 8, 3, 0, 0)
        SetPedComponentVariation(ped, 9, 0, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 4, 0, 0)
        ClearPedProp(ped, 0)
        ClearPedProp(ped, 1)
        ClearPedProp(ped, 2)
        ClearPedProp(ped, 3)
        ClearPedProp(ped, 4)
        ClearPedProp(ped, 5)
        ClearPedProp(ped, 6)
        ClearPedProp(ped, 7)
        ClearPedProp(ped, 8)
    elseif a_1 == 5 then
        SetPedComponentVariation(ped, 0, 27, 0, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 7, 3, 0)
        SetPedComponentVariation(ped, 3, 11, 0, 0)
        SetPedComponentVariation(ped, 4, 4, 8, 0)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 13, 14, 0)
        SetPedComponentVariation(ped, 7, 5, 3, 0)
        SetPedComponentVariation(ped, 8, 3, 0, 0)
        SetPedComponentVariation(ped, 9, 0, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 2, 7, 0)
        ClearPedProp(ped, 0)
        ClearPedProp(ped, 1)
        ClearPedProp(ped, 2)
        ClearPedProp(ped, 3)
        ClearPedProp(ped, 4)
        ClearPedProp(ped, 5)
        ClearPedProp(ped, 6)
        ClearPedProp(ped, 7)
        ClearPedProp(ped, 8)
    elseif a_1 == 6 then
        SetPedComponentVariation(ped, 0, 16, 0, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 15, 1, 0)
        SetPedComponentVariation(ped, 3, 3, 0, 0)
        SetPedComponentVariation(ped, 4, 5, 6, 0)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 2, 8, 0)
        SetPedComponentVariation(ped, 7, 0, 0, 0)
        SetPedComponentVariation(ped, 8, 2, 0, 0)
        SetPedComponentVariation(ped, 9, 0, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 3, 7, 0)
        ClearPedProp(ped, 0)
        ClearPedProp(ped, 1)
        ClearPedProp(ped, 2)
        ClearPedProp(ped, 3)
        ClearPedProp(ped, 4)
        ClearPedProp(ped, 5)
        ClearPedProp(ped, 6)
        ClearPedProp(ped, 7)
        ClearPedProp(ped, 8)
    end
end

function f(n)
	n = n + 0.00000
	return n
end

function setCamHeight(height)
	local pos = GetEntityCoords(PlayerPedId())
	SetCamCoord(cam, vector3(pos.x, pos.y, f(height)))
end

local function StartFade()
	DoScreenFadeOut(500)
	while IsScreenFadingOut() do
		Citizen.Wait(1)
	end
end

local function EndFade()
	ShutdownLoadingScreen()
	DoScreenFadeIn(500)
	while IsScreenFadingIn() do
		Citizen.Wait(1)
	end
end



Citizen.CreateThread(function()
	while freezedOnTop do
		if doStatus == 1 then
			SetEntityInvincible(PlayerPedId(), true)
			SetEntityVisible(PlayerPedId(), true)
			FreezeEntityPosition(PlayerPedId(), true)
			SetPedDiesInWater(PlayerPedId(), false)
		elseif doStatus == 2 then
			TriggerCamController(doStatus)
			SetEntityInvincible(PlayerPedId(), false)
			SetEntityVisible(PlayerPedId(), true)
			FreezeEntityPosition(PlayerPedId(), false)
			SetPedDiesInWater(PlayerPedId(), true)
			TriggerCamController(-2)
			freezedOnTop = false
		else
			SetEntityInvincible(PlayerPedId(), true)
			SetEntityVisible(PlayerPedId(), true)
			FreezeEntityPosition(PlayerPedId(), true)
		end
		Citizen.Wait(1)
	end
end)

function TriggerCamController(statusSent)
	if not DoesCamExist(cam) then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', false)
	end

	if statusSent == -1 then
		local pos = GetEntityCoords(PlayerPedId())
		SetCamCoord(cam, vector3(pos.x, pos.y, f(1000)))
		SetCamRot(cam, -f(90), f(0), f(0), 2)
		SetCamActive(cam, true)
		StopCamPointing(cam)
		RenderScriptCams(true, true, 0, 0, 0, 0)
	elseif statusSent == 2 then
		local pos = GetEntityCoords(PlayerPedId())
		SetCamCoord(cam, vector3(pos.x, pos.y, f(1000)))
		altura = 1000
		while altura > 50 do
			if altura <= 300 then
				altura = altura - 6
			elseif altura >= 301 and altura <= 700 then
				altura = altura - 4
			else
				altura = altura - 2
			end
			setCamHeight(altura)
			Citizen.Wait(10)
		end
	elseif statusSent == -2 then
		SetCamActive(cam, false)
		StopCamPointing(cam)
		RenderScriptCams(0, 0, 0, 0, 0, 0)
		SetFocusEntity(PlayerPedId())
	elseif statusSent == 1 then
		SetCamCoord(cam, vector3(402.6, -997.2, -98.3))
		SetCamRot(cam, f(0), f(0), f(358), 15)
		SetCamActive(cam, true)
		RenderScriptCams(true, true, 600, 0, 0, 0)
	end
end

RegisterNetEvent('ToogleBackCharacter')
AddEventHandler('ToogleBackCharacter', function()
	doStatus = 2
end)

AddEventHandler('zCreator:characterCreate', function()
	doStatus = 1
	SetTimeout(1000, function()
		TriggerCreateCharacter()
	end)
end)

AddEventHandler('zCreator:normalSpawn', function(firstspawn, cutscene)
	if firstspawn then
		TriggerCamController(-2)
		EndFade()
		doStatus = 2
		TriggerEvent('zLogin:Spawn', firstspawn, cutscene)
	else
		freezedOnTop = true
		doStatus = 2				
		TriggerEvent('zLogin:Spawn', firstspawn, cutscene)
	end
end)

local isInCharacterMode = false
local currentCharacterMode = { fathersID = 0, mothersID = 0, skinColor = 0, shapeMix = 0.0, eyesColor = 0, eyebrowsHeight = 0, eyebrowsWidth = 0, noseWidth = 0, noseHeight = 0, noseLength = 0, noseBridge = 0, noseTip = 0, noseShift = 0, cheekboneHeight = 0, cheekboneWidth = 0, cheeksWidth = 0, lips = 0, jawWidth = 0, jawHeight = 0, chinLength = 0, chinPosition = 0, chinWidth = 0, chinShape = 0, neckWidth = 0, hairModel = 4, firstHairColor = 0, secondHairColor = 0, eyebrowsModel = 0, eyebrowsColor = 0, beardModel = -1, beardColor = 0, chestModel = -1, chestColor = 0, blushModel = -1, blushColor = 0, lipstickModel = -1, lipstickColor = 0, blemishesModel = -1, ageingModel = -1, complexionModel = -1, sundamageModel = -1, frecklesModel = -1, makeupModel = -1 }
local characterName = ''
local characterFirstname = ''

function TriggerCreateCharacter()
	TriggerCamController(-1)
	isInCharacterMode = true
	StartFade()
	continuousFadeOutNetwork = true
	TriggerCamController(-2)
	changeGender('mp_m_freemode_01')
	refreshDefaultCharacter()
	TaskUpdateSkinOptions()
	TaskUpdateFaceOptions()
	TaskUpdateHeadOptions()
	SetEntityCoordsNoOffset(PlayerPedId(), config.creatorCoord[1], config.creatorCoord[2], config.creatorCoord[3], true, true, true) 
	SetEntityHeading(PlayerPedId(), f(180))
	TriggerCamController(doStatus)
	Citizen.Wait(1000)
	SetNuiFocus(isInCharacterMode, isInCharacterMode)
	SendNUIMessage({ CharacterMode = isInCharacterMode, CharacterMode2 = not isInCharacterMode, CharacterMode3 = not isInCharacterMode })
	EndFade()
end

function refreshDefaultCharacter()
	SetPedDefaultComponentVariation(PlayerPedId())
	ClearAllPedProps(PlayerPedId())
	if GetEntityModel(PlayerPedId()) == GetHashKey('mp_m_freemode_01') then
		SetPedComponentVariation(PlayerPedId(), 1, -1, 0, 2)
		SetPedComponentVariation(PlayerPedId(), 5, -1, 0, 2)
		SetPedComponentVariation(PlayerPedId(), 7, -1, 0, 2)
		SetPedComponentVariation(PlayerPedId(), 3, 15, 0, 2)
		SetPedComponentVariation(PlayerPedId(), 4, 61, 0, 2)
		SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2)
		SetPedComponentVariation(PlayerPedId(), 6, 16, 0, 2)
		SetPedComponentVariation(PlayerPedId(), 11, 104, 0, 2)
		SetPedComponentVariation(PlayerPedId(), 9, -1, 0, 2)
		SetPedComponentVariation(PlayerPedId(), 10, -1, 0, 2)
		SetPedPropIndex(PlayerPedId(), 2, -1, 0, 2)
		SetPedPropIndex(PlayerPedId(), 6, -1, 0, 2)
		SetPedPropIndex(PlayerPedId(), 7, -1, 0, 2)
	else
		SetPedComponentVariation(PlayerPedId(), 1, -1, 0, 2)
		SetPedComponentVariation(PlayerPedId(), 5, -1, 0, 2)
		SetPedComponentVariation(PlayerPedId(), 7, -1, 0, 2)
		SetPedComponentVariation(PlayerPedId(), 3, 15, 0, 2)
		SetPedComponentVariation(PlayerPedId(), 4, 15, 0, 2)
		SetPedComponentVariation(PlayerPedId(), 8, 7, 0, 2)
		SetPedComponentVariation(PlayerPedId(), 6, 5, 0, 2)
		SetPedComponentVariation(PlayerPedId(), 11, 5, 0, 2)
		SetPedComponentVariation(PlayerPedId(), 9, -1, 0, 2)
		SetPedComponentVariation(PlayerPedId(), 10, -1, 0, 2)
		SetPedPropIndex(PlayerPedId(), 2, -1, 0, 2)
		SetPedPropIndex(PlayerPedId(), 6, -1, 0, 2)
		SetPedPropIndex(PlayerPedId(), 7, -1, 0, 2)
	end
end

function changeGender(model)
	local mhash = GetHashKey(model)
	while not HasModelLoaded(mhash) do
		RequestModel(mhash)
		Citizen.Wait(10)
	end

	if HasModelLoaded(mhash) then
		SetPlayerModel(PlayerId(), mhash)
		SetPedMaxHealth(PlayerPedId(), 400)
        SetEntityHealth(PlayerPedId(), 400)
		SetModelAsNoLongerNeeded(mhash)
	end
end

function whatIsGender(ped)
	if IsPedModel(ped, 'mp_m_freemode_01') then
		return true
	else
		return false
	end
end

Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(1)
		if continuousFadeOutNetwork then 
			for id = 0, 256 do
				if id ~= PlayerId() and NetworkIsPlayerActive(id) then
					NetworkFadeOutEntity(GetPlayerPed(id), false)
				end
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

RegisterNUICallback('cDoneSave', function(data, cb)
	StartFade()
	DoScreenFadeOut(0)
	isInCharacterMode = false
	SetNuiFocus(isInCharacterMode, isInCharacterMode)
	SendNUIMessage({ CharacterMode = isInCharacterMode, CharacterMode2 = isInCharacterMode, CharacterMode3 = isInCharacterMode })
	if GetEntityModel(PlayerPedId()) == GetHashKey('mp_m_freemode_01') then
		local outfit = math.random(3)
		if outfit == 1 then
			SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 5, 42, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 3, 0, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 4, 15, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 6, 36, 2, 2)
			SetPedComponentVariation(PlayerPedId(), 11, 135, 3, 2)
			SetPedComponentVariation(PlayerPedId(), 9, 0, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 10, 0, 0, 2)
			SetPedPropIndex(PlayerPedId(), 0, -1, 0, 2)
			SetPedPropIndex(PlayerPedId(), 1, 10, 3, 2)
			SetPedPropIndex(PlayerPedId(), 2, 33, 0, 2)
			SetPedPropIndex(PlayerPedId(), 6, 4, 0, 2)
			SetPedPropIndex(PlayerPedId(), 7, -1, 0, 2)
		elseif outfit == 2 then
			SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 5, 42, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 3, 8, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 4, 78, 4, 2)
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 6, 42, 1, 2)
			SetPedComponentVariation(PlayerPedId(), 11, 38, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 9, 0, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 10, 0, 0, 2)
			SetPedPropIndex(PlayerPedId(), 0, -1, 0, 2)
			SetPedPropIndex(PlayerPedId(), 1, 19, 0, 2)
			SetPedPropIndex(PlayerPedId(), 2, 33, 0, 2)
			SetPedPropIndex(PlayerPedId(), 6, 4, 0, 2)
			SetPedPropIndex(PlayerPedId(), 7, -1, 0, 2)
		elseif outfit == 3 then
			SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 5, 42, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 3, 12, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 4, 24, 6, 2)
			SetPedComponentVariation(PlayerPedId(), 8, 60, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 6, 8, 7, 2)
			SetPedComponentVariation(PlayerPedId(), 11, 59, 2, 2)
			SetPedComponentVariation(PlayerPedId(), 9, 0, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 10, 0, 0, 2)
			SetPedPropIndex(PlayerPedId(), 0, -1, 0, 2)
			SetPedPropIndex(PlayerPedId(), 1, 4, 9, 2)
			SetPedPropIndex(PlayerPedId(), 2, 33, 0, 2)
			SetPedPropIndex(PlayerPedId(), 6, -1, 0, 2)
			SetPedPropIndex(PlayerPedId(), 7, -1, 0, 2)
		end
	else
		local outfit = math.random(3)
		if outfit == 1 then
			SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 5, 43, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 3, 5, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 4, 54, 2, 2)
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 6, 1, 1, 2)
			SetPedComponentVariation(PlayerPedId(), 11, 192, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 9, -1, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 10, -1, 0, 2)
			SetPedPropIndex(PlayerPedId(), 0, -1, 0, 2)
			SetPedPropIndex(PlayerPedId(), 1, -1, 0, 2)
			SetPedPropIndex(PlayerPedId(), 2, -1, 0, 2)
			SetPedPropIndex(PlayerPedId(), 6, -1, 0, 2)
			SetPedPropIndex(PlayerPedId(), 7, -1, 0, 2)
		elseif outfit == 2 then
			SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 5, 43, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 3, 14, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 4, 80, 4, 2)
			SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 6, 1, 7, 2)
			SetPedComponentVariation(PlayerPedId(), 11, 141, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 9, -1, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 10, -1, 0, 2)
			SetPedPropIndex(PlayerPedId(), 0, -1, 0, 2)
			SetPedPropIndex(PlayerPedId(), 1, -1, 0, 2)
			SetPedPropIndex(PlayerPedId(), 2, -1, 0, 2)
			SetPedPropIndex(PlayerPedId(), 6, -1, 0, 2)
			SetPedPropIndex(PlayerPedId(), 7, -1, 0, 2)
		elseif outfit == 3 then
			SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 5, 43, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 7, 0, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 3, 1, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 4, 62, 6, 2)
			SetPedComponentVariation(PlayerPedId(), 8, 163, 16, 2)
			SetPedComponentVariation(PlayerPedId(), 6, 19, 7, 2)
			SetPedComponentVariation(PlayerPedId(), 11, 1, 9, 2)
			SetPedComponentVariation(PlayerPedId(), 9, -1, 0, 2)
			SetPedComponentVariation(PlayerPedId(), 10, -1, 0, 2)
			SetPedPropIndex(PlayerPedId(), 0, -1, 0, 2)
			SetPedPropIndex(PlayerPedId(), 1, -1, 0, 2)
			SetPedPropIndex(PlayerPedId(), 2, -1, 0, 2)
			SetPedPropIndex(PlayerPedId(), 6, -1, 0, 2)
			SetPedPropIndex(PlayerPedId(), 7, -1, 0, 2)
		end
	end

	SetEntityCoordsNoOffset(PlayerPedId(), config.spawnCoord[1], config.spawnCoord[2], config.spawnCoord[3], true, true, true)
	SetEntityHeading(PlayerPedId(), f(158.62))
	
	TriggerServerEvent('zCreator:finishedCharacter', characterName, characterFirstname, currentCharacterMode)
	doStatus = 2
	TriggerEvent('prepareToCinematic')
end)

RegisterCommand('start', function()
	TriggerEvent('prepareToCinematic')
end)

RegisterNetEvent('prepareToCinematic')
AddEventHandler('prepareToCinematic', function()
	TriggerEvent('introCinematic')
	Wait(31520)
	DoScreenFadeOut(0)
	Wait(500)
	SetEntityCoordsNoOffset(PlayerPedId(), config.spawnCoord[1], config.spawnCoord[2], config.spawnCoord[3], true, true, true)
	SetEntityHeading(PlayerPedId(), f(158.62))
	DoScreenFadeIn(2000)
end)

RegisterNetEvent('introCinematic')
AddEventHandler('introCinematic', function()
	PrepareMusicEvent('FM_INTRO_START')
	TriggerMusicEvent('FM_INTRO_START')

	if whatIsGender(PlayerPedId()) then
		RequestCutsceneWithPlaybackList('MP_INTRO_CONCAT', 31, 8)
	else	
		RequestCutsceneWithPlaybackList('MP_INTRO_CONCAT', 103, 8)
	end

	while not HasCutsceneLoaded() do 
		Wait(10) 
	end

	if whatIsGender(PlayerPedId()) then
		RegisterEntityForCutscene(0, 'MP_Male_Character', 3, GetEntityModel(PlayerPedId()), 0)
		RegisterEntityForCutscene(PlayerPedId(), 'MP_Male_Character', 0, 0, 0)
		SetCutsceneEntityStreamingFlags('MP_Male_Character', 0, 1) 
		local female = RegisterEntityForCutscene(0,'MP_Female_Character',3,0,64) 
		NetworkSetEntityInvisibleToNetwork(female, true)
	else
		RegisterEntityForCutscene(0, 'MP_Female_Character', 3, GetEntityModel(PlayerPedId()), 0)
		RegisterEntityForCutscene(PlayerPedId(), 'MP_Female_Character', 0, 0, 0)
		SetCutsceneEntityStreamingFlags('MP_Female_Character', 0, 1) 
		local male = RegisterEntityForCutscene(0,'MP_Male_Character',3,0,64) 
		NetworkSetEntityInvisibleToNetwork(male, true)
	end
	
	local ped = {}

	for v_3 = 0, 6, 1 do
		
		if v_3 == 1 or v_3 == 2 or v_3 == 4 or v_3 == 6 then
			ped[v_3] = CreatePed(26, 'mp_f_freemode_01', -1117.77783203125, -1557.6248779296875, 3.3819, 0.0, 0, 0)
		else
			ped[v_3] = CreatePed(26, 'mp_m_freemode_01', -1117.77783203125, -1557.6248779296875, 3.3819, 0.0, 0, 0)
		end

        if not IsEntityDead(ped[v_3]) then
			sub_b747(ped[v_3], v_3)
            FinalizeHeadBlend(ped[v_3])
            RegisterEntityForCutscene(ped[v_3], sub_b0b5[v_3], 0, 0, 64)
			SetEntityVisible(ped[v_3], false)
        end
    end
	
	NewLoadSceneStartSphere(-1212.79, -1673.52, 7, 1000, 0)
    SetWeatherTypeNow('EXTRASUNNY')
    StartCutscene(0)
	local cutScene = GetCutsceneTotalDuration()
	Wait(38290)
	final()

	for v_3 = 0, 6, 1 do
		DeleteEntity(ped[v_3])
	end

	PrepareMusicEvent('AC_STOP')
	TriggerMusicEvent('AC_STOP')
end)

function final()
	StopCutsceneImmediately()
	DoScreenFadeOut(0)
	Wait(1000)
	SetEntityCoordsNoOffset(PlayerPedId(), config.spawnCoord[1], config.spawnCoord[2], config.spawnCoord[3], true, true, true)
	SetEntityHeading(PlayerPedId(), f(324.92))
	Wait(2000)
	DoScreenFadeIn(6000)
	continuousFadeOutNetwork = false
	TriggerEvent('zHud:changeHudOnOff', true)
	for id = 0, 256 do
		if id ~= PlayerId() and NetworkIsPlayerActive(id) then
			NetworkFadeInEntity(GetPlayerPed(id), true)
		end
	end
end

RegisterNUICallback('cChangeHeading', function(data, cb)
	SetEntityHeading(PlayerPedId(), f(data.camRotation))
	cb('ok')
end)

RegisterNUICallback('ChangeGender', function(data, cb)
	currentCharacterMode.gender = tonumber(data.gender)
	if tonumber(data.gender) == 1 then
		changeGender('mp_f_freemode_01')
	else
		changeGender('mp_m_freemode_01')
	end
	refreshDefaultCharacter()
	TaskUpdateSkinOptions()
	TaskUpdateFaceOptions()
	TaskUpdateHeadOptions()
	cb('ok')
end)

RegisterNUICallback('UpdateSkinOptions', function(data, cb)
	currentCharacterMode.fathersID = data.fathersID
	currentCharacterMode.mothersID = data.mothersID
	currentCharacterMode.skinColor = data.skinColor
	currentCharacterMode.shapeMix = data.shapeMix
	characterName = data.characterName
	characterFirstname = data.characterFirstname
	TaskUpdateSkinOptions()
	cb('ok')
end)

function TaskUpdateSkinOptions()
	local data = currentCharacterMode
	SetPedHeadBlendData(PlayerPedId(), data.fathersID, data.mothersID, 0, data.skinColor, 0, 0, f(data.shapeMix), 0, 0, false)
end

RegisterNUICallback('UpdateFaceOptions', function(data, cb)
	currentCharacterMode.eyesColor = data.eyesColor
	currentCharacterMode.eyebrowsHeight = data.eyebrowsHeight
	currentCharacterMode.eyebrowsWidth = data.eyebrowsWidth
	currentCharacterMode.noseWidth = data.noseWidth
	currentCharacterMode.noseHeight = data.noseHeight
	currentCharacterMode.noseLength = data.noseLength
	currentCharacterMode.noseBridge = data.noseBridge
	currentCharacterMode.noseTip = data.noseTip
	currentCharacterMode.noseShift = data.noseShift
	currentCharacterMode.cheekboneHeight = data.cheekboneHeight
	currentCharacterMode.cheekboneWidth = data.cheekboneWidth
	currentCharacterMode.cheeksWidth = data.cheeksWidth
	currentCharacterMode.lips = data.lips
	currentCharacterMode.jawWidth = data.jawWidth
	currentCharacterMode.jawHeight = data.jawHeight
	currentCharacterMode.chinLength = data.chinLength
	currentCharacterMode.chinPosition = data.chinPosition
	currentCharacterMode.chinWidth = data.chinWidth
	currentCharacterMode.chinShape = data.chinShape
	currentCharacterMode.neckWidth = data.neckWidth
	TaskUpdateFaceOptions()
	cb('ok')
end)

function TaskUpdateFaceOptions()
	local ped = PlayerPedId()
	local data = currentCharacterMode

	SetPedEyeColor(ped, data.eyesColor)

	SetPedFaceFeature(ped, 6, data.eyebrowsHeight)
	SetPedFaceFeature(ped, 7, data.eyebrowsWidth)

	SetPedFaceFeature(ped, 0, data.noseWidth)
	SetPedFaceFeature(ped, 1, data.noseHeight)
	SetPedFaceFeature(ped, 2, data.noseLength)
	SetPedFaceFeature(ped, 3, data.noseBridge)
	SetPedFaceFeature(ped, 4, data.noseTip)
	SetPedFaceFeature(ped, 5, data.noseShift)

	SetPedFaceFeature(ped, 8, data.cheekboneHeight)
	SetPedFaceFeature(ped, 9, data.cheekboneWidth)
	SetPedFaceFeature(ped, 10, data.cheeksWidth)

	SetPedFaceFeature(ped, 12, data.lips)
	SetPedFaceFeature(ped, 13, data.jawWidth)
	SetPedFaceFeature(ped, 14, data.jawHeight)

	SetPedFaceFeature(ped, 15, data.chinLength)
	SetPedFaceFeature(ped, 16, data.chinPosition)
	SetPedFaceFeature(ped, 17, data.chinWidth)
	SetPedFaceFeature(ped, 18, data.chinShape)

	SetPedFaceFeature(ped, 19, data.neckWidth)
end

RegisterNUICallback('UpdateHeadOptions', function(data, cb)
	currentCharacterMode.hairModel = data.hairModel
	currentCharacterMode.hairfade = data.hairfade

	local hairf = config.hairfades[tonumber(data.hairfade)]
    currentCharacterMode.hairfadedlc = hairf and hairf.dlc or nil
    currentCharacterMode.hairfadetexture = hairf and hairf.texture or nil

	currentCharacterMode.firstHairColor = data.firstHairColor
	currentCharacterMode.secondHairColor = data.secondHairColor
	currentCharacterMode.eyebrowsModel = data.eyebrowsModel
	currentCharacterMode.eyebrowsColor = data.eyebrowsColor
	currentCharacterMode.beardModel = data.beardModel
	currentCharacterMode.beardColor = data.beardColor
	currentCharacterMode.chestModel = data.chestModel
	currentCharacterMode.chestColor = data.chestColor
	currentCharacterMode.blushModel = data.blushModel
	currentCharacterMode.blushColor = data.blushColor
	currentCharacterMode.lipstickModel = data.lipstickModel
	currentCharacterMode.lipstickColor = data.lipstickColor
	currentCharacterMode.blemishesModel = data.blemishesModel
	currentCharacterMode.ageingModel = data.ageingModel
	currentCharacterMode.complexionModel = data.complexionModel
	currentCharacterMode.sundamageModel = data.sundamageModel
	currentCharacterMode.frecklesModel = data.frecklesModel
	currentCharacterMode.makeupModel = data.makeupModel
	TaskUpdateHeadOptions()
	cb('ok')
end)

function TaskUpdateHeadOptions()
	local ped = PlayerPedId()
	local data = currentCharacterMode

	SetPedComponentVariation(ped, 2, data.hairModel, 0, 0)
	SetPedHairColor(ped, data.firstHairColor, data.secondHairColor)

	ClearPedDecorations(ped)

	if data.hairfadedlc and data.hairfadetexture then
        AddPedDecorationFromHashes(ped, GetHashKey(data.hairfadedlc), GetHashKey(data.hairfadetexture))
    end

	SetPedHeadOverlay(ped, 2, data.eyebrowsModel, 0.99)
	SetPedHeadOverlayColor(ped, 2, 1, data.eyebrowsColor, data.eyebrowsColor)

	SetPedHeadOverlay(ped, 1, data.beardModel, 0.99)
	SetPedHeadOverlayColor(ped, 1, 1, data.beardColor, data.beardColor)

	SetPedHeadOverlay(ped, 10, data.chestModel, 0.99)
	SetPedHeadOverlayColor(ped, 10, 1, data.chestColor, data.chestColor)

	SetPedHeadOverlay(ped, 5, data.blushModel, 0.99)
	SetPedHeadOverlayColor(ped, 5, 2, data.blushColor, data.blushColor)

	SetPedHeadOverlay(ped, 8, data.lipstickModel, 0.99)
	SetPedHeadOverlayColor(ped, 8, 2, data.lipstickColor, data.lipstickColor)

	SetPedHeadOverlay(ped, 0, data.blemishesModel, 0.99)
	SetPedHeadOverlayColor(ped, 0, 0, 0, 0)

	SetPedHeadOverlay(ped, 3, data.ageingModel, 0.99)
	SetPedHeadOverlayColor(ped, 3, 0, 0, 0)

	SetPedHeadOverlay(ped, 6, data.complexionModel, 0.99)
	SetPedHeadOverlayColor(ped, 6, 0, 0, 0)

	SetPedHeadOverlay(ped, 7, data.sundamageModel, 0.99)
	SetPedHeadOverlayColor(ped, 7, 0, 0, 0)

	SetPedHeadOverlay(ped, 9, data.frecklesModel, 0.99)
	SetPedHeadOverlayColor(ped, 9, 0, 0, 0)

	SetPedHeadOverlay(ped, 4, data.makeupModel, 0.99)
	SetPedHeadOverlayColor(ped, 4, 0, 0, 0)
end



RegisterNetEvent('zCreator:cinematicStart')
AddEventHandler('zCreator:cinematicStart', function()
	PrepareMusicEvent('FM_INTRO_START')
	TriggerMusicEvent('FM_INTRO_START')
    local plyrId = PlayerPedId()
    -----------------------------------------------
	
    while not HasCutsceneLoaded() do Wait(10) end --- waiting for the cutscene to load
	if IsMale(plyrId) then
		RegisterEntityForCutscene(0, 'MP_Male_Character', 3, GetEntityModel(PlayerPedId()), 0)
		RegisterEntityForCutscene(PlayerPedId(), 'MP_Male_Character', 0, 0, 0)
		SetCutsceneEntityStreamingFlags('MP_Male_Character', 0, 1) 
		local female = RegisterEntityForCutscene(0,'MP_Female_Character',3,0,64) 
		NetworkSetEntityInvisibleToNetwork(female, true)
	else
		RegisterEntityForCutscene(0, 'MP_Female_Character', 3, GetEntityModel(PlayerPedId()), 0)
		RegisterEntityForCutscene(PlayerPedId(), 'MP_Female_Character', 0, 0, 0)
		SetCutsceneEntityStreamingFlags('MP_Female_Character', 0, 1) 
		local male = RegisterEntityForCutscene(0,'MP_Male_Character',3,0,64) 
		NetworkSetEntityInvisibleToNetwork(male, true)
	end
	
end)