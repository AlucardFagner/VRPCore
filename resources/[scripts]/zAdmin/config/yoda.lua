config = {}

--[[

    ATENÇÃO: Ao alterar as configurações, certifique-se de manter o padrão estabelecido no código.
    ATENÇÃO: Limite máximo de permissões por comando: 3. Caso deseje menos permissões, basta colocar NA nos campos indesejados.

    ==========================================================================
    ==  cmd = Comando usado pelo usuário;                                   ==
    ==  permissions = Cargos que podem podem executar o comando;            ==
    ==  webhook = Link do webhook, para o envio de registro para o Discord; ==
    ==========================================================================

]]

config.commands = {
    ['createChest'] = { ['cmd'] = 'bau', ['permissions'] = { 'gerente', 'administrador', 'moderador' }, ['webhook'] = '' },
    ['revive'] = { ['cmd'] = 'reviver', ['permissions'] = { 'gerente', 'administrador', 'moderador' }, ['webhook'] = '' },
    ['matar'] = { ['cmd'] = 'matar', ['permissions'] = { 'gerente', 'administrador', 'moderador' }, ['webhook'] = '' },
    ['skin'] = { ['cmd'] = 'personagem', ['permissions'] = { 'gerente', 'gerente', 'gerente' }, ['webhook'] = '' },
    ['item'] = { ['cmd'] = 'item', ['permissions'] = { 'gerente', 'gerente', 'gerente' }, ['webhook'] = '' },
    ['itemall'] = { ['cmd'] = 'itemall', ['permissions'] = { 'gerente', 'gerente', 'gerente' }, ['webhook'] = '' },
    ['debug'] = { ['cmd'] = 'debug', ['permissions'] = { 'gerente', 'gerente', 'gerente' }, ['webhook'] = nil },
    ['updateplate'] = { ['cmd'] = 'cplaca', ['permissions'] = { 'gerente', 'gerente', 'gerente' }, ['webhook'] = '' },
    ['addvehicle'] = { ['cmd'] = 'addcar', ['permissions'] = { 'gerente', 'gerente', 'gerente' }, ['webhook'] = '' },
    ['remvehicle'] = { ['cmd'] = 'remcar', ['permissions'] = { 'gerente', 'gerente', 'gerente' }, ['webhook'] = '' },
    ['hood'] = { ['cmd'] = 'capuz', ['permissions'] = { 'gerente', 'gerente', 'gerente' }, ['webhook'] = nil },
    ['kick'] = { ['cmd'] = 'kick', ['permissions'] = { 'gerente', 'gerente', 'gerente' }, ['webhook'] = '' },
    ['ban'] = { ['cmd'] = 'ban', ['permissions'] = { 'gerente', 'gerente', 'gerente' }, ['webhook'] = '' },
    ['unban'] = { ['cmd'] = 'unban', ['permissions'] = { 'gerente', 'gerente', 'gerente' }, ['webhook'] = '' },
    ['noclip'] = { ['cmd'] = 'nc', ['permissions'] = { 'gerente', 'gerente', 'gerente' }, ['webhook'] = nil },
    ['whitelist'] = { ['cmd'] = 'wl', ['permissions'] = { 'gerente', 'gerente', 'gerente' }, ['webhook'] = '' },
    ['unwhitelist'] = { ['cmd'] = 'unwl', ['permissions'] = { 'gerente', 'gerente', 'gerente' }, ['webhook'] = '' },
    ['tpcds'] = { ['cmd'] = 'tpcds', ['permissions'] = { 'gerente', 'gerente', 'gerente' }, ['webhook'] = nil },
    ['cds'] = { ['cmd'] = 'cds', ['permissions'] = { 'gerente', 'gerente', 'gerente' }, ['webhook'] = nil },
    ['cds2'] = { ['cmd'] = 'cds2', ['permissions'] = { 'gerente', 'gerente', 'gerente' }, ['webhook'] = nil },
    ['group'] = { ['cmd'] = 'group', ['permissions'] = { 'gerente', 'gerente', 'gerente' }, ['webhook'] = '' },
    ['ungroup'] = { ['cmd'] = 'ungroup', ['permissions'] = { 'gerente', 'gerente', 'gerente' }, ['webhook'] = '' },
    ['tptome'] = { ['cmd'] = 'tptome', ['permissions'] = { 'gerente', 'gerente', 'gerente' }, ['webhook'] = '' },
    ['tpto'] = { ['cmd'] = 'tpto', ['permissions'] = { 'gerente', 'gerente', 'gerente' }, ['webhook'] = '' },
    ['tpway'] = { ['cmd'] = 'tpway', ['permissions'] = { 'gerente', 'gerente', 'gerente' }, ['webhook'] = nil },
    ['limbo'] = { ['cmd'] = 'limbo', ['permissions'] = nil, ['webhook'] = nil },
    ['hash'] = { ['cmd'] = 'hash', ['permissions'] = { 'gerente', 'gerente', 'gerente' }, ['webhook'] = nil },
    ['delnpcs'] = { ['cmd'] = 'delnpcs', ['permissions'] = { 'gerente', 'gerente', 'gerente' }, ['webhook'] = nil },
    ['tuning'] = { ['cmd'] = 'tuning', ['permissions'] = { 'gerente', 'gerente', 'gerente' }, ['webhook'] = nil },
    ['fix'] = { ['cmd'] = 'fix', ['permissions'] = { 'gerente', 'gerente', 'gerente' }, ['webhook'] = nil },
    ['cleanarea'] = { ['cmd'] = 'limpararea', ['permissions'] = { 'gerente', 'gerente', 'gerente' }, ['webhook'] = nil },
    ['players'] = { ['cmd'] = 'players', ['permissions'] = { 'gerente', 'gerente', 'gerente' }, ['webhook'] = nil },
    ['pon'] = { ['cmd'] = 'pon', ['permissions'] = { 'gerente', 'gerente', 'gerente' }, ['webhook'] = nil },
    ['announcement'] = { ['cmd'] = 'anuncio', ['permissions'] = { 'gerente', 'gerente', 'gerente' }, ['webhook'] = nil },
    ['car'] = { ['cmd'] = 'car', ['permissions'] = { 'gerente', 'gerente', 'gerente' }, ['webhook'] = nil }
}