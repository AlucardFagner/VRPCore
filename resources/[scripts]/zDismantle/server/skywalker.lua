local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
server = {}
Tunnel.bindInterface("zDismantle",server)
client = Tunnel.getInterface("zDismantle")
client = Tunnel.getInterface("zGarages")

local timeList = 0
local maxVehlist = 10
local vehListActived = {}
local userList = {}

function server.permUnique() 
	local source = source 
	local user_id = vRP.getUserId(source)
	if user_id then 
		if config.NeedPermission then 
			if vRP.hasPermission(user_id, config.Permission) then 
				return true
			end
		else
			return true
		end
		return false
	end
end

function server.checkVehlist()
	local source = source
	local user_id = vRP.getUserId(source)
	local status = false
	if user_id then
		if config.NeedItemToDismantle then 
			local vehicle,vehNet,vehPlate,vehName = vRPclient.vehList(source,11)
			if vehicle then
				local plateId = vRP.getVehiclePlate(vehPlate)
				if plateId ~= user_id then
					local getStatus = vRP.query('vRP/get_vehicle_plate',{plate = vehPlate})
					for k, v in pairs(getStatus) do
						if v.arrested > 0 then
							status = false
						else
							vRP.tryGetInventoryItem(user_id, config.ItemDismantle, config.NeedItemAmount)
							status = true
						end
					end
					return status, vehicle
				else
					TriggerClientEvent("Notify",source,"negado","Este veículo é protegido pela seguradora.",5000)
				end
			end
		else
			local vehicle,vehNet,vehPlate,vehName = vRPclient.vehList(source,11)
			if vehicle then
				local plateId = vRP.getVehiclePlate(vehPlate)
				if not plateId then
					local getStatus = vRP.query('vRP/get_vehicle_plate',{plate = vehPlate})
					for k, v in pairs(getStatus) do
						if v.arrest > 0 then
							status = false
						else
							vRP.tryGetInventoryItem(user_id, config.ItemDismantle, config.NeedItemAmount)
							status = true
						end
					end
					return status, vehicle
				else
					TriggerClientEvent("Notify",source,"vermelho","Este veículo é protegido pela seguradora.",5000)
				end
			end
		end
		return false
	end
end

function server.paymentMethod(vehicle)
	local source = source
	local user_id = vRP.getUserId(source)
	local vehicle,vehNet,vehPlate,vehName = vRPclient.vehList(source,11)
	local plateUser = vRP.getVehiclePlate(vehPlate)
	if user_id then
		vRP.upgradeStress(user_id,25)
		client.deleteVehicle(source,vehicle)
		if config.paymentMethod == 1 then 
			for a, b in pairs(config.VehicleList) do 
				if vehName == b.vehicle then 
					vRP.tryGiveInventoryItem(user_id,config.DirtyMoney,b.dirtymoney,true)
				end
			end
		elseif config.paymentMethod == 2 then
			for a, b in pairs(config.VehicleList) do 
				if vehName == b.vehicle then 
					for c, d in pairs(config.ListOfItems) do
						vRP.tryGiveInventoryItem(user_id,d.item,d.value*b.listofitems,true)
					end
				end
			end
		else
			return false
		end
		vRP.execute("vRP/set_arrest",{ user_id = parseInt(plateUser), vehicle = vehName, arrest = 1, time = parseInt(os.time()) })
		return true
	end
end

function server.blockVehicle()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		for k, v in pairs(config.BlackListVehicle) do
			local vehName = vRPclient.vehList(source,11)
			if vehName == k then 
				return false
			end
		end
		return true
	end
end
