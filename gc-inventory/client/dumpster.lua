RegisterNetEvent("monster_inventoryhud:opendumpsterInventory")
AddEventHandler(
    "monster_inventoryhud:opendumpsterInventory",
    function(data)
        setdumpsterInventoryData(data)
        opendumpsterInventory()
        loadPlayerInventory()
        loadPlayerInventory()
    end
)

function refreshdumpsterInventory()
    data = exports['gc-dumpster']:getMonsterdumpsterLicense()
    loadPlayerInventory()
    ESX.TriggerServerCallback(
        "monster_dumpster:getdumpsterInventory",
        function(inventory)
            setdumpsterInventoryData(inventory)
            loadPlayerInventory()
        end,
        data, true
    )
end

local dumpsterType

function setdumpsterInventoryData(inventory)
    items = {}

    SendNUIMessage(
        {
            action = "setInfoText",
            text = "DUMPSTER"
        }
    )

    local blackMoney = inventory.blackMoney
    local dumpsterItems = inventory.items
    local dumpsterWeapons = inventory.weapons
    dumpsterType = inventory.job

    if blackMoney > 0 then
        accountData = {
            label = _U("black_money"),
            count = blackMoney,
            type = "item_account",
            name = "black_money",
            usable = false,
            rare = false,
            limit = -1,
            canRemove = false
        }
        table.insert(items, accountData)
    end

    for i = 1, #dumpsterItems, 1 do
        local item = dumpsterItems[i]

        if item.count > 0 then
            item.type = "item_standard"
            item.usable = false
            item.rare = false
            item.limit = -1
            item.canRemove = false

            table.insert(items, item)
        end
    end

    for i = 1, #dumpsterWeapons, 1 do
        local weapon = dumpsterWeapons[i]

        if dumpsterWeapons[i].name ~= "WEAPON_UNARMED" then
            table.insert(
                items,
                {
                    label = ESX.GetWeaponLabel(weapon.name),
                    count = weapon.ammo or weapon.count,
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

function opendumpsterInventory()
    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "dumpster"
        }
    )

    SetNuiFocus(true, true)
    loadPlayerInventory()
end

RegisterNUICallback(
    "PutIntodumpster",
    function(data, cb)
        if IsPedSittingInAnyVehicle(playerPed) then
            return
        end

        if type(data.number) == "number" and math.floor(data.number) == data.number then
            local count = 0
            loadPlayerInventory()

            if data.item.type == "item_weapon" then
                count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
                loadPlayerInventory()
                TriggerServerEvent("monster_dumpster:putItem", --[[ESX.GetPlayerData().identifier,--]] dumpsterType, data.item.type, data.item.name, count)
                loadPlayerInventory()
            else
                if data.number > data.item.count or data.number == 0 then
                    count = tonumber(data.item.count)
                    loadPlayerInventory()
                else
                    count = tonumber(data.number)
                    loadPlayerInventory()
                end
                loadPlayerInventory()
                TriggerServerEvent("monster_dumpster:putItem", --[[ESX.GetPlayerData().identifier,--]] dumpsterType, data.item.type, data.item.name, count)
                loadPlayerInventory()
            end

            
        end
        loadPlayerInventory()
        --Wait(250)
        refreshdumpsterInventory()
        --Wait(250)
        loadPlayerInventory()

        cb("ok")
    end
)

RegisterNUICallback(
    "TakeFromdumpster",
    function(data, cb)
        if IsPedSittingInAnyVehicle(playerPed) then
            return
        end

        if type(data.number) == "number" and math.floor(data.number) == data.number then
            local count = 0
            if data.number > data.item.count or data.number == 0 then
                count = tonumber(data.item.count)
                loadPlayerInventory()
            else
                count = tonumber(data.number)
                loadPlayerInventory()
            end
            TriggerServerEvent("monster_dumpster:getItem", --[[ESX.GetPlayerData().identifier,--]] dumpsterType, data.item.type, data.item.name, count)
        end
        loadPlayerInventory()
        --Wait(250)
        refreshdumpsterInventory()
        --Wait(250)
        loadPlayerInventory()

        cb("ok")
    end
)
