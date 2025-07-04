local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
zCLIENT = {}
Tunnel.bindInterface("zMedical",zCLIENT)
zSERVER = Tunnel.getInterface("zMedical")

local hea = 0
local leg = 0
local han = 0
local col = 0
local sit = 0
local menuactive = false
local damaged = {}
local bleeding = 0
local bleedtype = "Superficial"
local teste = false
local tratamento = false
local breaked = false
local tratamento2 = false

RegisterCommand(config.diagnosticPlayer,function()
	zSERVER.checkOfficer()
	ToggleActionMenu()
	SendNUIMessage({
		hea = 1,
		leg = 1,
		han = 1,
		col = 1,
		sit = 1,
	});
end)

RegisterNUICallback("ButtonClick",function(data,cb)
	if data == "rem-kit" then
		local head, legs, foot, breast = zSERVER.raiox()
		if not head and not legs and not foot and not breast then
			head = true
			legs = true
			foot = true
			breast = true
			zSERVER.setDamaged()
		end
		SendNUIMessage({
			head = head,
			legs = legs,
			foot = foot,
			breast = breast,
		});
		
	elseif data == "close" then
		ToggleActionMenu()
	end
end)

RegisterNUICallback('medClose', function()
	SetNuiFocus(false)
	TransitionFromBlurred(1000)
	SendNUIMessage({ hidemenu = true })
end)

function ToggleActionMenu()
	menuactive = not menuactive
	if menuactive then
		SetNuiFocus(true,true)
		TransitionToBlurred(1000)
		SendNUIMessage({ showmenu = true })
	else
		SetNuiFocus(false)
		TransitionFromBlurred(1000)
		SendNUIMessage({ hidemenu = true })
	end
end

function zCLIENT.getDiagnostic()
	for k,v in pairs(damaged) do --loop sem nada dentro?
		
	end	
	return damaged
end

function zCLIENT.getBleeding()
	return bleeding
end

function zCLIENT.zDiagnosticResetBleeding()
	bleeding = 0
end

function zCLIENT.killGod()
	nocauteado = false
	local ped = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(ped))
	NetworkResurrectLocalPlayer(x,y,z,true,true,false)
	ClearPedBloodDamage(ped)
	SetEntityInvincible(ped,false)
	SetEntityHealth(ped,110)
	ClearPedTasks(ped)
	ClearPedSecondaryTask(ped)
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

RegisterNetEvent("resetDiagnostic")
AddEventHandler("resetDiagnostic",function()
	teste = true
	damaged = {}
	Wait(1000)
	teste = false
end)

RegisterNetEvent("resetBleeding")
AddEventHandler("resetBleeding",function()
	bleeding = 0
end)

RegisterNetEvent("resetWarfarina")
AddEventHandler("resetWarfarina",function()
	repeat
		Citizen.Wait(15000)
		bleeding = bleeding - 1
	until bleeding <= 0
		TriggerEvent("Notify","importante","Sangramento paralisado.",8000)
end)

RegisterNetEvent('tratamento-macas')
AddEventHandler('tratamento-macas',function()
	repeat
		SetEntityHealth(PlayerPedId(),GetEntityHealth(PlayerPedId())+1)
		Citizen.Wait(900)
	until GetEntityHealth(PlayerPedId()) >= 400 or GetEntityHealth(PlayerPedId()) <= 100
	TriggerEvent("Notify","importante","Tratamento concluido.")
	TriggerEvent("cancelando",false)
end)

RegisterNetEvent("tratamento")
AddEventHandler("tratamento",function()
    local ped = PlayerPedId()
    local health = GetEntityHealth(ped)
    local armour = GetPedArmour(ped)
    local x,y,z = table.unpack(GetEntityCoords(ped))
    SetEntityHealth(ped,health)
    SetPedArmour(ped,armour)
	tratamento = true   
	if tratamento then
		repeat
			if IsEntityPlayingAnim(ped,"amb@world_human_sunbathe@female@back@idle_a","idle_a",3) then
				Citizen.Wait(600)
				if GetEntityHealth(ped) > 101 then
					SetEntityHealth(ped,GetEntityHealth(ped)+1)
				end
			else 
				tratamento = false
				breaked = true
				break 
			end
		until GetEntityHealth(ped) >= 400 or GetEntityHealth(ped) <= 101

		if not breaked then
			TriggerEvent("Notify","sucesso","Tratamento concluido.",8000)
			tratamento = false
			NetworkResurrectLocalPlayer(x,y,z,true,true,false)
			ClearPedBloodDamage(ped)
			SetEntityInvincible(ped,false)
			SetEntityHealth(ped,400)
			ClearPedTasks(ped)
			ClearPedSecondaryTask(ped)
			Wait(1000)
			damaged = {}
		else
			TriggerEvent("Notify","negado","Voce se levantou antes do tratamento ser finalizado.",8000)
			breaked = false
		end
    end
end)

Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		if GetEntityHealth(ped) > 101 then
			local hit,bone = GetPedLastDamageBone(ped)						
			if hit and not damaged[bone] and bone ~= 0 and not teste then
				damaged[bone] = true
				bleeding = bleeding + 1
			end
		end
		Citizen.Wait(1000)
	end
end)

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		local emMaca = false
		for k,v in pairs(config.stretchers) do
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			local distance = #(coords - vector3(v.x,v.y,v.z))
			if distance <= 1.1 then
				drawTxt("~g~E~w~  DEITAR    ~g~G~w~  TRATAMENTO",4,0.5,0.93,0.50,255,255,255,180)
				idle = 5
				if IsControlJustPressed(0,38) then
					SetEntityCoords(ped,v.x2,v.y2,v.z2)
					SetEntityHeading(ped,v.h)
					ExecuteCommand('e deitar5')
					emMaca = true
				end
				if IsControlJustPressed(0,47) then
					if zSERVER.checkServices() then
						TriggerEvent('cancelando',true)
						TriggerEvent('tratamento-macas')
						TriggerEvent('resetDiagnostic')
						TriggerEvent('resetWarfarina')
						SetEntityCoords(ped,v.x2,v.y2,v.z2)
						SetEntityHeading(ped,v.h)
						ExecuteCommand('e deitar5')
					else
						TriggerEvent("Notify","aviso","Existem paramédicos em serviço.")
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)

Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()

		if GetEntityHealth(ped) > 101 then
			if bleeding == 1 then
				bleedtype = "superficial"
			elseif bleeding == 2 then
				bleedtype = "baixo"
			elseif bleeding == 3 then
				bleedtype = "médio"
			   SetEntityHealth(ped,GetEntityHealth(ped)-3)
			elseif bleeding == 4 then
				bleedtype = "alto"
				SetEntityHealth(ped,GetEntityHealth(ped)-4)
			elseif bleeding >= 5 then
				bleedtype = "grave"
				SetEntityHealth(ped,GetEntityHealth(ped)-5)
			end
			
			if bleeding >= 1 and GetEntityHealth(ped) > 101 then
				TriggerEvent("Notify","sangramento","Sangramento <b>"..bleedtype.."</b> encontrado.",3000)
			end

			if bleeding >= 4 and GetEntityHealth(ped) > 101 then
				SetFlash(0,0,500,100,500)
			end
		end

		Citizen.Wait(15000)
   end
end)