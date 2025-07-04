local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
client = {}
Tunnel.bindInterface("zTowdriver",client)
server = Tunnel.getInterface("zTowdriver")

local tow = nil
local towed = nil

function client.towPlayer()
	local vehicle = GetPlayersLastVehicle()
	if IsVehicleModel(vehicle,GetHashKey(config.VehicleTow)) and not IsPedInAnyVehicle(PlayerPedId()) then
		towed = vRP.getNearVehicle(11)
		if DoesEntityExist(vehicle) and DoesEntityExist(towed) then
			if tow then
				server.tryTow(VehToNet(vehicle),VehToNet(tow),"out")
				towed = nil
				tow = nil
			else
				if vehicle ~= towed then
					server.tryTow(VehToNet(vehicle),VehToNet(towed),"in")
					tow = towed
				end
			end
		end
	end
end

RegisterNetEvent("zTowdriver:syncTow")
AddEventHandler("zTowdriver:syncTow",function(vehid01,vehid02,mod)
	if NetworkDoesNetworkIdExist(vehid01) and NetworkDoesNetworkIdExist(vehid02) then
		local vehicle = NetToEnt(vehid01)
		local towed = NetToEnt(vehid02)
		if DoesEntityExist(vehicle) and DoesEntityExist(towed) then
			if mod == "in" then
				local min,max = GetModelDimensions(GetEntityModel(towed))
				AttachEntityToEntity(towed,vehicle,GetEntityBoneIndexByName(vehicle,"bodyshell"),0,-2.2,0.4-min.z,0,0,0,1,1,0,1,0,1)
			elseif mod == "out" then
				AttachEntityToEntity(towed,vehicle,20,-0.5,-18.0,-0.2,0.0,0.0,0.0,false,false,true,false,20,true)
				DetachEntity(towed,false,false)
				SetVehicleOnGroundProperly(towed)
			end
		end
	end
end)