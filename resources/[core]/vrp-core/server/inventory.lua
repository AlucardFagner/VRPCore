function vRP.itemList()
	return itemlist
end

function vRP.itemBodyList(item)
	if itemlist[item] then
		return itemlist[item]
	end
end

function vRP.itemIndexList(item)
	if itemlist[item] then
		return itemlist[item].index
	end
end

function vRP.itemNameList(item)
	if itemlist[item] then
		return itemlist[item].name
	end
	return "Deleted"
end

function vRP.itemTypeList(item)
	if itemlist[item] then
		return itemlist[item].type
	end
end

function vRP.itemWeightList(item)
	if itemlist[item] then
		return itemlist[item].weight
	end
	return 0
end

function vRP.itemAmmoList(item)
	if itemlist[item] then
		if itemlist[item].ammo then
			return itemlist[item].ammo
		end
		return 0
	end
	return 0
end

function vRP.itemHashList(item)
	if itemlist[item] then
		if itemlist[item].hash then
			return itemlist[item].hash
		end
		return 0
	end
	return 0
end

function vRP.computeInvSlots(user_id)
	local slots = 0
	local inventory = vRP.getInventory(user_id)
	if inventory then
		for k, v in pairs(inventory) do
			if vRP.itemBodyList(v.item) then
				slots = slots + 1
			end
		end
		return slots
	end
	return 0
end

function vRP.computeInvWeight(user_id)
	local weight = 0
	local inventory = vRP.getInventory(user_id)
	if inventory then
		for k,v in pairs(inventory) do
			if vRP.itemBodyList(v.item) then
				weight = weight + vRP.itemWeightList(v.item) * parseInt(v.amount)
			end
		end
		return weight
	end
	return 0
end

function vRP.computeChestSlots(items)
	local slots = 0
	for k, v in pairs(items) do
		if vRP.itemBodyList(v.item) then
			slots = slots + 1
		end
	end
	return slots
end

function vRP.computeChestWeight(items)
	local weight = 0
	for k,v in pairs(items) do
		if vRP.itemBodyList(v.item) then
			weight = weight + vRP.itemWeightList(v.item) * parseInt(v.amount)
		end
	end
	return weight
end

function vRP.getInventoryItemAmount(user_id, idname)
	local data = vRP.getInventory(user_id)
	if data then
		for k,v in pairs(data) do
			if v.item == idname then
				return parseInt(v.amount)
			end
		end
	end
	return 0
end

function vRP.swapSlot(user_id,slot,target)
	local data = vRP.getInventory(user_id)
	if data then
		local temp = data[tostring(slot)]
		data[tostring(slot)] = data[tostring(target)]
		data[tostring(target)] = temp
	end
end

function vRP.getInventoryItemDurability(user_id,idname)
	local data = vRP.getInventory(user_id)
	if data then
		for k,v in pairs(data) do
			if v.item == idname and v.timestamp then
				return v.timestamp
			end
		end
	end
	return nil
end

