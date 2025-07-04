config = {}

config.organizations = {
    ['bratva'] = {
        ['name'] = 'Brátva',
        ['initVault'] = 0,
        ['permissions'] = {
            [1] = {'bratvaSoldado'},
            [2] = {'bratvaSargento'},
            [3] = {'bratvaCapitao'},
            [4] = {'bratvaComandante'},
        },
        ['paymentcity'] = false
    },
    ['corleone'] = {
        ['name'] = 'Corleonés',
        ['initVault'] = 0,
        ['permissions'] = {
            [1] = {'corleoneSoldado'},
            [2] = {'corleoneSargento'},
            [3] = {'corleoneCapitao'},
            [4] = {'corleoneComandante'}
        },
        ['paymentcity'] = true
    }
}