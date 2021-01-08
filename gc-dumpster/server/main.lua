ESX = nil
--local pagal = false
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
--[[TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..'mechanic', function(inventory)
	local inventoryItem = inventory.getItem(item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local luck = math.random(1,3)
	if luck == 1 then
		inventory.removeItem('metal', math.random(2,5))
	elseif luck == 2 then
		inventory.removeItem('copper', math.random(2,5))
	else
		inventory.removeItem('bread', math.random(2,5))
	end
end)]]
RegisterServerEvent('monster_dumpster:getItem')
AddEventHandler('monster_dumpster:getItem', function(--[[owner,--]] job, type, item, count)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)
	local xPlayerOwner = ESX.GetPlayerFromIdentifier(xPlayer.identifier)
	local luck = math.random(1,2)

	if type == 'item_standard' then

		local sourceItem = xPlayer.getInventoryItem(item)
	
		--if pagal == false then
			TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..'mechanic', function(inventory)
				local inventoryItem = inventory.getItem(item)
				local xPlayer = ESX.GetPlayerFromId(source)
				if count > 0 and inventoryItem.count >= count then
					if sourceItem.limit ~= nil and (sourceItem.count + count) > sourceItem.limit then
						--print('notify: player cannot hold')
						TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = 'error', text = _U('player_cannot_hold'), length = 5500})
					
					else
						inventory.removeItem(item, count)
						xPlayer.addInventoryItem(item, count)
						TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = 'success', text = _U('have_withdrawn', count, inventoryItem.label), length = 7500})
					end
				else
					--print('not enough in dumpster')
					TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = 'error', text = _U('not_enough_in_dumpster'), length = 5500})
				end
			end)
		--else
		--	TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = 'error', text = 'You Are Not Able To Find The Item Come Back Later', length = 5500})
		--end
		

	elseif type == 'item_account' then
		if xPlayer.job.name == job then
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..job..'_'..item, function(account)
				local policeAccountMoney = account.money

				if policeAccountMoney >= count then
					account.removeMoney(count)
					xPlayer.addAccountMoney(item, count)
				else
					TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = 'error', text = _U('amount_invalid'), length = 5500})
				end
			end)
		elseif job == 'dumpster' then
			TriggerEvent('esx_addonaccount:getAccount', 'dumpster_' .. item, xPlayerOwner.identifier, function(account)
				local roomAccountMoney = account.money
	
				if roomAccountMoney >= count then
					account.removeMoney(count)
					xPlayer.addAccountMoney(item, count)
				else
					TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = 'error', text = _U('amount_invalid'), length = 5500})
				end
			end)
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = 'error', text = "You not have permission", length = 5500})
		end
	elseif type == 'item_weapon' then
		if xPlayer.job.name == job then
			TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..job, function(store)
				local storeWeapons = store.get('weapons') or {}
				local weaponName   = nil
				local ammo         = nil
	
				for i=1, #storeWeapons, 1 do
					if storeWeapons[i].name == item then
						weaponName = storeWeapons[i].name
						ammo       = storeWeapons[i].ammo
	
						table.remove(storeWeapons, i)
						break
					end
				end
	
				store.set('weapons', storeWeapons)
				xPlayer.addWeapon(weaponName, ammo)
			end)
		elseif job == 'dumpster' then
			TriggerEvent('esx_datastore:getDataStore', 'dumpster', xPlayerOwner.identifier, function(store)
				local storeWeapons = store.get('weapons') or {}
				local weaponName   = nil
				local ammo         = nil
	
				for i=1, #storeWeapons, 1 do
					if storeWeapons[i].name == item then
						weaponName = storeWeapons[i].name
						ammo       = storeWeapons[i].ammo
	
						table.remove(storeWeapons, i)
						break
					end
				end
	
				store.set('weapons', storeWeapons)
				xPlayer.addWeapon(weaponName, ammo)
			end)
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = 'error', text = 'You not have permission', length = 5500})
		end
	end

end)

