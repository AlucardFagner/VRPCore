local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')
zCLIENT = {}
Tunnel.bindInterface('zBarberShops', zCLIENT)
zSERVER = Tunnel.getInterface('zBarberShops')

local cam = -1
local canStartTread = 0
local myClothes = {}
local pedModelHash = nil

function f(n)
	n = n + 0.00000
	return n
end

RegisterNUICallback('closeInterface',function(data)
    SetNuiFocus(false)
    displayBarbershop(false)
    SendNUIMessage({
        openBarbershop = false
    })
end)

RegisterNUICallback('updateSkin', function(data)
	myClothes.skinColor = tonumber(data.skinColor)
	myClothes.eyesColor = tonumber(data.eyesColor)
    myClothes.complexionModel = tonumber(data.complexionModel)
    myClothes.blemishesModel = tonumber(data.blemishesModel)
    myClothes.frecklesModel = tonumber(data.frecklesModel)
    myClothes.ageingModel = tonumber(data.ageingModel)
    myClothes.hairModel = tonumber(data.hairModel)
    myClothes.firstHairColor = tonumber(data.firstHairColor)
    myClothes.secondHairColor = tonumber(data.secondHairColor)
    myClothes.makeupModel = tonumber(data.makeupModel)
    myClothes.lipstickModel = tonumber(data.lipstickModel)
    myClothes.lipstickColor = tonumber(data.lipstickColor)
    myClothes.eyebrowsModel = tonumber(data.eyebrowsModel)
    myClothes.eyebrowsColor = tonumber(data.eyebrowsColor)
    myClothes.beardModel = tonumber(data.beardModel)
    myClothes.beardColor = tonumber(data.beardColor)    
    myClothes.blushModel = tonumber(data.blushModel)
    myClothes.blushColor = tonumber(data.blushColor)
    myClothes.hairfade = tonumber(data.hairfade)

    local hairf = config.hairfades[tonumber(data.hairfade)]
    myClothes.hairfadedlc = hairf and hairf.dlc or nil
    myClothes.hairfadetexture = hairf and hairf.texture or nil

    if data.value then
        SetNuiFocus(false)
        displayBarbershop(false)
        zSERVER.updateSkin(myClothes)
        SendNUIMessage({
            openBarbershop = false
        })
    end

    TaskUpdateHeadOptions(PlayerPedId())
    TaskUpdateFaceOptions(PlayerPedId())
end)

RegisterNUICallback('rotate', function(data, cb)
    local ped = PlayerPedId()
    local heading = GetEntityHeading(ped)
    if data == 'left' then
        SetEntityHeading(ped, heading + 10)
    elseif data == 'right' then
        SetEntityHeading(ped, heading - 10)
    end
end)

function displayBarbershop(enable)
    local ped = PlayerPedId()

    if enable then
        SetNuiFocus(true, true)
        SendNUIMessage({
            openBarbershop = true,
            myclothes = myClothes
        })
        FreezeEntityPosition(ped, true)
        SetPlayerInvincible(ped, true)
        if not DoesCamExist(cam) then
            cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
            SetCamCoord(cam, GetEntityCoords(ped))
            SetCamRot(cam, 0.0, 0.0, 0.0)
            SetCamActive(cam, true)
            RenderScriptCams(true, false, 0, true, true)
            SetCamCoord(cam, GetEntityCoords(ped))
        end

        local x, y, z = table.unpack(GetEntityCoords(ped))
        SetCamCoord(cam, x + 0.2, y + 0.5, z + 0.7)
        SetCamRot(cam, 0.0, 0.0, 150.0)
    else
        FreezeEntityPosition(ped, false)
        SetPlayerInvincible(ped, false)
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
    end
end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    SetTextFont(4)
    SetTextScale(0.35, 0.35)
    SetTextColour(255, 255, 255, 100)
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 400
    DrawRect(_x, _y + 0.0125, 0.01 + factor, 0.03, 0, 0, 0, 100)
end

