ESX = nil
ServerItems = {}
itemShopList = {}
TriggerEvent(
	"esx:getSharedObject",
	function(obj)
		ESX = obj
	end
)

 --[[ ESX.RegisterServerCallback("gc-inventory:getFastWeapons",function(source,cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	while not xPlayer do Citizen.Wait(10); ESX.GetPlayerFromId(source); end
	MySQL.Async.fetchAll(
		'SELECT * FROM user_fastItems WHERE identifier = @identifier',
		{
			['@identifier'] = xPlayer.identifier
		},
			function(result)
			local fastWeapons = {
				[1] = nil,
				[2] = nil,
				[3] = nil
			}
			for i=1, #result, 1 do
				fastWeapons[result[i].slot] = result[i].weapon
			end
			cb(fastWeapons)

		end
	)
end)
--]]
--[[
RegisterServerEvent("gc-inventory:changeFastItem")
AddEventHandler("gc-inventory:changeFastItem",function(slot,weapon)
	local xPlayer = ESX.GetPlayerFromId(source)
	while not xPlayer do Citizen.Wait(10); ESX.GetPlayerFromId(source); end
	if slot ~= 0 then
		MySQL.Async.fetchAll(
		'SELECT * FROM user_fastItems WHERE identifier = @identifier AND weapon=@weapon',
		{
			['@identifier'] = xPlayer.identifier,
			['@weapon'] = weapon
		},
		function(result)
			Citizen.Wait(200)
			if result[1] == nil then
				MySQL.Async.execute(
					'INSERT INTO user_fastItems (identifier, weapon, slot) VALUES (@identifier, @weapon, @slot)',
					{
						['@identifier']  = xPlayer.identifier,
						['@weapon']      = weapon,
						['@slot'] = slot
					}
				)
			else
				MySQL.Async.execute(
					'UPDATE user_fastItems SET slot = @slot WHERE identifier = @identifier AND weapon=@weapon',
					{
						['@identifier']  = xPlayer.identifier,
						['@weapon']      = weapon,
						['@slot'] = slot
					}
				)
			end
		end
		)
	else
		MySQL.Async.execute(
		'DELETE FROM user_fastItems WHERE identifier = @identifier AND weapon=@weapon',
		{
			['@identifier']  = xPlayer.identifier,
			['@weapon']      = weapon
		})
	end
end)
--]]
RegisterServerEvent('gc-removeitem')
AddEventHandler('gc-removeitem', function(itemname,count)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem(itemname,count)
	TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'Your Item Was Broken' })
end)
RegisterServerEvent('gc-removeweapon')
AddEventHandler('gc-removeweapon', function(itemname,count)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeWeapon(itemname,count)
	TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'Your Item Was Broken' })
end)
ESX.RegisterServerCallback(
	"gc-inventory:getPlayerInventory",
	function(source, cb, target)
		local targetXPlayer = ESX.GetPlayerFromId(target)
		if targetXPlayer ~= nil then
			cb({inventory = targetXPlayer.inventory, money = targetXPlayer.getMoney(), accounts = targetXPlayer.accounts, weapons = targetXPlayer.loadout})
		else
			cb(nil)
		end
	end
)
ESX.RegisterServerCallback(
		"gc-inventory:getPlayerInventoryWeight",
		function(source,cb)
			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)
			local playerweight = xPlayer.getWeight()
			cb(playerweight)
 end)

RegisterNetEvent("gc-inventoryhud:clearweapons")
AddEventHandler("gc-inventoryhud:clearweapons",
function(target)
	TriggerClientEvent('gc-inventoryhud:clearfastitems',target)
end)

ESX.RegisterServerCallback('gc-inventory:takePlayerItem', function(source, cb, item, count)
    local player = ESX.GetPlayerFromId(source)
    local invItem = player.getInventoryItem(item)
    if invItem.count - count < 0 then
        cb(false)
    else
        player.removeInventoryItem(item, count)
        cb(true)
    end
end)

RegisterNetEvent('gc-inventory:addPlayerItem')
AddEventHandler('gc-inventory:addPlayerItem', function(item, count)
    local player = ESX.GetPlayerFromId(source)
    local invItem = player.getInventoryItem(item)
    if player.canCarryItem(item, count) then
        player.addInventoryItem(item, count)
	end
end)

