local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
server = {}
Tunnel.bindInterface("zTowdriver",server)
client = Tunnel.getInterface("zTowdriver")

local userList = {}

RegisterCommand(config.CommandTow,function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRPclient.getHealth(source) > 101 then
			client.towPlayer(source)
			userList[user_id] = source
		end
	end
end)

function server.tryTow(vehid01,vehid02,mod)
	TriggerClientEvent("zTowdriver:syncTow",-1,vehid01,vehid02,tostring(mod))
end