RegisterServerEvent('monster_dumpster:putItem')
AddEventHandler('monster_dumpster:putItem', function(--[[owner,--]] job, type, item, count)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)
	local xPlayerOwner = ESX.GetPlayerFromIdentifier(xPlayer.identifier)

	if type == 'item_standard' then

		local playerItemCount = xPlayer.getInventoryItem(item).count

		if playerItemCount >= count and count > 0 then
			--if xPlayer.job.name == job then
				TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..'mechanic', function(inventory)
					xPlayer.removeInventoryItem(item, count)
					inventory.addItem(item, count)
					TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = 'success', text = _U('have_deposited', count, inventory.getItem(item).label), length = 7500})
				end)
				-- --print("monster_dumpster:putItem")
			
			--end
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = "error", text = _U('invalid_quantity'), length = 5500})
		end

	elseif type == 'item_account' then

		local playerAccountMoney = xPlayer.getAccount(item).money

		if playerAccountMoney >= count and count > 0 then
			xPlayer.removeAccountMoney(item, count)
			--if xPlayer.job.name == job and job == 'mechanic' then
				
			--elseif job == 'dumpster' then
			--	TriggerEvent('esx_addonaccount:getAccount', 'dumpster_' .. item, xPlayerOwner.identifier, function(account)
			--		account.addMoney(count)
			--	end)
			--else
			--	xPlayer.addAccountMoney(item, count)
			--	TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = 'error', text = 'This job not allow for black money', length = 5500})
			--end
			
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = 'error', text = _U('amount_invalid'), length = 5500})
		end

	elseif type == 'item_weapon' then
		if xPlayer.job.name == job then
			TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..job, function(store)
				local storeWeapons = store.get('weapons') or {}
	
				table.insert(storeWeapons, {
					name = item,
					count = count
				})
	
				xPlayer.removeWeapon(item)
				store.set('weapons', storeWeapons)
				
			end)
		elseif job == 'dumpster' then
			TriggerEvent('esx_datastore:getDataStore', 'dumpster', xPlayerOwner.identifier, function(store)
				local storeWeapons = store.get('weapons') or {}
	
				table.insert(storeWeapons, {
					name = item,
					ammo = count
				})
	
				xPlayer.removeWeapon(item)
				store.set('weapons', storeWeapons)
				
			end)
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = 'error', text = 'You not have permission', length = 5500})
		end
	end

end)

ESX.RegisterServerCallback('monster_dumpster:getdumpsterInventory', function(source, cb, item, refresh)
	-- local xPlayer    = ESX.GetPlayerFromIdentifier(owner)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem
	if item.needItemLicense ~= '' or item.needItemLicense ~= nil then
		xItem = xPlayer.getInventoryItem(item.needItemLicense)
	else
		xItem = nil
	end
	local refresh = refresh or false

	local blackMoney = 0
	local items      = {}
	local weapons    = {}

	if not refresh and (item.needItemLicense ~= '' or item.needItemLicense ~= nil) and xItem ~= nil and xItem.count < 1 then
		-- if xItem.count < 1 then
		cb(false)
		-- end
		-- return
	elseif not item.InfiniteLicense and not refresh and xItem ~= nil and xItem.count > 0 then
		-- if not item.InfiniteLicense then
			xPlayer.removeInventoryItem(item.needItemLicense, 1)
		-- end
	end

	-- if item.job == xPlayer.job.name then
	-- 	--print('u job: '..xPlayer.job.name)
	-- end

	local typedumpster = ''
	local society = false
	if string.find(item.job, "dumpster") then
		typedumpster = item.job
	else
		typedumpster = "society_"..item.job
		society = true
	end
	--print("dumpster: "..typedumpster)

	if society then
		if item.job == 'mechanic' then
			
		else
			blackMoney = 0
		end
		TriggerEvent('esx_addoninventory:getSharedInventory', typedumpster, function(inventory)
			items = inventory.items
		end)
		TriggerEvent('esx_datastore:getSharedDataStore', typedumpster, function(store)
			
		end)
		cb({
			blackMoney = blackMoney,
			items      = items,
			weapons    = weapons,
			job = item.job
		})
	else
		TriggerEvent('esx_addonaccount:getAccount', typedumpster..'_black_money', xPlayer.identifier, function(account)
			blackMoney = account.money
		end)

		TriggerEvent('esx_addoninventory:getInventory', typedumpster, xPlayer.identifier, function(inventory)
			items = inventory.items
		end)

		TriggerEvent('esx_datastore:getDataStore', typedumpster, xPlayer.identifier, function(store)
			weapons = store.get('weapons') or {}
		end)

		cb({
			blackMoney = blackMoney,
			items      = items,
			weapons    = weapons,
			job = item.job
		})
	end
end)