RegisterServerEvent("gc-inventory:tradePlayerItem")
AddEventHandler(
	"gc-inventory:tradePlayerItem",
	function(from, target, type, itemName, itemCount)
		local _source = from
		local sourceXPlayer = ESX.GetPlayerFromId(_source)
		local targetXPlayer = ESX.GetPlayerFromId(target)
		local item = sourceXPlayer.getInventoryItem(itemName)


		if type == "item_standard" then
            if itemCount > 0 and item.count >= itemCount then
                --if  targetXPlayer.canCarryItem(itemName, itemCount) then
                    sourceXPlayer.removeInventoryItem(itemName, itemCount)
					targetXPlayer.addInventoryItem(itemName, itemCount)
			--		TriggerEvent("tqrp_base:serverlog", "[TRADEITEM]: " .. GetPlayerName(_source) .. " ("..itemName .. ") x" .. itemCount .. " to " .. GetPlayerName(target), _source, GetCurrentResourceName())
                --else
                --    TriggerClientEvent('mythic_notify:client:SendAlert', _source , { type = 'error', text = 'The recipient has no space in the inventory!' })
                --end
            end
		elseif type == "item_money" then
			if itemCount > 0 and sourceXPlayer.getMoney() >= itemCount then
				sourceXPlayer.removeMoney(itemCount)
				targetXPlayer.addMoney(itemCount)
			--	TriggerEvent("tqrp_base:serverlog", "[TRADEMONEY]: " .. GetPlayerName(_source) .. " ("..itemCount .. ") to " .. GetPlayerName(target), _source, GetCurrentResourceName())
			end
		elseif type == "item_account" then
			if itemCount > 0 and sourceXPlayer.getAccount(itemName).money >= itemCount then
				sourceXPlayer.removeAccountMoney(itemName, itemCount)
				targetXPlayer.addAccountMoney(itemName, itemCount)
		--		TriggerEvent("tqrp_base:serverlog", "[TRADEBANK]: " .. GetPlayerName(_source) .. " ("..itemName .. ") x" .. itemCount .. " to " .. GetPlayerName(target), _source, GetCurrentResourceName())
			end

		elseif type == "item_weapon" then
			if not targetXPlayer.hasWeapon(itemName) then
				sourceXPlayer.removeWeapon(itemName)
				targetXPlayer.addWeapon(itemName, itemCount)
	--			TriggerEvent("tqrp_base:serverlog", "[TRADEWEAPON]: " .. GetPlayerName(_source) .. " ("..itemName .. ") x" .. itemCount .. " to " .. GetPlayerName(target), _source, GetCurrentResourceName())
			else
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'The recipient already has this weapon!' })
			end
		end
	end
)

--[[]RegisterCommand(
	"steal",
	function(source)
		local _source = source
		TriggerClientEvent('gcrp-inventoryhud:steal', _source)
	end
)]]
RegisterCommand(
		"closeinventory",
		function(source)
			local _source = source
			TriggerClientEvent('gc-inventoryhud:closeinventory', _source)
		end
)
RegisterServerEvent("suku:sendShopItems")
AddEventHandler("suku:sendShopItems", function(source, itemList)
	itemShopList = itemList
end)

