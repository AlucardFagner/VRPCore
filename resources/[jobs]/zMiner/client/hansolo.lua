local Tunnel = module('vrp','lib/Tunnel')
local Proxy = module('vrp','lib/Proxy')
vRP = Proxy.getInterface('vRP')

zSERVER = Tunnel.getInterface('zMiner')

local working = false
local selected = 1
local process = false

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		if not working then
			local ped = PlayerPedId()
			if not IsPedInAnyVehicle(ped) then
				local x,y,z = table.unpack(GetEntityCoords(ped))
				local distance = Vdist(x, y, z, config.rocks[selected].x, config.rocks[selected].y, config.rocks[selected].z)
				--local lastVehicle = GetEntityModel(GetPlayersLastVehicle())
				if distance <= 100.0 then
					idle = 5
					DrawMarker(21, config.rocks[selected].x, config.rocks[selected].y, config.rocks[selected].z-0.3, 0, 0, 0, 0, 180.0, 130.0, 0.6, 0.8, 0.5, 136, 96, 240, 180, 1, 0, 0, 1)
					if distance <= 1.2 and IsControlJustPressed(1,38) then
						--if lastVehicle == config.lastveh and zSERVER.checkPlate(lastVehicle) and zSERVER.checkCrimeRecord() then
							if zSERVER.checkWeight() then
								working = true
								vRP.removeObjects()
								TriggerEvent('cancelando',true)
								SetEntityCoords(ped, config.rocks[selected].x+0.0001, config.rocks[selected].y+0.0001, config.rocks[selected].z+0.0001-1, 1, 0, 0, 1)
								vRP.createObjects('amb@world_human_const_drill@male@drill@base', 'base','prop_tool_jackham', 15, 28422)
								
								SetTimeout(10000,function()
									working = false
									vRP.removeObjects()
									vRP._stopAnim(false)
									TriggerEvent('cancelando',false)
									backentrega = selected
									while true do
										if backentrega == selected then
											selected = math.random(#config.rocks)
										else
											break
										end
										Citizen.Wait(10)
									end
									zSERVER.collectOres()
								end)
							else
								TriggerEvent('Notify','negado','<b>Ferramenta</b> ou <b>espaço na mochila</b> insuficientes.', 8000)	
							end
						--else
							--TriggerEvent('Notify','negado','Você precisa do <b>veículo da mineradora</b> para fazer isso.')
						--end
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)