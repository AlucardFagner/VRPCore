local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
server = Tunnel.getInterface("zElectrician")
job = Tunnel.getInterface("zElectrician")

local servico = false
local locais = 0
local processo = false
local tempo = 0
local animacao = false
local pedlist = {
	{ ['x'] = 738.55, ['y'] = -1902.81, ['z'] = 29.31},
}
local encanador = {
	[1] = { ['x'] = 782.32, ['y'] = -2256.94, ['z'] = 29.45 },
	[2] = { ['x'] = 958.92, ['y'] = -1898.29, ['z'] = 31.2 },
	[3] = { ['x'] = 954.52, ['y'] = -1004.97, ['z'] = 39.69 }, 
	[4] = { ['x'] = 158.68, ['y'] = -1063.42, ['z'] = 41.99 }, 
	[5] = { ['x'] = -14.2, ['y'] = -1077.97, ['z'] = 26.68 }, 
	[6] = { ['x'] = -136.01, ['y'] = -1127.14, ['z'] = 24.95 }, 
	[7] = { ['x'] = -406.07, ['y'] = -207.41, ['z'] = 36.21 }, 
	[8] = { ['x'] = -467.64, ['y'] = -153.77, ['z'] = 38.2 },
	[9] = { ['x'] = -524.85, ['y'] = -95.09, ['z'] = 39.49 },
	[10] = { ['x'] = -962.88, ['y'] = -334.78, ['z'] = 37.82 }, 
	[11] = { ['x'] = -1231.21, ['y'] = -327.42, ['z'] = 37.41 }, 
	[12] = { ['x'] = -1385.21, ['y'] = -288.22, ['z'] = 43.3 }, 
	[13] = { ['x'] = -1469.7, ['y'] = -240.13, ['z'] = 49.9 },
	[14] = { ['x'] = -1409.23, ['y'] = 5.84, ['z'] = 52.58 },
	[15] = { ['x'] = -1654.8, ['y'] = 83.0, ['z'] = 63.73 },
	[16] = { ['x'] = -1697.9, ['y'] = 270.83, ['z'] = 62.49 },
	[17] = { ['x'] = -1595.58, ['y'] = 278.7, ['z'] = 58.66 }, 
	[18] = { ['x'] = -1406.53, ['y'] = 337.13, ['z'] = 62.86 },
	[19] = { ['x'] = -962.88, ['y'] = -334.78, ['z'] = 37.82 }
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
		nveh = CreateVehicle(bhash,737.8, -1914.85, 29.3+0.5, 352.13,true,false)
		SetVehicleIsStolen(nveh,false)
		SetVehicleOnGroundProperly(nveh)
		SetEntityInvincible(nveh,false)
		SetVehicleNumberPlateText(nveh,vRP.getRegistrationNumber())
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
		TriggerServerEvent("zElectrician:roupa")
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

Citizen.CreateThread(function()
	while true do
		local balaka = 1000
		local x,y,z =  743.62, -1905.9, 29.31
		local x2,y2,z2 = 743.62, -1905.9, 29.31
		local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
		if distance < 5 and servico == false then
			balaka = 5
			DrawText3Ds(x2,y2,z2 + 0.5,"~w~PRESSIONE ~g~E ~w~PARA PEGAR O SERVIÇO")
			DrawMarker(27,x,y,z-1.0,0,0,0,0,0,0,0.5,0.5,0.5,178,236,177,100,0,300,0,1)
			if not servico then
				if distance < 1 then
					if IsControlJustPressed(0, 38) then
						TriggerEvent("Notify","aviso","Você entrou em serviço")
						print('pegou serviço')
						--ColocarRoupa()
						Fade(1200)
						Wait(2000)
						TriggerEvent("Notify","aviso","Solicite sua van de trabalho!")
						servico = true
						locais = 1
						CriandoBlip(encanador,locais)
					end
				end
			end
		end
		Citizen.Wait(balaka)
	end
end)

Citizen.CreateThread(function()
	while true do
		local balaka = 1000
	    if servico then 
		    local x,y,z = 743.49, -1910.1, 29.3
		    local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
		    if distance <= 5 then
		        balaka = 5
              DrawText3Ds(x,y,z + 0.5,"~w~PRESSIONE ~g~E ~w~PARA SOLICITAR A VAN")
			  DrawMarker(27,x,y,z-1.0,0,0,0,0,0,0,0.5,0.5,0.5,178,236,177,100,0,300,0,1)
                if IsControlJustPressed(0,38) then	
                	Fade(1200)
		            spawnVan()
		            parte = 1
		            TriggerEvent("Notify","importante","Se dirija a bancada e pegue os materias!")
				end
		    end
		end
	Citizen.Wait(balaka)
	end
end)	

Citizen.CreateThread(function()
	while true do
		local balaka = 1000
		if servico then
			local x,y,z = 743.39, -1903.02, 29.31
			local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
			if distance <= 5 and servico == true then 
				balaka = 5
                  DrawText3Ds(x,y,z + 0.5,"~w~PRESSIONE ~g~E ~w~PARA COLETAR OS EQUIPAMENTOS")
			    	DrawMarker(27,x,y,z-1.0,0,0,0,0,0,0,0.5,0.5,0.5,178,236,177,100,0,300,0,1)
		        if IsControlJustPressed(0, 38) then
		        	--vRP._playAnim(false,{{"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator"}},true)
					vRP.playAnim(false,{"amb@world_human_hammering@male@base","base"},true)
		            TriggerEvent("progress",10000,"Coletando Equipamento")
					SetTimeout(10000,function()
					 vRP._stopAnim(source,false)
					end)	
					if server.giveFerramenta() then
					--  print("recebeu ferramenta")			
					end    
                end
		    end                   
		end
	Citizen.Wait(balaka)
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
				--if veh and usando == 0 then
					if distance < 2 then
						balaka = 5
						DrawText3Ds(x,y,z + 1.2,"~w~PRESSIONE ~g~E ~w~PARA CONSERTAR O A CAIXA ELÉTRICA")
						if IsControlJustPressed(0, 38) then
							TriggerEvent("progress",10000,"Consertando a caixa elétrica")
							RemoveBlip(blips)
							animacao = true
							if animacao then
								vRP.playAnim(false,{"amb@world_human_hammering@male@base","base"},true)
								--vRP._playAnim(false,{{"mini@repair","fixing_a_player"}},true)
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
				--end
			end
		end
	Citizen.Wait(balaka)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsControlJustPressed(0,168) and servico then
			TriggerEvent("Notify","aviso","Você saiu de serviço")
			servico = false
			TriggerEvent('cancelando',false)
			RemoveBlip(blips)
			vRP.playSound("Oneshot_Final","MP_MISSION_COUNTDOWN_SOUNDSET")
			MainRoupa()
			if nveh then
			    TriggerServerEvent("trydeleteveh",VehToNet(nveh))
			    nveh = nil
			end
		end
	end
end)

