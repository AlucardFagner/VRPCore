local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
client = {}
Tunnel.bindInterface("zLumberman",client)
server = Tunnel.getInterface("zLumberman")

local ouService = false
local inService = false
local selected = 0
local timeSeconds = 0
local collectBlip = nil
local deliverBlip = nil
local coSelected = 0
local deSelected = 0
local vehModel = -667151410

RegisterNetEvent('zLumberman:startJob')
AddEventHandler('zLumberman:startJob',function()
	if inService then
		inService = false
		TriggerEvent("Notify","aviso","O serviço de <b>Lenhador</b> foi finalizado.",2000)
		if DoesBlipExist(collectBlip) then
			RemoveBlip(collectBlip)
			collectBlip = nil
		end
		if DoesBlipExist(deliverBlip) then
			RemoveBlip(deliverBlip)
			deliverBlip = nil
		end
	else
		startthreadservice()
		inService = true
		if not ouService then
			ouService = true
			coSelected = math.random(#config.Collect)
			deSelected = math.random(#config.Delivery)
		end
		collectBlipMarked()
		deliverBlipMarked()
		TriggerEvent("Notify","aviso","O serviço de <b>Lenhador</b> foi iniciado.",2000)
	end
end)

function startthreadservice()
	Citizen.CreateThread(function()
		while true do
			local timeDistance = 500
			if inService then
				local ped = PlayerPedId()
				if not IsPedInAnyVehicle(ped) then
					local coords = GetEntityCoords(ped)
					local collectDis = #(coords - vector3(config.Collect[coSelected][1],config.Collect[coSelected][2],config.Collect[coSelected][3]))
					if collectDis <= 30 then
						timeDistance = 4
						DrawMarker(21,config.Collect[coSelected][1],config.Collect[coSelected][2],config.Collect[coSelected][3]-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,100,185,230,50,0,0,0,1)
						if collectDis <= 1.1 and GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_HATCHET") and IsControlJustPressed(1,38) then
							if server.collectMethod() then
								SetEntityHeading(ped,config.Collect[coSelected][4])
								SetEntityCoords(ped,config.Collect[coSelected][1],config.Collect[coSelected][2],config.Collect[coSelected][3]-1)
								vRP.playAnim(false,{"melee@hatchet@streamed_core","plyr_front_takedown_b"},true)
								SetTimeout(3000,function()
									vRP.removeObjects()
									TriggerEvent("cancelando",false)
									coSelected = math.random(#config.Collect)
									collectBlipMarked()
								end)
							end
						end
					end
					local deliverDis = #(coords - vector3(config.Delivery[deSelected][1],config.Delivery[deSelected][2],config.Delivery[deSelected][3]))
					if deliverDis <= 100 then
						timeDistance = 4
						DrawMarker(21,config.Delivery[deSelected][1],config.Delivery[deSelected][2],config.Delivery[deSelected][3]-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,100,185,230,50,0,0,0,1)
						if deliverDis <= 0.6 and IsControlJustPressed(1,38) and GetEntityModel(GetPlayersLastVehicle()) == vehModel then
							if server.paymentMethod() then
								deSelected = math.random(#config.Delivery)
								deliverBlipMarked()
							end
						end
					end
				end
			end
			Citizen.Wait(timeDistance)
		end
	end)
end

function collectBlipMarked()
	if DoesBlipExist(collectBlip) then
		RemoveBlip(collectBlip)
		collectBlip = nil
	end
	collectBlip = AddBlipForCoord(config.Collect[coSelected][1],config.Collect[coSelected][2],config.Collect[coSelected][3])
	SetBlipSprite(collectBlip,1)
	SetBlipColour(collectBlip,5)
	SetBlipScale(collectBlip,0.4)
	SetBlipAsShortRange(collectBlip,false)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Collect")
	EndTextCommandSetBlipName(collectBlip)
end

function deliverBlipMarked()
	if DoesBlipExist(deliverBlip) then
		RemoveBlip(deliverBlip)
		deliverBlip = nil
	end
	deliverBlip = AddBlipForCoord(config.Delivery[deSelected][1],config.Delivery[deSelected][2],config.Delivery[deSelected][3])
	SetBlipSprite(deliverBlip,1)
	SetBlipColour(deliverBlip,84)
	SetBlipScale(deliverBlip,0.4)
	SetBlipAsShortRange(deliverBlip,false)
	SetBlipRoute(deliverBlip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Delivery")
	EndTextCommandSetBlipName(deliverBlip)
end