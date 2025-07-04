local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
server = Tunnel.getInterface("zPlumber")
job = Tunnel.getInterface("zPlumber")

local servico = false
local locais = 0
local processo = false
local tempo = 0
local animacao = false
local pedlist = {
	{  ['x'] = 153.2, ['y'] = -3209.36, ['z'] = 5.92 },
}
local encanador = {
	[1] = { ['x'] = -798.38, ['y'] = 175.85, ['z'] = 72.84 },
	[2] = { ['x'] = -820.32, ['y'] = 106.88, ['z'] = 56.55 },
	[3] = { ['x'] = -843.46, ['y'] = -13.18, ['z'] = 39.89 },
	[4] = { ['x'] = -1127.7, ['y'] = 307.63, ['z'] = 66.18 }, 
	[5] = { ['x'] = -1560.74, ['y'] = 23.53, ['z'] = 59.56 },
	[6] = { ['x'] = -1032.92, ['y'] = 349.39, ['z'] = 71.37 },
	[7] = { ['x'] = -900.8, ['y'] = 99.6, ['z'] = 55.11 },
	[8] = { ['x'] = -1476.82, ['y'] = -339.75, ['z'] = 45.44 },
	[9] = { ['x'] = -806.15, ['y'] = -957.62, ['z'] = 15.29 },
	[10] = { ['x'] = 183.47, ['y'] = -161.23, ['z'] = 56.32 },
	[11] = { ['x'] = 141.92, ['y'] = -292.32, ['z'] = 46.31 },
	[12] = { ['x'] = 158.7, ['y'] = -284.7, ['z'] = 46.31 },
	[13] = { ['x'] = 67.26, ['y'] = -1387.56, ['z'] = 29.35 },
	[14] = { ['x'] = 17.71, ['y'] = -1300.08, ['z'] = 29.38 },
	[15] = { ['x'] = -16.18, ['y'] = -1076.93, ['z'] = 26.68 },
	[16] = { ['x'] = -218.67, ['y'] = -1165.74, ['z'] = 23.02 },
	[17] = { ['x'] = -690.3, ['y'] = -1391.3, ['z'] = 5.16 },
	[18] = { ['x'] = -1325.21, ['y'] = -919.99, ['z'] = 11.29 },
	[19] = { ['x'] = 424.22, ['y'] = -995.81, ['z'] = 30.72 }
}

function CriandoBlip(encanador,locais)
	blips = AddBlipForCoord(encanador[locais].x,encanador[locais].y,encanador[locais].z)
	SetBlipSprite(blips,433)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Arrumar Encanamento")
	EndTextCommandSetBlipName(blips)
end

function DrawText3Ds(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.50,0.35)
	SetTextColour(255,255,255,500)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text))/0
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,80)
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

function spawnVan()
	local bhash = config.vehicle
	if not nveh then
	while not HasModelLoaded(bhash) do
	    RequestModel(bhash)
	    Citizen.Wait(10)
	end
		local ped = PlayerPedId()
		local x,y,z = vRP.getPosition()
		nveh = CreateVehicle(bhash,145.86, -3209.94, 5.86+0.50, 92.07,true,false)
		SetVehicleIsStolen(nveh,false)
		SetVehicleOnGroundProperly(nveh)
		SetEntityInvincible(nveh,false)
		Citizen.InvokeNative(0xAD738C3085FE7E11,nveh,true,true)
		SetVehicleHasBeenOwnedByPlayer(nveh,true)
		SetVehicleDirtLevel(nveh,0.0)
		SetVehRadioStation(nveh,"OFF")
		SetVehicleEngineOn(GetVehiclePedIsIn(ped,false),true)
		SetModelAsNoLongerNeeded(bhash)
	end
end

function Fade(time)
	DoScreenFadeOut(800)
	Wait(time)
	DoScreenFadeIn(800)
end

function FadeRoupa(time,tipo,idle_copy)
	DoScreenFadeOut(800)
	Wait(time)
	if tipo == 1 then 
		vRP.setCustomization(idle_copy)
	else
		TriggerServerEvent("zPlumber:roupa")
	end
	DoScreenFadeIn(800)
end

