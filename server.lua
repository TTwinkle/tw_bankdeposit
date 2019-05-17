---------------------------------------------------------------------
--                   tw_bankdeposit by Twinkle                     --
--                     Discord: Twinkle#0110                       --
--     This script was based on esx_bankdeposit by FrostyLucas     --
--            Don't Change the name and don't reupload.            --
--                 https://forum.fivem.net/u/il_creon              --
---------------------------------------------------------------------

ESX = nil
Cache = {}

TriggerEvent("esx:getSharedObject", function(library)
    ESX = library
end)

function RegisterEvent(event, func)
    RegisterServerEvent(event)
    AddEventHandler(event, func)
end

print("\n---------------------------------------------------------------------")
print("\n--                   tw_bankdeposit by Twinkle                     --")
print("\n--                     Discord: Twinkle#0110                       --")
print("\n--     This script was based on esx_bankdeposit by FrostyLucas     --")
print("\n--                 https://forum.fivem.net/u/il_creon              --")
print("\n---------------------------------------------------------------------")


MySQL.ready(function()
    MySQL.Async.fetchAll("SELECT * FROM tw_bankdeposit", {}, function(response)
        if response == nil then return end

        for i = 1, #response do
            local bankdeposit = response[i]

            Cache[bankdeposit["identifier"]] = bankdeposit["content"]
        end
    end)
end)

ESX.RegisterServerCallback("Bank.Deposit.Purchase", function(source, callback, cost)
    local player = ESX.GetPlayerFromId(source)

    if player == nil then return end

    if Cache[player.getIdentifier()] ~= nil then
        callback(2)

        return
    end

    local bankaccount = player.getAccount("bank")

    if bankaccount.money >= cost then
        player.removeAccountMoney("bank", cost)

        MySQL.Async.execute("INSERT INTO tw_bankdeposit (identifier, content) VALUES (@identifier, @content)", {
            ["@identifier"] = player.getIdentifier(),
            ["@content"] = "{}"
        })

        Cache[player.getIdentifier()] = "{}"

        callback(0)
    else
        callback(1)
    end
end)

ESX.RegisterServerCallback("Bank.Deposit.FetchCache", function(source, callback)
    local player = ESX.GetPlayerFromId(source)

    if player == nil then return end

    if Cache[player.getIdentifier()] == nil then
        callback(nil)
    else
        callback(json.decode(Cache[player.getIdentifier()]))
    end
end)

ESX.RegisterServerCallback("Bank.Deposit.RemoveItem", function(source, callback, item, amount)
    local player = ESX.GetPlayerFromId(source)

    if player == nil then return end

    if player.getInventoryItem(item).count >= amount then
        callback(0)

        player.removeInventoryItem(item, amount)
    else
        callback(1)
    end
end)

ESX.RegisterServerCallback("Bank.Deposit.FetchInventory", function(source, callback)
    local player = ESX.GetPlayerFromId(source)

    if player == nil then return end

    callback(player.getInventory())
end)

RegisterEvent("Bank.Deposit.AddItem", function(source, item, amount)
    local player = ESX.GetPlayerFromId(source)

    if player == nil then return end

    player.addInventoryItem(item, amount)
end)

RegisterEvent("Bank.Deposit.UpdateCache", function(source, cache)
    local player = ESX.GetPlayerFromId(source)

    if player == nil then return end

    MySQL.Async.execute("UPDATE tw_bankdeposit SET content = @content WHERE identifier = @identifier", {
        ["@identifier"] = player.getIdentifier(),
        ["@content"] = cache
    })
end)