ESX.RegisterServerCallback("suku:getShopItems", function(source, cb, shoptype)
	itemShopList = {}
	local itemResult = MySQL.Sync.fetchAll('SELECT * FROM items')
	local itemInformation = {}
	for i=1, #itemResult, 1 do
		if itemInformation[itemResult[i].name] == nil then
			itemInformation[itemResult[i].name] = {}
		end
		itemInformation[itemResult[i].name].name = itemResult[i].name
		itemInformation[itemResult[i].name].label = itemResult[i].label
		itemInformation[itemResult[i].name].weight = itemResult[i].weight
		itemInformation[itemResult[i].name].rare = itemResult[i].rare
		itemInformation[itemResult[i].name].can_remove = itemResult[i].can_remove
		if shoptype == "regular" then
			for _, v in pairs(Config.Shops.RegularShop.Items) do
				if v.name == itemResult[i].name then
					table.insert(itemShopList, {
						type = "item_standard",
						name = itemInformation[itemResult[i].name].name,
						label = itemInformation[itemResult[i].name].label,
						weight = itemInformation[itemResult[i].name].weight,
						rare = itemInformation[itemResult[i].name].rare,
						can_remove = itemInformation[itemResult[i].name].can_remove,
						price = v.price,
						count = 99999999
					})
				end
			end
		end
		if shoptype == "ilegal" then
			for _, v in pairs(Config.Shops.IlegalShop.Items) do
				if v.name == itemResult[i].name then
					table.insert(itemShopList, {
						type = "item_standard",
						name = itemInformation[itemResult[i].name].name,
						label = itemInformation[itemResult[i].name].label,
						weight = itemInformation[itemResult[i].name].weight,
						rare = itemInformation[itemResult[i].name].rare,
						can_remove = itemInformation[itemResult[i].name].can_remove,
						price = v.price,
						count = 99999999
					})
				end
			end
		end
		if shoptype == "robsliquor" then
			for _, v in pairs(Config.Shops.RobsLiquor.Items) do
				if v.name == itemResult[i].name then
					table.insert(itemShopList, {
						type = "item_standard",
						name = itemInformation[itemResult[i].name].name,
						label = itemInformation[itemResult[i].name].label,
						weight = itemInformation[itemResult[i].name].weight,
						rare = itemInformation[itemResult[i].name].rare,
						can_remove = itemInformation[itemResult[i].name].can_remove,
						price = v.price,
						count = 99999999
					})
				end
			end
		end
		if shoptype == "youtool" then
			for _, v in pairs(Config.Shops.YouTool.Items) do
				if v.name == itemResult[i].name then
					table.insert(itemShopList, {
						type = "item_standard",
						name = itemInformation[itemResult[i].name].name,
						label = itemInformation[itemResult[i].name].label,
						weight = itemInformation[itemResult[i].name].weight,
						rare = itemInformation[itemResult[i].name].rare,
						can_remove = itemInformation[itemResult[i].name].can_remove,
						price = v.price,
						count = 99999999
					})
				end
			end
		end
		if shoptype == "policeshop" then
			for _, v in pairs(Config.Shops.PoliceShop.Items) do
				if v.name == itemResult[i].name then
					table.insert(itemShopList, {
						type = "item_standard",
						name = itemInformation[itemResult[i].name].name,
						label = itemInformation[itemResult[i].name].label,
						weight = itemInformation[itemResult[i].name].weight,
						rare = itemInformation[itemResult[i].name].rare,
						can_remove = itemInformation[itemResult[i].name].can_remove,
						price = v.price,
						count = 99999999
					})
				end
			end
		end
		if shoptype == "prison" then
			for _, v in pairs(Config.Shops.PrisonShop.Items) do
				if v.name == itemResult[i].name then
					if v.name == itemResult[i].name then
						table.insert(itemShopList, {
							type = "item_standard",
							name = itemInformation[itemResult[i].name].name,
							label = itemInformation[itemResult[i].name].label,
							weight = itemInformation[itemResult[i].name].weight,
							rare = itemInformation[itemResult[i].name].rare,
							can_remove = itemInformation[itemResult[i].name].can_remove,
							price = v.price,
							count = 99999999
						})
					end
				end
			end
		end
		if shoptype == "weaponshop" then
			for _, v in pairs(Config.Shops.WeaponShop.Items) do
				if v.name == itemResult[i].name then
					if v.name == itemResult[i].name then
						table.insert(itemShopList, {
							type = "item_standard",
							name = itemInformation[itemResult[i].name].name,
							label = itemInformation[itemResult[i].name].label,
							weight = itemInformation[itemResult[i].name].weight,
							rare = itemInformation[itemResult[i].name].rare,
							can_remove = itemInformation[itemResult[i].name].can_remove,
							price = v.price,
							count = 99999999
						})
					end
				end
			end
		end
	end
	cb(itemShopList)
end)