function ColocarRoupa()
	if vRP.getHealth() > 101 then
		if not vRP.isHandcuffed() then
			local custom = RoupaEntregador["Entregador"]
			if custom then
				local old_custom = vRP.getCustomization()
				local idle_copy = {}

				idle_copy = job.SaveIdleCustom(old_custom)
				idle_copy.modelhash = nil

				for l,w in pairs(custom[old_custom.modelhash]) do
						idle_copy[l] = w
				end
				FadeRoupa(1200,1,idle_copy)
			end
		end
	end
end

function MainRoupa()
	if vRP.getHealth() > 101 then
		if not vRP.isHandcuffed() then
	        FadeRoupa(1200,2)
	    end
	end
end

function Desabilitar()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1)
			if animacao then
				BlockWeaponWheelThisFrame()
				DisableControlAction(0,16,true)
				DisableControlAction(0,17,true)
				DisableControlAction(0,24,true)
				DisableControlAction(0,25,true)
				DisableControlAction(0,29,true)
				DisableControlAction(0,56,true)
				DisableControlAction(0,57,true)
				DisableControlAction(0,73,true)
				DisableControlAction(0,166,true)
				DisableControlAction(0,167,true)
				DisableControlAction(0,170,true)				
				DisableControlAction(0,182,true)	
				DisableControlAction(0,187,true)
				DisableControlAction(0,188,true)
				DisableControlAction(0,189,true)
				DisableControlAction(0,190,true)
				DisableControlAction(0,243,true)
				DisableControlAction(0,245,true)
				DisableControlAction(0,257,true)
				DisableControlAction(0,288,true)
				DisableControlAction(0,289,true)
				DisableControlAction(0,344,true)		
			end	
		end
	end)
end

RegisterNetEvent("zPlumber:StartJob")
AddEventHandler("zPlumber:StartJob",function()

	local balaka = 1000

	if not servico then
		TriggerEvent("Notify","aviso","Você entrou em serviço",9000)
		servico = true
		locais = 1
		spawnVan()
		Wait(1000)
		TriggerEvent("Notify","aviso","Pegue van de trabalho!",9000)
		CriandoBlip(encanador,locais)
	elseif servico then
		TriggerEvent("Notify","aviso","Você saiu de serviço",9000)
		servico = false
		TriggerEvent('cancelando',false)
		RemoveBlip(blips)
		vRP.playSound("Oneshot_Final","MP_MISSION_COUNTDOWN_SOUNDSET")
	end
end)	

RegisterNetEvent('zPlumber:CollectMaterial')
AddEventHandler('zPlumber:CollectMaterial', function()
	
	if servico then
		balaka = 1000
		vRP.playAnim(false,{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"},true)
		TriggerEvent("Notify","progress","Coletando Equipamento",8000)
		SetTimeout(8000,function()
			vRP._stopAnim(source,false)
			server.giveFerramenta()
			TriggerEvent("Notify","sucesso","Adicionado 3x Ferramentas na mochila.",8000)
		end)
	elseif not servico then
		TriggerEvent("Notify","negado","Você não está em serviço para coletar a ferramenta.",8000)
	end
end)

Citizen.CreateThread(function()
	while true do
		local balaka = 1000
		if servico then
			local car = GetHashKey(config.vehicle)
			local ped = PlayerPedId()
			local vehicle = GetPlayersLastVehicle(ped, car)
			local veh = IsVehicleModel(vehicle, car)
			local usando = GetVehiclePedIsUsing(ped)
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(encanador[locais].x,encanador[locais].y,encanador[locais].z)
			local distance = GetDistanceBetweenCoords(encanador[locais].x,encanador[locais].y,cdz,x,y,z,true)
			if distance < 10 then
				balaka = 1
				if distance < 2 then
					balaka = 5
					DrawText3Ds(x,y,z + 1.2,"~w~PRESSIONE ~g~E ~w~PARA CONSERTAR O CANO")
					if IsControlJustPressed(0, 38) then
						TriggerEvent("progress",10000,"Consertando o cano")
						RemoveBlip(blips)
						animacao = true
						if animacao then
							vRP.playAnim(false,{"amb@world_human_hammering@male@base","base"},true)
							Desabilitar()
							Citizen.Wait(10000)
							vRP.stopAnim(false)
							server.checkPayment()
							animacao = false
							if locais == #encanador then
								locais = 1
							else
								locais = math.random(1,19)
							end
							CriandoBlip(encanador,locais)
						end
					end	
				end
			end
		end
	Citizen.Wait(balaka)
	end
end)


