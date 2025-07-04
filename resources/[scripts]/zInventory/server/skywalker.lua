Tunnel = module('vrp', 'lib/Tunnel')
Proxy = module('vrp', 'lib/Proxy')
Tools = module('vrp', 'lib/Tools')
vRP = Proxy.getInterface('vRP')
vRPclient = Tunnel.getInterface('vRP')
local idgens = Tools.newIDGenerator()
zSERVER = {}
Tunnel.bindInterface('zInventory', zSERVER)
zCLIENT = Tunnel.getInterface('zInventory')
zCoreRAGE = Tunnel.getInterface('zGARAGES')
zPlayer = Tunnel.getInterface('zPlayer')
zHomes = Tunnel.getInterface('zHomes')
zTASKBAR = Tunnel.getInterface('zTASKBAR')

-----------------------------------------------------------------------------------------------------------------------------------
--[ INVENTORY ]--------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
local autentifikavimas = false
local active = {}
local ahotbar = {}
local weaponrechenger = {}
local firecracker = {}
local registerTimers = {}
local droplist = {}
local chestOpen = {}

RegisterNetEvent('zInventory:unEquipAmmo')
AddEventHandler('zInventory:unEquipAmmo', function(ammo, ammoAmount)
	local source = source
	local user_id = vRP.getUserId(source)
	vRP.tryGiveInventoryItem(user_id, ammo, ammoAmount)
end)

function zSERVER.getItemList()
	return vRP.itemList()
end

function zSERVER.registerWeapons(weapon, ammo, ammoAmount)
	local source = source
	local user_id = vRP.getUserId(source)
	vRP.updateWeaponData(user_id, weapon, ammo, ammoAmount, 'rem')
end

RegisterCommand(config.CommandSchoolbag,function(source, args)
	local user_id = vRP.getUserId(source)
	if user_id then 
		if vRP.getInventoryItemAmount(user_id,'roupas') >= 1 then
			for k, v in pairs(config.SchoolbagSet) do 
				if parseInt(args[1]) == k then
					TriggerClientEvent('zInventory:SetSchoolbag',source, v.id, v.color)
				end
			end
		end
	end
end)

function zSERVER.hotbar()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local inv = vRP.getInventory(user_id)
		if inv then
			local inventory = {}
			for k, v in pairs(inv) do
				if (parseInt(v.amount) <= 0 or vRP.itemBodyList(v.item) == nil) then
					vRP.removeInventoryItem(user_id, v.item, parseInt(v.amount), false)
				else
					if string.sub(v.item, 1, 9) == v.item then
						local advFile = LoadResourceFile('logsystem', 'toolboxes.json')
						local advDecode = json.decode(advFile)
						v.durability = advDecode[v.item]
					end
					if tonumber(k) >= 1 and tonumber(k) <= 5 then
						v.key = v.item
						v.slot = k
						v.index = vRP.itemIndexList(v.item)
						v.name = vRP.itemNameList(v.item)
						v.amount = parseInt(v.amount)
						v.weight = vRP.itemWeightList(v.item)
						v.type = vRP.itemTypeList(v.item)
						inventory[k] = v
					end
				end
			end
			return inventory, vRP.computeInvWeight(user_id), vRP.getBackpackWeight(user_id), parseInt(vRP.computeInvSlots(user_id)), vRP.getBackpackSlots(user_id)
		end
	end
end

function zSERVER.backpack()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local inv = vRP.getInventory(user_id)
		if inv then
			local inventory = {}
			for k, v in pairs(inv) do
				if (parseInt(v.amount) <= 0 or vRP.itemBodyList(v.item) == nil) then
					vRP.removeInventoryItem(user_id, v.item, parseInt(v.amount), false)
				else
					if string.sub(v.item, 1, 9) == v.item then
						local advFile = LoadResourceFile('logsystem', 'toolboxes.json')
						local advDecode = json.decode(advFile)
						v.durability = advDecode[v.item]
					end
					v.key = v.item
					v.slot = k
					v.index = vRP.itemIndexList(v.item)
					v.name = vRP.itemNameList(v.item)
					v.amount = parseInt(v.amount)
					v.weight = vRP.itemWeightList(v.item)
					v.type = vRP.itemTypeList(v.item)
					inventory[k] = v
				end
			end
			return inventory, vRP.computeInvWeight(user_id), vRP.getBackpackWeight(user_id), parseInt(vRP.computeInvSlots(user_id)), vRP.getBackpackSlots(user_id)
		end
	end
end

function dump(o)
	if type(o) == 'table' then
		local s = '{ '
		for k, v in pairs(o) do
			if type(k) ~= 'number' then k = '' .. k .. '' end
			s = s .. '[' .. k .. '] = ' .. dump(v) .. ', '
		end
		return s .. '} '
	else
		return tostring(o)
	end
end

local function checkWeaponByAmmo(ammo, weapon)
	local is_w = config.weapon_ammos[ammo]
	if is_w then
		for k, v in pairs(is_w) do
			if v == weapon then
				return true
			end
		end
	end
	return false
end

local function getAmmoTypeByWeapon(wea)
	for ammo, weapons in pairs(config.weapon_ammos) do
		for _, weapon in pairs(weapons) do
			if weapon  == wea then
				return ammo
			end
		end
	end
	return ''
end

function zSERVER.checkInventory()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if active[user_id] ~= nil and active[user_id] > 0 then
			return false
		end
		return true
	end
end

function zSERVER.getWeaponConf(item)
	if vRP.itemBodyList(item) then
		return item, vRP.itemAmmoList(item)
	end
	return 0, 0
end

RegisterNetEvent('zInventory:unEquipeBackpack')
AddEventHandler('zInventory:unEquipeBackpack', function()
	local source = source
    local user_id = vRP.getUserId(source)
	if user_id then
		if active[user_id] == nil then
			local backpack = nil
			local weight = vRP.getBackpackWeight(user_id)
			if weight == 36 then backpack = 'mochila-pequena' elseif weight == 72 then backpack = 'mochila-media' elseif weight == 90 then backpack = 'mochila-grande' end
			if vRP.computeInvWeight(user_id) + vRP.itemWeightList(backpack) <= 6 then
				if vRP.computeInvSlots(user_id) + 1 <= 6 then
					active[user_id] = 10
					zCLIENT.closeInventory(source)
					zCLIENT.blockButtons(source, true)
					TriggerClientEvent('Progress', source, 10000, 'Desequipando')
					repeat
						if active[user_id] == 0 then
							active[user_id] = nil
							zCLIENT.blockButtons(source, false)
							vRP.setBackpackWeight(user_id, 6)
							vRP.setBackpackSlots(user_id, 6)
							if config.backpackOnBody == true then
								TriggerClientEvent('zInventory:backpackOffBody', source)
							end
							vRP.giveInventoryItem(user_id, backpack, 1)
						end
						Citizen.Wait(0)
					until active[user_id] == nil	
				else
					TriggerClientEvent('Notify', source, 'negado', 'Você não pode <b>desequipar sua Mochila</b>, pois, não tem espaço no inventário.', 5000)
				end
			else
				TriggerClientEvent('Notify', source, 'negado', 'Você não pode <b>desequipar sua Mochila</b>, pois, está com muito peso.', 5000)
			end
		end
	end
end)

