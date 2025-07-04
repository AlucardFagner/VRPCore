local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
server = Tunnel.getInterface("zTaxi")

local blips = nil
local selecionado = 0
local emservico = false
local passageiro = nil
local lastpassageiro = nil
local checkped = true
local timers = 0
local payment = 1
local TaxiGuiAtivo = false
local Custobandeira = 3.0 
local custoporKm = 50.0
local CustoBase = 10.0
local inTaxi = false
local meterOpen = false
local meterActive = false

DecorRegister("bandeiras", 1)
DecorRegister("kilometros", 1)
DecorRegister("meteractive", 2)
DecorRegister("CustoBase", 1)
DecorRegister("custoporKm", 1)
DecorRegister("Custobandeira", 1)
	
RegisterNUICallback('close', function(data, cb)
	SendNUIMessage({openMeter = false})
	meterOpen = false
	cb('ok')
end)

RegisterKeyMapping('zTaxi:toggleHire', 'Activate the Meter', 'keyboard', 'F1')
RegisterCommand('zTaxi:toggleHire', function()
	if server.checkPermission() then
		TriggerEvent('taxi:toggleHire')
	end
end)

RegisterKeyMapping('zTaxi:resetMeter', 'Reset the Meter', 'keyboard', 'F2')
RegisterCommand('zTaxi:toggleHire', function()
	if server.checkPermission() then
		TriggerEvent('taxi:resetMeter')
	end
end)

RegisterKeyMapping('zTaxi:toggleDisplay', 'Activate the Display', 'keyboard', 'F3')
RegisterCommand('zTaxi:toggleHire', function()
	if server.checkPermission() then
		TriggerEvent('taxi:toggleDisplay')
	end
end)

