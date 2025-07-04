fx_version 'adamant'
games {'gta5'}

dependencies{
  'vrp',
  'oxmysql'
}

server_scripts{ 
  '@vrp/lib/utils.lua',
  'init.lua'
}
