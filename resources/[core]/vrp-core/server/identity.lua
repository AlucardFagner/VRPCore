function vRP.getUserIdentity(user_id)
	local rows = vRP.getUser(user_id)
	return rows[1]
end

function vRP.getUserRegistration(user_id)
	local rows = vRP.getUser(user_id)
	return rows[1].registration
end

function vRP.getUserIdRegistration(registration)
	local rows = vRP.query('vRP/get_registration', { registration = registration })
	if rows[1] then
		return rows[1].id
	end
end

function vRP.getVehiclePlate(plate)
	local rows = vRP.query('vRP/get_vehicle_by_plate', { plate = plate })
	if rows[1] then
		return rows[1].user_id
	end
end

function vRP.getUserByPhone(phone)
	local rows = vRP.query('vRP/get_user_by_phone', { phone = phone })
	if rows[1] then
		return rows[1].user_id
	end
end

function vRP.getPhone(id)
	local rows = vRP.query('vRP/get_user', { user_id = user_id })
	if rows[1] then
		return rows[1].phone
	end
end

function vRP.generateStringNumber(format)
	local abyte = string.byte('A')
	local zbyte = string.byte('0')
	local number = ''
	for i = 1, #format do
		local char = string.sub(format, i, i)
    	if char == 'D' then
    		number = number..string.char(zbyte+math.random(0, 9))
		elseif char == 'L' then
			number = number..string.char(abyte+math.random(0, 25))
		else
			number = number..char
		end
	end
	return number
end

function vRP.generateRegistrationNumber()
	local user_id = nil
	local registration = ''
	repeat
		Citizen.Wait(0)
		registration = vRP.generateStringNumber('DDLLLDDD')
		user_id = vRP.getUserIdRegistration(registration)
	until not user_id

	return registration
end

function vRP.generatePlateNumber()
	local user_id = nil
	local registration = ''
	repeat
		Citizen.Wait(0)
		registration = vRP.generateStringNumber('DDLLLDDD')
		user_id = vRP.getVehiclePlate(registration)
	until not user_id

	return registration
end

function vRP.genPlate()
	return vRP.generateStringNumber('LLDDDLLL')
end

function vRP.generatePhoneNumber()
	local user_id = nil
	local phone = ''

	repeat
		Citizen.Wait(0)
		phone = vRP.generateStringNumber('DDD-DDD')
		user_id = vRP.getUserByPhone(phone)
	until not user_id

	return phone
end