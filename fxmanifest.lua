fx_version 'cerulean'
game 'gta5'

author 'mrshortyno'
description 'A houserobbery script for ESX and QB-Core'
version '1.0.0'
lua54 'yes'

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
	'@oxmysql/lib/MySQL.lua'
}

shared_scripts {
	'@ox_lib/init.lua',
	'config.lua',
}

files {
	'locales/*.json',
}

escrow_ignore {
    'locales/*.lua',
    'config.lua',
    'client/functions.lua',
    'server/functions.lua',
    'install/*.txt',
    'install/*.sql',
	'install/*.md',
    'install/images/.png',
}