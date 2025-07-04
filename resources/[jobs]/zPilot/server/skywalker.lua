local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

server = {}
Tunnel.bindInterface("zPilot",server)

function server.checkPaymentShamal(pay)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.giveInventoryItem(user_id, 'dinheiro', pay)
		vRP.upgradeStress(user_id,1)
		TriggerClientEvent("zSounds:source",source,'coin',0.5)
		TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..vRP.format(pay).." dólares</b>.",8000)
	end
end

function server.checkPaymentMiljet(pay)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.giveInventoryItem(user_id, 'dinheiro', pay)
		vRP.upgradeStress(user_id,1)
		TriggerClientEvent("zSounds:source",source,'coin',0.5)
		TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..vRP.format(pay).." dólares</b>.",8000)
	end
end

RegisterServerEvent("trydeleteveh554")
AddEventHandler("trydeleteveh554",function(index)
	TriggerClientEvent("syncdeleteveh",-1,index)
end)