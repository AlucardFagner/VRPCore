config = {}

-- LOCALIZAÇÃO PARA INICIAR A ROTA (MOTORISTA)
config.start = {
	{ ['id'] = 1, ['x'] = 1196.79, ['y'] = -3253.65, ['z'] = 7.1 }, 
}
 
-- PAGAMENTO MÍNIMO E MÁXIMO DAS ENTREGAS DE GÁS
config.PayMinGas = 1000
config.PayMaxGas = 2000

-- PAGAMENTO MÍNIMO E MÁXIMO DAS ENTREGAS DE MADEIRA
config.PayMinWood = 1000
config.PayMaxWood = 2000

-- VEICULO PARA INICIAR A ROTA (MOTORISTA)
config.truck = "phantom" 
config.truck1 = "hauler"  

-- LOCAL DE SPAWN DA CARGA
config.trailer = {
	--[ COMBUSTIVEL ] ---------------------------------------
	[1] = { ['x'] = 1145.24, ['y'] = -3255.90, ['z'] = 5.23 },
	[2] = { ['x'] = 1145.24, ['y'] = -3260.90, ['z'] = 5.23 },
	[3] = { ['x'] = 1145.24, ['y'] = -3265.90, ['z'] = 5.23 },

	--[ MADEIRA ] --------------------------------------------
	[4] = { ['x'] = 1145.24, ['y'] = -3270.90, ['z'] = 5.23 },
	[5] = { ['x'] = 1145.24, ['y'] = -3275.90, ['z'] = 5.23 },
	[6] = { ['x'] = 1145.24, ['y'] = -3280.90, ['z'] = 5.23 },
}

-- LOCALIZAÇÃO DA ENTREGA DA CARGA + VALOR DE CADA ENTREGA
config.routegas = {
	--[ COMBUSTIVEL ] ---------------------------------------
	[1] = { ['x'] = -251.66, ['y'] = 6064.93, ['z'] = 31.68, ['pay'] = 2000, },
	[2] = { ['x'] = 198.88, ['y'] = 6619.29, ['z'] = 31.69, ['pay'] = 2000, },
	[3] = { ['x'] = 95.00, ['y'] = -634.89, ['z'] = 45.02, ['pay'] = 1000, },
}

config.routewood = {
	--[ MADEIRA ] --------------------------------------------
	[1] = { ['x'] = -600.73, ['y'] = 5297.41, ['z'] = 69.7, ['pay'] = 2000, },
	[2] = { ['x'] = 4.23, ['y'] = 6276.33, ['z'] = 31.24, ['pay'] = 2000, },
	[3] = { ['x'] = 2899.27, ['y'] = 4382.05, ['z'] = 50.39, ['pay'] = 2000, },
}