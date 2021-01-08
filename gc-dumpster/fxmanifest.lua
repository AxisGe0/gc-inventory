fx_version 'adamant'
game 'gta5'

name 'Monster dumpster'
description 'An dumpster script built for Monster gc Framework - A Monster gc Framework built for MonsterSrRP NOHD Nightmare'
author 'TaerAttO'
version 'v1.0.0'
url 'https://discord.gg/taeratto'

server_scripts {
	'@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua'
}

dependencies {
	'gc-core',
	'gc_addonaccount',
	'gc_addoninventory',
	'gc_datastore',
	'mythic_notify'
}

exports {
	"getMonsterdumpsterLicense"
}
