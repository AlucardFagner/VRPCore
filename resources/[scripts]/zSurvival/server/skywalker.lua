local Tunnel = module('vrp','lib/Tunnel')
local Proxy = module('vrp','lib/Proxy')
vRP = Proxy.getInterface('vRP')
vRPclient = Tunnel.getInterface('vRP')

zSERVER = {}
Tunnel.bindInterface('zSurvival',zSERVER)
zCLIENT = Tunnel.getInterface('zSurvival')

RegisterCommand(config.CommandRevive,function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,'ems') or vRP.hasPermission(user_id,'policia') then
			local nplayer = vRPclient.nearestPlayer(source,2)
			if nplayer then
				if zCLIENT.deadPlayer(nplayer) then
					TriggerClientEvent('Progress',source,10000,'Retirando...')
					TriggerClientEvent('cancelando',source,true)
					vRPclient._playAnim(source,false,{'mini@cpr@char_a@cpr_str','cpr_pumpchest'},true)
					SetTimeout(10000,function()
						vRPclient._removeObjects(source)
						zCLIENT._revivePlayer(nplayer,110)
						TriggerClientEvent('resetBleeding',nplayer)
						TriggerClientEvent('cancelando',source,false)
					end)
					TriggerClientEvent('zSurvival:PlayerRevive',nplayer)
				end
			end
		end
	end
end)

function zSERVER.ResetPedToHospital()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if zCLIENT.deadPlayer(source) then
			zCLIENT.finishDeath(source)
			TriggerClientEvent('resetHandcuff',source)
			TriggerClientEvent('resetBleeding',source)
			TriggerClientEvent('resetDiagnostic',source)
			TriggerClientEvent('zSurvival:FadeOutIn',source)
			local clear = vRP.clearInventory(user_id)
			if clear then
				vRPclient._clearWeapons(source)
				Wait(2000)
				vRPclient.teleport(source,359.87,-585.34,43.29)
				Wait(1000)
				zCLIENT.SetPedInBed(source)
			end
		end
	end
end

RegisterServerEvent('upgradeStress')
AddEventHandler('upgradeStress',function(number)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.upgradeStress(user_id,parseInt(number))
	end
end)