RegisterNetEvent('zBarberShops:setCustomization')
AddEventHandler('zBarberShops:setCustomization', function(characteristics, id)
    myClothes.complexionModel = tonumber(characteristics.complexionModel)
    myClothes.noseBridge = tonumber(characteristics.noseBridge)
    myClothes.chinWidth = tonumber(characteristics.chinWidth)
    myClothes.jawWidth = tonumber(characteristics.jawWidth)
    myClothes.noseHeight = tonumber(characteristics.noseHeight)
    myClothes.eyebrowsWidth = tonumber(characteristics.eyebrowsWidth)
    myClothes.chinPosition = tonumber(characteristics.chinPosition)
    myClothes.eyebrowsModel = tonumber(characteristics.eyebrowsModel)
    myClothes.eyebrowsColor = tonumber(characteristics.eyebrowsColor)
    myClothes.eyesColor = tonumber(characteristics.eyesColor)
    myClothes.blushModel = tonumber(characteristics.blushModel)
    myClothes.noseShift = tonumber(characteristics.noseShift)
    myClothes.frecklesModel = tonumber(characteristics.frecklesModel)
    myClothes.jawHeight = tonumber(characteristics.jawHeight)
    myClothes.secondHairColor = tonumber(characteristics.secondHairColor)
    myClothes.cheekboneWidth = tonumber(characteristics.cheekboneWidth)
    myClothes.gender = tonumber(characteristics.gender)
    myClothes.lipstickColor = tonumber(characteristics.lipstickColor)
    myClothes.beardModel = tonumber(characteristics.beardModel)
    myClothes.lips = tonumber(characteristics.lips)
    myClothes.eyebrowsHeight = tonumber(characteristics.eyebrowsHeight)
    myClothes.sundamageModel = tonumber(characteristics.sundamageModel)
    myClothes.cheeksWidth = tonumber(characteristics.cheeksWidth)
    myClothes.chestColor = tonumber(characteristics.chestColor)
    myClothes.noseLength = tonumber(characteristics.noseLength)
    myClothes.lipstickModel = tonumber(characteristics.lipstickModel)
    myClothes.makeupModel = tonumber(characteristics.makeupModel)
    myClothes.chinShape = tonumber(characteristics.chinShape)
    myClothes.noseWidth = tonumber(characteristics.noseWidth)
    myClothes.blushColor = tonumber(characteristics.blushColor)
    myClothes.neckWidth = tonumber(characteristics.neckWidth)
    myClothes.blemishesModel = tonumber(characteristics.blemishesModel)
    myClothes.noseTip = tonumber(characteristics.noseTip)
    myClothes.chinLength = tonumber(characteristics.chinLength)
    myClothes.chestModel = tonumber(characteristics.chestModel)
    myClothes.beardColor = tonumber(characteristics.beardColor)
    myClothes.firstHairColor = tonumber(characteristics.firstHairColor)
    myClothes.hairModel = tonumber(characteristics.hairModel)
    myClothes.ageingModel = tonumber(characteristics.ageingModel)
    myClothes.cheekboneHeight = tonumber(characteristics.cheekboneHeight)
    myClothes.shapeMix = tonumber(characteristics.shapeMix)
    myClothes.skinColor = tonumber(characteristics.skinColor)
    myClothes.fathersID = tonumber(characteristics.fathersID)
    myClothes.mothersID = tonumber(characteristics.mothersID)
    myClothes.hairfade = tonumber(characteristics.hairfade)

    local hairf = config.hairfades[tonumber(characteristics.hairfade)]
    myClothes.hairfadedlc = hairf and hairf.dlc or nil
    myClothes.hairfadetexture = hairf and hairf.texture or nil


    if myClothes.gender == 1 then
        pedModelHash = GetHashKey('mp_f_freemode_01')
    else
        pedModelHash = GetHashKey('mp_m_freemode_01')
    end

    if pedModelHash then
		local i = 0
		while not HasModelLoaded(pedModelHash) and i < 10000 do
			RequestModel(pedModelHash)
			Citizen.Wait(10)
		end

		if HasModelLoaded(pedModelHash) then
			SetPlayerModel(PlayerId(), pedModelHash)
            SetPedMaxHealth(PlayerPedId(), 400)
            SetEntityHealth(PlayerPedId(), zSERVER.dataHealth())
			SetModelAsNoLongerNeeded(pedModelHash)
		end
	end

    TaskUpdateSkinOptions(PlayerPedId())
    TaskUpdateFaceOptions(PlayerPedId())
    TaskUpdateHeadOptions(PlayerPedId())
    TriggerServerEvent('zSkinShops:init', id)
end)

function TaskUpdateSkinOptions(model)
    local data = myClothes
    SetPedHeadBlendData(model, data.fathersID, data.mothersID, 0, data.skinColor, 0, 0, f(data.shapeMix), 0, 0, false)
end

