local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
client = {}
Tunnel.bindInterface("zHarvest",client)
server = Tunnel.getInterface("zHarvest")

local ouService = false
local inService = false
local selected = 0
local blip = nil
local coSelected = 0
local timeSeconds = 0

RegisterNetEvent('zHarvest:start')
AddEventHandler('zHarvest:start', function()
	if inService then
		inService = false
		TriggerEvent("Notify","aviso","O serviço de <b>Colheita</b> foi finalizado.",2000)
		if DoesBlipExist(blip) then
			RemoveBlip(blip)
			blip = nil
		end
	else
		startthreadservice()
		startthreadserviceseconds()
		inService = true
		if not ouService then
			ouService = true
			coSelected = math.random(#config.CollectPoint)
		end
		makeBlipMarked()
		TriggerEvent("Notify","aviso","O serviço de <b>Colheita</b> foi iniciado.",2000)
	end
end)

function startthreadservice()
	Citizen.CreateThread(function()
		while true do
			local timeDistance = 500
			if inService then
				local ped = PlayerPedId()
				local coords = GetEntityCoords(ped)
				local collectDis = #(coords - vector3(config.CollectPoint[coSelected][1],config.CollectPoint[coSelected][2],config.CollectPoint[coSelected][3]))
				if collectDis <= 150 then
					timeDistance = 4
					DrawText3D(config.CollectPoint[coSelected][1],config.CollectPoint[coSelected][2],config.CollectPoint[coSelected][3],"~g~E~w~  COLHER")
					if collectDis <= 0.8 and IsControlJustPressed(1,38) and timeSeconds <= 0 then
						timeSeconds = 2
						if server.collectMethod() then
							SetEntityHeading(ped,config.CollectPoint[coSelected][4])
							SetEntityCoords(ped,config.CollectPoint[coSelected][1],config.CollectPoint[coSelected][2],config.CollectPoint[coSelected][3]-1)

							SetTimeout(4000,function()
								vRP.removeObjects()
								TriggerEvent("cancelando",false)
								coSelected = math.random(#config.CollectPoint)
							end)
						end
					end
				end
			end
			Citizen.Wait(timeDistance)
		end
	end)
end

function startthreadserviceseconds()
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
	blip = AddBlipForCoord(config.CollectPoint[coSelected][1],config.CollectPoint[coSelected][2],config.CollectPoint[coSelected][3])
	SetBlipSprite(blip,1)
	SetBlipColour(blip,84)
	SetBlipScale(blip,0.4)
	SetBlipAsShortRange(blip,false)
	SetBlipRoute(blip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Colheita")
	EndTextCommandSetBlipName(blip)
end

function DrawText3D(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(176,180,193,150)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text))/350
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,50,55,67,200)
end