ESX.RegisterServerCallback("suku:getCustomShopItems", function(source, cb, shoptype, customInventory)
	itemShopList = {}
	local itemResult = MySQL.Sync.fetchAll('SELECT * FROM items')
	local itemInformation = {}
	for i=1, #itemResult, 1 do
		if itemInformation[itemResult[i].name] == nil then
			itemInformation[itemResult[i].name] = {}
		end
		itemInformation[itemResult[i].name].name = itemResult[i].name
		itemInformation[itemResult[i].name].label = itemResult[i].label
		itemInformation[itemResult[i].name].weight = itemResult[i].weight
		itemInformation[itemResult[i].name].rare = itemResult[i].rare
		itemInformation[itemResult[i].name].can_remove = itemResult[i].can_remove
		if shoptype == "normal" then
			for _, v in pairs(customInventory.Items) do
				if v.name == itemResult[i].name then
					table.insert(itemShopList, {
						type = "item_standard",
						name = itemInformation[itemResult[i].name].name,
						label = itemInformation[itemResult[i].name].label,
						weight = itemInformation[itemResult[i].name].weight,
						rare = itemInformation[itemResult[i].name].rare,
						can_remove = itemInformation[itemResult[i].name].can_remove,
						price = itemInformation[itemResult[i].name].price,
						count = 99999999
					})
				end
			end
		end
		

		if shoptype == "weapon" then
			local weapons = customInventory.Weapons
			for _, v in pairs(customInventory.Weapons) do
				if v.name == itemResult[i].name then
					table.insert(itemShopList, {
						type = "item_weapon",
						name = itemInformation[itemResult[i].name].name,
						label = itemInformation[itemResult[i].name].label,
						weight = 0,
						ammo = v.ammo,
						rare = itemInformation[itemResult[i].name].rare,
						can_remove = itemInformation[itemResult[i].name].can_remove,
						price = itemInformation[itemResult[i].name].price,
						count = 99999999
					})
				end
			end
			local ammo = customInventory.Ammo
			for _,v in pairs(customInventory.Ammo) do
				if v.name == itemResult[i].name then
					table.insert(itemShopList, {
						type = "item_ammo",
						name = itemInformation[itemResult[i].name].name,
						label = itemInformation[itemResult[i].name].label,
						weight = 0,
						weaponhash = v.weaponhash,
						ammo = v.ammo,
						rare = itemInformation[itemResult[i].name].rare,
						can_remove = itemInformation[itemResult[i].name].can_remove,
						price = itemInformation[itemResult[i].name].price,
						count = 99999999
					})
				end
			end

			for _, v in pairs(customInventory.Items) do
				if v.name == itemResult[i].name then
					table.insert(itemShopList, {
						type = "item_standard",
						name = itemInformation[itemResult[i].name].name,
						label = itemInformation[itemResult[i].name].label,
						weight = itemInformation[itemResult[i].name].weight,
						rare = itemInformation[itemResult[i].name].rare,
						can_remove = itemInformation[itemResult[i].name].can_remove,
						price = itemInformation[itemResult[i].name].price,
						count = 99999999
					})
				end
			end
		end
	end
	cb(itemShopList)
end)
RegisterNetEvent("suku:SellItemToPlayer")
AddEventHandler("suku:SellItemToPlayer",function(source, type, item, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if type == "item_standard" then
		local targetItem = xPlayer.getInventoryItem(item)
		--if xPlayer.canCarryItem(item, count) then
			local list = itemShopList
			for i = 1, #list, 1 do
				if list[i].name == item then
					local totalPrice = count * list[i].price
					----------------------------CRAFTING-------------------------------------------------------
					if item =='WEAPON_ASSAULTRIFLE' then
						local recipe1 = 'ak_blueprint'
						local recipe2 = 'metal'
						if xPlayer.job.name == 'police' then
							xPlayer.addInventoryItem('WEAPON_ASSAULTRIFLE', count)
						else
							if xPlayer.getInventoryItem(recipe1).count >= 1 and xPlayer.getInventoryItem(recipe2).count >= 10 then
								xPlayer.addInventoryItem('WEAPON_ASSAULTRIFLE', '1')
								xPlayer.addInventoryItem('disc_ammo_rifle_large', '1')
								xPlayer.removeInventoryItem(recipe1, '1')
								xPlayer.removeInventoryItem(recipe2, '10')
							else
								TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You Must Have The Following Items To Craft This Items 1.Ak Gun Blueprint 2.Metal'})
							end
						end
					elseif item == 'WEAPON_PUMPSHOTGUN' then
						local recipe3 = 'ak_blueprint'
						local recipe4 = 'metal'
						if xPlayer.job.name == 'police' then
							xPlayer.addInventoryItem('WEAPON_PUMPSHOTGUN', count)
						else
							if xPlayer.getInventoryItem(recipe3).count >= 1 and xPlayer.getInventoryItem(recipe4).count >= 10 then
								xPlayer.addInventoryItem('WEAPON_PUMPSHOTGUN', '1')
								xPlayer.addInventoryItem('disc_ammo_shotgun', '1')
								xPlayer.removeInventoryItem(recipe3, '1')
								xPlayer.removeInventoryItem(recipe4, '10')
							else
							TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You Must Have The Following Items To Craft This Items 1.Pumpshot Gun Blueprint 2.Metal'})
							end
						end
					else
					 if xPlayer.getMoney() >= totalPrice then
						xPlayer.removeMoney(totalPrice)
						xPlayer.addInventoryItem(item, count)
			
						TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'You bought '..count.." "..list[i].label })
					 else
						TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You dont have enough money!' })
					 end
				end
					end
			end
		