RegisterNetEvent('zTaxi:StartJob')
AddEventHandler('zTaxi:StartJob', function()
	if not emservico then
		server.addGroup()
		emservico = true
		selecionado = math.random(#config.taxi)
		CriandoBlip(taxi,selecionado)
		TaxiGuiAtivo = true
		StartMeter()
		TriggerEvent("Notify","sucesso","Você entrou em serviço.",8000)
	elseif emservico then 
		local vehicle = GetVehiclePedIsIn(PlayerPedId())
		RemoveBlip(blips)
		if DoesEntityExist(passageiro) then
			TaskLeaveVehicle(passageiro,vehicle,262144)
			TaskWanderStandard(passageiro,10.0,10)
			Citizen.Wait(1100)
			SetVehicleDoorShut(vehicle,3,0)
			FreezeEntityPosition(vehicle,false)					
		end
		blips = nil
		selecionado = 0
		passageiro = nil
		checkped = true
		emservico = false
		server.removeGroup()
		TriggerEvent("Notify","importante","Você cancelou o serviço.",8000)
	end
end)

RegisterNetEvent('taxi:updatebandeira')
AddEventHandler('taxi:updatebandeira', function(veh)
	local _bandeira = DecorGetFloat(veh, "bandeiras")
	local _kilometros = DecorGetFloat(veh, "kilometros")
	local Custobandeira = _bandeira + (_kilometros * DecorGetFloat(veh, "custoporKm"))
	SendNUIMessage({
		updateBalance = true,
		balance = string.format("%.2f", Custobandeira),
		player = string.format("%.2f", _kilometros),
		meterActive = DecorGetBool(veh, "meteractive")
	})
end)

RegisterNetEvent('taxi:toggleDisplay')
AddEventHandler('taxi:toggleDisplay', function()
	if(NoTaxi() and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId()) then
		if meterOpen then
			SendNUIMessage({openMeter = false})
			meterOpen = false
		else
			local _bandeira = DecorGetFloat(GetVehiclePedIsIn(PlayerPedId(), false), "bandeiras")
			if _bandeira < CustoBase then
				DecorSetFloat(GetVehiclePedIsIn(PlayerPedId(), false), "bandeiras", CustoBase)
			end
			TriggerEvent('taxi:updatebandeira', GetVehiclePedIsIn(PlayerPedId(), false))
			SendNUIMessage({openMeter = true})
			meterOpen = true
		end
	end
end)

RegisterNetEvent('taxi:toggleHire')
AddEventHandler('taxi:toggleHire', function()
	if NoTaxi() then
		if meterActive then
			meterActive = false
			SendNUIMessage({meterActive = false})
			DecorSetBool(GetVehiclePedIsIn( PlayerPedId(), false), "meteractive", false)
		else
			meterActive = true
			SendNUIMessage({meterActive = true})
			DecorSetBool(GetVehiclePedIsIn( PlayerPedId(), false), "meteractive", true)
		end
	end
end)

RegisterNetEvent('taxi:resetMeter')
AddEventHandler('taxi:resetMeter', function()
	if(NoTaxi() and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId()) then
		local _bandeira = DecorGetFloat(GetVehiclePedIsIn(PlayerPedId(), false), "bandeiras")
		local _kilometros = DecorGetFloat(GetVehiclePedIsIn(PlayerPedId(), false), "kilometros")
		DecorSetFloat(GetVehiclePedIsIn(PlayerPedId(), false), "CustoBase", CustoBase)
		DecorSetFloat(GetVehiclePedIsIn(PlayerPedId(), false), "custoporKm", custoporKm)
		DecorSetFloat(GetVehiclePedIsIn(PlayerPedId(), false), "Custobandeira", Custobandeira)
		DecorSetFloat(GetVehiclePedIsIn(PlayerPedId(), false), "bandeiras", DecorGetFloat(GetVehiclePedIsIn(PlayerPedId(), false), "CustoBase"))
		DecorSetFloat(GetVehiclePedIsIn(PlayerPedId(), false), "kilometros", 0.0)
		TriggerEvent('taxi:updatebandeira', GetVehiclePedIsIn(PlayerPedId(), false))
	end
end)

function removePeds()
	SetTimeout(20000,function()
		if emservico and lastpassageiro and passageiro == nil then
			TriggerServerEvent("trydeleteped",PedToNet(lastpassageiro))
		end
	end)
end

function round(num, numDecimalPlaces)
	local mult = 5^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function NoTaxi()
	if IsVehicleModel(GetVehiclePedIsUsing(PlayerPedId()),GetHashKey("taxi")) then 
		return true
	end
	return false
end

function modelRequest(model)
	RequestModel(GetHashKey(model))
	while not HasModelLoaded(GetHashKey(model)) do
		Citizen.Wait(10)
	end
end

function CriandoBlip(taxi,selecionado)
	blips = AddBlipForCoord(config.taxi[selecionado].x,config.taxi[selecionado].y,config.taxi[selecionado].z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,27)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Corrida de Taxista")
	EndTextCommandSetBlipName(blips)
end

function StartMeter()
	Citizen.CreateThread(function()
		while true do
			local idle = 1000
			if emservico then
				local ped = PlayerPedId()
				local vehicle = GetVehiclePedIsUsing(ped)
				local vehiclespeed = GetEntitySpeed(vehicle)*3.6
				local coords = GetEntityCoords(ped)
				local distance = #(coords - vector3(config.taxi[selecionado].x,config.taxi[selecionado].y,config.taxi[selecionado].z))
				if distance <= 50.0 and IsVehicleModel(vehicle,GetHashKey("taxi")) then
					idle = 5
					DrawMarker(21,config.taxi[selecionado].x,config.taxi[selecionado].y,config.taxi[selecionado].z+0.20,0,0,0,0,180.0,130.0,2.0,2.0,1.0,255,0,0,50,1,0,0,1)
					if distance <= 2.5 then
						if IsControlJustPressed(0,38) and server.checkPermission() then
							RemoveBlip(blips)
							FreezeEntityPosition(vehicle,true)
							if DoesEntityExist(passageiro) then
								server.checkPayment(payment)
								Citizen.Wait(3000)
								TaskLeaveVehicle(passageiro,vehicle,262144)
								TaskWanderStandard(passageiro,10.0,10)
								Citizen.Wait(1100)
								SetVehicleDoorShut(vehicle,3,0)
								Citizen.Wait(1000)
								removePeds()
							end
	
							if checkped then
								local pmodel = math.random(#config.pedlist)
								modelRequest(config.pedlist[pmodel].model)
	
								passageiro = CreatePed(4,config.pedlist[pmodel].hash,config.taxi[selecionado].xp,config.taxi[selecionado].yp,config.taxi[selecionado].zp,3374176,true,false)
								SetEntityInvincible(passageiro,true)
								TaskEnterVehicle(passageiro,vehicle,-1,2,1.0,1,0)
								checkped = false
								payment = 1
								lastpassageiro = passageiro
							else
								passageiro = nil
								checkped = true
								FreezeEntityPosition(vehicle,false)
							end
	
							lselecionado = selecionado
							while true do
								if lselecionado == selecionado then
									selecionado = math.random(#config.taxi)
								else
									break
								end
								Citizen.Wait(1)
							end
	
							CriandoBlip(config.taxi,selecionado)
	
							if DoesEntityExist(passageiro) then
								while true do
									Citizen.Wait(1)
									local x2,y2,z2 = table.unpack(GetEntityCoords(passageiro))
									if not IsPedSittingInVehicle(passageiro,vehicle) then
										DrawMarker(21,x2,y2,z2+1.3,0,0,0,0,180.0,130.0,0.6,0.8,0.5,255,0,0,50,1,0,0,1)
									end
									if IsPedSittingInVehicle(passageiro,vehicle) then
										FreezeEntityPosition(vehicle,false)
										break
									end
								end
							end
						end
					end
				end
				if IsEntityAVehicle(vehicle) and DoesEntityExist(passageiro) then
					if math.ceil(vehiclespeed) >= config.maxvel and timers <= 0 and payment > 0 then
						Citizen.SetTimeout(5000, function()
							payment = payment - 1
						end)
					end
				end
			end
			Citizen.Wait(idle)
		end
	end)

	Citizen.CreateThread(function()
		while true do
			if TaxiGuiAtivo then
				local ped = PlayerPedId()
				local veh = GetVehiclePedIsIn(ped, false)
				if NoTaxi() and GetPedInVehicleSeat(veh, -1) ~= ped then
					local ped = PlayerPedId()
					local veh = GetVehiclePedIsIn(ped, false)
					TriggerEvent('taxi:updatebandeira', veh)
					SendNUIMessage({openMeter = true})
					meterOpen = true
				end
				if meterActive and GetPedInVehicleSeat(veh, -1) == ped then
					local _bandeira = DecorGetFloat(veh, "bandeiras")
					local _kilometros = DecorGetFloat(veh, "kilometros")
					local _Custobandeira = DecorGetFloat(veh, "Custobandeira")
				if _Custobandeira ~= 0 then
					DecorSetFloat(veh, "bandeiras", _bandeira + _Custobandeira)
				else
					DecorSetFloat(veh, "bandeiras", _bandeira + Custobandeira)
				end
					DecorSetFloat(veh, "kilometros", _kilometros + round(GetEntitySpeed(veh) * 0.000621371, 5))
					TriggerEvent('taxi:updatebandeira', veh)
				end
				if NoTaxi() and not GetPedInVehicleSeat(veh, -1) == ped then
					TriggerEvent('taxi:updatebandeira', veh)
				end
			end
			Citizen.Wait(1000)
		end
	end)
end