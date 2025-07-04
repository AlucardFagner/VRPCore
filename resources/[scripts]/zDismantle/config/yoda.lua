config = {}

config.LocateDismantle = vector3(2349.79, 3134.05, 48.21)

config.NeedItemToDismantle = true 
config.ItemDismantle = 'lockpick'
config.NeedItemAmount = 1

config.NeedPermission = true
config.Permission = 'Gerente'

config.paymentMethod = 2 -- Use 1 to pay Dirty Money or use 2 to pay the item list.
config.DirtyMoney = 'dinheiro-sujo'
config.ListOfItems = { -- Put the minimum payout in "value" and adjust the multiplication of each item below.
    [1] = { ['item'] = 'lockpick', ['value'] = 10 },
    [2] = { ['item'] = 'agua', ['value'] = 5 }
}

config.BlackListVehicle = {
    'bus',
    'rubel2'
}
config.VehicleList = { -- Below the "dirtymoney" is the amount that will be paid in the Dirty Money option, in listofitems it is the multiplier of each item in the list above.
    [1] = { ['vehicle'] = 'jester', ['dirtymoney'] = 15000, ['listofitems'] = 2},
    [2] = { ['vehicle'] = 'panto', ['dirtymoney'] = 20000, ['listofitems'] = 1}
}