function vRP.tryGiveInventoryItem(user_id, idname, amount, notify, slot)
	local data = vRP.getInventory(user_id)
	if data and parseInt(amount) > 0 then
		if not slot then
			local initial = 0
			repeat
				initial = initial + 1
			until data[tostring(initial)] == nil or (data[tostring(initial)] and data[tostring(initial)].item == idname)
			initial = tostring(initial)
			
			if data[initial] == nil then
				if vRP.computeInvWeight(user_id) + vRP.itemWeightList(idname) * parseInt(amount) <= vRP.getBackpackWeight(user_id) and vRP.computeInvSlots(user_id) + 1 <= vRP.getBackpackSlots(user_id) then
					data[initial] = { item = idname, amount = parseInt(amount) }

					if notify and vRP.itemBodyList(idname) then
						TriggerClientEvent("itensNotify", vRP.getUserSource(user_id), { "RECEBEU", vRP.itemIndexList(idname), vRP.format(parseInt(amount)), vRP.itemNameList(idname) })
					end

					return true
				else
					local msg = 'Mochila cheia! '..vRP.format(parseInt(amount))..'x '..vRP.itemNameList(idname)..' caiu no chão.'
					TriggerClientEvent('Notify', vRP.getUserSource(user_id), 'negado', msg, 5000)
					TriggerEvent('itemdrop:Create', idname, parseInt(amount), vRP.getUserSource(user_id))
					return false
				end
			elseif data[initial] and data[initial].item == idname then
				if vRP.computeInvWeight(user_id) + vRP.itemWeightList(idname) * parseInt(amount) <= vRP.getBackpackWeight(user_id) then
					data[initial].amount = parseInt(data[initial].amount) + parseInt(amount)

					if notify and vRP.itemBodyList(idname) then
						TriggerClientEvent("itensNotify", vRP.getUserSource(user_id), { "RECEBEU", vRP.itemIndexList(idname), vRP.format(parseInt(amount)), vRP.itemNameList(idname) })
					end

					return true
				else
					local msg = 'Mochila cheia! '..vRP.format(parseInt(amount))..'x '..vRP.itemNameList(idname)..' caiu no chão.'
					TriggerClientEvent('Notify', vRP.getUserSource(user_id), 'negado', msg, 5000)
					TriggerEvent('itemdrop:Create', idname, parseInt(amount), vRP.getUserSource(user_id))
					return false
				end
			end
		else
			slot = tostring(slot)

			if data[slot] then
				if data[slot].item == idname then
					if vRP.computeInvWeight(user_id) + vRP.itemWeightList(idname) <= vRP.getBackpackWeight(user_id) then
						local oldAmount = parseInt(data[slot].amount)
						data[slot] = { item = idname, amount = parseInt(oldAmount) + parseInt(amount) }

						if notify and vRP.itemBodyList(idname) then
							TriggerClientEvent("itensNotify", vRP.getUserSource(user_id), { "RECEBEU", vRP.itemIndexList(idname), vRP.format(parseInt(amount)), vRP.itemNameList(idname) })
						end

						return true
					else
						local msg = 'Mochila cheia! '..vRP.format(parseInt(amount))..'x '..vRP.itemNameList(idname)..' caiu no chão.'
						TriggerClientEvent('Notify', vRP.getUserSource(user_id), 'negado', msg, 5000)
						TriggerEvent('itemdrop:Create', idname, parseInt(amount), vRP.getUserSource(user_id))
						return false
					end
				end
			else
				if vRP.computeInvWeight(user_id) + vRP.itemWeightList(idname) <= vRP.getBackpackWeight(user_id) and vRP.computeInvSlots(user_id) + 1 <= vRP.getBackpackSlots(user_id) then
					data[slot] = { item = idname, amount = parseInt(amount) }
					
					if notify and vRP.itemBodyList(idname) then
						TriggerClientEvent("itensNotify", vRP.getUserSource(user_id), { "RECEBEU", vRP.itemIndexList(idname), vRP.format(parseInt(amount)), vRP.itemNameList(idname) })
					end

					return true
				else
					local msg = 'Mochila cheia! '..vRP.format(parseInt(amount))..'x '..vRP.itemNameList(idname)..' caiu no chão.'
					TriggerClientEvent('Notify', vRP.getUserSource(user_id), 'negado', msg, 5000)
					TriggerEvent('itemdrop:Create', idname, parseInt(amount), vRP.getUserSource(user_id))
					return false
				end
			end
		end
	end
end

