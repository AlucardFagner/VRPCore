local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface("vRP")

zGarages = Tunnel.getInterface("zGarages")
zSERVER = Tunnel.getInterface("zTruckdriver")

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
	AddTextComponentString("Rota de Caminhoneiro")
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
		local nveh = CreateVehicle(mhash,x,y,z,267.54,true,false)
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
		SetVehicleNumberPlateText(NetToVeh(netveh),"CAMINHAO")
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

RegisterNetEvent('zTruckdriver:StartJob')
AddEventHandler('zTruckdriver:StartJob', function()
	if not emservico then
		for _,v in pairs(config.start) do
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local lastVehicle = GetEntityModel(GetPlayersLastVehicle())
			ToggleActionMenu()
		end
	elseif emservico then
		emservico = false
		RemoveBlip(blip)
		TriggerEvent("Notify","importante","Você cancelou o serviço.",8000)
		wood = false
		gas = false
		criado = false
		zSERVER.setWork()
	end
end)

RegisterNUICallback("ButtonClick",function(data,cb)	
	if data == "gas-01" then
		if emservico == true then
			TriggerEvent("Notify","importante","Voce ja esta em serviço.",8000)
		else
			for k,v in pairs(config.trailer) do
				if k == 1 then
					servehicle = 1956216962
					emservico = true
					gas = true
					entrega = 1
					pay = config.routegas[entrega].pay
					zSERVER.setWork()
					ToggleActionMenu()
					spawnVehicle("tanker2",v.x,v.y,v.z)
					TriggerEvent("Notify","sucesso","Você entrou em serviço. Carga liberado para entrega.",8000)
				end
			end
		end
	elseif data == "gas-02" then
		if emservico == true then
			TriggerEvent("Notify","importante","Voce ja esta em serviço.",8000)
		else
			for k,v in pairs(config.trailer) do
				if k == 2 then
					servehicle = 1956216962
					emservico = true
					gas = true
					entrega = 2
					pay = config.routegas[entrega].pay
					zSERVER.setWork()
					ToggleActionMenu()
					spawnVehicle("tanker2",v.x,v.y,v.z)
					TriggerEvent("Notify","sucesso","Você entrou em serviço. Carga liberado para entrega.",8000)
				end
			end
		end
	elseif data == "gas-03" then
		if emservico == true then
			TriggerEvent("Notify","importante","Voce ja esta em serviço.",8000)
		else
			for k,v in pairs(config.trailer) do
				if k == 3 then
					servehicle = 1956216962
					emservico = true
					gas = true
					entrega = 3
					pay = config.routegas[entrega].pay
					zSERVER.setWork()
					ToggleActionMenu()
					spawnVehicle("tanker2",v.x,v.y,v.z)
					TriggerEvent("Notify","sucesso","Você entrou em serviço. Carga liberado para entrega.",8000)
				end
			end
		end
	elseif data == "woods-01" then
		if emservico == true then
			TriggerEvent("Notify","importante","Voce ja esta em serviço.",8000)
		else
			for k,v in pairs(config.trailer) do
				if k == 4 then
					servehicle = 2016027501
					emservico = true
					wood = true
					entrega = 1
					pay = config.routewood[entrega].pay
					zSERVER.setWork()
					ToggleActionMenu()
					spawnVehicle("trailerlogs",v.x,v.y,v.z)
					TriggerEvent("Notify","sucesso","Você entrou em serviço. Carga liberado para entrega.",8000)
				end
			end
		end
	elseif data == "woods-02" then
		if emservico == true then
			TriggerEvent("Notify","importante","Voce ja esta em serviço.",8000)
		else
			for k,v in pairs(config.trailer) do
				if k == 5 then
					servehicle = 2016027501
					emservico = true
					wood = true
					entrega = 2
					pay = config.routewood[entrega].pay
					zSERVER.setWork()
					ToggleActionMenu()
					spawnVehicle("trailerlogs",v.x,v.y,v.z)
					TriggerEvent("Notify","sucesso","Você entrou em serviço. Carga liberado para entrega.",8000)
				end
			end
		end
	elseif data == "woods-03" then
		if emservico == true then
			TriggerEvent("Notify","importante","Voce ja esta em serviço.",8000)
		else
			for k,v in pairs(config.trailer) do
				if k == 6 then
					servehicle = 2016027501
					emservico = true
					wood = true
					entrega = 3
					pay = config.routewood[entrega].pay
					zSERVER.setWork()
					ToggleActionMenu()
					spawnVehicle("trailerlogs",v.x,v.y,v.z)
					TriggerEvent("Notify","sucesso","Você entrou em serviço. Carga liberado para entrega.",8000)
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
				local bowz,cdz = GetGroundZFor_3dCoord(config.routegas[entrega].x, config.routegas[entrega].y, config.routegas[entrega].z)
				local distance = GetDistanceBetweenCoords(GetEntityCoords(ped),config.routegas[entrega].x,config.routegas[entrega].y,config.routegas[entrega].z,true)
				if criado == false then
					criandoblip(config.routegas[entrega].x, config.routegas[entrega].y, config.routegas[entrega].z)
					criado = true
				end
				if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), config.routegas[entrega].x,config.routegas[entrega].y,config.routegas[entrega].z, true ) < 50 then
					idle = 5
					DrawMarker(23,config.routegas[entrega].x, config.routegas[entrega].y, config.routegas[entrega].z-0.96,0, 0, 0, 0, 0, 0, 10.0, 10.0, 1.0, 136, 96, 240, 180, 0, 0, 0, 0)
					if distance <= 10.0 then
						if IsControlJustPressed(0,38) then
							if not IsPedInAnyVehicle(ped) then
								local vehicle = getVehicleInDirection(GetEntityCoords(PlayerPedId()),GetOffsetFromEntityInWorldCoords(PlayerPedId(),0.0,5.0,0.0))
								if GetEntityModel(vehicle) == servehicle then
									zGarages.deleteVehicles(vehicle)
									zSERVER.checkPaymentGas()
									RemoveBlip(blip)
									emservico = false
									criado = false
									gas = false	
								end
							else	
								TriggerEvent("Notify","importante","Saia do caminhao e vá ao lado da carga para entregar.",8000)					
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
				local bowz,cdz = GetGroundZFor_3dCoord(config.routewood[entrega].x, config.routewood[entrega].y, config.routewood[entrega].z)
				local distance = GetDistanceBetweenCoords(config.routewood[entrega].x, config.routewood[entrega].y, config.routewood[entrega].z,cdz,x,y,z,true)
				if criado == false then
					criandoblip(config.routewood[entrega].x, config.routewood[entrega].y, config.routewood[entrega].z)
					criado = true
				end
				if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), config.routewood[entrega].x,config.routewood[entrega].y,config.routewood[entrega].z, true ) < 50 then
					idle = 5
					DrawMarker(23,config.routewood[entrega].x, config.routewood[entrega].y, config.routewood[entrega].z-0.96,0, 0, 0, 0, 0, 0, 10.0, 10.0, 1.0, 136, 96, 240, 180, 0, 0, 0, 0)
					if IsControlJustPressed(0,38) then
						if not IsPedInAnyVehicle(ped) then
							local vehicle = getVehicleInDirection(GetEntityCoords(PlayerPedId()),GetOffsetFromEntityInWorldCoords(PlayerPedId(),0.0,5.0,0.0))
							if GetEntityModel(vehicle) == servehicle then
								zGarages.deleteVehicles(vehicle)
								zSERVER.checkPaymentWood()
								RemoveBlip(blip)
								emservico = false
								criado = false	
								wood = false
							end
						else	
							TriggerEvent("Notify","importante","Saia do caminhao e vá ao lado da carga para entregar.",8000)					
						end
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)