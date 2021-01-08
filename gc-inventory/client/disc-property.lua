local propertyData
local propertyName

RegisterNetEvent("esx_inventoryhud:openDiscPropertyInventory")
AddEventHandler(
        "esx_inventoryhud:openDiscPropertyInventory",
        function(data)
            propertyName = data.inventory_name
            setPropertyInventoryData(data)
            openPropertyInventory()
        end
)

RegisterNetEvent("esx_inventoryhud:refreshDiscPropertyInventory")
AddEventHandler("esx_inventoryhud:refreshDiscPropertyInventory", function()
    refreshPropertyInventory()
    loadPlayerInventory()
end)

function refreshPropertyInventory()
    ESX.TriggerServerCallback(
            "disc-property:getPropertyInventoryFor",
            function(data)
                setPropertyInventoryData(data)
            end,
            propertyName
    )
end

function setPropertyInventoryData(data)
    propertyData = data
    items = {}

    local accounts = data.item_account or {}
    local moneys = data.item_money or {}
    local propertyItems = data.item_standard or {}
    local propertyWeapons = data.item_weapon or {}

    for i = 1, #accounts, 1 do
        local account = accounts[i]
        accountData = {
            label = _U(account.name),
            count = account.count,
            type = "item_account",
            name = account.name,
            usable = false,
            rare = false,
            limit = -1,
            canRemove = false
        }
        table.insert(items, accountData)
    end

    for i = 1, #moneys, 1 do
        local money = moneys[i]
        accountData = {
            label = _U(money.name),
            count = money.count,
            type = "item_money",
            name = money.name,
            usable = false,
            rare = false,
            limit = -1,
            canRemove = false
        }
        table.insert(items, accountData)
    end

    for i = 1, #propertyItems, 1 do
        local item = propertyItems[i]

        if item.count > 0 then
            item.label = item.name
            item.type = "item_standard"
            item.usable = false
            item.rare = false
            item.limit = -1
            item.canRemove = false

            table.insert(items, item)
        end
    end

    for i = 1, #propertyWeapons, 1 do
        local weapon = propertyWeapons[i]

        if propertyWeapons[i].name ~= "WEAPON_UNARMED" then
            table.insert(
                    items,
                    {
                        label = ESX.GetWeaponLabel(weapon.name),
                        count = weapon.count,
                        limit = -1,
                        type = "item_weapon",
                        name = weapon.name,
                        usable = false,
                        rare = false,
                        canRemove = false
                    }
            )
        end
    end

    SendNUIMessage(
            {
                action = "setSecondInventoryItems",
                itemList = items
            }
    )
end

function openPropertyInventory()
    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
            {
                action = "display",
                type = "disc-property"
            }
    )

    SetNuiFocus(true, true)
end

RegisterNUICallback(
        "PutIntoDiscProperty",
        function(data, cb)
            if type(data.number) == "number" and math.floor(data.number) == data.number then
                local count = tonumber(data.number)

                if data.item.type == "item_weapon" then
                    count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
                end

                TriggerServerEvent("disc-property:putItemInPropertyFor", propertyName, data.item, count)
            end
            cb("ok")
        end
)

RegisterNUICallback(
        "TakeFromDiscProperty",
        function(data, cb)
            if type(data.number) == "number" and math.floor(data.number) == data.number then
                local count = tonumber(data.number)

                if data.item.type == "item_weapon" then
                    count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
                end

                TriggerServerEvent("disc-property:takeItemFromProperty", propertyName, data.item, count)
            end
            cb("ok")
        end
)