function vRP.giveInventoryItem(user_id, idname, amount, notify, slot)
	local data = vRP.getInventory(user_id)
	if data and parseInt(amount) > 0 then
		if not slot then
			local initial = 0
			repeat
				initial = initial + 1
			until data[tostring(initial)] == nil or (data[tostring(initial)] and data[tostring(initial)].item == idname)
			initial = tostring(initial)
			
			if data[initial] == nil then
				if vRP.computeInvWeight(user_id) + vRP.itemWeightList(idname) <= vRP.getBackpackWeight(user_id) then
					data[initial] = { item = idname, amount = parseInt(amount) }
				end
			elseif data[initial] and data[initial].item == idname then
				data[initial].amount = parseInt(data[initial].amount) + parseInt(amount)
			end

			if notify and vRP.itemBodyList(idname) then
				TriggerClientEvent("itensNotify", vRP.getUserSource(user_id), { "RECEBEU", vRP.itemIndexList(idname), vRP.format(parseInt(amount)), vRP.itemNameList(idname) })
			end
		else
			slot = tostring(slot)

			if data[slot] then
				if data[slot].item == idname then
					local oldAmount = parseInt(data[slot].amount)
					data[slot] = { item = idname, amount = parseInt(oldAmount) + parseInt(amount) }
				end
			else
				data[slot] = { item = idname, amount = parseInt(amount) }
			end

			if notify and vRP.itemBodyList(idname) then
				TriggerClientEvent("itensNotify", vRP.getUserSource(user_id), { "RECEBEU", vRP.itemIndexList(idname), vRP.format(parseInt(amount)), vRP.itemNameList(idname) })
			end
		end
	end
end


-- function vRP.giveInventoryItem(user_id,idname,amount,notify,slot,timestamp)
-- 	local data = vRP.getInventory(user_id)
-- 	if data and parseInt(amount) > 0 then
-- 		if not slot then
-- 			local initial = 0
-- 			repeat
-- 				initial = initial + 1
-- 			until data[tostring(initial)] == nil or (data[tostring(initial)] and data[tostring(initial)].item == idname)
-- 			initial = tostring(initial)
			

-- 			if vRP.itemSubTypeList(idname) then
-- 				if vRP.getInventoryItemAmount(user_id,idname) > 0 then
-- 					return false
-- 				else
-- 					if data[initial] == nil then
-- 						if timestamp then
-- 							data[initial] = { item = idname, amount = parseInt(1), timestamp = timestamp }
-- 						else
-- 							data[initial] = { item = idname, amount = parseInt(1), timestamp = (os.time() + vRP.itemDurabilityList(idname)) }
-- 						end
						
-- 					elseif data[initial] and data[initial].item == idname then
-- 						return false
-- 					end
	
-- 					if notify and vRP.itemBodyList(idname) then
-- 						TriggerClientEvent('itensNotify',vRP.getUserSource(user_id),{ '+',vRP.itemIndexList(idname),vRP.format(parseInt(1)),vRP.itemNameList(idname) })
-- 					end
-- 					return true
-- 				end
-- 			else
-- 				if data[initial] == nil then
-- 					data[initial] = { item = idname, amount = parseInt(amount) }
-- 				elseif data[initial] and data[initial].item == idname then
-- 					data[initial].amount = parseInt(data[initial].amount) + parseInt(amount)
-- 				end

-- 				if notify and vRP.itemBodyList(idname) then
-- 					TriggerClientEvent('itensNotify',vRP.getUserSource(user_id),{ '+',vRP.itemIndexList(idname),vRP.format(parseInt(amount)),vRP.itemNameList(idname) })
-- 				end
-- 				return true
-- 			end
-- 		else
-- 			slot = tostring(slot)

-- 			if vRP.itemSubTypeList(idname) then
-- 				if data[slot] then
-- 					return false
-- 				else
-- 					if timestamp then
-- 						data[slot] = { item = idname, amount = parseInt(1), timestamp = timestamp }
-- 					else
-- 						data[slot] = { item = idname, amount = parseInt(1), timestamp = (os.time() + vRP.itemDurabilityList(idname)) }
-- 					end
-- 				end

