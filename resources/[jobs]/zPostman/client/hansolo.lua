local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

zSERVER = Tunnel.getInterface("zPostman")

local process = false
local time = 0
local check = 0
local blips = false
local inService = false

RegisterNetEvent('zPostman:StartJob')
AddEventHandler('zPostman:StartJob', function()
	local ped = PlayerPedId()
	if not IsPedInAnyVehicle(ped) then
		local lastVehicle = GetEntityModel(GetPlayersLastVehicle())
		if not inService then
			inService = true
			check = math.random(#config.postmandeliverys)
			makeBlipsServices()
			TriggerEvent("Notify","sucesso","<b>Rota</b> iniciada.",8000)
			zSERVER.setWork()
		end
	end
end)

RegisterNetEvent('zPostman:BoxRem')
AddEventHandler('zPostman:BoxRem', function()
	local ped = PlayerPedId()
	if not IsPedInAnyVehicle(ped) then
		local x,y,z = table.unpack(GetEntityCoords(ped))
		if not process then
			process = true
			TriggerEvent('cancelando',true)
			TriggerEvent("Notify","progress",8000,"Coletando")
			FreezeEntityPosition(ped,true)
			vRP.playAnim(false,{"amb@prop_human_parking_meter@male@base","base"},true)
			SetTimeout(8000,function()
				process = false
				TriggerEvent('cancelando',false)
				zSERVER.giveOrders()
				FreezeEntityPosition(ped,false)
				vRP._stopAnim(false)
			end)
		end
	end
end)

function CalculateTimeToDisplay5()
	time = GetClockHours()
	if time <= 9 then
		time = "0" .. time
	end
end

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.28, 0.28)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.005+ factor, 0.03, 41, 11, 41, 68)
end

function makeBlipsServices()
	blips = AddBlipForCoord(config.postmandeliverys[check][1],config.postmandeliverys[check][2],config.postmandeliverys[check][3])
	SetBlipSprite(blips,1)
	SetBlipColour(blips,27)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Encomendas")
	EndTextCommandSetBlipName(blips)
end

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		local ped = PlayerPedId()
		if inService then
			if not IsPedInAnyVehicle(ped) then
				local x,y,z = table.unpack(GetEntityCoords(ped))
				local distance = Vdist(config.postmandeliverys[check][1],config.postmandeliverys[check][2],config.postmandeliverys[check][3],x,y,z)
				local lastVehicle = GetEntityModel(GetPlayersLastVehicle())
				if distance < 10.1 then
					idle = 5
					DrawMarker(21, config.postmandeliverys[check][1],config.postmandeliverys[check][2],config.postmandeliverys[check][3]-0.3, 0, 0, 0, 0, 180.0, 130.0, 0.6, 0.8, 0.5, 136, 96, 240, 180, 1, 0, 0, 1)
					if distance < 1.2 then
						if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),config.postmandeliverys[check][1],config.postmandeliverys[check][2],config.postmandeliverys[check][3], true ) <= 1.1  then
							DrawText3D(config.postmandeliverys[check][1],config.postmandeliverys[check][2],config.postmandeliverys[check][3], "Pressione [~p~E~w~] para entregar as ~p~ENCOMENDAS~w~.")
						end
						if IsControlJustPressed(1,38) then
							if lastVehicle == GetHashKey(config.postmanveh) then
								if zSERVER.startPayments() then
									RemoveBlip(blips)
									check = math.random(#config.postmandeliverys)
									makeBlipsServices()
								end
							else
								TriggerEvent("Notify","negado","Você precisa do <b>veículo de entregas</b> para fazer isso.",8000)
							end
						end
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)

Citizen.CreateThread(function()
	while true do
		local idle=1000
		if inService then
			idle=5
			if IsControlJustPressed(0,168) then
				inService = false
				RemoveBlip(blips)
				TriggerEvent("Notify","importante","Você saiu de serviço.",8000)
				zSERVER.setWork()
			end
		end
		Citizen.Wait(idle)
	end
end)