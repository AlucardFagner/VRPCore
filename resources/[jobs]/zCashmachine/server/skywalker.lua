local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
Tools = module('vrp', 'lib/Tools')
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
local idgens = Tools.newIDGenerator()
server = {}
Tunnel.bindInterface("zCashmachine",server)

local machineGlobal = 0
local machineStart = false
local droplist = {}
local x, y, z = {}

function server.startMachine()
	local source = source
	local user_id = vRP.getUserId(source)
	x, y, z = vRPclient.getPositions(source)
	if user_id then
		local copAmount = vRP.numPermission(config.PolicePerm)
		if parseInt(#copAmount) <= config.NeedCopsAmount then
			TriggerClientEvent("Notify",source,"aviso","Sistema indisponível no momento.",5000)
			return false
		else
			if config.NeedItem then
				if vRP.getInventoryItemAmount(user_id,config.NeedItemName) >= 1 then
					if machineGlobal == 0 then
						if not machineStart then
							machineStart = true
							machineGlobal = parseInt(config.CooldownGlobal)
							vRP.upgradeStress(user_id,10)
							vRP.wantedTimer(parseInt(user_id),parseInt(config.WantedTimer))
							vRP.removeInventoryItem(user_id,config.NeedItemName,config.NeedItemAmount)
							return true
						end
					end
				end
			else
				if machineGlobal == 0 then
					if not machineStart then
						machineStart = true
						machineGlobal = parseInt(config.CooldownGlobal)
						vRP.upgradeStress(user_id,10)
						vRP.wantedTimer(parseInt(user_id),parseInt(config.WantedTimer))
						return true
					end
				end
			end
		end
	end
	return false
end

function server.callPolice(x,y,z)
	local copAmount = vRP.numPermission(config.PolicePerm)
	for k,v in pairs(copAmount) do
		async(function()
			TriggerClientEvent("NotifyPush",v,{ time = os.date("%H:%M:%S - %d/%m/%Y"), code = 31, title = "Roubo ao Caixa Eletrônico", x = x, y = y, z = z, rgba = {170,80,25} })
		end)
	end
end

function server.stopMachine(x,y,z)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if machineStart then
			machineStart = false
			local grid = vRP.getGridzone(x,y)
			TriggerEvent("zCashmachine:CreateDrop",config.ItemNamePayment,parseInt(math.random(config.PaymentMin,config.PaymentMax)),source)
		end
	end
end

RegisterServerEvent('zCashmachine:CreateDrop')
AddEventHandler('zCashmachine:CreateDrop', function(item, count, source)
    local id = idgens:gen()
    droplist[id] = { item = item, count = count, x = x, y = y, z = z, name = vRP.itemNameList(item),  index = vRP.itemIndexList(item), desc = vRP.itemDescList(item), peso = vRP.itemWeightList(item) }
    TriggerClientEvent('itemdrop:Players', -1, id, droplist[id])
	local nplayer = vRPclient.nearestPlayer(source, 5)
    if nplayer then
        TriggerClientEvent('zInventory:Update', nplayer, 'updateMochila')
    end
end)

Citizen.CreateThread(function()
	while true do
		if parseInt(machineGlobal) > 0 then
			machineGlobal = parseInt(machineGlobal) - 1
			if parseInt(machineGlobal) <= 0 then
				machineStart = false
			end
		end
		Citizen.Wait(1000)
	end
end)