function TaskUpdateFaceOptions(model)
	local data = myClothes
	SetPedEyeColor(model, data.eyesColor)
	SetPedFaceFeature(model, 6, data.eyebrowsHeight)
    SetPedFaceFeature(model, 7, data.eyebrowsWidth)
    SetPedFaceFeature(model, 0, data.noseWidth)
    SetPedFaceFeature(model, 1, data.noseHeight)
    SetPedFaceFeature(model, 2, data.noseLength)
    SetPedFaceFeature(model, 3, data.noseBridge)
    SetPedFaceFeature(model, 4, data.noseTip)
    SetPedFaceFeature(model, 5, data.noseShift)
    SetPedFaceFeature(model, 8, data.cheekboneHeight)
    SetPedFaceFeature(model, 9, data.cheekboneWidth)
    SetPedFaceFeature(model, 10, data.cheeksWidth)
    SetPedFaceFeature(model, 12, data.lips)
    SetPedFaceFeature(model, 13, data.jawWidth)
    SetPedFaceFeature(model, 14, data.jawHeight)
    SetPedFaceFeature(model, 15, data.chinLength)
    SetPedFaceFeature(model, 16, data.chinPosition)
    SetPedFaceFeature(model, 17, data.chinWidth)
    SetPedFaceFeature(model, 18, data.chinShape)
    SetPedFaceFeature(model, 19, data.neckWidth)
end

function TaskUpdateHeadOptions(model)
	local data = myClothes
	SetPedHeadOverlay(model, 2, data.eyebrowsModel, 0.99)
    SetPedHeadOverlayColor(model, 2, 1, data.eyebrowsColor, data.eyebrowsColor)
    
    SetPedComponentVariation(model, 2, data.hairModel, 0, 0)
    SetPedHairColor(model, data.firstHairColor, data.secondHairColor)
    
    ClearPedDecorations(PlayerPedId())

    if data.hairfadedlc and data.hairfadetexture then
        AddPedDecorationFromHashes(PlayerPedId(), GetHashKey(data.hairfadedlc), GetHashKey(data.hairfadetexture))
    end

    SetPedHeadOverlay(model, 1, data.beardModel, 0.99)
    SetPedHeadOverlayColor(model, 1, 1, data.beardColor, data.beardColor)
    SetPedHeadOverlay(model, 10, data.chestModel, 0.99)
    SetPedHeadOverlayColor(model, 10, 1, data.chestColor, data.chestColor)
    SetPedHeadOverlay(model, 4, data.makeupModel, 0.99)
    SetPedHeadOverlayColor(model, 4, 0, 0, 0)
    SetPedHeadOverlay(model, 5, data.blushModel, 0.99)
    SetPedHeadOverlayColor(model, 5, 2, data.blushColor, data.blushColor)
    SetPedHeadOverlay(model, 8, data.lipstickModel, 0.99)
    SetPedHeadOverlayColor(model, 8, 2, data.lipstickColor, data.lipstickColor)
    SetPedHeadOverlay(model, 0, data.blemishesModel, 0.99)
    SetPedHeadOverlayColor(model, 0, 0, 0, 0)
    SetPedHeadOverlay(model, 3, data.ageingModel, 0.99)
    SetPedHeadOverlayColor(model, 3, 0, 0, 0)
    SetPedHeadOverlay(model, 6, data.complexionModel, 0.99)
    SetPedHeadOverlayColor(model, 6, 0, 0, 0)
    SetPedHeadOverlay(model, 7, data.sundamageModel, 0.99)
    SetPedHeadOverlayColor(model, 7, 0, 0, 0)
    SetPedHeadOverlay(model, 9, data.frecklesModel, 0.99)
    SetPedHeadOverlayColor(model, 9, 0, 0, 0)
end

RegisterNetEvent('syncarea')
AddEventHandler('syncarea', function(x, y, z, distance)
    ClearAreaOfVehicles(x, y, z, distance + 0.0, false, false, false, false, false)
    ClearAreaOfEverything(x, y, z, distance + 0.0, false, false, false, false)
end)

RegisterNetEvent('zBarberShops:open')
AddEventHandler('zBarberShops:open', function()
    displayBarbershop(true)
    SetEntityHeading(PlayerPedId(), 332.21)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if canStartTread > 0 then
			while not IsPedModel(PlayerPedId(), 'mp_m_freemode_01') and not IsPedModel(PlayerPedId(), 'mp_f_freemode_01') do
				Citizen.Wait(10)
			end
            
            canStartTread = canStartTread - 1
		end
	end
end)