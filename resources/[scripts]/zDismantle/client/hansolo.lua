local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
client = {}
Tunnel.bindInterface("zDismantle",client)
server = Tunnel.getInterface("zDismantle")

local inService = false
local startjob = false

function startDismantle()
	Citizen.CreateThread(function()
		while true do
			local timeDistance = 500
			if inService then
				local ped = PlayerPedId()
				if not IsPedInAnyVehicle(ped) then
					local coords = GetEntityCoords(ped)
					local distance = #(coords - config.LocateDismantle)
					if distance <= 3 then
						timeDistance = 4
						dwText("~y~E~w~  PRESSIONE PARA DESMANCHAR",0.95)
						if IsControlJustPressed(1,38) then
							local status,vehicle = server.checkVehlist()
							if server.blockVehicle() then
								if status then
									startjob = true
									TaskTurnPedToFaceEntity(ped,vehicle,1000)
									Citizen.Wait(2000)
									SetEntityInvincible(ped,true)
									FreezeEntityPosition(ped,true)
									TriggerEvent("cancelando",true)
									FreezeEntityPosition(vehicle,true)
									vRP._playAnim(false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)
									for i = 0,5 do
										Citizen.Wait(10000)
										SetVehicleDoorBroken(vehicle,i,false)
									end
									for i = 0,7 do
										Citizen.Wait(10000)
										SetVehicleTyreBurst(vehicle,i,1,1000.01)
									end
									vRP.removeObjects()
									SetEntityInvincible(ped,false)
									FreezeEntityPosition(ped,false)
									TriggerEvent("cancelando",false)
									if server.paymentMethod(vehicle) then 
										startjob = false
									end
								end
							else
								TriggerEvent("Notify","vermelho","Este veículo é protegido pela seguradora.",5000)
							end
						end
					end
				end
			end
			Citizen.Wait(timeDistance)
		end
	end)
end

function dwText(text,height)
	SetTextFont(4)
	SetTextScale(0.50,0.50)
	SetTextColour(255,255,255,180)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.5,height)
end

RegisterNetEvent('zDismantle:Start')
AddEventHandler('zDismantle:Start', function()
	if server.permUnique() then
		startDismantle()
		inService = true
	end
end)