-- 				if notify and vRP.itemBodyList(idname) then
-- 					TriggerClientEvent('itensNotify',vRP.getUserSource(user_id),{ '+',vRP.itemIndexList(idname),vRP.format(parseInt(1)),vRP.itemNameList(idname) })
-- 				end
-- 				return true
-- 			else
-- 				if data[slot] then
-- 					if data[slot].item == idname then
-- 						local oldAmount = parseInt(data[slot].amount)
-- 						data[slot] = { item = idname, amount = parseInt(oldAmount) + parseInt(amount) }
-- 					end
-- 				else
-- 					data[slot] = { item = idname, amount = parseInt(amount) }
-- 				end

-- 				if notify and vRP.itemBodyList(idname) then
-- 					TriggerClientEvent('itensNotify',vRP.getUserSource(user_id),{ '+',vRP.itemIndexList(idname),vRP.format(parseInt(amount)),vRP.itemNameList(idname) })
-- 				end
-- 				return true
-- 			end
-- 		end
-- 	end
-- end

function vRP.tryGetInventoryItem(user_id,idname,amount,notify,slot)
	local data = vRP.getInventory(user_id)
	if data then
		if not slot then
			for k,v in pairs(data) do
				if v.item == idname and parseInt(v.amount) >= parseInt(amount) then
					v.amount = parseInt(v.amount) - parseInt(amount)

					if parseInt(v.amount) <= 0 then
						data[k] = nil
					end

					if notify and vRP.itemBodyList(idname) then
						TriggerClientEvent('itensNotify',vRP.getUserSource(user_id),{ '-',vRP.itemIndexList(idname),vRP.format(parseInt(amount)),vRP.itemNameList(idname) })
					end
					return true
				end
			end
		else
			local slot  = tostring(slot)

			if data[slot] and data[slot].item == idname and parseInt(data[slot].amount) >= parseInt(amount) then
				data[slot].amount = parseInt(data[slot].amount) - parseInt(amount)

				if parseInt(data[slot].amount) <= 0 then
					data[slot] = nil
				end

				if notify and vRP.itemBodyList(idname) then
					TriggerClientEvent('itensNotify',vRP.getUserSource(user_id),{ '-',vRP.itemIndexList(idname),vRP.format(parseInt(amount)),vRP.itemNameList(idname) })
				end
				return true
			end
		end
	end

	return false
end

function vRP.removeInventoryItem(user_id,idname,amount,notify)
	local data = vRP.getInventory(user_id)
	if data then
		for k,v in pairs(data) do
			if v.item == idname and parseInt(v.amount) >= parseInt(amount) then
				v.amount = parseInt(v.amount) - parseInt(amount)

				if parseInt(v.amount) <= 0 then
					data[k] = nil
				end

				if notify and vRP.itemBodyList(idname) then
					TriggerClientEvent('itensNotify',vRP.getUserSource(user_id),{ '-',vRP.itemIndexList(idname),vRP.format(parseInt(amount)),vRP.itemNameList(idname) })
				end

				break
			end
		end
	end
end

function vRP.createDurability(itemName)
	local advFile = LoadResourceFile('logsystem','toolboxes.json')
	local advDecode = json.decode(advFile)

	if advDecode[itemName] then
		advDecode[itemName] = advDecode[itemName] - 1

		if advDecode[itemName] <= 0 then
			advDecode[itemName] = nil
			vRP.removeInventoryItem(user_id,itemName,1,true)
		end
	else
		advDecode[itemName] = 9
	end

	SaveResourceFile('logsystem','toolboxes.json',json.encode(advDecode),-1)
end

local actived = {}
local activedAmount = {}

Citizen.CreateThread(function()
	while true do
		local slyphe = 500
		if actived then
			slyphe = 100 
			for k,v in pairs(actived) do
				if actived[k] > 0 then
					actived[k] = v - 1
					if actived[k] <= 0 then
						actived[k] = nil
					end
				end
			end
		end
		Citizen.Wait(slyphe)
	end
end)

