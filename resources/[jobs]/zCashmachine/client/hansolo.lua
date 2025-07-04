local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
client = {}
Tunnel.bindInterface("zCashmachine",client)
server = Tunnel.getInterface("zCashmachine")

local machineStart = false
local machineTimer = 0
local machinePosX = 0.0
local machinePosY = 0.0
local machinePosZ = 0.0
local objectBomb = nil

function startthreadmachinestart()
	Citizen.CreateThread(function()
		while true do
			if machineStart and machineTimer > 0 then
				machineTimer = machineTimer - 1
				if machineTimer <= 0 then
					machineStart = false
					TriggerServerEvent("tryDeleteEntity",ObjToNet(objectBomb))
					server.stopMachine(machinePosX,machinePosY,machinePosZ)
					AddExplosion(machinePosX,machinePosY,machinePosZ,2,100.0,true,false,true)
				end
			end
			Citizen.Wait(1000)
		end
	end)
end

RegisterNetEvent("zCashmachine:machineRobbery")
AddEventHandler("zCashmachine:machineRobbery",function()
	local ped = PlayerPedId()
	if not machineStart then
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)
			for k,v in pairs(config.machines) do
				local distance = #(coords - vector3(v[1],v[2],v[3]))
				if distance <= 0.6 then
					if server.startMachine() then
						machinePosX = v[1]
						machinePosY = v[2]
						machinePosZ = v[3]
						SetEntityHeading(ped,v[4])
						TriggerEvent("cancelando",true)
						SetEntityCoords(ped,v[1],v[2],v[3]-1)
						vRP._playAnim(false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)
						Citizen.Wait(10000)
						startthreadmachinestart()
						machineStart = true
						vRP.removeObjects()
						TriggerEvent("cancelando",false)
						machineTimer = math.random(30,40)
						server.callPolice(machinePosX,machinePosY,machinePosZ)
						local mHash = GetHashKey("prop_c4_final_green")
						RequestModel(mHash)
						while not HasModelLoaded(mHash) do
							RequestModel(mHash)
							Citizen.Wait(10)
						end
						local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,0.23,0.0)
						objectBomb = CreateObjectNoOffset(mHash,coords.x,coords.y,coords.z-0.23,true,false,false)
						SetEntityAsMissionEntity(objectBomb,true,true)
						FreezeEntityPosition(objectBomb,true)
						SetEntityHeading(objectBomb,v[4])
						SetModelAsNoLongerNeeded(mHash)
					end
				end
			end
		end
	end
end)