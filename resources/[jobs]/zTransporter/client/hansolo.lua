local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
client = {}
Tunnel.bindInterface("zTransporter",client)
server = Tunnel.getInterface("zTransporter")

local ouService = false
local inService = false
local selected = 0
local blipCollect = nil
local blipDelivery = nil
local coSelected = 0
local deSelected = 0

function toggleService()
	if inService then
		inService = false
		TriggerEvent("Notify","negado","O serviço de <b>Transportador</b> foi finalizado.",2000)
		if DoesBlipExist(blipCollect) then
			RemoveBlip(blipCollect)
			blipCollect = nil
		end
		
		if DoesBlipExist(blipDelivery) then
			RemoveBlip(blipDelivery)
			blipDelivery = nil
		end
	else
		startthreadservice()
		inService = true
		if not ouService then
			ouService = true
			coSelected = math.random(#config.LocateCollect)
			deSelected = math.random(#config.LocateDelivery)
		end
		
		makeCollectMarked(config.LocateCollect[coSelected][1],config.LocateCollect[coSelected][2],config.LocateCollect[coSelected][3])
		makeDeliveryMarked(config.LocateDelivery[deSelected][1],config.LocateDelivery[deSelected][2],config.LocateDelivery[deSelected][3])
		TriggerEvent("Notify","aviso","O serviço de <b>Transportador</b> foi iniciado.",2000)
		
	end
end

function startthreadservice()
	Citizen.CreateThread(function()
		while true do
			local timeDistance = 500
			if inService then
				local ped = PlayerPedId()
				if not IsPedInAnyVehicle(ped) then
					local coords = GetEntityCoords(ped)
					local collectDis = #(coords - vector3(config.LocateCollect[coSelected][1],config.LocateCollect[coSelected][2],config.LocateCollect[coSelected][3]))
					if collectDis <= 10 then
						timeDistance = 4
						DrawText3D(config.LocateCollect[coSelected][1],config.LocateCollect[coSelected][2],config.LocateCollect[coSelected][3],"~g~E~w~  COLETAR")
						makeCollectMarked(config.LocateCollect[coSelected][1],config.LocateCollect[coSelected][2],config.LocateCollect[coSelected][3])
						if collectDis <= 0.6 and IsControlJustPressed(1,38) then
							SetEntityHeading(ped,config.LocateCollect[coSelected][4])
							SetEntityCoords(ped,config.LocateCollect[coSelected][1],config.LocateCollect[coSelected][2],config.LocateCollect[coSelected][3]-1)
							TriggerEvent("cancelando",true)
							TriggerEvent("Progress",10000,"Coletando...")
							vRP.playAnim(false,{"amb@prop_human_atm@male@idle_a","idle_a"},true)
							Wait(10000)
							server.collectMethod()
							TriggerEvent("cancelando",false)
							ClearPedTasks(ped)
							vRP.removeObjects()
							coSelected = math.random(#config.LocateCollect)
						end
					end
					local deliverDis = #(coords - vector3(config.LocateDelivery[deSelected][1],config.LocateDelivery[deSelected][2],config.LocateDelivery[deSelected][3]))
					if deliverDis <= 150 then
						timeDistance = 4
						DrawText3D(config.LocateDelivery[deSelected][1],config.LocateDelivery[deSelected][2],config.LocateDelivery[deSelected][3],"~g~E~w~  Abastecer ATM")
						makeDeliveryMarked(config.LocateDelivery[deSelected][1],config.LocateDelivery[deSelected][2],config.LocateDelivery[deSelected][3])
						if deliverDis <= 0.6 and IsControlJustPressed(1,38) then
						    if GetEntityModel(GetPlayersLastVehicle()) == config.VehModel then
								TriggerEvent("Notify","aviso","ATM abastecido</b>.",3000)
							if server.paymentMethod() then
								deSelected = math.random(#config.LocateDelivery)
								makeDeliveryMarked(config.LocateDelivery[deSelected][1],config.LocateDelivery[deSelected][2],config.LocateDelivery[deSelected][3])
							end
							else
								TriggerEvent("Notify","aviso","Você precisa utilizar o veículo do <b>Transportador</b>.",3000)
							end
						end
					end
				end
				timeDistance = 4
				if IsControlJustPressed(1,168) then
					guardarCarro()
					toggleService()
				end
			end
			Citizen.Wait(timeDistance)
		end
	end)
end

function DrawText3D(x,y,z,text)
	local onScreen,_x,_y = GetScreenCoordFromWorldCoord(x,y,z)

	if onScreen then
		BeginTextCommandDisplayText("STRING")
		AddTextComponentSubstringKeyboardDisplay(text)
		SetTextColour(255,255,255,150)
		SetTextScale(0.35,0.35)
		SetTextFont(4)
		SetTextCentre(1)
		EndTextCommandDisplayText(_x,_y)

		local width = string.len(text) / 160 * 0.45
		DrawRect(_x,_y + 0.0125,width,0.03,38,42,56,200)
	end
end

function makeCollectMarked(x,y,z)
	if DoesBlipExist(blipCollect) then
		RemoveBlip(blipCollect)
		blipCollect = nil
	end
	blipCollect = AddBlipForCoord(x,y,z)
	SetBlipSprite(blipCollect,12)
	SetBlipColour(blipCollect,2)
	SetBlipScale(blipCollect,0.9)
	SetBlipAsShortRange(blipCollect,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Coletar")
	EndTextCommandSetBlipName(blipCollect)
end

function makeDeliveryMarked(x,y,z)
	if DoesBlipExist(blipDelivery) then
		RemoveBlip(blipDelivery)
		blipDelivery = nil
	end
	blipDelivery = AddBlipForCoord(x,y,z)
	SetBlipSprite(blipDelivery,12)
	SetBlipColour(blipDelivery,5)
	SetBlipScale(blipDelivery,0.9)
	SetBlipAsShortRange(blipDelivery,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entregar")
	EndTextCommandSetBlipName(blipDelivery)
end

----------- Função que cria o veículo

function criaCarro()
	local vehicle = config.vehicle
		local mhash = GetHashKey(config.vehicle)
		while not HasModelLoaded(mhash) do
			RequestModel(mhash)
			Citizen.Wait(10)
		end

	if HasModelLoaded(mhash) then
		rand = 1
		while true do
			checkPos = GetClosestVehicle(-5.35, -670.3, 32.34, 188.06,0,71)
		local spawnLocs = 	{
							[1] = { ['x'] = -5.35, ['y'] = -670.3, ['z'] = 32.34, ['h'] = 188.06 },
							}
			if DoesEntityExist(checkPos) and checkPos ~= nil then
				rand = rand + 1
				if rand > #spawnLocs[1] then
					rand = -1
					TriggerEvent("Notify","importante","Todas as vagas estão ocupadas no momento.",9000)
					break
				end
			else
				break
			end
			Citizen.Wait(1)
		end
		if rand ~= -1 then
			nveh = CreateVehicle(mhash,-5.35, -670.3, 32.34+0.5, 188.06,true,false)
			netveh = VehToNet(nveh)

			NetworkRegisterEntityAsNetworked(nveh)
			while not NetworkGetEntityIsNetworked(nveh) do
				NetworkRegisterEntityAsNetworked(nveh)
				Citizen.Wait(1)
			end
			if NetworkDoesNetworkIdExist(netveh) then
				SetEntitySomething(nveh,true)
				if NetworkGetEntityIsNetworked(nveh) then
					SetNetworkIdExistsOnAllMachines(netveh,true)
				end
			end
			NetworkFadeInEntity(NetToEnt(netveh),true)
			SetVehicleIsStolen(NetToVeh(netveh),false)
			SetVehicleNeedsToBeHotwired(NetToVeh(netveh),false)
			SetEntityInvincible(NetToVeh(netveh),false)
			SetEntityAsMissionEntity(NetToVeh(netveh),true,true)
			SetVehicleHasBeenOwnedByPlayer(NetToVeh(netveh),true)
			SetVehRadioStation(NetToVeh(netveh),"OFF")
			if custom then
				vRPg.setVehicleMods(custom,NetToVeh(netveh))
			end
			SetVehicleEngineHealth(NetToVeh(netveh),1000+0.0)
			SetVehicleBodyHealth(NetToVeh(netveh),1000+0.0)
			SetVehicleFuelLevel(NetToVeh(netveh),100+0.0)
			SetModelAsNoLongerNeeded(mhash)

		end
		return true,VehToNet(nveh),name
	end
end

	--- função para deletar o veículo

function guardarCarro()

 local vehicle = vRP.getNearestVehicle(30)

  local model = GetEntityModel(vehicle)
  local displaytext = GetDisplayNameFromVehicleModel(model)
  local name = GetLabelText(displaytext)

if name == config.vehicle then
	TriggerServerEvent("zGarages:deleteVehicle",VehToNet(vehicle),GetVehicleEngineHealth(vehicle),GetVehicleBodyHealth(vehicle),GetVehicleFuelLevel(vehicle))
	TriggerServerEvent("deleteVehicle",VehToNet(vehicle))
	end
end

	--- thread que inicia o serviço e puxa a função de criar veículo

Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		if not inService then
			local ped = PlayerPedId()
			if not IsPedInAnyVehicle(ped) then
				local coords = GetEntityCoords(ped)
				local startDis = #(coords - vector3(config.LocateService['x'],config.LocateService['y'],config.LocateService['z']))
				if startDis <= 10 then
					timeDistance = 4
					DrawText3D(config.LocateService['x'],config.LocateService['y'],config.LocateService['z'],"~g~E~w~  INICIAR O TRABALHO")
					makeCollectMarked(config.LocateService['x'],config.LocateService['y'],config.LocateService['z'])
					if startDis <= 1.1 and IsControlJustPressed(1,38) then
						criaCarro()
						toggleService()
					end
				end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)