function zSERVER.getItemSlot(slot)
	local source = source
    local user_id = vRP.getUserId(source)
	local inv = vRP.getInventory(user_id)
	if inv then
		local itemName = inv[tostring(slot)].item
 		return itemName
	end
	return false
end

RegisterNetEvent('zInventory:useItem')
AddEventHandler('zInventory:useItem', function(slot, rAmount)
	local source = source
    local user_id = vRP.getUserId(source)
	if user_id then
		if rAmount == nil then rAmount = 1 end
		if rAmount <= 0 then rAmount = 1 end
		if active[user_id] == nil then
			local inv = vRP.getInventory(user_id)
			if inv then
				if not inv[tostring(slot)] or inv[tostring(slot)].item == nil then
					return
				end
				local itemName = inv[tostring(slot)].item
				
				if vRP.itemTypeList(itemName) == 'use' then
					zCLIENT.removeWeaponInHand(source)
					if tonumber(slot) >= 1 and tonumber(slot) <= 5 then
						TriggerClientEvent('zInventory:Update', source, 'showHotbar')	
					end
					for k, v in pairs(config.noalcoholic_drinks) do
						if itemName == k then
							active[user_id] = 10
							vRPclient.stopActived(source)
							zCLIENT.closeInventory(source)
							zCLIENT.blockButtons(source, true)
							TriggerClientEvent('Progress', source, 10000, v[4])
							vRPclient._createObjects(source, v[1], v[2], v[3], 49, 28422)
							repeat
								if active[user_id] == 0 then
									active[user_id] = nil
									zCLIENT.blockButtons(source, false)
									vRPclient._removeObjects(source, 'one')
									if vRP.tryGetInventoryItem(user_id, itemName, 1, true, slot) then
										vRP.upgradeThirst(user_id, v[5])
										vRP.upgradeHunger(user_id, v[6])
										vRP.downgradeStress(user_id, v[7])
										if v[8] ~= nil then
											vRP.tryGiveInventoryItem(user_id, v[8], 1)
										end
										if v[9] ~= 0 and v[10] ~= 0 then
											TriggerClientEvent('setEnergetic', source, v[9], v[10])
										end
									end
								end
								Citizen.Wait(0)
							until active[user_id] == nil
						end
					end
					for k, v in pairs(config.alcoholic_drinks) do
						if itemName == k then
							active[user_id] = 10
							vRPclient.stopActived(source)
							zCLIENT.closeInventory(source)
							zCLIENT.blockButtons(source, true)
							TriggerClientEvent('Progress', source, 10000, v[4])
							vRPclient._createObjects(source, v[1], v[2], v[3], 49, 28422)
							repeat
								if active[user_id] == 0 then
									active[user_id] = nil
									zCLIENT.blockButtons(source, false)
									vRPclient._removeObjects(source, 'one')
									if vRP.tryGetInventoryItem(user_id, itemName, 1, true, slot) then
										vRP.upgradeThirst(user_id, v[5])
										vRP.upgradeHunger(user_id, v[6])
										vRP.downgradeStress(user_id, v[7])
										if v[8] ~= nil then
											vRP.tryGiveInventoryItem(user_id, v[8], 1)
										end
										if v[9] ~= 0 and v[10] ~= 0 then
											TriggerClientEvent('setEnergetic', source, v[9], v[10])
										end
										TriggerClientEvent('setDrunkTime', source, 300)
									end
								end
								Citizen.Wait(0)
							until active[user_id] == nil
						end
					end
					for k, v in pairs(config.foods) do
						if itemName == k then
							active[user_id] = 10
							vRPclient.stopActived(source)
							zCLIENT.closeInventory(source)
							zCLIENT.blockButtons(source, true)
							TriggerClientEvent('Progress', source, 10000, v[4])
							vRPclient._createObjects(source, v[1], v[2], v[3], 49, 60309)
							repeat
								if active[user_id] == 0 then
									active[user_id] = nil
									zCLIENT.blockButtons(source, false)
									vRPclient._removeObjects(source, 'one')
									if vRP.tryGetInventoryItem(user_id, itemName, 1, true, slot) then
										vRP.upgradeThirst(user_id, v[5])
										vRP.upgradeHunger(user_id, v[6])
										vRP.downgradeStress(user_id, v[7])
										if v[8] ~= nil then
											vRP.tryGiveInventoryItem(user_id, v[8], 1)
										end
										if v[9] ~= 0 and v[10] ~= 0 then
											TriggerClientEvent('setEnergetic', source, v[9], v[10])
										end
									end
								end
								Citizen.Wait(0)
							until active[user_id] == nil
						end
					end
					if itemName == 'binoculo' then
						active[user_id] = 2
						zCLIENT.closeInventory(source)
						zCLIENT.blockButtons(source, true)
						TriggerClientEvent('Progress', source, 2000, 'Utilizando...')
						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								zCLIENT.blockButtons(source, false)
								vRPclient._createObjects(source, 'amb@world_human_binoculars@male@enter', 'enter', 'prop_binoc_01', 50, 28422)
								Citizen.Wait(750)
								TriggerClientEvent('useBinoculos', source)
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end
					if itemName == 'wammoWEAPON_STICKYBOMB' then
						TriggerClientEvent('zCASHMACHINE:machineRobbery',source)
					end
					if itemName == 'pneu' then
						if not vRPclient.inVehicle(source) then
							local vehicle, vehNet = vRPclient.vehList(source, 3)
							if vehicle then
								active[user_id] = 30
								vRPclient.stopActived(source)
								zCLIENT.closeInventory(source)
								zCLIENT.blockButtons(source, true)
								vRPclient._playAnim(source, false, {'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer'}, true)
								local taskResult = zTASKBAR.taskTwo(source)
								if taskResult then
									if vRP.tryGetInventoryItem(user_id, itemName, 1, true, slot) then
										TriggerClientEvent('zInventory:repairTires', -1, vehNet)
									end
								end
								zCLIENT.blockButtons(source, false)
								vRPclient._stopAnim(source, false)
								active[user_id] = nil
							end
						end
					end
					if itemName == 'camera' then
						active[user_id] = 2
						zCLIENT.closeInventory(source)
						zCLIENT.blockButtons(source, true)
						TriggerClientEvent('Progress', source, 2000, 'Utilizando...')
						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								zCLIENT.blockButtons(source, false)
								vRPclient._createObjects(source, 'amb@world_human_paparazzi@male@base', 'base', 'prop_pap_camera_01', 49, 28422)
								Citizen.Wait(100)
								TriggerClientEvent('useCamera', source)
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end
					if itemName == 'celular' then
						TriggerClientEvent('gcPhone:activePhone', source)
						
					end
					if itemName == 'celular-pro' then
						TriggerClientEvent('gcPhone:activePhone', source)
						
					end
					if itemName == 'GADGET_PARACHUTE' then
						active[user_id] = 10
						zCLIENT.closeInventory(source)
						zCLIENT.blockButtons(source, true)
						TriggerClientEvent('Progress', source, 10000, 'Utilizando...')
						repeat	
							if active[user_id] == 0 then
								active[user_id] = nil
								zCLIENT.blockButtons(source, false)
								if vRP.tryGetInventoryItem(user_id, itemName, 1, true, slot) then
									zCLIENT.parachuteColors(source)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end
					if itemName == 'skate' then
						active[user_id] = 3
						zCLIENT.closeInventory(source)
						zCLIENT.blockButtons(source, true)
						TriggerClientEvent('Progress', source, 3000, 'Utilizando...')
						repeat	
							if active[user_id] == 0 then
								active[user_id] = nil
								zCLIENT.blockButtons(source, false)
								if vRP.tryGetInventoryItem(user_id, itemName, 1, true, slot) then
									zCLIENT.skateStart(source)
								end
							end
							Citizen.Wait(0)
						until active[user_id] == nil
					end
					if itemName == 'mochila-pequena' then
						local weight = vRP.getBackpackWeight(user_id)
						if weight <= 6 then
							if vRP.tryGetInventoryItem(user_id, itemName, 1, true, slot) then
								vRP.setBackpackWeight(user_id, 36)
								vRP.setBackpackSlots(user_id, 12)
								if config.backpackOnBody == true then
									TriggerClientEvent('zInventory:backpackOnBody', source)
								end
								TriggerClientEvent('zInventory:Update', source, 'updateBackpack')
							end
						else
							TriggerClientEvent('Notify', source, 'aviso', 'No momento você não pode usar essa mochila.', 5000)
						end
					end
					if itemName == 'mochila-media' then
						local weight = vRP.getBackpackWeight(user_id)
						if weight <= 6 then
							if vRP.tryGetInventoryItem(user_id, itemName, 1, true, slot) then
								vRP.setBackpackWeight(user_id, 72)
								vRP.setBackpackSlots(user_id, 18)
								if config.backpackOnBody == true then
									TriggerClientEvent('zInventory:backpackOnBody', source)
								end
								TriggerClientEvent('zInventory:Update', source, 'updateBackpack')
							end
						else
							TriggerClientEvent('Notify', source, 'aviso', 'No momento você não pode usar essa mochila.', 5000)
						end
					end
					if itemName == 'mochila-grande' then
						local weight = vRP.getBackpackWeight(user_id)
						if weight <= 6 then
							if vRP.tryGetInventoryItem(user_id, itemName, 1, true, slot) then
								vRP.setBackpackWeight(user_id, 90)
								vRP.setBackpackSlots(user_id, 32)
								if config.backpackOnBody == true then
									TriggerClientEvent('zInventory:backpackOnBody', source)
								end
								TriggerClientEvent('zInventory:Update', source, 'updateBackpack')
							end
						else
							TriggerClientEvent('Notify', source, 'aviso', 'No momento você não pode usar essa mochila.', 5000)
						end
					end
					TriggerClientEvent('zInventory:Update', source, 'hideHotbar')
				end

				

				if vRP.itemTypeList(itemName) == 'equip' then
					zCLIENT.putWeaponHands(source, itemName)
					local ammo = vRP.itemAmmoList(itemName)

					--vRP.tryGetAmmo(user_id)

					local targetAmount = vRP.getInventoryItemAmount(user_id, ammo)

					if targetAmount > 250 then
						targetAmount = 250
					end

					if vRP.tryGetInventoryItem(user_id, ammo, parseInt(targetAmount)) then
						zCLIENT.rechargeWeapon(source, itemName, targetAmount)
						TriggerClientEvent ('zInventory:Update', source, 'updateMochila')	
					end
                end

				--[[if vRP.itemTypeList(itemName) == 'reloading' then
					local targetAmount = vRP.getInventoryItemAmount(user_id, itemName)

					if targetAmount > 250 then
						targetAmount = 250
					end

					if vRP.tryGetInventoryItem(user_id, itemName, parseInt(targetAmount), true, slot) then
						zCLIENT.closeInventory(source)
						zCLIENT.rechargeWeapon(source, itemName, targetAmount)
						TriggerClientEvent ('zInventory:Update', source, 'updateMochila')
					end
				end]]
			end
		end
	end
end)

