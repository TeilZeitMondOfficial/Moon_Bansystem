local banList = {}
local servername = GetConvar("sv_hostname", "Unbekannter Server")

function loadBans()
    local file = LoadResourceFile(GetCurrentResourceName(), Config.BansJSONName)
    banList = json.decode(file) or {}
end

function saveBans()
    local file = json.encode(banList, {indent = true})
    SaveResourceFile(GetCurrentResourceName(), Config.BansJSONName, file, -1)
end

-- Überprüft, ob der Wert in der Tabelle enthalten ist
function has_value(tab, val)
    for _, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

local function isPlayerBanned(identifiers)
    for _, ban in ipairs(banList) do
        for _, bannedIdentifier in ipairs(ban.identifiers) do
            for _, identifier in ipairs(identifiers) do
                if bannedIdentifier == identifier then
                    return true
                end
            end
        end
    end
    return false
end

-- Ban Command

RegisterCommand(Config.BanSystemCommand, function(source, args, rawCommand)
    local player = source

    -- Überprüfen, ob der Spieler die erforderliche ACE-Berechtigung hat

    if not IsPlayerAceAllowed(player, Config.CommandPerm) then
        print("Sie haben nicht die erforderliche Berechtigung, um diesen Befehl auszuführen.")
        return
    end

    if not args[1] then
        print("Sie müssen eine Aktion (ban oder unban) angeben!")
        return
    end

    local action = args[1]:lower()

    -- Ban-Aktion
    if action == "ban" then
        local target = tonumber(args[2]) 
        local reason = args[3] or "Kein Grund angegeben"
        if not target then
            print("Sie müssen eine SpielerID angeben!")
            return
        end
        TriggerEvent(GetCurrentResourceName() .. ':ClientBanStart', target, player, reason)
    -- Unban-Aktion
    elseif action == "unban" then
        local banID = tonumber(args[2])
        if not banID then
            print("Sie müssen eine BanID angeben!")
            return
        end

        local wasUnbanned = false
        for i, ban in ipairs(banList) do
            if ban.banID == banID then
                table.remove(banList, i)
                saveBans()
                wasUnbanned = true
                print("Spieler mit BanID " .. banID .. " wurde entbannt!")
                break
            end
        end

        if not wasUnbanned then
            print("BanID " .. banID .. " nicht gefunden!")
        end
    else
        print("Ungültige Aktion! Verwenden Sie 'ban' oder 'unban'.")
    end
end, true)

-- BAN TRIGGER

RegisterNetEvent(GetCurrentResourceName() .. ':ServerBanNow')
AddEventHandler(GetCurrentResourceName() .. ':ServerBanNow', function(adminSource, screenshotUrl, reason)
    local banID = math.random(100000, 999999) 
    local identifiers = GetPlayerIdentifiers(source)

    if isPlayerBanned(identifiers) then         --
        return                                  --  Protection, so player will not get banned multiple times
    end                                         --
    
    local steamID, licenseID, discordID = "N/A", "N/A", "N/A"
    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamID = v
        elseif string.find(v, "license") then
            licenseID = v
        elseif string.find(v, "discord") then
            discordID = v
        end
    end

    table.insert(banList, {
        banID = banID,
        identifiers = identifiers,
        reason = reason,
        screenshot = screenshotUrl
    })

    saveBans()
    print('^0[^1' .. Config.BanSystemName .. '^0] | Player Banned Succesfully. ^1Name:' .. GetPlayerName(source) .. ' ^0Reason: ^1' .. reason .. " Ban ID : " .. banID)
    
    local banEmbed = {
        {
            ["color"] = "15548997",
            ["title"] = "Banned Cheater\n\n",
            ["description"] = "__**INFORMATIONS**:__\n\n"
            .."**Server Name :** " .. servername .. "\n\n"
            .."**Server ID:** " .. source .. "\n\n"
            .. "**Player:** " .. GetPlayerName(source) .. "\n\n"
            .."**Reason:** " .. reason .. "\n\n"
            .. "**Steam:** " .. steamID .. "\n"
            .. "**License:** " .. licenseID .. "\n"
            .. "**Discord:** " .. discordID .. "\n",
            ["image"] = {
                url = screenshotUrl
            },
            ["footer"] = {
                ["text"] = "Bansystem | by TeilZeitMond | " .. os.date("%x %X %p")
            },
        }
    }

    DropPlayer(source, "You have been banned. Reason: " .. reason .. ". If you believe this is a mistake, please contact our support team.\nBan ID : " .. banID)
    PerformHttpRequest(Config.BansWebhook, function(error, texto, cabeceras) end, "POST", json.encode({username = Config.BanSystemName, embeds = banEmbed}), {["Content-Type"] = "application/json"})
end)

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    local src = source
    local identifiers = GetPlayerIdentifiers(src) -- Holen Sie sich die Identifikatoren des Spielers
    deferrals.defer()
    Citizen.Wait(0)

    loadBans()
    
    local isBanned = false
    for _, ban in ipairs(banList) do
        for _, identifier in ipairs(identifiers) do
            if has_value(ban.identifiers, identifier) then
                isBanned = true
                -- PLAYER GETS BANSCREEN
                print('^0[^1' .. Config.BanSystemName .. '^0] | Player Tried to join while Banned. \n^1Name : ' ..GetPlayerName(src).. '\n^0Reason : ^1 ' ..ban.reason.. '\n^0BanID : ^1 ' .. ban.banID .. "^0")
                
                local banCard = {
                    type = "AdaptiveCard",
                    ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
                    version = "1.6",
                    body = {
                        {
                            type = "TextBlock",
                            text = "Spieler Gebannt!",
                            weight = "Bolder",
                            size = "Medium",
                            horizontalAlignment = "Left",
                            separator = true
                        },
                        {
                            type = "Container",
                            items = {
                                { type = "TextBlock", text = "Spieler :", weight = "Bolder", size = "Small" },
                                { type = "TextBlock", text = GetPlayerName(src), spacing = "Small" }
                            },
                            spacing = "Small",
                            style = "emphasis",
                            cornerRadius = "10"
                        },
                        {
                            type = "Container",
                            items = {
                                { type = "TextBlock", text = "Grund :", weight = "Bolder", size = "Small" },
                                { type = "TextBlock", text = ban.reason, spacing = "Small" }
                            },
                            spacing = "Small",
                            style = "emphasis",
                            cornerRadius = "10"
                        },
                        {
                            type = "Container",
                            items = {
                                { type = "TextBlock", text = "BAN ID :", weight = "Bolder", size = "Small" },
                                { type = "TextBlock", text = tostring(ban.banID), spacing = "Small" }
                            },
                            spacing = "Small",
                            style = "emphasis",
                            cornerRadius = "10"
                        },
                        {
                            type = "Image",
                            url = ban.screenshot,
                            horizontalAlignment = "Center",
                            size = "Stretch"
                        }
                    }
                }                              

                Citizen.Wait(200)
                deferrals.presentCard(banCard)
                return
            end
        end
    end

    if not isBanned then
        -- NOTHING HAPENS :D
        deferrals.done()
    end
end)


loadBans() 