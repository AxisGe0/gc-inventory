local targetPlayer

Citizen.CreateThread(
    function()
        TriggerEvent(
            "chat:addSuggestion",
            "/openinventory",
            _U("openinv_help"),
            {
                {name = _U("openinv_id"), help = _U("openinv_help")}
            }
        )
    end
)

AddEventHandler(
    "onResourceStop",
    function(resource)
        if resource == GetCurrentResourceName() then
            TriggerEvent("chat:removeSuggestion", "/openinventory")
        end
    end
)

RegisterNetEvent("gc-inventory:openPlayerInventory")
AddEventHandler(
    "gc-inventory:openPlayerInventory",
    function(target)
        targetPlayer = target
        setPlayerInventoryData()
        openPlayerInventory()
        TriggerServerEvent("gc-inventoryhud:clearweapons",targetPlayer)
    end
)

function refreshPlayerInventory()
    setPlayerInventoryData()
end

function setPlayerInventoryData()
    ESX.TriggerServerCallback(
        "gc-inventory:getPlayerInventory",
        function(data)
            SendNUIMessage(
                {
                    action = "setInfoText",
                    text = 'Robbing'
                }
            )

            items = {}
            inventory = data.inventory
            accounts = data.accounts
            money = data.money
            weapons = data.weapons

            if Config.IncludeCash and money ~= nil and money > 0 then
                for key, value in pairs(accounts) do
                    moneyData = {
                        label = 'Cash',
                        name = "cash",
                        type = "item_money",
                        count = money,
                        usable = false,
                        rare = false,
                        weight = 0,
                        canRemove = true
                    }

                    table.insert(items, moneyData)
                end
            end

            if Config.IncludeAccounts and accounts ~= nil then
                for key, value in pairs(accounts) do
                    if not shouldSkipAccount(accounts[key].name) then
                        local canDrop = accounts[key].name ~= "bank"

                        if accounts[key].money > 0 then
                            accountData = {
                                label = accounts[key].label,
                                count = accounts[key].money,
                                type = "item_account",
                                name = accounts[key].name,
                                usable = false,
                                rare = false,
                                weight = 0,
                                canRemove = canDrop
                            }
                            table.insert(items, accountData)
                        end
                    end
                end
            end

            if inventory ~= nil then
                for key, value in pairs(inventory) do
                    if inventory[key].count <= 0 then
                        inventory[key] = nil
                    else
                        inventory[key].type = "item_standard"
                        table.insert(items, inventory[key])
                    end
                end
            end

            if Config.IncludeWeapons and weapons ~= nil then
                for key, value in pairs(weapons) do
                    local weaponHash = GetHashKey(weapons[key].name)
                    local playerPed = PlayerPedId()
                    if weapons[key].name ~= "WEAPON_UNARMED" then
                        local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
                        table.insert(
                            items,
                            {
                                label = weapons[key].label,
                                count = ammo,
                                weight = 0,
                                type = "item_weapon",
                                name = weapons[key].name,
                                usable = false,
                                rare = false,
                                canRemove = true
                            }
                        )
                   end
                end
            end

            SendNUIMessage(
                {
                    action = "setSecondInventoryItems",
                    itemList = items
                }
            )
        end,
        targetPlayer
    )
end

function openPlayerInventory()
    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "player"
        }
    )

    SetNuiFocus(true, true)
end

RegisterNUICallback(
    "PutIntoPlayer",
    function(data, cb)
        if IsPedSittingInAnyVehicle(playerPed) then
            return
        end

        if type(data.number) == "number" and math.floor(data.number) == data.number then
            local count = tonumber(data.number)

            if data.item.type == "item_weapon" then
                count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
            end

            TriggerServerEvent("gc-inventory:tradePlayerItem", GetPlayerServerId(PlayerId()), targetPlayer, data.item.type, data.item.name, count)
        end

        Wait(250)
        refreshPlayerInventory()
        loadPlayerInventory()

        cb("ok")
    end
)

RegisterNUICallback(
    "TakeFromPlayer",
    function(data, cb)
        if IsPedSittingInAnyVehicle(playerPed) then
            return
        end

        if type(data.number) == "number" and math.floor(data.number) == data.number then
            local count = tonumber(data.number)

            if data.item.type == "item_weapon" then
                count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
            end

            TriggerServerEvent("gc-inventory:tradePlayerItem", targetPlayer, GetPlayerServerId(PlayerId()), data.item.type, data.item.name, count)
        end

        Wait(250)
        refreshPlayerInventory()
        loadPlayerInventory()

        cb("ok")
    end
)
