local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
local Tools = module('vrp', 'lib/Tools')
vRP = Proxy.getInterface('vRP')
vRPclient = Tunnel.getInterface('vRP')

z = {}
Tunnel.bindInterface('zCraft', z)
zCLIENT = Tunnel.getInterface('zCraft')

local active = {}

function z.craft(factory)
    local source = source
	local user_id = vRP.getUserId(source)
    local craftable = {}
    local ingredients = {}
    if user_id then
        for a, b in pairs(config.craft) do
            if a == factory then
                for c, d in pairs(b.crafts) do
                    if vRP.itemBodyList(d.item) then
                        table.insert(craftable, {
                            key = d.item, 
                            name = vRP.itemNameList(d.item), 
                            index = vRP.itemIndexList(d.item), 
                            amount = d.amount, 
                            required_name_one = vRP.itemIndexList(d.require.one_item), 
                            required_amount_one = d.require.one_amount,
                            required_name_two = vRP.itemIndexList(d.require.two_item), 
                            required_amount_two = d.require.two_amount,
                            required_name_three = vRP.itemIndexList(d.require.three_item), 
                            required_amount_three = d.require.three_amount,
                            required_name_four = vRP.itemIndexList(d.require.four_item), 
                            required_amount_four = d.require.four_amount,
                        })
                    end
                end
            end
        end
        return craftable
    end
end

function z.checkPermission(permission)
    local source = source
	local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id, permission) then
            return true
        end
    end
end

function z.crafting(itemName)
    local source = source
	local user_id = vRP.getUserId(source)
    if user_id then
        for a, b in pairs(config.craft) do
            for c, d in pairs(b.crafts) do
                if d.item == itemName then
                    if vRP.getInventoryItemAmount(user_id, d.require.one_item) >= d.require.one_amount then
                        if vRP.getInventoryItemAmount(user_id, d.require.two_item) >= d.require.two_amount then
                            if vRP.getInventoryItemAmount(user_id, d.require.three_item) >= d.require.three_amount then
                                if vRP.getInventoryItemAmount(user_id, d.require.four_item) >= d.require.four_amount then
                                    if vRP.tryGetInventoryItem(user_id, d.require.one_item, d.require.one_amount) and vRP.tryGetInventoryItem(user_id, d.require.two_item, d.require.two_amount) and vRP.tryGetInventoryItem(user_id, d.require.three_item, d.require.three_amount) and vRP.tryGetInventoryItem(user_id, d.require.four_item, d.require.four_amount) then
                                        active[user_id] = 10
                                        vRPclient.stopActived(source)
                                        TriggerClientEvent('Progress', source, 10000, 'FABRICANDO')
                                        TriggerClientEvent("zCraft:closeNui", source)
                                        vRPclient._playAnim(source, false, {"amb@prop_human_parking_meter@female@idle_a", "idle_a_female"} ,true)
                                        repeat
                                            if active[user_id] == 0 then
                                                vRPclient._stopAnim(source,false)
                                                active[user_id] = nil
                                                vRP.tryGiveInventoryItem(user_id, d.item, 1, true)
                                            end
                                            Citizen.Wait(0)
                                        until active[user_id] == nil
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

Citizen.CreateThread(function()
	while true do
		for k, v in pairs(active) do
			if active[k] > 0 then
				active[k] = active[k] - 1
			end
		end
		Citizen.Wait(1000)
	end
end)