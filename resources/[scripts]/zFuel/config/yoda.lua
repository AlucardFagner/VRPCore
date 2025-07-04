local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

Config = {}

-- Lista de frentistas
Config.pedlist = {
	{ ['x'] = 265.03, ['y'] = -1263.29, ['z'] = 29.3, ['h'] = 80.98, ['hash'] = 0xEDA0082D, ['hash2'] = "ig_jimmyboston" },
	{ ['x'] = 265.11, ['y'] = -1255.15, ['z'] = 29.3, ['h'] = 80.98, ['hash'] = 0xA8C22996, ['hash2'] = "csb_chin_goon" },
	{ ['x'] = 173.95, ['y'] = -1557.98, ['z'] = 29.33, ['h'] = 210.33, ['hash'] = 0xA8C22996, ['hash2'] = "csb_chin_goon" },
}

-- Função que retorna o dinheiro que o jogador tem 
-- retorno: Dinheiro do player 
function returnMoney(source)
	local user_id = vRP.getUserId(source)
	return vRP.getMoney(user_id)
end

-- Função para um jogador realizar pagamento
-- retorno: True caso tenha conseguido retirar o dinheiro falso caso contrário
function checkPayment(source, amount)
	local user_id = vRP.getUserId(source)
	if vRP.tryPayment(user_id,amount) then
		return true
	else 
		TriggerClientEvent("Notify", source, "negado", "Dinheiro insuficiente para abastecer.")
		return false
	end
end

-- Se true o frentista sempre ira até a roda mais próxima da bomba, porém sua movimentação pode bugar em alguns casos. 
--(mais realista)
-- Se false, o frentista sempre abastecerá na roda esquerda, evitando bugs na movimentação do mesmo.
--(mais seguro)
Config.nearWheel = false

-- Se true, os frentistas irão assoviar assim que algum jogador se aproximar
Config.whistle = true

-- Cooldown do assovio dos frentistas (segundos)
Config.whistleCD = 180

-- Som do frentista abastecendo o carro
Config.sound = true

-- Volume do som
Config.volume = 0.2

-- Preço por Litro da Gasolina
Config.tax = 3

-- Preço do galao
Config.canPrice = 500

-- Botão para abrir a tampa do veículo
Config.openButton = 47

-- Taxa de velocidade do abastecimento manual (Quanto menor mais rapido e maior o "ms")
Config.vel = 1.5

-- Velocidade de abastecimento do frentista
Config.velFrontMan = 0.2

-- Id do decorador utilizado
Config.FuelDecor = "FUEL_LEVEL"

-- Controles desabilitados no momento do abastecimento
Config.DisableKeys = { 0,22,23,24,29,30,31,37,44,56,82,140,166,167,168,170,288,289,311,323 }

-- Hash dos modelos da bomba aceitos
Config.PumpModels = {
	[-2007231801] = true,
	[1339433404] = true,
	[1694452750] = true,
	[1933174915] = true,
	[-462817101] = true,
	[-469694731] = true,
	[-164877493] = true
}

-- Taxa de perda de gasolina para cada tipo de classe de veículo
Config.Classes = {
	[0] = 0.6, -- Compacts
	[1] = 0.6, -- Sedans
	[2] = 0.6, -- SUVs
	[3] = 0.6, -- Coupes
	[4] = 0.6, -- Muscle
	[5] = 0.6, -- Sports Classics
	[6] = 0.6, -- Sports
	[7] = 0.6, -- Super
	[8] = 0.6, -- Motorcycles
	[9] = 0.6, -- Off-road
	[10] = 0.6, -- Industrial
	[11] = 0.6, -- Utility
	[12] = 0.6, -- Vans
	[13] = 0.0, -- Cycles
	[14] = 0.0, -- Boats
	[15] = 0.0, -- Helicopters
	[16] = 0.0, -- Planes
	[17] = 0.3, -- Service
	[18] = 0.3, -- Emergency
	[19] = 0.6, -- Military
	[20] = 0.6, -- Commercial
	[21] = 0.6, -- Trains
}

-- Não alterar
Config.FuelUsage = {
	[1.0] = 1.0,
	[0.9] = 0.9,
	[0.8] = 0.8,
	[0.7] = 0.7,
	[0.6] = 0.6,
	[0.5] = 0.5,
	[0.4] = 0.4,
	[0.3] = 0.3,
	[0.2] = 0.2,
	[0.1] = 0.1,
	[0.0] = 0.0,
}

-- Não alterar
Config.money = returnMoney
Config.payment = checkPayment