function vRP.tryChestItem(user_id, chestData, itemName, amount, slot)
	slot = tostring(slot)
	if actived[user_id] == nil then
		actived[user_id] = 1
		local data = vRP.getSData(chestData)
		local items = json.decode(data) or {}
		if data and items ~= nil then
			for k, v in pairs(items) do
				if v.item == itemName and parseInt(v.amount) >= parseInt(amount) then
					if parseInt(amount) > 0 then
						activedAmount[user_id] = parseInt(amount)
					else
						activedAmount[user_id] = parseInt(v.amount)
					end
					local new_weight = vRP.computeInvWeight(user_id) + vRP.itemWeightList(itemName) * parseInt(activedAmount[user_id])
					vRP.tryGiveInventoryItem(user_id, itemName, parseInt(activedAmount[user_id]), true)
					v.amount = parseInt(v.amount) - parseInt(activedAmount[user_id])
					if parseInt(v.amount) <= 0 then
						items[k] = nil
					end
					vRP.setSData(chestData, json.encode(items))
					return true
				end
			end
		end
	end
	return false
end

function vRP.storeChestItem(user_id, chestData, itemName, amountSend, chestWeight, chestSlot, slotchest)
	if actived[user_id] == nil then
		actived[user_id] = 1
		local mychest = {}
		local slotchest = tostring(slotchest)
		local slot = tostring(slot)
		local data = vRP.getSData(chestData)
		local items = json.decode(data) or {}
		local amount = amountSend
		
		if parseInt(amountSend) > 0 then
			activedAmount[user_id] = parseInt(amountSend)
		else 
			activedAmount[user_id] = 1
		end

		for k, v in pairs(items) do 
			table.insert(mychest, {camount = parseInt(v.amount), name = vRP.itemNameList(v.item), index = vRP.itemIndexList(v.item), key = v.item, weight = vRP.itemWeightList(v.item), slot = k})
			if v.item == itemName then
				amount = parseInt(v.amount) + amountSend
				slotchest = k
			end
		end

		if data and items ~= nil then
			local new_weight = vRP.computeChestWeight(items) + vRP.itemWeightList(itemName) * parseInt(activedAmount[user_id])
			local new_slots = vRP.computeChestSlots(items) + 1
			if new_weight <= chestWeight and new_slots <= chestSlot then
				if vRP.tryGetInventoryItem(user_id, itemName, parseInt(activedAmount[user_id]), true) then
					items[slotchest] = { item = itemName, amount = parseInt(amount) }
					vRP.setSData(chestData, json.encode(items))
					return
				end
			end
		end
	end
end

function vRP.updateWeaponData(user_id, weapon, ammo, ammoAmount, operation)
	local data = vRP.getWeapons(user_id)
	if data then
		if operation == 'add' then
			if data[weapon] == nil then
				if ammoAmount > 0 then
					data[weapon] = { ammo = ammo, ammoAmount = parseInt(ammoAmount) }
				end
			elseif data[weapon] and data[weapon] == weapon then
				data[weapon].ammoAmount = parseInt(data[weapon].ammoAmount) + parseInt(ammoAmount)
				if parseInt(data[weapon].ammoAmount) <= 0 then
					data[weapon] = nil
				end
			end
		elseif operation == 'rem' then
			if data[weapon] == nil then
				if ammoAmount > 0 then
					data[weapon] = { ammo = ammo, ammoAmount = parseInt(ammoAmount) }
				end
			elseif data[weapon] and data[weapon] == weapon then
				data[weapon].ammoAmount = parseInt(data[weapon].ammoAmount) - parseInt(ammoAmount)
				if parseInt(data[weapon].ammoAmount) <= 0 then
					data[weapon] = nil
				end
			end
		elseif operation == 'remAll' then
			data[weapon] = nil
		end
	end
end