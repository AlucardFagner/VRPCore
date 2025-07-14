function vRP.getBackpackWeight(user_id)
	local data = vRP.getUserDataTable(user_id)
	if data.backpack_weight == nil then
		data.backpack_weight = 6
	end

	return data.backpack_weight
end

function vRP.getBackpackSlots(user_id)
	local data = vRP.getUserDataTable(user_id)
	if data.backpack_slots == nil then
		data.backpack_slots = 6
	end

	return data.backpack_slots
end

function vRP.setBackpackWeight(user_id, amount)
	local data = vRP.getUserDataTable(user_id)
	if data then
		data.backpack_weight = amount
	end
end

function vRP.setBackpackSlots(user_id, amount)
	local data = vRP.getUserDataTable(user_id)
	if data then
		data.backpack_slots = amount
	end
end

function vRP.bonusDelivery(user_id)
	local data = vRP.getUserDataTable(user_id)
	if data.delivery == nil then
		data.delivery = 0
	end

	return data.delivery
end

function vRP.setBonusDelivery(user_id,amount)
	local data = vRP.getUserDataTable(user_id)
	if data.delivery then
		data.delivery = data.delivery + amount
	else
		data.delivery = amount
	end
end

function vRP.bonusPostOp(user_id)
	local data = vRP.getUserDataTable(user_id)
	if data.postop == nil then
		data.postop = 0
	end

	return data.postop
end

function vRP.setbonusPostOp(user_id,amount)
	local data = vRP.getUserDataTable(user_id)
	if data.postop then
		data.postop = data.postop + amount
	else
		data.postop = amount
	end
end