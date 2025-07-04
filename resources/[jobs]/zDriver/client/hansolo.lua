local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
client = {}
Tunnel.bindInterface("zDriver",client)
server = Tunnel.getInterface("zDriver")

local blip = nil
local inService = false
local driverPosition = 1
local timeSeconds = 0

function startthreadservice()
	Citizen.CreateThread(function()
		while true do
			local timeDistance = 500
			if inService then
				local ped = PlayerPedId()
				if IsPedInAnyVehicle(ped) then
					local veh = GetVehiclePedIsUsing(ped)
					local coordsPed = GetEntityCoords(ped)
					local distance = #(coordsPed - vector3(config.Coords[driverPosition][1],config.Coords[driverPosition][2],config.Coords[driverPosition][3]))
					if distance <= 300 and IsVehicleModel(veh,GetHashKey(config.Vehicle)) then
						timeDistance = 4
						DrawMarker(21,config.Coords[driverPosition][1],config.Coords[driverPosition][2],config.Coords[driverPosition][3]+0.60,0,0,0,0,180.0,130.0,2.0,2.0,1.0,121,206,121,100,1,0,0,1)
						if distance <= 15 then
							local speed = GetEntitySpeed(veh) * 2.236936
							if IsControlJustPressed(1,38) and speed <= 20 and timeSeconds <= 0 then
								timeSeconds = 2
								if driverPosition == #config.Coords then
									driverPosition = 1
									server.paymentMethod(true)
								else
									driverPosition = driverPosition + 1
									server.paymentMethod(false)
								end
								makeBlipMarked()
							end
						end
					end
				end
			end
			Citizen.Wait(timeDistance)
		end
	end)
end

function startthreadtimeseconds()
	Citizen.CreateThread(function()
		while true do
			if timeSeconds > 0 then
				timeSeconds = timeSeconds - 1
			end
			Citizen.Wait(1000)
		end
	end)
end

function makeBlipMarked()
	if DoesBlipExist(blip) then
		RemoveBlip(blip)
		blip = nil
	end
	blip = AddBlipForCoord(config.Coords[driverPosition][1],config.Coords[driverPosition][2],config.Coords[driverPosition][3],50.0)
	SetBlipSprite(blip,1)
	SetBlipColour(blip,2)
	SetBlipScale(blip,0.5)
	SetBlipAsShortRange(blip,false)
	SetBlipRoute(blip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Parada de Ônibus")
	EndTextCommandSetBlipName(blip)
end

RegisterNetEvent('zDriver:Start')
AddEventHandler('zDriver:Start', function()
	local ped = PlayerPedId()
	if not inService then
		startthreadservice()
		startthreadtimeseconds()
		inService = true
		makeBlipMarked()
		TriggerEvent("Notify","aviso","O serviço de <b>Motorista</b> foi iniciado.",2000)
	else
		inService = false
		TriggerEvent("Notify","aviso","O serviço de <b>Motorista</b> foi finalizado.",2000)
		if DoesBlipExist(blip) then
			RemoveBlip(blip)
			blip = nil
		end
	end
end)