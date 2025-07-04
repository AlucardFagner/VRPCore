Proxy = module('vrp', 'lib/Proxy')
Tunnel = module('vrp', 'lib/Tunnel')
vRP = Proxy.getInterface('vRP')
zCLIENT = {}
Tunnel.bindInterface('zShops', zCLIENT)
zSERVER = Tunnel.getInterface('zShops')

local imageService = config.imageService
local shops = {}

RegisterNetEvent('zShops:openShop')
AddEventHandler('zShops:openShop', function()
    local coords = GetEntityCoords(PlayerPedId())
    local shop = zSERVER.getThisShop(coords)
    if shop then
        SetNuiFocus(true,true)
        SendNUIMessage({action = 'showMenu', shop = shop})
    end
end)

RegisterNUICallback('shopClose', function(data, cb)
	SetNuiFocus(false, false)
	SendNUIMessage({ action = 'hideMenu', shop = data.shop })
end)

RegisterNUICallback('requestDataShop',function(data, cb)
	local inventory, weight, maxweight, slots, maxslots, shop, shopname, shopslots = zSERVER.getDataShop(data.shop)
	if inventory then
		cb({ inventory = inventory, weight = weight, maxweight = maxweight, slots = slots, maxslots = maxslots, shop = shop, shopname = shopname, shopslots = shopslots, imageService = imageService })
	end
end)

RegisterNUICallback('buyItem',function(data)
	zSERVER.buyItem(data.item, data.slot, data.amount, data.shop)
end)

RegisterNUICallback('sellItem',function(data)
	zSERVER.sellItem(data.item, data.slot, data.amount, data.shop)
end)

RegisterNetEvent('zShops:update')
AddEventHandler('zShops:update', function(shop)
    SendNUIMessage({ action = 'update', shop = shop })
end)

Citizen.CreateThread(function()
    TransitionFromBlurred(1000)
	SetNuiFocus(false, false)
end)