end
	if type == "item_weapon" then
		
		if xPlayer.canCarryItem(item, count) then
			local list = itemShopList
			for i = 1, #list, 1 do
				if list[i].name == item then
					local totalPrice = count * list[i].price
					if xPlayer.getMoney() >= totalPrice then
						xPlayer.removeMoney(totalPrice)
						xPlayer.addInventoryItem(item, count)
				--		TriggerEvent("tqrp_base:serverlog", "[BUYITEM]: ("..item .. ") x" .. count .. " $("..totalPrice..")", _source, GetCurrentResourceName())
						TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'You bought '..count.." "..list[i].label })
					else
						TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You dont have enough money!' })
					end
				end
			end
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Não consegues carregar mais nada no inventário!' })
		end
	end

	if type == "item_ammo" then
		local targetItem = xPlayer.getInventoryItem(item)
		local list = itemShopList
		for i = 1, #list, 1 do
			if list[i].name == item then
				local targetWeapon = xPlayer.hasWeapon(list[i].weaponhash)
				if targetWeapon then
					local totalPrice = count * list[i].price
					local ammo = count * list[i].ammo
					if xPlayer.getMoney() >= totalPrice then
						xPlayer.removeMoney(totalPrice)
						TriggerClientEvent("suku:AddAmmoToWeapon", source, list[i].weaponhash, ammo)
				--		TriggerEvent("tqrp_base:serverlog", "[BUYAMMO]: ("..list[i].weaponhash .. ") x" .. ammo .. " $("..totalPrice..")", _source, GetCurrentResourceName())
						TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'You bought '..count.." "..list[i].label })
					else
						TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You dont have enough money!' })
					end
				else
					TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You dont have the weapon for this type of ammunition! '})
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(10)
	MySQL.Async.fetchAll('SELECT * FROM items WHERE LCASE(name) LIKE \'%weapon_%\'', {}, function(results)
		for k, v in pairs(results) do
			ESX.RegisterUsableItem(v.name, function(source)
				TriggerClientEvent('gc-inventoryhud:useWeapon', source, v.name)
			end)
		end
	end)
end)

RegisterServerEvent('gc-inventoryhud:updateAmmoCount')
AddEventHandler('gc-inventoryhud:updateAmmoCount', function(hash, count)
	local player = ESX.GetPlayerFromId(source)
	MySQL.Async.execute('UPDATE disc_ammo SET count = @count WHERE hash = @hash AND owner = @owner', {
		['@owner'] = player.identifier,
		['@hash'] = hash,
		['@count'] = count
	}, function(results)
		if results == 0 then
			MySQL.Async.execute('INSERT INTO disc_ammo (owner, hash, count) VALUES (@owner, @hash, @count)', {
				['@owner'] = player.identifier,
				['@hash'] = hash,
				['@count'] = count
			})
		end
	end)
end)

ESX.RegisterServerCallback('gc-inventoryhud:getAmmoCount', function(source, cb, hash)
	local player = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM disc_ammo WHERE owner = @owner and hash = @hash', {
		['@owner'] = player.identifier,
		['@hash'] = hash
	}, function(results)
		if #results == 0 then
			cb(nil)
		else
			cb(results[1].count)
		end
	end)
end)

ESX.RegisterServerCallback('GetCharacterNameServer', function(source, dd, target) -- GR10
    local source = ESX.GetPlayerFromId(source)

    local result = MySQL.Sync.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", {
        ['@identifier'] = source.identifier
    })

    local firstname = result[1].firstname
    local lastname  = result[1].lastname

    ddd(''.. firstname .. ' ' .. lastname ..'')
end)


AddEventHandler('esx:playerLoaded', function (source)
    GetLicenses(source)
end)

function GetLicenses(source)
    TriggerEvent('esx_license:getLicenses', source, function (licenses)
        TriggerClientEvent('suku:GetLicenses', source, licenses)
    end)
end

RegisterServerEvent('suku:buyLicense')
AddEventHandler('suku:buyLicense', function ()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.get('money') >= Config.LicensePrice then
		xPlayer.removeMoney(Config.LicensePrice)
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'You registered a Fire Arms license.' })
		TriggerEvent('esx_license:addLicense', _source, 'weapon', function ()
			GetLicenses(_source)
		end)
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have enough money!' })
	end
end)
