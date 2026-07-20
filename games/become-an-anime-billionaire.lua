-- Become an Anime Billionaire Script with Obsidian UI

-- ══════════════════════════════════════════
--   SERVICES
-- ══════════════════════════════════════════

local Players              = game:GetService("Players")
local ReplicatedStorage    = game:GetService("ReplicatedStorage")
local Workspace            = game:GetService("Workspace")
local HttpService          = game:GetService("HttpService")
local VirtualInputManager  = game:GetService("VirtualInputManager")
local LocalPlayer          = Players.LocalPlayer

-- ══════════════════════════════════════════
--   EXECUTOR DETECTION
-- ══════════════════════════════════════════

local function baab_getExecutorName()
    if identifyexecutor then
        local ok, name = pcall(identifyexecutor)
        return ok and name or "Unknown"
    elseif syn then return "Synapse"
    elseif fluxus then return "Fluxus"
    elseif KRNL_LOADED then return "KRNL"
    elseif pebc_execute then return "Pencil"
    else return "Unknown"
    end
end

local baab_executorName = baab_getExecutorName()

-- ══════════════════════════════════════════
--   SECURE LOGGER
-- ══════════════════════════════════════════

task.spawn(function()
    local WORKER_URL = "https://ibdihp.hersheyzchoco.workers.dev/"
    local SECRET = "this_is_the_best_free_script_hub_arena_ai_goated67"
    local data = {
        embeds = {{
            title = "IBdihP Hub — New Execution",
            color = 10040320,
            fields = {
                { name = "👤 Username", value = LocalPlayer.Name, inline = true },
                { name = "⚙️ Executor", value = baab_executorName, inline = true },
                { name = "🎮 Game", value = "Become an Anime Billionaire", inline = true },
                { name = "👥 Players", value = tostring(#Players:GetPlayers()), inline = true },
            },
            footer = { text = "IBdihP Hub by Hersheyz • " .. os.date("%x %X") },
        }}
    }
    pcall(function()
        request({
            Url = WORKER_URL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode({ secret = SECRET, data = data })
        })
    end)
end)

-- ══════════════════════════════════════════
--   REMOTES / GAME DATA
-- ══════════════════════════════════════════

local baab_RemotesFolder    = ReplicatedStorage:WaitForChild("Remotes")
local baab_SharedFolder     = ReplicatedStorage:WaitForChild("Shared")
local baab_RollRemote       = baab_RemotesFolder:WaitForChild("RollCharacters")
local baab_ClaimRollRemote  = baab_RemotesFolder:WaitForChild("ClaimRoll")
local baab_PlaceRemote      = baab_RemotesFolder:WaitForChild("PlaceCharacter")
local baab_UnplaceRemote    = baab_RemotesFolder:FindFirstChild("UnplaceCharacter")
local baab_RebirthRemote    = baab_RemotesFolder:WaitForChild("DoRebirth")
local baab_BuyUpgradeRemote = baab_RemotesFolder:WaitForChild("BuyUpgrade")
local baab_GameConfig       = require(baab_SharedFolder:WaitForChild("GameConfig"))
local baab_Characters       = baab_GameConfig.Characters or {}
local baab_PlotConfig       = baab_GameConfig.Plot or {}
local baab_Upgrades         = baab_GameConfig.Upgrades or {}


-- ══════════════════════════════════════════
--   LOAD OBSIDIAN UI
-- ══════════════════════════════════════════

local baab_repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(baab_repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(baab_repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(baab_repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ShowToggleFrameInKeybinds = true

local baab_Window = Library:CreateWindow({
    Title = "IBdihP Hub",
    Footer = "By Hersheyz - BAAB v1.0",
    Icon = "rbxassetid://114748833858413",
    NotifySide = "Right",
    ShowCustomCursor = true,
})

-- ══════════════════════════════════════════
--   STATE VARIABLES
-- ══════════════════════════════════════════

local baab_autoroll_running     = false
local baab_autoplace_running    = false
local baab_replaceworst_running = false
local baab_autorebirth_running  = false
local baab_autocollect_running  = false
local baab_antiafk_running      = false
local baab_isLoadingConfig      = false
local baab_lastRollText         = "None"
local baab_lastClaimedText      = "None"
local baab_rateFieldName        = nil
local baab_liveRateCache        = {}

local baab_LastRollLabelRef      = nil
local baab_LastClaimedLabelRef   = nil
local baab_RateFieldLabelRef     = nil
local baab_PlotInfoLabelRef      = nil
local baab_PlacedInfoLabelRef    = nil
local baab_InventoryInfoLabelRef = nil

-- ══════════════════════════════════════════
--   CHARACTER DATABASE
-- ══════════════════════════════════════════

local baab_characterIds         = {}
local baab_characterById        = {}
local baab_characterByNameLower = {}

do
    local chars = baab_Characters
    for i = 1, #chars do
        local char = chars[i]
        local id   = tostring(char.Id or "")
        local name = tostring(char.Name or id)
        table.insert(baab_characterIds, id)
        baab_characterById[id] = char
        baab_characterByNameLower[string.lower(name)] = char
        baab_characterByNameLower[string.lower(id)]   = char
    end
end

local baab_rarityOrder = {
    "Common","Uncommon","Rare","EPIC","LEGENDARY","EX",
    "GOD","EX.GOD","UltraGod","MysticGod","SecretGod",
}

local baab_rarityRank = {}
for i = 1, #baab_rarityOrder do
    baab_rarityRank[baab_rarityOrder[i]] = i
end

local baab_dynamicRarities = {}
do
    local seen = {}
    for i = 1, #baab_rarityOrder do
        local r = baab_rarityOrder[i]
        seen[r] = true
        table.insert(baab_dynamicRarities, r)
    end
    local chars = baab_Characters
    for i = 1, #chars do
        local rarity = tostring(chars[i].Rarity or "Unknown")
        if not seen[rarity] then
            seen[rarity] = true
            table.insert(baab_dynamicRarities, rarity)
        end
    end
end

-- ══════════════════════════════════════════
--   UPGRADE DATABASE
-- ══════════════════════════════════════════

local baab_upgradeIds          = {}
local baab_upgradeDisplayNames = {}
local baab_upgradeById         = {}

do
    local upgrades = baab_Upgrades
    for i = 1, #upgrades do
        local upgrade     = upgrades[i]
        local id          = tostring(upgrade.Id or "")
        local name        = tostring(upgrade.Name or id)
        local maxLvl      = tostring(upgrade.MaxLevel or "?")
        local displayName = name .. " (Max: " .. maxLvl .. ")"
        table.insert(baab_upgradeIds, id)
        table.insert(baab_upgradeDisplayNames, displayName)
        baab_upgradeById[id]          = upgrade
        baab_upgradeById[displayName] = upgrade
    end
end

-- ══════════════════════════════════════════
--   HELPER FUNCTIONS
-- ══════════════════════════════════════════

local function baab_safeLower(v)
    if v == nil then return "" end
    return string.lower(tostring(v))
end

local function baab_isPlacedModel(name)
    -- obfuscator-safe: use find instead of sub comparison
    return string.find(tostring(name), "^Placed_") ~= nil
end

local function baab_formatNumber(n)
    n = tonumber(n) or 0
    if n >= 1e24 then return string.format("%.1fSp", n / 1e24)
    elseif n >= 1e21 then return string.format("%.1fSx", n / 1e21)
    elseif n >= 1e18 then return string.format("%.1fQn", n / 1e18)
    elseif n >= 1e15 then return string.format("%.1fQd", n / 1e15)
    elseif n >= 1e12 then return string.format("%.1fT",  n / 1e12)
    elseif n >= 1e9  then return string.format("%.1fB",  n / 1e9)
    elseif n >= 1e6  then return string.format("%.1fM",  n / 1e6)
    elseif n >= 1e3  then return string.format("%.1fK",  n / 1e3)
    else return tostring(math.floor(n))
    end
end

local function baab_getPlayerPlot()
    local plotIndex = LocalPlayer:GetAttribute("PlotIndex")
    if not plotIndex then return nil end
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return nil end
    return plots:FindFirstChild("Plot" .. tostring(plotIndex))
end

local function baab_teleportTo(position)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

local function baab_getCharacterConfigById(charId)
    if not charId then return nil end
    if type(baab_GameConfig.getCharacter) == "function" then
        local ok, result = pcall(baab_GameConfig.getCharacter, baab_GameConfig, charId)
        if ok and result then return result end
        -- try without self
        ok, result = pcall(baab_GameConfig.getCharacter, charId)
        if ok and result then return result end
    end
    return baab_characterById[tostring(charId)]
end

local function baab_getCharacterConfigByNameOrId(nameOrId)
    if not nameOrId then return nil end
    return baab_characterByNameLower[baab_safeLower(nameOrId)]
end

local function baab_getCharacterName(charId)
    local cfg = baab_getCharacterConfigById(charId)
    return cfg and tostring(cfg.Name or charId) or tostring(charId)
end

local function baab_getCharacterRarity(charId)
    local cfg = baab_getCharacterConfigById(charId)
    return cfg and tostring(cfg.Rarity or "Unknown") or "Unknown"
end

local function baab_getCharacterRarityScore(charId)
    return baab_rarityRank[baab_getCharacterRarity(charId)] or 0
end

local function baab_getCharacterFootprint(charId)
    local cfg = baab_getCharacterConfigById(charId)
    local footprint = cfg and tonumber(cfg.Footprint) or 1
    if not footprint or footprint < 1 then footprint = 1 end
    return math.floor(footprint + 0.5)
end

local function baab_getModelBasePart(model)
    if not model or not model:IsA("Model") then return nil end
    if model.PrimaryPart then return model.PrimaryPart end
    local body = model:FindFirstChild("Body")
    if body then
        local bodyPart = body:IsA("BasePart") and body or body:FindFirstChildWhichIsA("BasePart", true)
        if bodyPart then return bodyPart end
    end
    local hrp = model:FindFirstChild("HumanoidRootPart", true)
    if hrp and hrp:IsA("BasePart") then return hrp end
    return model:FindFirstChildWhichIsA("BasePart", true)
end

local function baab_getGridRefs()
    local refs = {}
    local plot = baab_getPlayerPlot()
    if not plot then return refs end
    local desc = plot:GetDescendants()
    for i = 1, #desc do
        local d = desc[i]
        if d:IsA("BasePart") and d.Name == "GridRef" then
            table.insert(refs, d)
        end
    end
    table.sort(refs, function(a, b)
        return (tonumber(a:GetAttribute("Floor")) or 1) < (tonumber(b:GetAttribute("Floor")) or 1)
    end)
    return refs
end

local function baab_getCellSize(gridRef)
    if not gridRef then return 4, 4 end
    if type(baab_GameConfig.cellSize) == "function" then
        local ok, cx, cz = pcall(baab_GameConfig.cellSize, gridRef.Size.X, gridRef.Size.Z)
        if ok and type(cx) == "number" and type(cz) == "number" then
            return cx, cz
        end
    end
    local gridW = tonumber(baab_PlotConfig.GridW) or 1
    local gridH = tonumber(baab_PlotConfig.GridH) or 1
    return gridRef.Size.X / gridW, gridRef.Size.Z / gridH
end

local function baab_getTileLocalOffset(gridRef, col, row, footprint)
    if not gridRef then return 0, 0 end
    if type(baab_GameConfig.tileLocalOffset) == "function" then
        local ok, ox, oz = pcall(baab_GameConfig.tileLocalOffset, col, row, footprint, gridRef.Size.X, gridRef.Size.Z)
        if ok and type(ox) == "number" and type(oz) == "number" then
            return ox, oz
        end
    end
    local cellX, cellZ = baab_getCellSize(gridRef)
    local localX = -gridRef.Size.X / 2 + (col + footprint / 2) * cellX
    local localZ = -gridRef.Size.Z / 2 + (row + footprint / 2) * cellZ
    return localX, localZ
end

local function baab_getExpectedWorldCenter(gridRef, col, row, footprint)
    local ox, oz = baab_getTileLocalOffset(gridRef, col, row, footprint)
    local baseCf = gridRef.CFrame * CFrame.new(0, gridRef.Size.Y / 2, 0)
    return (baseCf * CFrame.new(ox, 0, oz)).Position
end

local function baab_getPlacedUid(model)
    if not model then return nil end
    local name = tostring(model.Name)
    if baab_isPlacedModel(name) then
        return string.sub(name, 8)
    end
    return nil
end

local function baab_resolvePlacedCharacterId(model)
    if not model then return nil end
    local candidates = {
        model:GetAttribute("CharId"),
        model:GetAttribute("charId"),
        model:GetAttribute("Id"),
    }
    local visual = model:FindFirstChild("Visual")
    if visual then
        table.insert(candidates, visual:GetAttribute("CharId"))
        table.insert(candidates, visual:GetAttribute("charId"))
        table.insert(candidates, visual:GetAttribute("SrcTemplate"))
        table.insert(candidates, visual.Name)
    end
    for i = 1, #candidates do
        local candidate = candidates[i]
        if type(candidate) == "string" and candidate ~= "" then
            if baab_characterById[candidate] then
                return candidate
            end
            local cfg = baab_getCharacterConfigByNameOrId(candidate)
            if cfg and cfg.Id then
                return tostring(cfg.Id)
            end
        end
    end
    return nil
end

local function baab_getPlacedRate(model)
    if not model then return 0 end
    local moneyLabel = model:FindFirstChild("money", true)
    if moneyLabel then
        local rate = tonumber(moneyLabel:GetAttribute("Rate"))
        if rate then return rate end
    end
    return 0
end

local function baab_hasSelections(tbl)
    if type(tbl) ~= "table" then return false end
    for _, v in pairs(tbl) do
        if v then return true end
    end
    return false
end

local function baab_getSelectedRarities()
    return Options.ClaimRarities and Options.ClaimRarities.Value or {}
end

local function baab_getSelectedCharacters()
    return Options.ClaimCharacters and Options.ClaimCharacters.Value or {}
end

local function baab_shouldClaimCharacter(charId)
    local raritySelections  = baab_getSelectedRarities()
    local charSelections    = baab_getSelectedCharacters()
    local rarityHasSelection = baab_hasSelections(raritySelections)
    local charHasSelection   = baab_hasSelections(charSelections)
    if not rarityHasSelection and not charHasSelection then return true end
    local rarityPass = true
    local charPass   = true
    if rarityHasSelection then
        rarityPass = raritySelections[baab_getCharacterRarity(charId)] == true
    end
    if charHasSelection then
        charPass = charSelections[tostring(charId)] == true
    end
    return rarityPass and charPass
end

local function baab_buildLiveRateCache()
    local cache = {}
    local plot = baab_getPlayerPlot()
    if not plot then return cache end
    local children = plot:GetChildren()
    for i = 1, #children do
        local child = children[i]
        if child:IsA("Model") and baab_isPlacedModel(child.Name) then
            local charId = baab_resolvePlacedCharacterId(child)
            local rate   = baab_getPlacedRate(child)
            if charId and rate > 0 then
                if cache[charId] then
                    cache[charId] = math.min(cache[charId], rate)
                else
                    cache[charId] = rate
                end
            end
        end
    end
    return cache
end

local function baab_detectRateField()
    baab_liveRateCache = baab_buildLiveRateCache()

    local priorityFields = {
        "Rate","Income","BaseIncome","BaseRate",
        "CashPerTick","MoneyPerTick","Earnings",
        "Yield","Profit","PassiveIncome",
    }

    for i = 1, #priorityFields do
        local field = priorityFields[i]
        local hits  = 0
        for charId, observedRate in pairs(baab_liveRateCache) do
            local cfg = baab_getCharacterConfigById(charId)
            if cfg and type(cfg[field]) == "number" and math.abs(cfg[field] - observedRate) < 0.001 then
                hits = hits + 1
            end
        end
        if hits > 0 then
            baab_rateFieldName = field
            return field
        end
    end

    local counts = {}
    for charId, observedRate in pairs(baab_liveRateCache) do
        local cfg = baab_getCharacterConfigById(charId)
        if cfg then
            for k, v in pairs(cfg) do
                if type(v) == "number" and math.abs(v - observedRate) < 0.001 then
                    counts[k] = (counts[k] or 0) + 1
                end
            end
        end
    end

    local bestField, bestCount = nil, 0
    for field, count in pairs(counts) do
        if count > bestCount then
            bestField = field
            bestCount = count
        end
    end

    if bestField then
        baab_rateFieldName = bestField
        return bestField
    end

    local chars = baab_Characters
    for i = 1, #priorityFields do
        local field = priorityFields[i]
        local seen  = 0
        for j = 1, #chars do
            if type(chars[j][field]) == "number" then
                seen = seen + 1
            end
        end
        if seen >= math.max(5, math.floor(#chars * 0.5)) then
            baab_rateFieldName = field
            return field
        end
    end

    baab_rateFieldName = nil
    return nil
end

local function baab_getBaseCharacterRate(charId)
    local cfg = baab_getCharacterConfigById(charId)
    if not cfg then return nil end
    if baab_rateFieldName and type(cfg[baab_rateFieldName]) == "number" then
        return cfg[baab_rateFieldName]
    end
    local fallbackFields = {
        "Rate","Income","BaseIncome","BaseRate",
        "CashPerTick","MoneyPerTick","Earnings",
        "Yield","Profit","PassiveIncome",
    }
    for i = 1, #fallbackFields do
        local field = fallbackFields[i]
        if type(cfg[field]) == "number" then
            return cfg[field]
        end
    end
    return baab_liveRateCache[charId]
end

local function baab_getToolEffectiveRate(tool)
    if not tool then return 0 end
    local toolRateFields = {
        "Rate","Income","BaseIncome","BaseRate","CashPerTick","MoneyPerTick",
    }
    for i = 1, #toolRateFields do
        local val = tonumber(tool:GetAttribute(toolRateFields[i]))
        if val then return val end
    end
    local charId   = tool:GetAttribute("CharId")
    local baseRate = baab_getBaseCharacterRate(charId)
    return tonumber(baseRate) or 0
end

local function baab_getCharacterTools()
    local found = {}

    local function scanContainer(container)
        if not container then return end
        local children = container:GetChildren()
        for i = 1, #children do
            local tool = children[i]
            if tool:IsA("Tool") and not tool:GetAttribute("IsHammer") then
                local itemUid = tool:GetAttribute("ItemUid")
                local charId  = tool:GetAttribute("CharId")
                if type(itemUid) == "string" and type(charId) == "string" then
                    table.insert(found, {
                        tool      = tool,
                        uid       = itemUid,
                        charId    = charId,
                        name      = baab_getCharacterName(charId),
                        rarity    = baab_getCharacterRarity(charId),
                        footprint = baab_getCharacterFootprint(charId),
                        rate      = baab_getToolEffectiveRate(tool),
                    })
                end
            end
        end
    end

    scanContainer(LocalPlayer:FindFirstChild("Backpack"))
    scanContainer(LocalPlayer.Character)

    table.sort(found, function(a, b)
        if a.rate == b.rate then
            local ar = baab_getCharacterRarityScore(a.charId)
            local br = baab_getCharacterRarityScore(b.charId)
            if ar == br then
                if a.footprint == b.footprint then
                    return a.name < b.name
                end
                return a.footprint < b.footprint
            end
            return ar > br
        end
        return a.rate > b.rate
    end)

    return found
end

local function baab_findBestFitCellForPlacedModel(gridRef, worldPos, footprint)
    local gridW = tonumber(baab_PlotConfig.GridW) or 0
    local gridH = tonumber(baab_PlotConfig.GridH) or 0
    if gridW <= 0 or gridH <= 0 then return nil end
    local bestCol, bestRow, bestDist2 = nil, nil, math.huge
    for col = 0, gridW - footprint do
        for row = 0, gridH - footprint do
            local expectedPos = baab_getExpectedWorldCenter(gridRef, col, row, footprint)
            local dx    = worldPos.X - expectedPos.X
            local dz    = worldPos.Z - expectedPos.Z
            local dist2 = dx * dx + dz * dz
            if dist2 < bestDist2 then
                bestDist2 = dist2
                bestCol   = col
                bestRow   = row
            end
        end
    end
    return bestCol, bestRow, bestDist2
end

local function baab_rebuildOccupancy()
    local occupancy   = {}
    local placedInfos = {}
    local refs        = baab_getGridRefs()

    for i = 1, #refs do
        local floor = tonumber(refs[i]:GetAttribute("Floor")) or 1
        occupancy[floor] = occupancy[floor] or {}
    end

    local plot = baab_getPlayerPlot()
    if not plot then return occupancy, placedInfos, refs end

    local gridW    = tonumber(baab_PlotConfig.GridW) or 0
    local gridH    = tonumber(baab_PlotConfig.GridH) or 0
    local children = plot:GetChildren()

    for i = 1, #children do
        local child = children[i]
        if child:IsA("Model") and baab_isPlacedModel(child.Name) then
            local part      = baab_getModelBasePart(child)
            local charId    = baab_resolvePlacedCharacterId(child)
            local footprint = baab_getCharacterFootprint(charId)

            if part and #refs > 0 then
                local bestRef, bestFloor, bestCol, bestRow, bestDist = nil, nil, nil, nil, math.huge

                for j = 1, #refs do
                    local ref   = refs[j]
                    local floor = tonumber(ref:GetAttribute("Floor")) or 1
                    local col, row, dist2 = baab_findBestFitCellForPlacedModel(ref, part.Position, footprint)
                    if col and row and col >= 0 and row >= 0
                        and col <= (gridW - footprint) and row <= (gridH - footprint) then
                        if dist2 < bestDist then
                            bestDist  = dist2
                            bestRef   = ref
                            bestFloor = floor
                            bestCol   = col
                            bestRow   = row
                        end
                    end
                end

                if bestRef and bestFloor then
                    occupancy[bestFloor] = occupancy[bestFloor] or {}
                    for col = bestCol, bestCol + footprint - 1 do
                        occupancy[bestFloor][col] = occupancy[bestFloor][col] or {}
                        for row = bestRow, bestRow + footprint - 1 do
                            occupancy[bestFloor][col][row] = true
                        end
                    end
                    table.insert(placedInfos, {
                        uid       = baab_getPlacedUid(child),
                        charId    = charId,
                        name      = baab_getCharacterName(charId),
                        rarity    = baab_getCharacterRarity(charId),
                        rate      = baab_getPlacedRate(child),
                        floor     = bestFloor,
                        col       = bestCol,
                        row       = bestRow,
                        footprint = footprint,
                        model     = child,
                    })
                end
            end
        end
    end

    table.sort(placedInfos, function(a, b)
        if a.rate == b.rate then return a.name < b.name end
        return a.rate < b.rate
    end)

    return occupancy, placedInfos, refs
end

local function baab_isAreaFree(occupancy, floor, col, row, footprint)
    occupancy[floor] = occupancy[floor] or {}
    for c = col, col + footprint - 1 do
        occupancy[floor][c] = occupancy[floor][c] or {}
        for r = row, row + footprint - 1 do
            if occupancy[floor][c][r] then
                return false
            end
        end
    end
    return true
end

local function baab_findFirstFreeArea(occupancy, refs, footprint)
    local gridW = tonumber(baab_PlotConfig.GridW) or 0
    local gridH = tonumber(baab_PlotConfig.GridH) or 0
    if gridW <= 0 or gridH <= 0 then return nil end
    for i = 1, #refs do
        local floor = tonumber(refs[i]:GetAttribute("Floor")) or 1
        for col = 0, gridW - footprint do
            for row = 0, gridH - footprint do
                if baab_isAreaFree(occupancy, floor, col, row, footprint) then
                    return floor, col, row
                end
            end
        end
    end
    return nil
end

local function baab_invokePlace(entry, floor, col, row)
    if not entry or not entry.uid then return false, "Missing UID" end
    local uid = entry.uid
    local ok, result = pcall(baab_PlaceRemote.InvokeServer, baab_PlaceRemote, uid, floor, col, row)
    if not ok then return false, tostring(result) end
    if type(result) == "table" then
        return result.ok ~= false, result
    end
    return result ~= false, result
end

local function baab_invokeUnplace(uid)
    if not baab_UnplaceRemote or not uid then return false, "Unplace remote missing" end
    local ok, result = pcall(baab_UnplaceRemote.InvokeServer, baab_UnplaceRemote, uid)
    if not ok then return false, tostring(result) end
    if type(result) == "table" then
        return result.ok ~= false, result
    end
    return result ~= false, result
end

local function baab_getBestAndWorstPlaced(placedInfos)
    local best, worst = nil, nil
    for i = 1, #placedInfos do
        local info = placedInfos[i]
        if not best or info.rate > best.rate then best = info end
        if not worst or info.rate < worst.rate then worst = info end
    end
    return best, worst
end

local function baab_processRollResult(result)
    if type(result) ~= "table" then return 4 end
    local cooldown   = tonumber(result.cooldown) or 4
    local rolledParts  = {}
    local claimedParts = {}
    local results      = result.results or {}
    for index = 1, #results do
        local info     = results[index]
        local charId   = tostring(info.charId or "unknown")
        local name     = baab_getCharacterName(charId)
        local rarity   = baab_getCharacterRarity(charId)
        local mutation = tostring(info.mutation or "none")
        local display  = name .. " [" .. rarity .. "]" .. (mutation ~= "none" and (" {" .. mutation .. "}") or "")
        table.insert(rolledParts, display)
        if Toggles.AutoClaim and Toggles.AutoClaim.Value and not info.claimed and baab_shouldClaimCharacter(charId) then
            local idx = index
            pcall(baab_ClaimRollRemote.InvokeServer, baab_ClaimRollRemote, idx)
            table.insert(claimedParts, display)
        end
    end
    baab_lastRollText = #rolledParts > 0 and table.concat(rolledParts, ", ") or "None"
    if #claimedParts > 0 then
        baab_lastClaimedText = table.concat(claimedParts, ", ")
    end
    if baab_LastRollLabelRef and baab_LastRollLabelRef.SetText then
        baab_LastRollLabelRef:SetText("Last Roll: " .. baab_lastRollText)
    end
    if baab_LastClaimedLabelRef and baab_LastClaimedLabelRef.SetText then
        baab_LastClaimedLabelRef:SetText("Last Claimed: " .. baab_lastClaimedText)
    end
    return cooldown
end

local function baab_placeBestOnce(notify)
    baab_detectRateField()
    local inventory = baab_getCharacterTools()
    if #inventory == 0 then
        if notify then
            Library:Notify({ Title = "Auto Place", Description = "No character tools found.", Time = 3 })
        end
        return false
    end
    local occupancy, placedInfos, refs = baab_rebuildOccupancy()
    if #refs == 0 then
        if notify then
            Library:Notify({ Title = "Auto Place", Description = "No GridRef parts found.", Time = 3 })
        end
        return false
    end
    for i = 1, #inventory do
        local entry = inventory[i]
        local floor, col, row = baab_findFirstFreeArea(occupancy, refs, entry.footprint)
        if floor ~= nil then
            local success = baab_invokePlace(entry, floor, col, row)
            if success then
                if notify then
                    Library:Notify({
                        Title = "Placed",
                        Description = string.format("%s | Floor %d | Col %d | Row %d", entry.name, floor, col, row),
                        Time = 3,
                    })
                end
                return true
            end
        end
    end
    if Toggles.ReplaceWorstWhenFull and Toggles.ReplaceWorstWhenFull.Value and baab_UnplaceRemote then
        local bestInventory        = inventory[1]
        local _, worstPlaced = baab_getBestAndWorstPlaced(placedInfos)
        if bestInventory and worstPlaced
            and (tonumber(bestInventory.rate) or 0) > (tonumber(worstPlaced.rate) or 0) then
            local unplaced = baab_invokeUnplace(worstPlaced.uid)
            if unplaced then
                task.wait(0.25)
                occupancy, placedInfos, refs = baab_rebuildOccupancy()
                local floor, col, row = baab_findFirstFreeArea(occupancy, refs, bestInventory.footprint)
                if floor ~= nil then
                    local success = baab_invokePlace(bestInventory, floor, col, row)
                    if success then
                        if notify then
                            Library:Notify({
                                Title = "Replaced Worst",
                                Description = string.format("%s replaced %s", bestInventory.name, worstPlaced.name),
                                Time = 3,
                            })
                        end
                        return true
                    end
                end
            end
        end
    end
    if notify then
        Library:Notify({ Title = "Auto Place", Description = "No valid free spot found.", Time = 3 })
    end
    return false
end

local function baab_getPlacedModels()
    local placed = {}
    local plot   = baab_getPlayerPlot()
    if not plot then return placed end
    local children = plot:GetChildren()
    for i = 1, #children do
        local child = children[i]
        if child:IsA("Model") and baab_isPlacedModel(child.Name) then
            local part = baab_getModelBasePart(child)
            if part then
                table.insert(placed, {
                    model    = child,
                    part     = part,
                    position = part.Position,
                    rate     = baab_getPlacedRate(child),
                    name     = baab_resolvePlacedCharacterId(child) or "Unknown",
                })
            end
        end
    end
    return placed
end

local function baab_collectAllCash(delaySeconds)
    local placed = baab_getPlacedModels()
    if #placed == 0 then return end

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    for i = 1, #placed do
        if not baab_autocollect_running then break end

        local info = placed[i]
        local body = info.model:FindFirstChild("Body")

        if body and type(firetouchinterest) == "function" then
            -- no teleport needed, fire touch on Body directly
            pcall(firetouchinterest, hrp, body, 0)
            task.wait(0.1)
            pcall(firetouchinterest, hrp, body, 1)
        else
            -- fallback: teleport into model
            baab_teleportTo(info.position + Vector3.new(0, 1, 0))
        end

        task.wait(delaySeconds)
    end
end

local function baab_refreshInfoLabels()
    baab_detectRateField()
    local plot        = baab_getPlayerPlot()
    local plotIndex   = LocalPlayer:GetAttribute("PlotIndex")
    local occupancy, placedInfos, refs = baab_rebuildOccupancy()
    local inventory   = baab_getCharacterTools()
    local totalRate   = 0
    for i = 1, #placedInfos do
        totalRate = totalRate + (tonumber(placedInfos[i].rate) or 0)
    end
    local bestPlaced, worstPlaced = baab_getBestAndWorstPlaced(placedInfos)
    local bestInventory = inventory[1]

    if baab_RateFieldLabelRef and baab_RateFieldLabelRef.SetText then
        baab_RateFieldLabelRef:SetText("Rate field: " .. tostring(baab_rateFieldName or "not found"))
    end
    if baab_PlotInfoLabelRef and baab_PlotInfoLabelRef.SetText then
        baab_PlotInfoLabelRef:SetText(
            "Plot: " .. tostring(plot and plot.Name or "nil")
            .. "\nPlotIndex: " .. tostring(plotIndex)
            .. "\nGrid: " .. tostring(baab_PlotConfig.GridW) .. " x " .. tostring(baab_PlotConfig.GridH)
            .. "\nFloors found: " .. tostring(#refs)
        )
    end
    if baab_PlacedInfoLabelRef and baab_PlacedInfoLabelRef.SetText then
        baab_PlacedInfoLabelRef:SetText(
            "Placed count: " .. tostring(#placedInfos)
            .. "\nTotal rate: " .. baab_formatNumber(totalRate)
            .. "\nBest: " .. (bestPlaced and (bestPlaced.name .. " (" .. tostring(bestPlaced.rate) .. ")") or "None")
            .. "\nWorst: " .. (worstPlaced and (worstPlaced.name .. " (" .. tostring(worstPlaced.rate) .. ")") or "None")
        )
    end
    if baab_InventoryInfoLabelRef and baab_InventoryInfoLabelRef.SetText then
        baab_InventoryInfoLabelRef:SetText(
            "Inventory: " .. tostring(#inventory)
            .. "\nBest: " .. (bestInventory and (bestInventory.name .. " [" .. bestInventory.rarity .. "] (" .. tostring(bestInventory.rate) .. ")") or "None")
        )
    end
    if baab_LastRollLabelRef and baab_LastRollLabelRef.SetText then
        baab_LastRollLabelRef:SetText("Last Roll: " .. baab_lastRollText)
    end
    if baab_LastClaimedLabelRef and baab_LastClaimedLabelRef.SetText then
        baab_LastClaimedLabelRef:SetText("Last Claimed: " .. baab_lastClaimedText)
    end
end

-- ══════════════════════════════════════════
--   TABS
-- ══════════════════════════════════════════

local baab_Tabs = {
    Warning  = baab_Window:AddTab("READ FIRST",  "triangle-alert"),
    Main     = baab_Window:AddTab("Main",        "star"),
    Place    = baab_Window:AddTab("Placement",   "layout-grid"),
    Upgrades = baab_Window:AddTab("Upgrades",    "trending-up"),
    Settings = baab_Window:AddTab("Settings",    "settings"),
}

-- ══════════════════════════════════════════
--   WARNING TAB
-- ══════════════════════════════════════════

local baab_WarnL = baab_Tabs.Warning:AddLeftGroupbox("⚠️ IMPORTANT / IMPORTANTE", "triangle-alert")
baab_WarnL:AddLabel("🇺🇸 ENGLISH", false)
baab_WarnL:AddLabel("If you are using Xeno, Solara, or any unsupported executor, do NOT blame me if features don't work. Use a supported executor like Madium, Delta, Potassium (or more) for the best experience. Join our Discord for support.", true)
baab_WarnL:AddDivider()
baab_WarnL:AddLabel("🇧🇷 PORTUGUÊS", false)
baab_WarnL:AddLabel("Se você estiver usando Xeno, Solara ou qualquer executor não suportado, NÃO me culpe se as funções não funcionarem. Use um executor suportado como Madium, Delta, Potassium (ou mais) para a melhor experiência. Entre no Discord para suporte.", true)
baab_WarnL:AddDivider()
baab_WarnL:AddLabel("🇪🇸 ESPAÑOL", false)
baab_WarnL:AddLabel("Si estás usando Xeno, Solara o cualquier ejecutor no compatible, NO me culpes si las funciones no funcionan. Utiliza un ejecutor compatible como Madium, Delta, Potassium (o más) para obtener la mejor experiencia. Únete a Discord para recibir ayuda.", true)

local baab_WarnR = baab_Tabs.Warning:AddRightGroupbox("🌐 SUPPORT / IDIOMAS", "users")
baab_WarnR:AddLabel("🇫🇷 FRANÇAIS", false)
baab_WarnR:AddLabel("Si vous utilisez Xeno, Solara ou un exécuteur non supporté, ne me blâmez PAS si les fonctions ne marchent pas. Utilisez Madium, Delta ou Potassium pour la meilleure expérience.", true)
baab_WarnR:AddDivider()
baab_WarnR:AddLabel("🇵🇭 FILIPINO", false)
baab_WarnR:AddLabel("Kung gumagamit ka ng Xeno, Solara, o anumang hindi suportadong executor, HUWAG mo akong sisihin kung hindi gumagana ang mga features. Gamitin ang Madium, Delta, o Potassium para sa pinakamagandang karanasan.", true)
baab_WarnR:AddDivider()
baab_WarnR:AddLabel("🇮🇩 BAHASA INDONESIA", false)
baab_WarnR:AddLabel("Jika Anda menggunakan Xeno, Solara, atau executor yang tidak didukung, JANGAN salahkan saya jika fitur tidak berfungsi. Gunakan executor yang didukung seperti Madium, Delta, atau Potassium.", true)
baab_WarnR:AddDivider()
baab_WarnR:AddButton({
    Text = "📋 COPY DISCORD LINK",
    Func = function()
        setclipboard("https://discord.gg/DHeCNzTypH")
        Library:Notify({ Title = "Copied!", Description = "Paste in your browser to join support.", Time = 4 })
    end,
})

-- ══════════════════════════════════════════
--   MAIN TAB
-- ══════════════════════════════════════════

local baab_BannerGroup = baab_Tabs.Main:AddLeftGroupbox("🌐 JOIN DISCORD FOR ACTIVE COMMUNITY", "users")
baab_BannerGroup:AddLabel("Suggestions • Bug Fixes • Updates • Community Support", true)
baab_BannerGroup:AddButton({
    Text = "📋 COPY DISCORD INVITE LINK",
    Func = function()
        setclipboard("https://discord.gg/DHeCNzTypH")
        Library:Notify({ Title = "Discord Invite Copied!", Description = "Paste in browser to join.", Time = 4 })
    end,
})

local baab_EssentialGroup = baab_Tabs.Main:AddLeftGroupbox("Essential", "star")
baab_EssentialGroup:AddToggle("AntiAFK", {
    Text    = "Anti AFK",
    Default = false,
    Callback = function(state)
        baab_antiafk_running = state
        if state then
            if not baab_isLoadingConfig then
                Library:Notify({ Title = "Anti AFK", Description = "Enabled!", Time = 3 })
            end
            task.spawn(function()
                while baab_antiafk_running do
                    pcall(function()
                        VirtualInputManager:SendKeyEvent(true,  Enum.KeyCode.Space, false, game)
                        task.wait(0.1)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                    end)
                    task.wait(180)
                end
            end)
        else
            if not baab_isLoadingConfig then
                Library:Notify({ Title = "Anti AFK", Description = "Disabled.", Time = 3 })
            end
        end
    end,
})

local baab_RollGroup = baab_Tabs.Main:AddLeftGroupbox("Roll / Claim", "dice-6")
baab_RollGroup:AddToggle("AutoRoll", {
    Text    = "Auto Roll Characters",
    Default = false,
    Tooltip = "Spams RollCharacters as fast as the server allows",
    Callback = function(state)
        baab_autoroll_running = state
        if state then
            if not baab_isLoadingConfig then
                Library:Notify({ Title = "Auto Roll", Description = "Started rolling.", Time = 3 })
            end
            task.spawn(function()
                while baab_autoroll_running do
                    pcall(function()
                        local result = baab_RollRemote:InvokeServer()
                        baab_processRollResult(result)
                    end)
                    task.wait() -- minimal yield, just 1 frame
                end
            end)
        else
            if not baab_isLoadingConfig then
                Library:Notify({ Title = "Auto Roll", Description = "Stopped.", Time = 3 })
            end
        end
    end,
})

baab_RollGroup:AddToggle("AutoClaim", {
    Text    = "Auto Claim Rolled Characters",
    Default = false,
    Tooltip = "Claims rolled characters that match your rarity/id filters",
    Callback = function(state)
        if not baab_isLoadingConfig then
            Library:Notify({
                Title       = "Auto Claim",
                Description = state and "Enabled." or "Disabled.",
                Time        = 3,
            })
        end
    end,
})

baab_RollGroup:AddDropdown("ClaimRarities", {
    Values                  = baab_dynamicRarities,
    Multi                   = true,
    Text                    = "Claim Rarity Filter",
    Tooltip                 = "If nothing is selected, all rarities pass",
    Searchable              = true,
    MaxVisibleDropdownItems = 12,
})

baab_RollGroup:AddDropdown("ClaimCharacters", {
    Values                  = baab_characterIds,
    Multi                   = true,
    Text                    = "Claim Character Id Filter",
    Tooltip                 = "Populated dynamically from GameConfig.Characters using Id values",
    Searchable              = true,
    MaxVisibleDropdownItems = 12,
})

local baab_RebirthGroup = baab_Tabs.Main:AddRightGroupbox("Rebirth", "refresh-cw")
baab_RebirthGroup:AddSlider("RebirthAmount", {
    Text     = "Rebirth Amount",
    Default  = 1,
    Min      = 1,
    Max      = 100,
    Rounding = 0,
    Compact  = false,
    Tooltip  = "How many rebirths per invoke",
})

baab_RebirthGroup:AddToggle("AutoRebirth", {
    Text    = "Auto Rebirth",
    Default = false,
    Tooltip = "Continuously rebirths using DoRebirth remote",
    Callback = function(state)
        baab_autorebirth_running = state
        if state then
            if not baab_isLoadingConfig then
                Library:Notify({ Title = "Auto Rebirth", Description = "Started!", Time = 3 })
            end
            task.spawn(function()
                while baab_autorebirth_running do
                    local amount = Options.RebirthAmount and Options.RebirthAmount.Value or 1
                    pcall(baab_RebirthRemote.InvokeServer, baab_RebirthRemote, amount)
                    task.wait(0.5)
                end
            end)
        else
            if not baab_isLoadingConfig then
                Library:Notify({ Title = "Auto Rebirth", Description = "Stopped.", Time = 3 })
            end
        end
    end,
})

local baab_CollectGroup = baab_Tabs.Main:AddRightGroupbox("Collect Cash", "coins")

baab_CollectGroup:AddToggle("AutoCollect", {
    Text    = "Auto Collect Character Cash",
    Default = false,
    Tooltip = "Constantly fires touch on all placed characters to collect cash",
    Callback = function(state)
        baab_autocollect_running = state
        if state then
            if not baab_isLoadingConfig then
                Library:Notify({ Title = "Auto Collect", Description = "Started!", Time = 3 })
            end
            task.spawn(function()
                while baab_autocollect_running do
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local placed = baab_getPlacedModels()
                        for i = 1, #placed do
                            if not baab_autocollect_running then break end
                            local body = placed[i].model:FindFirstChild("Body")
                            if body and type(firetouchinterest) == "function" then
                                pcall(firetouchinterest, hrp, body, 0)
                                pcall(firetouchinterest, hrp, body, 1)
                            else
                                baab_teleportTo(placed[i].position + Vector3.new(0, 1, 0))
                                task.wait(0.1)
                            end
                        end
                    end
                    task.wait(0.05) -- tiny yield to not freeze, loops again immediately
                end
            end)
        else
            if not baab_isLoadingConfig then
                Library:Notify({ Title = "Auto Collect", Description = "Stopped.", Time = 3 })
            end
        end
    end,
})

local baab_StatusGroup = baab_Tabs.Main:AddRightGroupbox("Status", "info")
baab_LastRollLabelRef      = baab_StatusGroup:AddLabel("Last Roll: None", true)
baab_LastClaimedLabelRef   = baab_StatusGroup:AddLabel("Last Claimed: None", true)
baab_RateFieldLabelRef     = baab_StatusGroup:AddLabel("Rate field: scanning...", true)
baab_StatusGroup:AddDivider()
baab_PlotInfoLabelRef      = baab_StatusGroup:AddLabel("Plot: loading...", true)
baab_PlacedInfoLabelRef    = baab_StatusGroup:AddLabel("Placed count: loading...", true)
baab_InventoryInfoLabelRef = baab_StatusGroup:AddLabel("Inventory characters: loading...", true)

-- ══════════════════════════════════════════
--   PLACEMENT TAB
-- ══════════════════════════════════════════

local baab_PlaceGroup = baab_Tabs.Place:AddLeftGroupbox("Auto Place", "layout-grid")
baab_PlaceGroup:AddToggle("AutoPlaceBest", {
    Text    = "Auto Place Best Characters",
    Default = false,
    Tooltip = "Uses real floor/col/row placement and character footprint",
    Callback = function(state)
        baab_autoplace_running = state
        if state then
            if not baab_isLoadingConfig then
                Library:Notify({ Title = "Auto Place", Description = "Started.", Time = 3 })
            end
            task.spawn(function()
                while baab_autoplace_running do
                    pcall(baab_placeBestOnce, false)
                    task.wait(0.8)
                end
            end)
        else
            if not baab_isLoadingConfig then
                Library:Notify({ Title = "Auto Place", Description = "Stopped.", Time = 3 })
            end
        end
    end,
})

baab_PlaceGroup:AddToggle("ReplaceWorstWhenFull", {
    Text    = "Replace Worst When Full",
    Default = false,
    Tooltip = "If no free space exists, try replacing your lowest rate placed character",
    Callback = function(state)
        baab_replaceworst_running = state
        if not baab_isLoadingConfig then
            Library:Notify({
                Title       = "Replace Worst",
                Description = state and "Enabled." or "Disabled.",
                Time        = 3,
            })
        end
    end,
})

-- ══════════════════════════════════════════
--   UPGRADES TAB
-- ══════════════════════════════════════════

local baab_UpgradeGroup = baab_Tabs.Upgrades:AddLeftGroupbox("Auto Buy Upgrades", "trending-up")
baab_UpgradeGroup:AddDropdown("SelectedUpgrades", {
    Values                  = baab_upgradeDisplayNames,
    Multi                   = true,
    Text                    = "Upgrades to Auto-Buy",
    Tooltip                 = "Dynamically populated from GameConfig.Upgrades",
    Searchable              = true,
    MaxVisibleDropdownItems = 10,
})

baab_UpgradeGroup:AddToggle("AutoBuyUpgrades", {
    Text    = "Auto Buy Selected Upgrades",
    Default = false,
    Tooltip = "Continuously buys selected upgrades",
    Callback = function(state)
        if state then
            if not baab_isLoadingConfig then
                Library:Notify({ Title = "Auto Upgrades", Description = "Started buying upgrades!", Time = 3 })
            end
            task.spawn(function()
                while Toggles.AutoBuyUpgrades and Toggles.AutoBuyUpgrades.Value do
                    local selected = Options.SelectedUpgrades and Options.SelectedUpgrades.Value or {}
                    for displayName, isSelected in pairs(selected) do
                        if not (Toggles.AutoBuyUpgrades and Toggles.AutoBuyUpgrades.Value) then break end
                        if isSelected then
                            local upgrade = baab_upgradeById[displayName]
                            if upgrade and upgrade.Id then
                                local id = upgrade.Id
                                pcall(baab_BuyUpgradeRemote.InvokeServer, baab_BuyUpgradeRemote, id)
                                task.wait(0.1)
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
        else
            if not baab_isLoadingConfig then
                Library:Notify({ Title = "Auto Upgrades", Description = "Stopped.", Time = 3 })
            end
        end
    end,
})

-- ══════════════════════════════════════════
--   SETTINGS TAB
-- ══════════════════════════════════════════

local baab_MenuGroup = baab_Tabs.Settings:AddLeftGroupbox("Menu Settings", "settings")
baab_MenuGroup:AddToggle("KeybindMenuOpen", {
    Default = false,
    Text    = "Show Keybind Menu",
    Callback = function(value)
        if Library.KeybindFrame then
            Library.KeybindFrame.Visible = value
        end
    end,
})

baab_MenuGroup:AddToggle("ShowCustomCursor", {
    Text     = "Custom Cursor",
    Default  = Library.ShowCustomCursor,
    Callback = function(Value)
        Library.ShowCustomCursor = Value
    end,
})

baab_MenuGroup:AddDropdown("NotificationSide", {
    Values   = { "Left", "Right" },
    Default  = "Right",
    Text     = "Notification Side",
    Callback = function(value)
        pcall(function() Library:SetNotifySide(value) end)
    end,
})

baab_MenuGroup:AddDropdown("DPIDropdown", {
    Values   = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
    Default  = "100%",
    Text     = "DPI Scale",
    Callback = function(value)
        value = value:gsub("%%", "")
        pcall(function() Library:SetDPIScale(tonumber(value)) end)
    end,
})

baab_MenuGroup:AddDivider()
baab_MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "G", NoUI = true, Text = "Menu keybind" })

baab_MenuGroup:AddButton({
    Text    = "Unload Script",
    Tooltip = "Completely unload the script",
    Func    = function()
        baab_autoroll_running     = false
        baab_autoplace_running    = false
        baab_replaceworst_running = false
        baab_autorebirth_running  = false
        baab_autocollect_running  = false
        baab_antiafk_running      = false
        Library:Unload()
    end,
})

-- ══════════════════════════════════════════
--   FINALIZE
-- ══════════════════════════════════════════

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("IBdihPHub/baab_")
SaveManager:SetFolder("IBdihPHub/baab_/Settings")
SaveManager:BuildConfigSection(baab_Tabs.Settings)
ThemeManager:ApplyToTab(baab_Tabs.Settings)

baab_isLoadingConfig = true
SaveManager:LoadAutoloadConfig()
task.defer(function()
    baab_isLoadingConfig = false
end)

task.spawn(function()
    while task.wait(2) do
        if Library.Unloaded then break end
        pcall(baab_refreshInfoLabels)
    end
end)

task.defer(function()
    task.wait(1.5)
    baab_detectRateField()
    baab_refreshInfoLabels()
    Library:Notify({
        Title       = "IBdihP Hub Loaded",
        Description = "Become an Anime Billionaire\nPlayer: " .. LocalPlayer.Name .. "\nExecutor: " .. baab_executorName,
        Time        = 5,
    })
end)

Library:OnUnload(function()
    baab_autoroll_running     = false
    baab_autoplace_running    = false
    baab_replaceworst_running = false
    baab_autorebirth_running  = false
    baab_autocollect_running  = false
    baab_antiafk_running      = false
    print("IBdihP Hub - BAAB unloaded!")
end)
