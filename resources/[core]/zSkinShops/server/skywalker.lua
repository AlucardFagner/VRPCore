local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')
vRPclient = Tunnel.getInterface('vRP')

z = {}
Tunnel.bindInterface('zSkinShops', z)
zCLIENT = Tunnel.getInterface('zSkinShops')



function z.updateClothes(clothes, demand)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.setUData(user_id, 'Clothings', clothes)
	end
end



RegisterServerEvent('zSkinShops:Buy')
AddEventHandler('zSkinShops:Buy', function(price)
    local source = source
    local user_id = vRP.getUserId(source)
    if price > 0 then
        if vRP.tryPayment(user_id, parseInt(price)) then
            TriggerClientEvent('Notify', source, 'sucesso', 'Você pagou <b>$'..vRP.format(parseInt(price))..' dólares</b> em roupas e acessórios.', 3000)
            TriggerClientEvent('zSkinShops:receivePurchase', source, true)
        else
            TriggerClientEvent('Notify', source, 'negado', 'Dinheiro & saldo insuficientes.', 3000)
            TriggerClientEvent('zSkinShops:receivePurchase', source, false)	
        end
    end
end)

RegisterServerEvent('zSkinShops:init')
AddEventHandler('zSkinShops:init', function(user_id)
    local player = vRP.getUserSource(user_id)
    if player then
        local value = vRP.getUData(user_id, 'Clothings')
        if value ~= '' then
            local custom = json.decode(value) or {}     
            TriggerClientEvent('zSkinShops:setClothes', player, custom)
        end
    end
end)