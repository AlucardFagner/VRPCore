local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

zSERVER = Tunnel.getInterface("zGarages")
server = Tunnel.getInterface("zPilot")

local emservico = false
local menuactive = false
local wood = false
local gas = false
local criado = false
local servehicle = nil
local entrega = 0
local pay = 0

function CalculateTimeToDisplay6()
	hour = GetClockHours()
	if hour <= 9 then
		hour = "0" .. hour
	end
end

function ToggleActionMenu()
	menuactive = not menuactive
	if menuactive then
		SetNuiFocus(true,true)
		SendNUIMessage({ showmenu = true })
	else
		SetNuiFocus(false)
		SendNUIMessage({ hidemenu = true })
	end
end

function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function criandoblip(x,y,z)
	blip = AddBlipForCoord(x,y,z)
	SetBlipSprite(blip,1)
	SetBlipColour(blip,27)
	SetBlipScale(blip,0.4)
	SetBlipAsShortRange(blip,false)
	SetBlipRoute(blip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Plano de Voo")
	EndTextCommandSetBlipName(blip)
	criado = true
end

function spawnVehicle(name,x,y,z)
	local mhash = GetHashKey(name)
	while not HasModelLoaded(mhash) do
		RequestModel(mhash)
		Citizen.Wait(10)
	end
	
	if HasModelLoaded(mhash) then
		local nveh = CreateVehicle(mhash,x,y,z,147.22,true,false)
		local netveh = VehToNet(nveh)
		local id = NetworkGetNetworkIdFromEntity(nveh)

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

		SetNetworkIdCanMigrate(id,true)
		SetVehicleNumberPlateText(NetToVeh(netveh),"AVIAO")
		Citizen.InvokeNative(0xAD738C3085FE7E11,NetToVeh(netveh),true,true)
		SetVehicleHasBeenOwnedByPlayer(NetToVeh(netveh),true)
		SetVehicleNeedsToBeHotwired(NetToVeh(netveh),false)
		SetModelAsNoLongerNeeded(mhash)
	end
end

function getVehicleInDirection(coordsfrom,coordsto)
	local handle = CastRayPointToPoint(coordsfrom.x,coordsfrom.y,coordsfrom.z,coordsto.x,coordsto.y,coordsto.z,10,PlayerPedId(),false)
	local a,b,c,d,vehicle = GetRaycastResult(handle)
	return vehicle
end

RegisterNetEvent('zPilot:StartJob')
AddEventHandler('zPilot:StartJob', function()
	if not emservico then
		for _,v in pairs(config.start) do
			local cds = GetEntityCoords(PlayerPedId())
			ToggleActionMenu()
		end
	elseif emservico then
		emservico = false
		wood = false
		gas = false
		criado = false
		zSERVER.deleteVehicles(vehicle)
		RemoveBlip(blip)
		TriggerEvent("Notify","importante","Você cancelou o serviço.",8000)
	end
end)

RegisterNUICallback("ButtonClick",function(data,cb)	
	if data == "airport-1" then
		if emservico == true then
			TriggerEvent("Notify","importante","Voce ja esta em serviço.",8000)
		else
			for k,v in pairs(config.spawn) do
				if k == 1 then
					TriggerEvent("Notify","sucesso","Você entrou em serviço. Avião liberado para decolagem.",8000)
					spawnVehicle(config.plane,v.x,v.y,v.z)
					servehicle = GetEntityModel(config.plane)
					emservico = true
					gas = true
					entrega = 1
					pay = config.routeshamal[entrega].pay
					ToggleActionMenu()
				end
			end
		end
	elseif data == "airport-2" then
		if emservico == true then
			TriggerEvent("Notify","importante","Voce ja esta em serviço.",8000)
		else
			for k,v in pairs(config.spawn) do
				if k == 2 then 
					TriggerEvent("Notify","sucesso","Você entrou em serviço. Avião liberado para decolagem.",8000)
					spawnVehicle(config.plane,v.x,v.y,v.z)
					servehicle = GetEntityModel(config.plane)
					emservico = true
					gas = true
					entrega = 2
					pay = config.routeshamal[entrega].pay
					ToggleActionMenu()
				end
			end
		end
	elseif data == "airport-3" then
		if emservico == true then
			TriggerEvent("Notify","importante","Voce ja esta em serviço.",8000)
		else
			for k,v in pairs(config.spawn) do
				if k == 3 then
					spawnVehicle(config.plane,v.x,v.y,v.z)
					TriggerEvent("Notify","sucesso","Você entrou em serviço. Avião liberado para decolagem.",8000)
					servehicle = GetEntityModel(config.plane)
					emservico = true
					gas = true
					entrega = 3
					pay = config.routeshamal[entrega].pay
					ToggleActionMenu()
				end
			end
		end
	elseif data == "airport-01" then
		if emservico == true then
			TriggerEvent("Notify","importante","Voce ja esta em serviço.",8000)
		else
			for k,v in pairs(config.spawn) do
				if k == 4 then
					spawnVehicle(config.plane1,v.x,v.y,v.z)
					TriggerEvent("Notify","sucesso","Você entrou em serviço. Avião liberado para decolagem.",8000)
					servehicle = GetEntityModel(config.plane1)
					emservico = true
					wood = true
					entrega = 1
					pay = config.routemiljet[entrega].pay
					ToggleActionMenu()
				end
			end
		end
	elseif data == "airport-02" then
		if emservico == true then
			TriggerEvent("Notify","importante","Voce ja esta em serviço.",8000)
		else
			for k,v in pairs(config.spawn) do
				if k == 5 then
					spawnVehicle(config.plane1,v.x,v.y,v.z)
					TriggerEvent("Notify","sucesso","Você entrou em serviço. Avião liberado para decolagem.",8000)
					servehicle = GetEntityModel(config.plane1)
					emservico = true
					wood = true
					entrega = 2
					pay = config.routemiljet[entrega].pay
					ToggleActionMenu()
				end
			end
		end
	elseif data == "airport-03" then
		if emservico == true then
			TriggerEvent("Notify","importante","Voce ja esta em serviço.",8000)
		else
			for k,v in pairs(config.spawn) do
				if k == 6 then
					spawnVehicle(config.plane1,v.x,v.y,v.z)
					TriggerEvent("Notify","sucesso","Você entrou em serviço. Avião liberado para decolagem.",8000)
					servehicle = GetEntityModel(config.plane1)
					emservico = true
					wood = true
					entrega = 3
					pay = config.routemiljet[entrega].pay
					ToggleActionMenu()
				end
			end
		end
	end
	if data == "fechar" then
		ToggleActionMenu()	
	end
end)

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		local ped = PlayerPedId()
		if gas then
			if emservico then
				local x,y,z = table.unpack(GetEntityCoords(ped))
				local bowz,cdz = GetGroundZFor_3dCoord(config.routeshamal[entrega].x, config.routeshamal[entrega].y, config.routeshamal[entrega].z)
				local distance = GetDistanceBetweenCoords(GetEntityCoords(ped),config.routeshamal[entrega].x,config.routeshamal[entrega].y,config.routeshamal[entrega].z,true)
				if criado == false then
					criandoblip(config.routeshamal[entrega].x, config.routeshamal[entrega].y, config.routeshamal[entrega].z)
					criado = true
				end
				if distance <= 100.0 then
					idle = 5
					DrawMarker(23,config.routeshamal[entrega].x, config.routeshamal[entrega].y, config.routeshamal[entrega].z-0.96,0, 0, 0, 0, 0, 0, 10.0, 10.0, 1.0, 136, 96, 240, 180, 0, 0, 0, 0)
					if distance <= 10.0 then
						if IsControlJustPressed(0,38) then
							local vehicle = getVehicleInDirection(GetEntityCoords(PlayerPedId()),GetOffsetFromEntityInWorldCoords(PlayerPedId(),0.0,5.0,0.0))
							if GetEntityModel(vehicle) == servehicle then
								zSERVER.deleteVehicles(vehicle)
								server.checkPaymentShamal(pay)
								RemoveBlip(blip)
								emservico = false
								criado = false	
								gas = false
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
		local idle = 1000
		local ped = PlayerPedId()
		if wood then
			if emservico then
				local x,y,z = table.unpack(GetEntityCoords(ped))
				local bowz,cdz = GetGroundZFor_3dCoord(config.routemiljet[entrega].x, config.routemiljet[entrega].y, config.routemiljet[entrega].z)
				local distance = GetDistanceBetweenCoords(config.routemiljet[entrega].x, config.routemiljet[entrega].y,cdz,x,y,false)
				if criado == false then
					criandoblip(config.routemiljet[entrega].x, config.routemiljet[entrega].y, config.routemiljet[entrega].z)
					criado = true
				end
				if distance <= 100.0 then
					idle = 5
					DrawMarker(23,config.routemiljet[entrega].x, config.routemiljet[entrega].y, config.routemiljet[entrega].z-0.96,0, 0, 0, 0, 0, 0, 10.0, 10.0, 1.0, 136, 96, 240, 180, 0, 0, 0, 0)
					if distance <= 10.0 then						
						if IsControlJustPressed(0,38) then
							local vehicle = GetEntityModel(GetPlayersLastVehicle())
							if GetEntityModel(vehicle) == servehicle then
								zSERVER.deleteVehicles(vehicle)
								server.checkPaymentMiljet(pay)
								RemoveBlip(blip)
								emservico = false
								criado = false	
								wood = false
							end
						end
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)