local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')
vRPclient = Tunnel.getInterface('vRP')

z = {}
Tunnel.bindInterface('zSkinShops', z)
zSERVER = Tunnel.getInterface('zSkinShops')

local skinData = {}
local previousSkinData = {}

local openShop = false

local cam = -1
local camPos = nil
local pos = nil

local dataPart = 1
local handsup = false

local totalPrice = 0
local price = 0

local hour = 0
local imageService = config.imageService

local skinData = {
	['pants'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
	['arms'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
	['t-shirt'] = { item = 1, texture = 0, defaultItem = 1, defaultTexture = 0 },
	['torso2'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
	['vest'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
	['bag'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
	['shoes'] = { item = 0, texture = 0, defaultItem = 1, defaultTexture = 0 },
	['mask'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
	['hat'] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
	['glass'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
	['ear'] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
	['watch'] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
	['bracelet'] = { item = -1, texture = 0, defaultItem = -1, defaultTexture = 0 },
	['accessory'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 },
	['decals'] = { item = 0, texture = 0, defaultItem = 0, defaultTexture = 0 }
}

local clothingCategorys = {
	['arms'] = { type = 'variation', id = 3, idc = 3 },
	['t-shirt'] = { type = 'variation', id = 8, idc = 8 },
	['torso2'] = { type = 'variation', id = 11, idc = 11 },
	['pants'] = { type = 'variation', id = 4, idc = 4 },
	['vest'] = { type = 'variation', id = 9, idc = 9 },
	['shoes'] = { type = 'variation', id = 6, idc = 6 },
	['bag'] = { type = 'variation', id = 5, idc = 5 },
	['mask'] = { type = 'mask', id = 1, idc = 1 },
	['hat'] = { type = 'prop', id = 0, idc = 'p0' },
	['glass'] = { type = 'prop', id = 1, idc = 'p1' },
	['ear'] = { type = 'prop', id = 2, idc = 'p2' },
	['watch'] = { type = 'prop', id = 6, idc = 'p6' },
	['bracelet'] = { type = 'prop', id = 7, idc = 'p7' },
	['accessory'] = { type = 'variation', id = 7, idc = 7 },
	['decals'] = { type = 'variation', id = 10, idc = 10 }
}

local shoppingCart = {
	['arms'] = false,
	['t-shirt'] = false,
	['torso2'] = false,
	['pants'] = false,
	['vest'] = false,
	['shoes'] = false,
	['bag'] = false,
	['mask'] = false,
	['hat'] = false,
	['glass'] = false,
	['ear'] = false,
	['watch'] = false,
	['bracelet'] = false,
	['accessory'] = false,
	['decals'] = false
}

local convertData = {
	[1] = { name =  'mask' },
	[2] = { name =  'pants' },
	[3] = { name =  'arms' },
	[4] = { name =  'pants' },
	[5] = { name =  'bag' },
	[6] = { name =  'shoes' },
	[7] = { name =  'accessory' },
	[8] = { name =  't-shirt' },
	[9] = { name =  'vest' },
	[10] = { name =  'decals' },
	[11] = { name =  'torso2' },
	['p0'] = { name =  'hat' },
	['p1'] = { name =  'glass' },
	['p2'] = { name =  'ear' },
	['p6'] = { name =  'watch' },
	['p7'] = { name =  'bracelet' }
}

RegisterNUICallback('changeCategory', function(data, cb)
    dataPart = clothingCategorys[data.part].idc
    local ped = PlayerPedId()
    if GetEntityModel(ped) == GetHashKey('mp_m_freemode_01') then
        SendNUIMessage({ changeCategory = true, gender = 'Male', prefix = 'M', drawa = vRP.getDrawables(dataPart), category = dataPart, categoryName = data.part, imageService = imageService  })
    elseif GetEntityModel(ped) == GetHashKey('mp_f_freemode_01') then 
        SendNUIMessage({ changeCategory = true, gender = 'Female', prefix = 'F', drawa = vRP.getDrawables(dataPart), category = dataPart, categoryName = data.part, imageService = imageService  })
    end
    cb('ok')
end)

RegisterNUICallback('updateSkin', function(data)
    changeVariation(data)
end)

RegisterNUICallback('resetOutfit', function()
	resetClothing(json.decode(previousSkinData))
	skinData = json.decode(previousSkinData)
	previousSkinData = {}
    closeInterface()
    ClearPedTasks(PlayerPedId())
	TriggerEvent('zHud:changeHudOnOff', true)
end)

RegisterNUICallback('leftHeading', function(data)
    local currentHeading = GetEntityHeading(PlayerPedId())
    heading = currentHeading-tonumber(data.value)
    SetEntityHeading(PlayerPedId(), heading)
end)

RegisterNUICallback('handsUp', function(data)
    local dict = 'missminuteman_1ig_2'
    
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(100)
    end
    
    if not handsup then
        TaskPlayAnim(PlayerPedId(), dict, 'handsup_enter', 8.0, 8.0, -1, 50, 0, false, false, false)
        handsup = true
    else
        handsup = false
        ClearPedTasks(PlayerPedId())
    end
end)

RegisterNUICallback('rightHeading', function(data)
    local currentHeading = GetEntityHeading(PlayerPedId())
    heading = currentHeading + tonumber(data.value)
    SetEntityHeading(PlayerPedId(), heading)
end)

RegisterNUICallback('payament', function(data)
	shoppingCart = {
		['arms'] = false,
		['t-shirt'] = false,
		['torso2'] = false,
		['pants'] = false,
		['vest'] = false,
		['shoes'] = false,
		['bag'] = false,
		['mask'] = false,
		['hat'] = false,
		['glass'] = false,
		['ear'] = false,
		['watch'] = false,
		['bracelet'] = false,
		['accessory'] = false,
		['decals'] = false
	}
	TriggerServerEvent('zSkinShops:Buy', tonumber(data.price)) 
end)

RegisterNUICallback('changeColor', function(data)
	changeVariation(data)
end)

RegisterNUICallback('closeInterface', function(data)
	closeInterface()
end)


function CalculateTimeToDisplay()
	hour = GetClockHours()
	if hour <= 9 then
		hour = '0'..hour
	end
end

function parse_part(key)
    if type(key) == 'string' and string.sub(key, 1, 1) == 'p' then
        return tonumber(string.sub(key, 2))
    else
        return false, tonumber(key)
    end
end

function drawText3D(x, y, z, text)
    local onScreen, _x, _y=World3dToScreen2d(x, y, z)
    local px, py, pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.28, 0.28)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y+0.0125, 0.005+ factor, 0.03, 41, 11, 41, 68)
end

function setCameraCoords()
    local ped = PlayerPedId()
	RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    
	if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
		SetCamActive(cam, true)
        RenderScriptCams(true, true, 500, true, true)

        pos = GetEntityCoords(PlayerPedId())
        camPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, 0.0)
        SetCamCoord(cam, camPos.x, camPos.y, camPos.z+0.75)
        PointCamAtCoord(cam, pos.x, pos.y, pos.z+0.15)
    end

end

function deleteCam()
	SetCamActive(cam, false)
	RenderScriptCams(false, true, 0, true, true)
	cam = nil
end

function openInterface()
    local ped = PlayerPedId()
    previousSkinData = json.encode(skinData)
    
    setCameraCoords()

    if GetEntityModel(ped) == GetHashKey('mp_m_freemode_01') then
        SendNUIMessage({ openShop = true, gender = 'Male', prefix = 'M', drawa = vRP.getDrawables(dataPart), category = dataPart, categoryName = 'mask', imageService = imageService })
    elseif GetEntityModel(ped) == GetHashKey('mp_f_freemode_01') then
        SendNUIMessage({ openShop = true, gender = 'Female', prefix = 'F', drawa = vRP.getDrawables(dataPart), category = dataPart, categoryName = 'mask', imageService = imageService })
    end

    SetNuiFocus(true, true)
    SetCursorLocation(0.9, 0.25)
    openShop = true
end

function closeInterface()
    local ped = PlayerPedId()
    
    SetNuiFocus(false, false)
    SendNUIMessage({ openShop = false })
	playerReturnInstancia()
	SendNUIMessage({ action = 'setPrice', price = 0, typeaction = 'remove' })
    
    FreezeEntityPosition(ped, false)
    SetEntityInvincible(ped, false)
    deleteCam()
    openShop = false
end

function updateShoppingCart()
    price = 0
    for k, v in pairs(shoppingCart) do
        if shoppingCart[k] == true then
            price = price + 100
        end
    end
    totalPrice = price
    return price
end

function changeVariation(data)
	local ped = PlayerPedId()
	local clothingCategory = data.clothingType
	local typee = data.type 
	local item = tonumber(parseInt(data.articleNumber))

	if type(data.clothingTypeId) == 'number' then
        max = GetNumberOfPedTextureVariations(ped, data.clothingTypeId, tonumber(parseInt(data.articleNumber)))
    elseif type(data.clothingTypeId) == 'string' then
        max = GetNumberOfPedPropTextureVariations(ped, parse_part(data.clothingTypeId), tonumber(parseInt(data.articleNumber)))
    end

    if data.action == 'previous' then
        if color > 0 then 
			color = color - 1 
		else 
			color = max 
		end
    elseif data.action == 'next' then
        if color < max then
			color = color + 1 
		else 
			color = 0
		end
    end

	if clothingCategory == 'pants' then
		if typee == 'item' then
			SetPedComponentVariation(ped, 4, item, 0, 2)
			skinData['pants'].item = item
		elseif typee == 'texture' then
			local curItem = GetPedDrawableVariation(ped, 4)
			SetPedComponentVariation(ped, 4, curItem, color, 2)
			skinData['pants'].texture = color
		end
	elseif clothingCategory == 'arms' then
		if typee == 'item' then
			SetPedComponentVariation(ped, 3, item, 0, 2)
			skinData['arms'].item = item
		elseif typee == 'texture' then
			local curItem = GetPedDrawableVariation(ped, 3)
			SetPedComponentVariation(ped, 3, curItem, color, 2)
			skinData['arms'].texture = color
		end
	elseif clothingCategory == 't-shirt' then
		if typee == 'item' then
			SetPedComponentVariation(ped, 8, item, 0, 2)
			skinData['t-shirt'].item = item
		elseif typee == 'texture' then
			local curItem = GetPedDrawableVariation(ped, 8)
			SetPedComponentVariation(ped, 8, curItem, color, 2)
			skinData['t-shirt'].texture = color
		end
	elseif clothingCategory == 'vest' then
		if typee == 'item' then
			SetPedComponentVariation(ped, 9, item, 0, 2)
			skinData['vest'].item = item
		elseif typee == 'texture' then
			SetPedComponentVariation(ped, 9, skinData['vest'].item, color, 2)
			skinData['vest'].texture = color
		end
	elseif clothingCategory == 'bag' then
		if typee == 'item' then
			SetPedComponentVariation(ped, 5, item, 0, 2)
			skinData['bag'].item = item
		elseif typee == 'texture' then
			SetPedComponentVariation(ped, 5, skinData['bag'].item, color, 2)
			skinData['bag'].texture = color
		end
	elseif clothingCategory == 'decals' then
		if typee == 'item' then
			SetPedComponentVariation(ped, 10, item, 0, 2)
			skinData['decals'].item = item
		elseif typee == 'texture' then
			SetPedComponentVariation(ped, 10, skinData['decals'].item, color, 2)
			skinData['decals'].texture = color
		end
	elseif clothingCategory == 'accessory' then
		if typee == 'item' then
			SetPedComponentVariation(ped, 7, item, 0, 2)
			skinData['accessory'].item = item
		elseif typee == 'texture' then
			SetPedComponentVariation(ped, 7, skinData['accessory'].item, color, 2)
			skinData['accessory'].texture = color
		end
	elseif clothingCategory == 'torso2' then
		if typee == 'item' then
			SetPedComponentVariation(ped, 11, item, 0, 2)
			skinData['torso2'].item = item
		elseif typee == 'texture' then
			local curItem = GetPedDrawableVariation(ped, 11)
			SetPedComponentVariation(ped, 11, curItem, color, 2)
			skinData['torso2'].texture = color
		end
	elseif clothingCategory == 'shoes' then
		if typee == 'item' then
			SetPedComponentVariation(ped, 6, item, 0, 2)
			skinData['shoes'].item = item
		elseif typee == 'texture' then
			local curItem = GetPedDrawableVariation(ped, 6)
			SetPedComponentVariation(ped, 6, curItem, color, 2)
			skinData['shoes'].texture = color
		end
	elseif clothingCategory == 'mask' then
		if typee == 'item' then
			SetPedComponentVariation(ped, 1, item, 0, 2)
			skinData['mask'].item = item
		elseif typee == 'texture' then
			local curItem = GetPedDrawableVariation(ped, 1)
			SetPedComponentVariation(ped, 1, curItem, color, 2)
			skinData['mask'].texture = color
		end
	elseif clothingCategory == 'hat' then
		if typee == 'item' then
			if item ~= -1 then
				SetPedPropIndex(ped, 0, item, skinData['hat'].texture, 2)
			else
				ClearPedProp(ped, 0)
			end
			skinData['hat'].item = item
		elseif typee == 'texture' then
			SetPedPropIndex(ped, 0, skinData['hat'].item, color, 2)
			skinData['hat'].texture = color
		end
	elseif clothingCategory == 'glass' then
		if typee == 'item' then
			if item ~= -1 then
				SetPedPropIndex(ped, 1, item, skinData['glass'].texture, 2)
				skinData['glass'].item = item
			else
				ClearPedProp(ped, 1)
			end
		elseif typee == 'texture' then
			SetPedPropIndex(ped, 1, skinData['glass'].item, color, 2)
			skinData['glass'].texture = color
		end
	elseif clothingCategory == 'ear' then
		if typee == 'item' then
			if item ~= -1 then
				SetPedPropIndex(ped, 2, item, skinData['ear'].texture, 2)
			else
				ClearPedProp(ped, 2)
			end
			skinData['ear'].item = item
		elseif typee == 'texture' then
			SetPedPropIndex(ped, 2, skinData['ear'].item, color, 2)
			skinData['ear'].texture = color
		end
	elseif clothingCategory == 'watch' then
		if typee == 'item' then
			if item ~= -1 then
				SetPedPropIndex(ped, 6, item, skinData['watch'].texture, 2)
			else
				ClearPedProp(ped, 6)
			end
			skinData['watch'].item = item
		elseif typee == 'texture' then
			SetPedPropIndex(ped, 6, skinData['watch'].item, color, 2)
			skinData['watch'].texture = color
		end
	elseif clothingCategory == 'bracelet' then
		if typee == 'item' then
			if item ~= -1 then
				SetPedPropIndex(ped, 7, item, skinData['bracelet'].texture, 2)
			else
				ClearPedProp(ped, 7)
			end
			skinData['bracelet'].item = item
		elseif typee == 'texture' then
			SetPedPropIndex(ped, 7, skinData['bracelet'].item, color, 2)
			skinData['bracelet'].texture = color
		end
	end

	data = json.decode(previousSkinData)	
	prev = data[clothingCategory].item
	new = skinData[clothingCategory].item

	if typee == 'item' then
		if new ~= prev and not shoppingCart[clothingCategory] then
			shoppingCart[clothingCategory] = true
			price = updateShoppingCart()
			SendNUIMessage({ action = 'setPrice', price = price, typeaction = 'add' })
		end
		if new == prev then
			shoppingCart[clothingCategory] = false
			price = updateShoppingCart()
			SendNUIMessage({ action = 'setPrice', price = price, typeaction = 'remove' })
		end
	end

	prevColor = data[clothingCategory].texture
	newColor = skinData[clothingCategory].texture

	if typee == 'texture' then
		if newColor ~= prevColor and not shoppingCart[clothingCategory] then
			shoppingCart[clothingCategory] = true
			price = updateShoppingCart()
			SendNUIMessage({ action = 'setPrice', price = price, typeaction = 'add' })
		end
		if newColor == prevColor then
			shoppingCart[clothingCategory] = false
			price = updateShoppingCart()
			SendNUIMessage({ action = 'setPrice', price = price, typeaction = 'remove' })
		end
	end

	SendNUIMessage({ value = price })
end

function resetClothing(data)
	local ped = PlayerPedId()

	SetPedComponentVariation(ped, 4, data['pants'].item, data['pants'].texture, 2)
	SetPedComponentVariation(ped, 3, data['arms'].item, data['arms'].texture, 2)
	SetPedComponentVariation(ped, 8, data['t-shirt'].item, data['t-shirt'].texture, 2)
	SetPedComponentVariation(ped, 9, data['vest'].item, data['vest'].texture, 2)
	SetPedComponentVariation(ped, 11, data['torso2'].item, data['torso2'].texture, 2)
	SetPedComponentVariation(ped, 6, data['shoes'].item, data['shoes'].texture, 2)
	SetPedComponentVariation(ped, 1, data['mask'].item, data['mask'].texture, 2)
	SetPedComponentVariation(ped, 10, data['decals'].item, data['decals'].texture, 2)
	SetPedComponentVariation(ped, 7, data['accessory'].item, data['accessory'].texture, 2)
	SetPedComponentVariation(ped, 5, data['bag'].item, data['bag'].texture, 2)

	if data['hat'].item ~= -1 and data['hat'].item ~= 0 then
		SetPedPropIndex(ped, 0, data['hat'].item, data['hat'].texture, 2)
	else
		ClearPedProp(ped, 0)
	end

	if data['glass'].item ~= -1 and data['glass'].item ~= 0 then
		SetPedPropIndex(ped, 1, data['glass'].item, data['glass'].texture, 2)
	else
		ClearPedProp(ped, 1)
	end

	if data['ear'].item ~= -1 and data['ear'].item ~= 0 then
		SetPedPropIndex(ped, 2, data['ear'].item, data['ear'].texture, 2)
	else
		ClearPedProp(ped, 2)
	end

	if data['watch'].item ~= -1 and data['watch'].item ~= 0 then
		SetPedPropIndex(ped, 6, data['watch'].item, data['watch'].texture, 2)
	else
		ClearPedProp(ped, 6)
	end

	if data['bracelet'].item ~= -1 and data['bracelet'].item ~= 0 then
		SetPedPropIndex(ped, 7, data['bracelet'].item, data['bracelet'].texture, 2)
	else
		ClearPedProp(ped, 7)
	end
end

function playerInstancia()
    for _, player in ipairs(GetActivePlayers()) do
        local ped = PlayerPedId()
        local otherPlayer = GetPlayerPed(player)
        if ped ~= otherPlayer then
            SetEntityVisible(otherPlayer, false)
            SetEntityNoCollisionEntity(ped, otherPlayer, true)
        end
    end
end

function playerReturnInstancia()
    for _, player in ipairs(GetActivePlayers()) do
        local ped = PlayerPedId()
        local otherPlayer = GetPlayerPed(player)
        if ped ~= otherPlayer then
            SetEntityVisible(otherPlayer, true)
            SetEntityCollision(ped, true)
        end
    end
end


RegisterNetEvent('convertClothes')
AddEventHandler('convertClothes',function(custom)
	for a, b in pairs(convertData) do
		for c, d in pairs(custom) do
			for e, f in pairs(skinData) do
				if c == a then
					if b.name == e then
						skinData[b.name].item = d[1]
						skinData[b.name].texture = d[2]
						skinData[b.name].defaultItem = f.defaultItem
						skinData[b.name].defaultTexture = f.defaultTexture
					end
				end
			end
		end
	end
	resetClothing(skinData)
	zSERVER.updateClothes(json.encode(skinData))
end)

RegisterNetEvent('zSkinShops:setClothes')
AddEventHandler('zSkinShops:setClothes', function(custom)
	skinData = custom
	resetClothing(custom)
end)

RegisterNetEvent('zSkinShops:receivePurchase')
AddEventHandler('zSkinShops:receivePurchase', function(confirm)
	if confirm then
		zSERVER.updateClothes(json.encode(skinData), true)
		previousSkinData = {}
		closeInterface()
		ClearPedTasks(PlayerPedId())
	else
		resetClothing(json.decode(previousSkinData))
		skinData = json.decode(previousSkinData)
		previousSkinData = {}
		closeInterface()
		ClearPedTasks(PlayerPedId())
	end
end)

RegisterNetEvent('zSkinShops:open')
AddEventHandler('zSkinShops:open', function()
	color = 0
	SetEntityHeading(PlayerPedId(), 181.42)
	FreezeEntityPosition(ped, true)
	SetEntityInvincible(ped, false)
	openInterface()
	TriggerEvent('zHud:changeHudOnOff', false)
end)

Citizen.CreateThread(function()
    while openShop do
		playerInstancia()
		DisableControlAction(1, 1, true)
		DisableControlAction(1, 2, true)
		DisableControlAction(1, 24, true)
		DisablePlayerFiring(PlayerPedId(), true)
		DisableControlAction(1, 142, true)
		DisableControlAction(1, 106, true)
		DisableControlAction(1, 37, true)
        Citizen.Wait(5)
    end
end)