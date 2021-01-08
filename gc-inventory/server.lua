ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
ESX.RegisterServerCallback('dura:getdura', function(source, cb, itemName)
    local player = ESX.GetPlayerFromId(source)
    local durability = MySQL.Sync.fetchScalar("SELECT durability FROM user_inventory WHERE identifier = @identifier AND item = @item", 
		{
			['@identifier'] 	= identifier,
			['@item']			= itemName
    
    }, function(results)
        if #results == 0 then
            cb(nil)
        else
            cb(results[1].durability)
        end
    end)
end)
RegisterServerEvent('esx_durability:update')
AddEventHandler('esx_durability:update', function(itemName)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local identifier = GetPlayerIdentifiers(source)[1]
		local durability = MySQL.Sync.fetchScalar("SELECT durability FROM user_inventory WHERE identifier = @identifier AND item = @item", 
		{
			['@identifier'] 	= identifier,
			['@item']			= itemName
		})
		if durability > 1 then
			MySQL.Async.execute("UPDATE user_inventory SET durability = @durability WHERE identifier = @identifier AND item = @item",
			{
				['@identifier']		= identifier,
				['@item']			= itemName,
				['@durability']		= durability - 1
			})
			print("the durability of the item :" .. itemName .. " for the player :" .. identifier .. "has been lowered by 1")
			print("")
			print("the oldest durability is " .. durability)
			print("the new durability is " .. durability - 1)
			
		elseif durability == 1 then
			print("Player :" .. identifier .. " - the durability of the item :" .. itemName .. " was at 0 and was been removed")
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 	   'The object was broken!'})
			MySQL.Async.execute("UPDATE user_inventory SET durability = @durability, count = @count WHERE identifier = @identifier AND item = @item",
			{
				['@identifier']		= identifier,
				['@item']			= itemName,
				['@durability']		= 0,
				['@count']			= 0
			})
				xPlayer.removeInventoryItem(itemName, 1)
		elseif durability == 0 then
			MySQL.Async.execute("UPDATE user_inventory SET durability = @durability WHERE identifier = @identifier AND item = @item",
			{
				['@identifier']		= identifier,
				['@item']			= itemName,
				['@durability']		= 4
			})
			print("default durability setted for item : " .. itemName .. " of player :"  .. identifier)
			print("the new durability is " .. 4)
		end
end)
ESX.RegisterServerCallback("np-durability",function(itemName, cb, quality)
	local result = MySQL.Sync.fetchAll("SELECT * FROM user_inventory WHERE identifier = @identifier", {['@identifier'] = identifier})
    if result[1] ~= nil then
        local take = result[1]

        return {
            durability = take['durability'],
            item = take['item'],
        }
    else
        return nil
    end
end)