RegisterNetEvent('zInventory:updateSlot')
AddEventHandler('zInventory:updateSlot', function(itemName, slot, target, amount, ammo, ammoAmount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		TriggerClientEvent('zSounds:source', source, 'slot', 0.1)
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end
		local inv = vRP.getInventory(user_id)
		if inv then
			if ammo and ammo ~= 0 then
				if inv[tostring(slot)] and inv[tostring(target)] and inv[tostring(slot)].item == inv[tostring(target)].item then
					if vRP.tryGetInventoryItem(user_id, itemName, amount, false, slot) then
						vRP.giveInventoryItem(user_id, itemName, amount, false, target)
						vRP.tryGiveInventoryItem(user_id, ammo, ammoAmount)
						vRP.updateWeaponData(user_id, itemName, ammo, ammoAmount, 'remAll')
					end
				else
					vRP.swapSlot(user_id, slot, target)
					vRP.tryGiveInventoryItem(user_id, ammo, ammoAmount)
					vRP.updateWeaponData(user_id, itemName, ammo, ammoAmount, 'remAll')
				end
			else
				if inv[tostring(slot)] and inv[tostring(target)] and inv[tostring(slot)].item == inv[tostring(target)].item then
					if vRP.tryGetInventoryItem(user_id, itemName, amount, false, slot) then
						vRP.giveInventoryItem(user_id, itemName, amount, false, target)
					end
				else
					vRP.swapSlot(user_id, slot, target)
				end
			end
			TriggerClientEvent('zInventory:Update', source, 'updateBackpack')
		end
	end
end)

RegisterNetEvent('zInventory:sendItem')
AddEventHandler('zInventory:sendItem', function(itemName, amount, ammo, ammoAmount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if active[user_id] == nil and not zPlayer.getHandcuff(source) then
			if amount == nil then amount = 1 end
			if amount <= 0 then amount = 1 end
			if not vRP.wantedReturn(user_id) then
				if ammo and ammo ~= 0 then
					local nplayer = vRPclient.nearestPlayer(source, 3)
					if nplayer then
						local nuser_id = vRP.getUserId(nplayer)
						if nuser_id then
							if vRP.getInventoryItemAmount(user_id, itemName) <= amount then
								TriggerClientEvent('zInventory:unEquipWeapon', source, itemName)
								vRP.tryGiveInventoryItem(user_id, ammo, parseInt(ammoAmount))
								vRP.updateWeaponData(user_id, itemName, ammo, ammoAmount, 'remAll')				
							end
							
							if vRP.tryGetInventoryItem(user_id, itemName, parseInt(amount), true) then
								vRP.tryGiveInventoryItem(nuser_id, itemName, parseInt(amount), true)
								TriggerClientEvent('zInventory:Update', nplayer, 'updateBackpack')
								vRPclient._playAnim(source, true, {'pickup_object', 'putdown_low'}, false)
								Citizen.Wait(750)
								vRPclient._removeObjects(source)
							end
						end
					end
				else					
					local nplayer = vRPclient.nearestPlayer(source, 3)
					if nplayer then
						local nuser_id = vRP.getUserId(nplayer)
						if nuser_id then
							if vRP.tryGetInventoryItem(user_id, itemName, parseInt(amount), true) then
								vRP.tryGiveInventoryItem(nuser_id, itemName, parseInt(amount), true)
								TriggerClientEvent('zInventory:Update', nplayer, 'updateBackpack')
								vRPclient._playAnim(source, true, {'pickup_object', 'putdown_low'}, false)
								Citizen.Wait(750)
								vRPclient._removeObjects(source)
							end
						end
					end
				end
			end
		end
	end
end)

RegisterNetEvent('zInventory:dropItem')
AddEventHandler('zInventory:dropItem', function(itemName, amount, bole, ammo, ammoAmount)
	local source = source
	local user_id = vRP.getUserId(source)
	weaponrechenger[itemName] = false
    local x, y, z = vRPclient.getPosition(source)

	if amount == nil then return end
	if amount <= 0 then return end

    if parseInt(amount) > 0 then
        if bole == true then
			if ammo and ammo ~= 0 then
				if vRP.getInventoryItemAmount(user_id, itemName) <= amount then
					TriggerClientEvent('zInventory:unEquipWeapon', source, itemName)
					vRP.updateWeaponData(user_id, itemName, ammo, ammoAmount, 'remAll')
					TriggerEvent('itemdrop:Create', ammo, parseInt(ammoAmount), source)			
				end

				if vRP.tryGetInventoryItem(user_id, itemName, parseInt(amount)) then
					TriggerEvent('itemdrop:Create', itemName, parseInt(amount), source)
					zCLIENT.closeInventory(source)
				end
			else
				if vRP.tryGetInventoryItem(user_id, itemName, parseInt(amount)) then
					TriggerEvent('itemdrop:Create', itemName, parseInt(amount), source)
					zCLIENT.closeInventory(source)
				end
			end
        else
            TriggerEvent('itemdrop:Create', itemName, parseInt(amount), source)
        end
        
    end
    
	local nplayer = vRPclient.nearestPlayer(source, 5)
    if nplayer then
        TriggerClientEvent('zInventory:Update', nplayer, 'updateMochila')
    end
end)

RegisterServerEvent('itemdrop:Create')
AddEventHandler('itemdrop:Create', function(item, count, source)
    local id = idgens:gen()
    local x, y, z = vRPclient.getPositions(source)
    droplist[id] = { item = item, count = count, x = x, y = y, z = z, name = vRP.itemNameList(item),  index = vRP.itemIndexList(item), desc = vRP.itemDescList(item), peso = vRP.itemWeightList(item) }
    TriggerClientEvent('itemdrop:Players', -1, id, droplist[id])
	local nplayer = vRPclient.nearestPlayer(source, 5)
    if nplayer then
        TriggerClientEvent('zInventory:Update', nplayer, 'updateMochila')
    end
end)

RegisterServerEvent('zItemdrop:Create')
AddEventHandler('zItemdrop:Create', function(item, count, x, y, z, source)
    local id = idgens:gen()
    droplist[id] = { item = item, count = count, x = x, y = y, z = z, name = vRP.itemNameList(item),  index = vRP.itemIndexList(item), desc = vRP.itemDescList(item), peso = vRP.itemWeightList(item) }
    TriggerClientEvent('itemdrop:Players', -1, id, droplist[id])
	local nplayer = vRPclient.nearestPlayer(source, 5)
	if nplayer then
		TriggerClientEvent('zInventory:Update', nplayer, 'updateMochila')
	end
end)

RegisterServerEvent('itemdrop:Pickup')
AddEventHandler('itemdrop:Pickup', function(id, slot, amount)
    local source = source
    local user_id = vRP.getUserId(source)
    local inv = vRP.getInventory(user_id)
	local nplayer = vRPclient.nearestPlayer(source, 5)
    if nplayer then
        TriggerClientEvent('zInventory:Update', nplayer, 'updateDrop')
    end
	if droplist[id] == nil then
        return
    end
	if droplist[id].count < amount then
		return
	end
	if amount == nil then amount = 1 end
	if amount <= 0 then amount = 1 end

	if droplist[id].count - amount >= 1 then
		TriggerClientEvent('itemdrop:Remove', -1, id)
		vRP.tryGiveInventoryItem(user_id, tostring(droplist[id].item), amount, true, slot)
		local newamount = droplist[id].count - amount
		zCLIENT.dropItem(source, droplist[id].item, newamount)
		zCLIENT.closeInventory(source)
		vRPclient._playAnim(source, true, {'pickup_object', 'pickup_low'}, false)
		droplist[id] = nil
		idgens:free(id)
		return
	else
		TriggerClientEvent('itemdrop:Remove', -1, id)
		vRP.tryGiveInventoryItem(user_id, tostring(droplist[id].item), parseInt(droplist[id].count), true, slot)
		zCLIENT.closeInventory(source)
		vRPclient._playAnim(source, true, {'pickup_object', 'pickup_low'}, false)
		droplist[id] = nil
		idgens:free(id)
	end
end)

RegisterServerEvent('takeSkate')
AddEventHandler('takeSkate', function()
    local source = source
    local user_id = vRP.getUserId(source)
    local inv = vRP.getInventory(user_id)
	vRP.tryGiveInventoryItem(user_id, 'skate', 1, false)
	zCLIENT.skateAttach(source, 'pick')
end)

RegisterServerEvent('zInventory:Cancel')
AddEventHandler('zInventory:Cancel', function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if active[user_id] ~= nil and active[user_id] > 0 then
			active[user_id] = nil
			TriggerClientEvent('Progress', source, 1500, 'Cancelando...')
			SetTimeout(1000, function()
				vRPclient._removeObjects(source)
				zCLIENT.blockButtons(source, false)
				vRP.updateHotwired(source, false)
			end)
		else
			vRPclient._removeObjects(source)
		end
	end
end)

AddEventHandler('vRP:playerSpawn', function(user_id, source)
	TriggerClientEvent('itemdrop:Update', source, droplist)
end)

Citizen.CreateThread(function()
	while true do
		for k, v in pairs(registerTimers) do
			if registerTimers[k][4] > 0 then
				registerTimers[k][4] = registerTimers[k][4] - 1
				if registerTimers[k][4] <= 0 then
					registerTimers[k] = nil
					TriggerClientEvent('zInventory:updateRegister', -1, registerTimers)
				end
			end
		end
		Citizen.Wait(10000)
	end
end)

Citizen.CreateThread(function()
	while true do
		for k, v in pairs(firecracker) do
			if firecracker[k] > 0 then
				firecracker[k] = firecracker[k] - 30
				if firecracker[k] <= 0 then
					firecracker[k] = nil
				end
			end
		end
		Citizen.Wait(30000)
	end
end)

Citizen.CreateThread(function()
	while true do
		for k, v in pairs(active) do
			if active[k] > 0 then
				active[k] = active[k] - 1
			end
		end
		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------
--[ CHEST ]------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
local chestOpen = {}
local maxslotschest = {}
local slotsusedchest = {}

RegisterCommand('testechest', function(source, args, rawCommand)
	local rows = vRP.query('vRP/get_alltable')
    if #rows > 0 then
		for k, v in pairs(rows) do
			zCLIENT.insertTable(source, rows[k].name, { rows[k].x, rows[k].y, rows[k].z } )
		end
	end
end)

function zSERVER.checkIntPermissions(chestName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.wantedReturn(parseInt(user_id)) then
			return false
		end
		local consult = vRP.query('vRP/getExistChest', { name = chestName })
		if consult[1].name == chestName then
			if vRP.hasPermission(parseInt(user_id), consult[1].permission) then
				chestOpen[user_id] = chestName
				return true
			end
		end
	end
	return false
end

function zSERVER.chestClose()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if chestOpen[user_id] then
			chestOpen[user_id] = nil
		end
	end
end

function zSERVER.openChest()
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		local myinventory = {}
		local mychestopen = {}
		local mychestname = chestOpen[parseInt(user_id)]
		if mychestname ~= nil then
			local inv = vRP.getInventory(parseInt(user_id))
			if inv then
				for k, v in pairs(inv) do
					if string.sub(v.item, 1, 9) == 'toolboxes' then
						local advFile = LoadResourceFile('logsystem', 'toolboxes.json')
						local advDecode = json.decode(advFile)
						v.durability = advDecode[v.item]
					end
					v.amount = parseInt(v.amount)
					v.name = vRP.itemNameList(v.item)
					v.weight = vRP.itemWeightList(v.item)
					v.index = vRP.itemIndexList(v.item)
					v.key = v.item
					v.slot = k
					myinventory[k] = v
				end
			end
			local data = vRP.getSData('chest:'..mychestname)
			local sdata = json.decode(data) or {}
			if data then
				for k, v in pairs(sdata) do
					table.insert(mychestopen, {amount = parseInt(v.amount), name = vRP.itemNameList(v.item), index = vRP.itemIndexList(v.item), key = v.item, weight = vRP.itemWeightList(v.item), slot = k})
				end
			end
			local consult = vRP.query('vRP/getExistChest', { name = mychestname })
			if consult[1].name == mychestname then
				return myinventory, mychestopen, vRP.computeInvWeight(user_id), vRP.getBackpackWeight(user_id), parseInt(vRP.computeInvSlots(user_id)), vRP.getBackpackSlots(user_id), vRP.computeChestWeight(sdata), consult[1].weight, vRP.computeChestSlots(sdata), parseInt(consult[1].slots)
			end
		end
	end
	return false
end

function zSERVER.storeItem(itemName, slot, amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if itemName and user_id then
		if config.NoStoreItem[itemName] or vRP.itemSubTypeList(itemName) then
			TriggerClientEvent('Notify', source, 'importante', 'Você não pode armazenar este item em baús.', 5000)
			return
		end
		if parseInt(slotsusedchest) < parseInt(maxslotschest) then
			setslot = parseInt(slotsusedchest) + 1
		elseif parseInt(slotsusedchest) == 0 or parseInt(slotsusedchest) == nil then 
			setslot = 1
		elseif parseInt(slotsusedchest) == parseInt(maxslotschest) or parseInt(slotsusedchest) > parseInt(maxslotschest) then
			return false
		end
		local consult = vRP.query('vRP/getExistChest', { name = tostring(chestOpen[parseInt(user_id)]) })
		if consult[1].name == tostring(chestOpen[parseInt(user_id)]) then
			if vRP.storeChestItem(user_id, 'chest:'..tostring(chestOpen[parseInt(user_id)]), itemName, amount, consult[1].weight, consult[1].slots, setslot) then
				TriggerClientEvent('chest:Update', source, 'updateChest')
				return true
			else
				TriggerClientEvent('chest:Update', source, 'updateChest')
				return false
			end
		end
	end
end

function zSERVER.takeItem(itemName, slot, amount)
	if itemName then
		local source = source
		local user_id = vRP.getUserId(source)
		if user_id then
			if vRP.tryChestItem(user_id, 'chest:'..tostring(chestOpen[parseInt(user_id)]), itemName, amount, slot) then
				TriggerClientEvent('chest:Update', source, 'updateChest')
			end
		end
	end
end

RegisterNetEvent('chest:populateSlot')
AddEventHandler('chest:populateSlot', function(itemName, slot, target, amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end
		if vRP.tryGetInventoryItem(user_id, itemName, amount, false, slot) then
			vRP.giveInventoryItem(user_id, itemName, amount, false, target)
			TriggerClientEvent('chest:Update', source, 'updateChest')
		end
	end
end)

RegisterNetEvent('chest:updateSlot')
AddEventHandler('chest:updateSlot', function(itemName, slot, target, amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end
		local inv = vRP.getInventory(user_id)
		if inv then
			if inv[tostring(slot)] and inv[tostring(target)] and inv[tostring(slot)].item == inv[tostring(target)].item then
				if vRP.tryGetInventoryItem(user_id, itemName, amount, false, slot) then
					vRP.giveInventoryItem(user_id, itemName, amount, false, target)
				end
			else
				vRP.swapSlot(user_id, slot, target)
			end
		end
		TriggerClientEvent('chest:Update', source, 'updateChest')
	end
end)

RegisterNetEvent('chest:sumSlot')
AddEventHandler('chest:sumSlot', function(itemName, slot, amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local inv = vRP.getInventory(user_id)
		if inv then
			if inv[tostring(slot)] and inv[tostring(slot)].item == itemName then
				if vRP.tryChestItem(user_id, 'chest:'..tostring(chestOpen[parseInt(user_id)]), itemName, amount, slot) then
					TriggerClientEvent('chest:Update', source, 'updateChest')
				end
			end
		end
	end
end)

AddEventHandler('vRP:playerSpawn', function(user_id, source)
	local rows = vRP.query('vRP/get_alltable')
    if #rows > 0 then
		for k, v in pairs(rows) do
			zCLIENT.insertTable(source, rows[k].name, { rows[k].x, rows[k].y, rows[k].z } )
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------
--[ INSPECT ]----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------

local opened = {}

RegisterCommand('revistar', function(source, args, rawCommand)
	local user_id = vRP.getUserId(source)
	for a, b in pairs(config.PerssionInspect) do
		local nplayer = vRPclient.nearestPlayer(source, 5)
		if nplayer then
			local nuser_id = vRP.getUserId(nplayer)
			if nuser_id then
				if vRP.hasPermission(user_id, b) then
					zCLIENT.toggleCarry(nplayer, source)
					local weapons = vRPclient.replaceWeapons(nplayer)
					for k, v in pairs(weapons) do
						vRP.giveInventoryItem(nuser_id, k, 1)
						if v.ammo > 0 then
							vRP.giveInventoryItem(nuser_id, vRP.itemAmmoList(k), v.ammo)
						end
					end
					vRPclient.updateWeapons(nplayer)
					opened[user_id] = parseInt(nuser_id)
					TriggerClientEvent('inspect:OpenNui', source)
				else
					if not vRP.wantedReturn(nuser_id) then
						local policia = vRP.numPermission('Police')
						if vRPclient.getHealth(nplayer) > 101 then
							local request = vRP.request(nplayer, 'Você está sendo revistado, você permite?', 60)
							if request then
								vRPclient._playAnim(nplayer, true, {'random@arrests@busted', 'idle_a'}, true)
								zCLIENT.toggleCarry(nplayer, source)
								local weapons = vRPclient.replaceWeapons(nplayer)
								for k, v in pairs(weapons) do
									vRP.giveInventoryItem(nuser_id, k, 1)
									if v.ammo > 0 then
										vRP.giveInventoryItem(nuser_id, vRP.itemAmmoList(k), v.ammo)
									end
								end
								vRP.wantedTimer(user_id, 600)
								opened[user_id] = parseInt(nuser_id)
								TriggerClientEvent('inspect:OpenNui', source)
							else
								TriggerClientEvent('Notify', source, 'negado', 'Pedido de revista recusado.', 5000)
							end
						end
					end
				end
			end
		end
	end
end)

function zSERVER.openInspectServ()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if opened[user_id] ~= nil then
			local inventory = {}
			local myInv = vRP.getInventory(user_id)
			for k, v in pairs(myInv) do
				if string.sub(v.item, 1, 9) == 'toolboxes' then
					local advFile = LoadResourceFile('logsystem', 'toolboxes.json')
					local advDecode = json.decode(advFile)
				end
				v.amount = parseInt(v.amount)
				v.name = vRP.itemNameList(v.item)
				v.weight = vRP.itemWeightList(v.item)
				v.index = vRP.itemIndexList(v.item)
				v.key = v.item
				v.slot = k
				inventory[k] = v
			end
			local inventorytwo = {}
			local othInv = vRP.getInventory(opened[user_id])
			for k, v in pairs(othInv) do
				if string.sub(v.item, 1, 9) == 'toolboxes' then
					local advFile = LoadResourceFile('logsystem', 'toolboxes.json')
					local advDecode = json.decode(advFile)
				end
				v.amount = parseInt(v.amount)
				v.name = vRP.itemNameList(v.item)
				v.weight = vRP.itemWeightList(v.item)
				v.index = vRP.itemIndexList(v.item)
				v.key = v.item
				v.slot = k
				inventorytwo[k] = v
			end
			local weighttwo = vRP.computeInvWeight(opened[user_id])
			local maxweighttwo = vRP.getBackpackWeight(opened[user_id])
			local slotstwo = parseInt(vRP.computeInvSlots(opened[user_id]))
			local maxslotstwo = vRP.getBackpackSlots(opened[user_id])
			return inventory, vRP.computeInvWeight(user_id), vRP.getBackpackWeight(user_id), parseInt(vRP.computeInvSlots(user_id)), vRP.getBackpackSlots(user_id), inventorytwo, weighttwo, maxweighttwo, slotstwo, maxslotstwo
		end
	end
end

function zSERVER.storeItemInspect(itemName, slot, amount)
	local source = source
	local user_id = vRP.getUserId(source)
	local steam = vRP.getSteam(source)
	local useridentity = vRP.getUserIdentity(user_id)
	if user_id then
		if user_id == opened[user_id] then
			vRP.execute('vRP/set_banned', { steam = tostring(nuidentity.steam), banned = 1 })
			vRP.kick(source, 'Você foi banido por tentativa de dump.')
		else
			if vRP.tryGetInventoryItem(user_id, itemName, amount, true, slot) then
				vRP.tryGiveInventoryItem(opened[user_id], itemName, amount, true)
				TriggerClientEvent('inspect:Update', source, 'updateInspect')
			end
		end
	else
		return false
	end
end

function zSERVER.takeItemInspect(itemName, slot, amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and itemName then
		if vRP.tryGetInventoryItem(opened[user_id], itemName, amount, true, slot) then
			vRP.tryGiveInventoryItem(user_id, itemName, amount, true)
			TriggerClientEvent('inspect:Update', source, 'updateInspect')
		end
	else
		return false
	end
end

function zSERVER.resetInspect()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local nplayer = vRPclient.nearestPlayer(source, 5)
		if nplayer then
			vRPclient._stopAnim(nplayer, false)
			zCLIENT.toggleCarryInspect(nplayer, source)
		end
		if opened[user_id] ~= nil then
			opened[user_id] = nil
		end
		vRPclient._stopAnim(source, false)
	end
end

RegisterNetEvent('inspect:populateSlot')
AddEventHandler('inspect:populateSlot', function(itemName, slot, target, amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end
		if vRP.tryGetInventoryItem(user_id, itemName, amount, false, slot) then
			vRP.giveInventoryItem(user_id, itemName, amount, false, target)
			TriggerClientEvent('inspect:Update', source, 'updateInspect')
		end
	end
end)

RegisterNetEvent('inspect:populateSlot')
AddEventHandler('inspect:populateSlot', function(itemName, slot, target, amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end
		if vRP.tryGetInventoryItem(user_id, itemName, amount, false, slot) then
			vRP.giveInventoryItem(user_id, itemName, amount, false, target)
			TriggerClientEvent('inspect:Update', source, 'updateInspect')
		end
	end
end)

RegisterNetEvent('inspect:updateSlot')
AddEventHandler('inspect:updateSlot', function(itemName, slot, target, amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end
		local inv = vRP.getInventory(user_id)
		if inv then
			if inv[tostring(slot)] and inv[tostring(target)] and inv[tostring(slot)].item == inv[tostring(target)].item then
				if vRP.tryGetInventoryItem(user_id, itemName, amount, false, slot) then
					vRP.giveInventoryItem(user_id, itemName, amount, false, target)
				end
			else
				vRP.swapSlot(user_id, slot, target)
			end
		end
		TriggerClientEvent('inspect:Update', source, 'updateInspect')
	end
end)

RegisterNetEvent('inspect:sumSlot')
AddEventHandler('inspect:sumSlot', function(itemName, slot, target, amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local inv = vRP.getInventory(user_id)
		if inv then
			if inv[tostring(target)] and inv[tostring(target)].item == itemName then
				if vRP.tryGetInventoryItem(opened[user_id], itemName, amount, false, slot) then
					vRP.giveInventoryItem(user_id, itemName, amount, false, target)
					TriggerClientEvent('inspect:Update', source, 'updateInspect')
				end
			end
		end
	end
end)

RegisterNetEvent('inspect:sum2Slot')
AddEventHandler('inspect:sum2Slot', function(itemName, slot, target, amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local inv = vRP.getInventory(opened[user_id])
		if inv[tostring(target)] and inv[tostring(target)].item == item then
			if vRP.tryGetInventoryItem(user_id, itemName, amount, false, slot) then
				vRP.giveInventoryItem(opened[user_id], itemName, amount, false, target)
				TriggerClientEvent('inspect:Update', source, 'updateInspect')
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------
--[ TRUNKCHEST ]-------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------

local vehChest = {}
local vehNames = {}
local vehWeight = {}
local trunkchestOpen = {}
local maxslotscar = {}
local slotsusedcar = {}

function zSERVER.openTrunkchest()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local veh, vehNet, vehPlate, vehName, vehLock, vehBlock = vRPclient.vehList(source, 7)
		if veh then
            for k, v in pairs(trunkchestOpen) do
                if v == vehPlate then
					
                    return
                end
            end
            if not vehLock then
                if vehBlock then
                    return
                end
				vehPlate = string.gsub(vehPlate, " ", "")
                local plateUserId = vRP.getVehiclePlate(vehPlate)
                if plateUserId ~= nil then
                    trunkchestOpen[user_id] = vehPlate
                    zCLIENT.trunkOpen(source)
                    if not vRPclient.inVehicle(source) then
                        TriggerClientEvent('player:syncDoors', -1, vehNet, '5')
                    end
                end
			else
				TriggerClientEvent('Notify', source, 'negado', 'O veículo está trancado!', 8000)
            end
        end
    end
end

function zSERVER.trunkchestOpencar()
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		local vehicle, vehNet, vehPlate, vehName = vRPclient.vehList(source, 7)
		if vehicle then
			vehPlate = string.gsub(vehPlate, " ", "")
			local plateUserId = vRP.getVehiclePlate(vehPlate)
			if plateUserId then
				local myinventory = {}
				local myvehicle = {}
				if vRPclient.inVehicle(source) then
					vehWeight[user_id] = 7
					vehChest[parseInt(user_id)] = 'gloves:'..parseInt(plateUserId)..':'..vehName..':'..vehPlate
				else
					vehWeight[user_id] = parseInt(vRP.vehicleChest(vehName))
					vehChest[parseInt(user_id)] = 'chest:'..parseInt(plateUserId)..':'..vehName..':'..vehPlate
				end
				vehNames[parseInt(user_id)] = vehName
				local inv = vRP.getInventory(parseInt(user_id))
				local data = vRP.getSData(vehChest[parseInt(user_id)])
				local sdata = json.decode(data) or {}
				if data and sdata ~= nil then
					for k, v in pairs(sdata) do
						table.insert(myvehicle, {amount = parseInt(v.amount), name = vRP.itemNameList(v.item), index = vRP.itemIndexList(v.item), key = v.item, weight = vRP.itemWeightList(v.item), slot = k})
					end
				end
				for k, v in pairs(inv) do
					if string.sub(v.item, 1, 9) == 'toolboxes' then
						local advFile = LoadResourceFile('logsystem', 'toolboxes.json')
						local advDecode = json.decode(advFile)
						v.durability = advDecode[v.item]
					end
					v.amount = parseInt(v.amount)
					v.name = vRP.itemNameList(v.item)
					v.weight = vRP.itemWeightList(v.item)
					v.index = vRP.itemIndexList(v.item)
					v.key = v.item
					v.slot = k
					myinventory[k] = v
				end 
				maxslotscar = vRP.vehicleSlots(vehName)
				slotsusedcar = vRP.computeChestSlots(sdata)
				return myinventory, myvehicle, vRP.computeInvWeight(user_id), vRP.getBackpackWeight(user_id), parseInt(vRP.computeInvSlots(user_id)), vRP.getBackpackSlots(user_id), vRP.computeChestWeight(sdata), parseInt(vehWeight[user_id]), vRP.computeChestSlots(sdata), vRP.vehicleSlots(vehName)
			end
		end
	end
	return false
end

function zSERVER.storeTrunkchestItem(itemName, slot, amount)
	if itemName then
		local source = source
		local user_id = vRP.getUserId(source)
		if user_id then
			if config.permStoreVeh[vehNames[parseInt(user_id)]] then
				if not config.permStoreVeh[vehNames[parseInt(user_id)]][itemName] then
					TriggerClientEvent('Notify', source, 'vermelho', 'Você não pode guardar este item.', 3000)
					zCLIENT.trunkClose(source)
					return
				end
			end
			if config.NoStoreItem[itemName] or vRP.itemSubTypeList(itemName) then
				TriggerClientEvent('Notify', source, 'vermelho', 'Você não pode guardar este item.', 3000)
				zCLIENT.trunkClose(source)
				return
			end
			if parseInt(slotsusedcar) < parseInt(maxslotscar) then
				setslot = parseInt(slotsusedcar) + 1
			elseif parseInt(slotsusedcar) == 0 or parseInt(slotsusedcar) == nil then 
				setslot = 1
			elseif parseInt(slotsusedcar) == parseInt(maxslotscar) or parseInt(slotsusedcar) > parseInt(maxslotscar) then
				return false
			end
			if vRP.storeChestItem(user_id, vehChest[parseInt(user_id)], itemName, amount, parseInt(vehWeight[user_id]), parseInt(maxslotscar), setslot) then
				TriggerClientEvent('trunkchest:Update', source, 'updateTrunkchest')
				return true
			else
				TriggerClientEvent('trunkchest:Update', source, 'updateTrunkchest')
				return false
			end
		end
	end
end

function zSERVER.takeTrunkchestItem(itemName, slot, amount)
	if itemName then
		local source = source
		local user_id = vRP.getUserId(source)
		if user_id then
			if vRP.tryChestItem(user_id, vehChest[parseInt(user_id)], itemName, amount, slot) then
				TriggerClientEvent('trunkchest:Update', source, 'updateTrunkchest')
			end
		end
	end
end

function zSERVER.trunkchestClose()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehicle, vehNet, vehPlate, vehName = vRPclient.vehList(source, 7)
		if vehicle then
			if not vRPclient.inVehicle(source) then
				TriggerClientEvent('player:syncDoors', -1, vehNet, '5')
			end
			if trunkchestOpen[user_id] then
				trunkchestOpen[user_id] = nil
			end
		end
	end
end

RegisterNetEvent('trunkchest:populateSlot')
AddEventHandler('trunkchest:populateSlot', function(itemName, slot, target, amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end
		if vRP.tryGetInventoryItem(user_id, itemName, amount, false, slot) then
			vRP.giveInventoryItem(user_id, itemName, amount, false, target)
			TriggerClientEvent('trunkchest:Update', source, 'updateTrunkchest')
		end
	end
end)

RegisterNetEvent('trunkchest:updateSlot')
AddEventHandler('trunkchest:updateSlot', function(itemName, slot, target, amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end
		local inv = vRP.getInventory(user_id)
		if inv then
			if inv[tostring(slot)] and inv[tostring(target)] and inv[tostring(slot)].item == inv[tostring(target)].item then
				if vRP.tryGetInventoryItem(user_id, itemName, amount, false, slot) then
					vRP.giveInventoryItem(user_id, itemName, amount, false, target)
				end
			else
				vRP.swapSlot(user_id, slot, target)
			end
		end
		TriggerClientEvent('trunkchest:Update', source, 'updateTrunkchest')
	end
end)

RegisterNetEvent('trunkchest:sumSlot')
AddEventHandler('trunkchest:sumSlot', function(itemName, slot, amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local inv = vRP.getInventory(user_id)
		if inv then
			if inv[tostring(slot)] and inv[tostring(slot)].item == itemName then
				if vRP.tryChestItem(user_id, vehChest[parseInt(user_id)], itemName, amount, slot) then
					TriggerClientEvent('trunkchest:Update', source, 'updateTrunkchest')
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------
--- [ CHESTHOMES] -----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
local slotsusedhome = {}
local maxweighthome = {}
local maxslotshome = {}

function zSERVER.checkPermissionHome(homeName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.getUserIdentity(user_id)
		if identity then
			if not vRP.wantedReturn(user_id) then
				local homeResult = vRP.query('vRP/get_homepermissions', { home = tostring(homeName) })
				if parseInt(#homeResult) >= 1 then
					local myResult = vRP.query('vRP/get_homeuser', { user_id = parseInt(user_id), home = tostring(homeName) })
					if myResult[1] then
						return true
					else
						return false
					end
				end
			end
		end
	end
end

function zSERVER.requestChesthome(homeName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local myinventory = {}
		local mychesthome = {}
		local mychestname = homeName
		if mychestname ~= nil then
			local inv = vRP.getInventory(parseInt(user_id))
			if inv then
				for k, v in pairs(inv) do
					if string.sub(v.item, 1, 9) == 'toolboxes' then
						local advFile = LoadResourceFile('logsystem', 'toolboxes.json')
						local advDecode = json.decode(advFile)
						v.durability = advDecode[v.item]
					end
					v.amount = parseInt(v.amount)
					v.name = vRP.itemNameList(v.item)
					v.weight = vRP.itemWeightList(v.item)
					v.index = vRP.itemIndexList(v.item)
					v.key = v.item
					v.slot = k
					myinventory[k] = v
				end
			end
			local data = vRP.getSData('homesVault:'..mychestname)
			local sdata = json.decode(data) or {}
			if data then
				for k, v in pairs(sdata) do
					table.insert(mychesthome, {amount = parseInt(v.amount), name = vRP.itemNameList(v.item), index = vRP.itemIndexList(v.item), key = v.item, weight = vRP.itemWeightList(v.item), slot = k})
				end
			end
			local getHome = vRP.query('vRP/get_home',{user_id = user_id, home = tostring(mychestname)})
			for a, b in pairs(getHome) do 
				maxweighthome = b.vault
				maxslotshome = b.slots
			end	
			slotsusedhome = vRP.computeChestSlots(sdata)
			return myinventory, mychesthome, vRP.computeInvWeight(user_id), vRP.getBackpackWeight(user_id), parseInt(vRP.computeInvSlots(user_id)), vRP.getBackpackSlots(user_id), vRP.computeChestWeight(sdata), maxweighthome, slotsusedhome, maxslotshome, mychestname 
	
		end
	end
	return false
end

function zSERVER.chesthomeStoreItem(homeName, itemName, amount)
	local source = source
	local user_id = vRP.getUserId(source)
	local chestName = 'homesVault:'..homeName
	local setslot = {}
	if user_id and itemName then
		if config.NoStoreItem[itemName] or vRP.itemSubTypeList(itemName) then
			TriggerClientEvent('Notify', source, 'negado', 'Você não pode armazenar este item em baús.', 5000)
			return
		end
		if parseInt(slotsusedhome) < parseInt(maxslotshome) then
			setslot = parseInt(slotsusedhome) + 1
		elseif parseInt(slotsusedhome) == 0 or parseInt(slotsusedhome) == nil then 
			setslot = 1
		elseif parseInt(slotsusedhome) == parseInt(maxslotshome) or parseInt(slotsusedhome) > parseInt(maxslotshome) then
			return false
		end
		if vRP.storeChestItem(user_id, chestName, itemName, amount, maxweighthome, maxslotshome, setslot) then
			TriggerClientEvent('zInventory:updateChesthome', source, 'updateChesthome')
			return true
		else
			TriggerClientEvent('zInventory:updateChesthome', source, 'updateChesthome')
			return false
		end
	end
end

function zSERVER.chesthomeTakeItem(homeName, itemName, slot, amount)
	if itemName then
		local source = source
		local user_id = vRP.getUserId(source)
		if user_id then
			if vRP.tryChestItem(user_id, 'homesVault:'..tostring(homeName), itemName, amount, slot) then
				TriggerClientEvent('zInventory:updateChesthome', source, 'updateChesthome')
			else
				TriggerClientEvent('zInventory:updateChesthome', source, 'updateChesthome')
			end
		end
	end
end

AddEventHandler('vRP:playerLeave', function(user_id, source)
	if not vRP.getPremium(user_id) then
		local identity = vRP.getUserIdentity(user_id)
		if identity then
			vRP.execute('vRP/update_priority', { steam = identity.steam })
		end
	end
	if active[user_id] ~= nil then
		active[user_id] = nil
	elseif chestOpen[user_id] ~= nil then
		chestOpen[user_id] = nil
	elseif trunkchestOpen[user_id] ~= nil then
		trunkchestOpen[user_id] = nil
	elseif houseName ~= nil then
		houseName = nil
	end
end)