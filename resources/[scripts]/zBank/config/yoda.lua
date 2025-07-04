config = {}

config.initial_money = 2500
config.invoice_fees = 5

config.log = { --  Configurações dos registros das ações;
	['pay'] = { ['use'] = false, ['webhook'] = '' }, -- Pagamento de multas.
	['withdraw'] = { ['use'] = false, ['webhook'] = '' }, -- Saque de valores.
	['deposit'] = { ['use'] = false, ['webhook'] = '' }, -- Depósito de valores.
	['transfer'] = { ['use'] = false, ['webhook'] = '' }, -- Transferencia de valores.
	['loan'] = { ['use'] = false, ['webhook'] = '' }, -- Ações relacionadas a empréstimos.
	['credit'] = { ['use'] = false, ['webhook'] = '' } -- Ações relacionadas ao cartão de crédito.
}

config.credit = { -- Configurações dos cartões de crédito:
	['use'] = false, -- Uso de cartão de crédito no servidor.
	['credit_values'] = {2000, 200000}, -- Primeiro valor: Valor minimo de crédito sedido. Segundo valor: Valor maxímo de crédito sedido.
	['credit_payday'] = 5 -- Tempo real entre cada cobraça do cartão de crédito.
}

config.loan = { -- Configurações dos empréstimos:
	['use'] = false, -- Uso de empréstimo no servidor.
	['loan_values'] = {2000, 200000}, -- Primeiro valor: Valor minimo de empréstimo sedido. Segundo valor: Valor maxímo de empréstimo sedido.
	['loan_payday'] = 5 -- Tempo real entre cada cobraça do empréstimo.
}