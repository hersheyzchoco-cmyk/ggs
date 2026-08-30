--!nocheck
--!nolint
-- ══════════════════════════════════════════════════════════════════════
--   PRISM — Anime Card Farm
-- ══════════════════════════════════════════════════════════════════════

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService       = game:GetService("HttpService")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local VirtualUser       = game:GetService("VirtualUser")
local VIM               = game:GetService("VirtualInputManager")
local TeleportService   = game:GetService("TeleportService")
local Lighting          = game:GetService("Lighting")
local StatsService      = game:GetService("Stats")
local LocalPlayer       = Players.LocalPlayer
local Camera            = workspace.CurrentCamera

-- ══════════════════════════════════════════
--   EXECUTOR DETECTION
-- ══════════════════════════════════════════

local executorName = "Unknown"
pcall(function()
    if identifyexecutor then
        local name, ver = identifyexecutor()
        executorName = (type(ver) == "string" and ver ~= "") and (name .. " " .. ver) or name
    elseif syn then executorName = "Synapse X"
    elseif fluxus then executorName = "Fluxus"
    elseif KRNL_LOADED then executorName = "KRNL"
    elseif pebc_execute then executorName = "Pencil"
    end
end)

-- ══════════════════════════════════════════
--   SESSION STATS
-- ══════════════════════════════════════════

local SessionStats = {
    startTime      = os.clock(),
    packsBought    = 0,
    cardsGraded    = 0,
    traitsRolled   = 0,
    raidsCompleted = 0,
    floorsCleared  = 0,
}

-- ══════════════════════════════════════════
--   LOAD OBSIDIAN UI & CORE HELPERS FIRST
-- ══════════════════════════════════════════

local repo    = "https://raw.githubusercontent.com/joustingmatch/ObsidianUltra/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

pcall(function() Library.ScreenGui.Parent = game:GetService("CoreGui") end)

local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Toggles = Library.Toggles
local Options = Library.Options

local function isOn(name)
    if Library.Unloaded then return false end
    local t = Toggles[name]
    return type(t) == "table" and t.Value == true
end

local function getNumber(name, fallback)
    local o = Options[name]
    return (type(o) == "table" and tonumber(o.Value)) or fallback
end

local function copyText(text, msg)
    if setclipboard then setclipboard(text)
    elseif toclipboard then toclipboard(text) end
    Library:Notify(msg or "Copied to clipboard!")
end

-- ══════════════════════════════════════════
--   FORMATTING HELPERS
-- ══════════════════════════════════════════

local function c(t, col)
    if not col or col == "" then return t end
    return string.format('<font color="%s">%s</font>', col, t)
end

local function b(t) return string.format("<b>%s</b>", t) end
local function i(t) return string.format("<i>%s</i>", t) end
local function sz(t, size) return string.format('<font size="%d">%s</font>', size, t) end

local function hexToRgb(hex)
    hex = hex:gsub("#", "")
    return tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))
end

local function rgbToHex(r, g, b)
    return string.format("#%02x%02x%02x", math.clamp(r, 0, 255), math.clamp(g, 0, 255), math.clamp(b, 0, 255))
end

local function lerp(a, b, t) return a + (b - a) * t end

local function createGradientText(word, startHex, endHex)
    local r1, g1, b1 = hexToRgb(startHex)
    local r2, g2, b2 = hexToRgb(endHex)
    local result = ""
    local len = #word
    if len == 0 then return "" end
    if len == 1 then return string.format('<font color="%s">%s</font>', startHex, word) end
    for j = 1, len do
        local t = (j - 1) / (len - 1)
        local r = math.round(lerp(r1, r2, t))
        local g = math.round(lerp(g1, g2, t))
        local b = math.round(lerp(b1, b2, t))
        local char = word:sub(j, j)
        if char == " " then
            result = result .. " "
        else
            result = result .. string.format('<font color="%s">%s</font>', rgbToHex(r, g, b), char)
        end
    end
    return result
end

local function createMultiGradientText(word, colors)
    if #colors < 2 then return createGradientText(word, colors[1] or "#ffffff", colors[1] or "#ffffff") end
    local result = ""
    local len = #word
    if len == 0 then return "" end
    for j = 1, len do
        local globalT = (len == 1) and 0 or (j - 1) / (len - 1)
        local scaled = globalT * (#colors - 1)
        local idx = math.floor(scaled) + 1
        local localT = scaled - (idx - 1)
        local c1 = colors[math.min(idx, #colors)]
        local c2 = colors[math.min(idx + 1, #colors)]
        local r1, g1, b1 = hexToRgb(c1)
        local r2, g2, b2 = hexToRgb(c2)
        local r = math.round(lerp(r1, r2, localT))
        local g = math.round(lerp(g1, g2, localT))
        local b = math.round(lerp(b1, b2, localT))
        local char = word:sub(j, j)
        if char == " " then
            result = result .. " "
        else
            result = result .. string.format('<font color="%s">%s</font>', rgbToHex(r, g, b), char)
        end
    end
    return result
end

local PALETTE = {
    prism   = { "#38bdf8", "#a78bfa", "#ec4899" },
    aurora  = { "#4ade80", "#22d3ee", "#a78bfa" },
    sunset  = { "#fbbf24", "#f97316", "#ef4444" },
    ocean   = { "#38bdf8", "#0ea5e9", "#6366f1" },
    fire    = { "#fef08a", "#fb923c", "#dc2626" },
    ice     = { "#e0f2fe", "#7dd3fc", "#3b82f6" },
    rainbow = { "#ef4444", "#fbbf24", "#4ade80", "#22d3ee", "#a78bfa", "#ec4899" },
}

local function formatNumber(n)
    if type(n) ~= "number" then return tostring(n) end
    local formatted = tostring(math.floor(n))
    while true do
        local newFormatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
        formatted = newFormatted
        if k == 0 then break end
    end
    return formatted
end

local function formatDuration(secs)
    secs = math.floor(secs)
    local h = math.floor(secs / 3600)
    local m = math.floor((secs % 3600) / 60)
    local s = secs % 60
    if h > 0 then return string.format("%dh %dm %ds", h, m, s) end
    if m > 0 then return string.format("%dm %ds", m, s) end
    return string.format("%ds", s)
end

local function gradPlus(colors)
    return createMultiGradientText("[+]", colors)
end

local DISCORD_INVITE = "https://discord.gg/DHeCNzTypH"
local RSCRIPTS_LINK  = "https://rscripts.net/@Prism"

-- ══════════════════════════════════════════
--   DISCORD LOGGER
-- ══════════════════════════════════════════

task.spawn(function()
    local WORKER_URL = "https://ibdihp.hersheyzchoco.workers.dev/"
    local SECRET     = "this_is_the_best_free_script_hub_arena_ai_goated67"
    local gameName   = "Anime Card Farm"
    pcall(function()
        gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    end)
    local data = {
        embeds = {{
            title  = "Prism -- Execution",
            color  = 65535,
            fields = {
                { name = "User",     value = LocalPlayer.Name,                inline = true },
                { name = "Executor", value = executorName,                    inline = true },
                { name = "Game",     value = gameName,                        inline = true },
                { name = "Players",  value = tostring(#Players:GetPlayers()), inline = true },
            },
            footer = { text = "Prism - " .. os.date("%x %X") },
        }}
    }
    pcall(function()
        request({
            Url     = WORKER_URL,
            Method  = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body    = HttpService:JSONEncode({ secret = SECRET, data = data })
        })
    end)
end)

-- ══════════════════════════════════════════
--   REMOTES
-- ══════════════════════════════════════════

local Remotes           = ReplicatedStorage:WaitForChild("Remotes")
local ConveyorRE        = Remotes:WaitForChild("ConveyorRE")
local SellRE            = Remotes:WaitForChild("SellRE")
local UpgradesRE        = Remotes:WaitForChild("UpgradesRE")
local ConveyorUpgradeRE = Remotes:WaitForChild("ConveyorUpgradeRE")
local CardSlotRE        = ReplicatedStorage:WaitForChild("CardSlotRE")
local PlayTimeRewardRE  = Remotes:WaitForChild("PlayTimeRewardRE")
local GradeRollRE       = Remotes:WaitForChild("GradeRollRE")
local TraitRollRE       = Remotes:WaitForChild("TraitRollRE")
local BossRaidRE        = Remotes:WaitForChild("BossRaidRE")
local ItemsRE           = Remotes:WaitForChild("ItemsRE") -- <-- ADD THIS LINE


-- ══════════════════════════════════════════
--   GAME STATE & PLOT HELPERS
-- ══════════════════════════════════════════

local characterParts = {}

local function acf_getPlotNumber()
    local pn = LocalPlayer:FindFirstChild("PlotNumber")
    if pn then
        if pn.Value == 0 then pn:GetPropertyChangedSignal("Value"):Wait() end
        return pn.Value
    end
    return nil
end

local acf_plotNumber = acf_getPlotNumber()

local function acf_getPlotN0()
    if not acf_plotNumber then return nil end
    local map   = workspace:FindFirstChild("MAP")
    if not map then return nil end
    local plots = map:FindFirstChild("Plots")
    if not plots then return nil end
    local plot  = plots:FindFirstChild(tostring(acf_plotNumber))
    if not plot then return nil end
    return plot:FindFirstChild("Plot_N0")
end

local function acf_getClickDetector()
    local plotN0 = acf_getPlotN0()
    if not plotN0 then return nil end
    local buttonPart = plotN0:FindFirstChild("ButtonPart")
    if not buttonPart then return nil end
    return buttonPart:FindFirstChildOfClass("ClickDetector")
end

local function acf_getProxiBoxPrompt()
    local plotN0 = acf_getPlotN0()
    if not plotN0 then return nil end
    local bbm = plotN0:FindFirstChild("BoxBaseModel")
    if not bbm then return nil end
    local pb = bbm:FindFirstChild("ProxiBox")
    if not pb then return nil end
    return pb:FindFirstChildOfClass("ProximityPrompt"), pb
end

local function acf_getSellPrompt()
    local plotN0 = acf_getPlotN0()
    if not plotN0 then return nil end
    local sellPart = plotN0:FindFirstChild("SellPart")
    if not sellPart then return nil end
    return sellPart:FindFirstChildOfClass("ProximityPrompt"), sellPart
end

local function acf_getRoot()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5)
end

local function getHumanoid()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function acf_teleportTo(part, yOffset)
    local root = acf_getRoot()
    if not root or not part then return false end
    local cf
    if part:IsA("BasePart") then cf = part.CFrame
    elseif part:IsA("Model") then cf = part:GetPivot()
    else return false end
    root.CFrame = cf * CFrame.new(0, yOffset or 5, 0)
    root.AssemblyLinearVelocity = Vector3.zero
    root.Velocity = Vector3.zero
    return true
end

local function acf_getCardBoxTool()
    local char = LocalPlayer.Character
    if char then
        for _, obj in ipairs(char:GetChildren()) do
            if obj:IsA("Tool") and (obj.Name:lower():find("box") or obj.Name:lower():find("card")) then return obj end
        end
    end
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, obj in ipairs(backpack:GetChildren()) do
            if obj:IsA("Tool") and (obj.Name:lower():find("box") or obj.Name:lower():find("card")) then return obj end
        end
    end
    return nil
end

local function acf_equipTool(tool)
    if not tool then return false end
    local char = LocalPlayer.Character
    if not char then return false end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    humanoid:EquipTool(tool)
    return true
end

local function acf_getSlotPrompt(slotNum)
    local plotN0 = acf_getPlotN0()
    if not plotN0 then return nil, nil end
    local slot = plotN0:FindFirstChild("CardSlot" .. slotNum)
    if not slot then
        local top = plotN0:FindFirstChild("TOP")
        if top then slot = top:FindFirstChild("CardSlot" .. slotNum) end
    end
    if not slot then return nil, nil end
    local promptHolder = slot:FindFirstChild("PromptHolder")
    if not promptHolder then return nil, nil end
    local prompt = promptHolder:FindFirstChildOfClass("ProximityPrompt")
    return prompt, slot
end

local function acf_getBackpackTools()
    local tools = {}
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, obj in ipairs(backpack:GetChildren()) do
            if obj:IsA("Tool") then table.insert(tools, obj) end
        end
    end
    local char = LocalPlayer.Character
    if char then
        for _, obj in ipairs(char:GetChildren()) do
            if obj:IsA("Tool") then table.insert(tools, obj) end
        end
    end
    return tools
end

local function acf_getPackTools()
    local packs = {}
    for _, tool in ipairs(acf_getBackpackTools()) do
        if tool.Name:lower():find("pack") then table.insert(packs, tool) end
    end
    return packs
end

local function acf_fireEquipBest()
    pcall(function() CardSlotRE:FireServer("EquipBest") end)
end

-- ══════════════════════════════════════════
--   CARD SLOT HELPERS (Remove & Restore)
-- ══════════════════════════════════════════

local function acf_removeCardsFromSlots(maxSlot)
    maxSlot = maxSlot or 4
    local plotN0 = acf_getPlotN0()
    if not plotN0 then return {} end
    local removed = {}

    for i = 1, maxSlot do
        local prompt, slot = acf_getSlotPrompt(i)
        if prompt and slot and (prompt.ActionText == "Remove") then
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            local beforeInstances = {}
            if backpack then
                for _, item in ipairs(backpack:GetChildren()) do beforeInstances[item] = true end
            end
            acf_teleportTo(slot, 3)
            task.wait(1)
            pcall(function() fireproximityprompt(prompt) end)
            task.wait(1)
            local foundTool = nil
            if backpack then
                for _, item in ipairs(backpack:GetChildren()) do
                    if item:IsA("Tool") and not beforeInstances[item] then
                        if not item.Name:lower():find("pack") then
                            foundTool = item
                            break
                        end
                    end
                end
            end
            if foundTool then
                table.insert(removed, { slotNum = i, tool = foundTool, cardName = foundTool.Name })
            end
            task.wait(0.5)
        end
    end
    return removed
end

local function acf_restoreCardsToSlots(removedList)
    if not removedList or #removedList == 0 then return end
    for _, entry in ipairs(removedList) do
        local slotNum  = entry.slotNum
        local tool     = entry.tool
        local cardName = entry.cardName
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        local char     = LocalPlayer.Character
        local validTool = nil

        if tool and tool.Parent == backpack then validTool = tool
        elseif tool and char and tool.Parent == char then validTool = tool
        else
            local alreadyUsed = {}
            for _, e in ipairs(removedList) do
                if e.tool and e ~= entry then alreadyUsed[e.tool] = true end
            end
            if backpack then
                for _, item in ipairs(backpack:GetChildren()) do
                    if item:IsA("Tool") and item.Name == cardName and not alreadyUsed[item] then
                        validTool = item; break
                    end
                end
            end
        end

        if validTool then
            acf_equipTool(validTool)
            task.wait(0.8)
            local prompt, slot = acf_getSlotPrompt(slotNum)
            if prompt and slot then
                acf_teleportTo(slot, 3)
                task.wait(0.8)
                pcall(function() fireproximityprompt(prompt) end)
                task.wait(1)
            end
        end
    end
end

-- ══════════════════════════════════════════
--   SAFE CLICK HELPER
-- ══════════════════════════════════════════

local function acf_safeClick(btn)
    pcall(function() firesignal(btn.MouseButton1Click) end)
    pcall(function() btn.MouseButton1Click:Fire() end)
    pcall(function()
        local pos = btn.AbsolutePosition + (btn.AbsoluteSize / 2)
        VIM:SendMouseButtonEvent(pos.X, pos.Y, 0, true,  game, 0)
        task.wait(0.05)
        VIM:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 0)
    end)
end

-- ══════════════════════════════════════════
--   BOSS RAID TIMER HELPER
-- ══════════════════════════════════════════

local function acf_getBossRaidTimerInfo()
    local ok, result = pcall(function()
        local model = workspace:FindFirstChild("BossRaidModel")
        if not model then return nil end
        local gui   = model:FindFirstChild("Gui")
        if not gui  then return nil end
        local bb    = gui:FindFirstChild("BillboardGui")
        if not bb   then return nil end
        local timer = bb:FindFirstChild("Timer")
        if not timer then return nil end
        return timer.Text
    end)
    if not ok or result == nil then return false, "" end
    local text   = tostring(result)
    local isOpen = not text:lower():find("open in")
    return isOpen, text
end

-- ══════════════════════════════════════════
--   DYNAMIC CONFIG MODULES
-- ══════════════════════════════════════════

local acf_conveyorPacksModule = nil

local function acf_getPackConfig()
    if acf_conveyorPacksModule then return acf_conveyorPacksModule end
    local ok, module = pcall(function()
        return require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ConveyorPacks"))
    end)
    if ok and module then acf_conveyorPacksModule = module; return module end
    return nil
end

local function acf_getPackNames()
    local config = acf_getPackConfig()
    local names = {}
    if config then
        for _, pack in ipairs(config.List) do
            if pack.Id then table.insert(names, pack.Id) end
        end
    end
    return names
end

local function acf_getMutationNames()
    local config = acf_getPackConfig()
    local names = {}
    if config then
        for _, mut in ipairs(config.Mutations) do
            if mut.Name then table.insert(names, mut.Name) end
        end
    end
    return names
end

local function acf_getRarityNames()
    local config = acf_getPackConfig()
    local rarities = {}
    if config then
        for name, rank in pairs(config.RarityRank) do
            table.insert(rarities, { name = name, rank = rank })
        end
        table.sort(rarities, function(a, b) return a.rank < b.rank end)
    end
    local names = {}
    for _, r in ipairs(rarities) do table.insert(names, r.name) end
    return names
end

local acf_traitConfigModule = nil

local function acf_loadTraitConfig()
    local ok, module = pcall(function()
        return require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("TraitsConfig"))
    end)
    if ok and module and module.Traits then
        acf_traitConfigModule = module
        return module
    end
    return nil
end

local function acf_getTraitNames()
    local module = acf_loadTraitConfig()
    local names = {}
    if not module or not module.Traits then return names end
    local traitList = {}
    for name, data in pairs(module.Traits) do
        table.insert(traitList, { name = name, order = data.LayoutOrder or 999 })
    end
    table.sort(traitList, function(a, b) return a.order < b.order end)
    for _, t in ipairs(traitList) do table.insert(names, t.name) end
    return names
end

local function acf_getCardTrait(tool)
    if not tool then return nil end
    local trait = tool:GetAttribute("CardTrait")
    if trait and trait ~= "" then return trait end
    return nil
end

local function acf_traitMetTarget(currentTrait, targetTraits)
    if not targetTraits or not next(targetTraits) then return false end
    if not currentTrait or currentTrait == "" then return false end
    return targetTraits[currentTrait] == true
end

local acf_gradeConfigModule = nil
local acf_gradeRanks = {}

local function acf_loadGradeConfig()
    local ok, module = pcall(function()
        return require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("GradeRollConfig"))
    end)
    if ok and module and module.GetGrades then
        acf_gradeConfigModule = module
        acf_gradeRanks = { ["None"] = 0 }
        local grades = module.GetGrades()
        for i, entry in ipairs(grades) do acf_gradeRanks[entry.Grade] = i end
        return grades
    end
    acf_gradeRanks = {
        ["None"] = 0, ["F"] = 1,  ["E"] = 2,  ["D"] = 3,
        ["C"]    = 4, ["B"] = 5,  ["A"] = 6,  ["S"] = 7,
        ["SS"]   = 8, ["SR"] = 9, ["UR"] = 10, ["LR"] = 11,
    }
    return {
        {Grade="F"},{Grade="E"},{Grade="D"},{Grade="C"},{Grade="B"},
        {Grade="A"},{Grade="S"},{Grade="SS"},{Grade="SR"},{Grade="UR"},{Grade="LR"},
    }
end

local function acf_getGradeNames()
    local grades = acf_loadGradeConfig()
    local names = {}
    for _, entry in ipairs(grades) do table.insert(names, entry.Grade) end
    return names
end

local function acf_getCardGrade(tool)
    if not tool then return nil end
    local grade = tool:GetAttribute("CardGrade") or tool:GetAttribute("Grade")
    if grade then return grade end
    local gradeValue = tool:FindFirstChild("Grade")
    if gradeValue and gradeValue:IsA("StringValue") then return gradeValue.Value end
    return nil
end

local function acf_gradeMetTarget(currentGrade, targetGrades)
    if not targetGrades or not next(targetGrades) then return false end
    if not currentGrade then return false end
    return targetGrades[currentGrade] == true
end

-- ══════════════════════════════════════════
--   POTION CONFIG & HELPERS
-- ══════════════════════════════════════════

local acf_itemsConfigModule = nil
local acf_potionDisplayToId = {}
local acf_potionIdToDisplay = {}

local function acf_loadItemsConfig()
    if acf_itemsConfigModule then return acf_itemsConfigModule end
    local ok, module = pcall(function()
        return require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ItemsConfig"))
    end)
    if ok and module and module.Items then
        acf_itemsConfigModule = module
        return module
    end
    return nil
end

local function acf_getPotionDisplayNames()
    local config = acf_loadItemsConfig()
    acf_potionDisplayToId = {}
    acf_potionIdToDisplay = {}

    local list = {}

    if config and config.Items then
        for id, def in pairs(config.Items) do
            -- Only grab consumables that are potions (or have boosts/timeskips)
            if def.Type == "consumable" and (id:find("Potion") or def.Boost or def.TimeSkipSeconds) then
                local disp = def.DisplayName or id
                acf_potionDisplayToId[disp] = id
                acf_potionIdToDisplay[id] = disp
                table.insert(list, {
                    id          = id,
                    displayName = disp,
                    order       = tonumber(def.LayoutOrder) or 9999
                })
            end
        end
        table.sort(list, function(a, b) return a.order < b.order end)
    else
        -- Fallback if module fails
        local fallbacks = {
            { id = "CashPotion1",       displayName = "Cash I" },
            { id = "CashPotion2",       displayName = "Cash II" },
            { id = "CashPotion3",       displayName = "Cash III" },
            { id = "LuckPotion1",       displayName = "Luck I" },
            { id = "LuckPotion2",       displayName = "Luck II" },
            { id = "LuckPotion3",       displayName = "Luck III" },
            { id = "MutationPotion1",   displayName = "Mutation I" },
            { id = "MutationPotion2",   displayName = "Mutation II" },
            { id = "MutationPotion3",   displayName = "Mutation III" },
            { id = "ProductionPotion1", displayName = "Production I" },
            { id = "ProductionPotion2", displayName = "Production II" },
            { id = "ProductionPotion3", displayName = "Production III" },
            { id = "TimePotion1",       displayName = "Time I" },
            { id = "TimePotion2",       displayName = "Time II" },
            { id = "TimePotion3",       displayName = "Time III" },
        }
        for _, entry in ipairs(fallbacks) do
            acf_potionDisplayToId[entry.displayName] = entry.id
            acf_potionIdToDisplay[entry.id] = entry.displayName
            table.insert(list, entry)
        end
    end

    local displayNames = {}
    for _, item in ipairs(list) do
        table.insert(displayNames, item.displayName)
    end
    return displayNames
end

-- ══════════════════════════════════════════
--   INVENTORY CARD SCANNER
-- ══════════════════════════════════════════

local acf_cardInstanceMap = {}

local function acf_isCardTool(tool)
    local lower = tool.Name:lower()
    if lower:find("box")  then return false end
    if lower:find("pack") then return false end
    return true
end

local function acf_getAllCardTools()
    local allTools = {}
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") and acf_isCardTool(item) then
                table.insert(allTools, item)
            end
        end
    end
    local char = LocalPlayer.Character
    if char then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") and acf_isCardTool(item) then
                table.insert(allTools, item)
            end
        end
    end
    table.sort(allTools, function(a, b) return a.Name < b.Name end)
    return allTools
end

local function acf_getInventoryCardDisplayNames()
    acf_cardInstanceMap = {}
    local allTools  = acf_getAllCardTools()
    local nameCount = {}
    for _, tool in ipairs(allTools) do
        nameCount[tool.Name] = (nameCount[tool.Name] or 0) + 1
    end
    local nameIndex    = {}
    local displayNames = {}
    for _, tool in ipairs(allTools) do
        local baseName = tool.Name
        local grade    = acf_getCardGrade(tool) or "?"
        local trait    = acf_getCardTrait(tool)
        local bracket
        if trait and trait ~= "" and trait ~= "None" then
            bracket = "[" .. grade .. " / " .. trait .. "]"
        else
            bracket = "[" .. grade .. "]"
        end
        local displayName
        if nameCount[baseName] > 1 then
            nameIndex[baseName] = (nameIndex[baseName] or 0) + 1
            displayName = baseName .. " " .. bracket .. " #" .. nameIndex[baseName]
        else
            displayName = baseName .. " " .. bracket
        end
        acf_cardInstanceMap[displayName] = tool
        table.insert(displayNames, displayName)
    end
    return displayNames
end

-- ══════════════════════════════════════════
--   GRADE/TRAIT PROCESSORS
-- ══════════════════════════════════════════

local acf_selected_grade_baseNames = {}
local acf_selected_trait_baseNames = {}
local acf_selected_grade_displays = {}
local acf_selected_trait_displays = {}

local function acf_displaySelectionToBaseNames(selectedDisplays)
    local baseNames = {}
    for displayName, v in pairs(selectedDisplays) do
        if v == true then
            local tool = acf_cardInstanceMap[displayName]
            if tool then
                baseNames[tool.Name] = true
            else
                local baseName = displayName:match("^(.-)%s*%[") or displayName
                baseName = baseName:gsub("%s+$", "")
                if baseName ~= "" then baseNames[baseName] = true end
            end
        end
    end
    return baseNames
end

local function acf_resolveToolsByBaseName(baseNameSet)
    if not next(baseNameSet) then return {} end
    local allTools  = acf_getAllCardTools()
    local result = {}
    for _, tool in ipairs(allTools) do
        if baseNameSet[tool.Name] then
            table.insert(result, tool)
        end
    end
    return result
end

-- ══════════════════════════════════════════
--   GLOBAL VARIABLES & STATES
-- ══════════════════════════════════════════

local acf_isLoadingConfig = false
local acf_farm_paused     = false

local acf_spawn_delay       = 1
local acf_buy_delay         = 0.1
local acf_sell_delay        = 1.0
local acf_place_delay       = 0.5
local acf_open_delay        = 0.5
local acf_upgrade_delay     = 0.1
local acf_tower_delay       = 3
local acf_cardupgrade_delay = 0.05
local acf_grade_delay       = 0.5
local acf_trait_delay       = 0.5
local acf_bossraid_difficulty = "Hard"

local acf_tower_last_floor        = -1
local acf_tower_floor_stuck_start = 0
local acf_tower_no_gui_start      = 0
local acf_tower_session_id        = 0
local acf_tower_in_raid_process   = false
local acf_tower_exit_floor        = 0

local acf_selectedPacks      = {}
local acf_selectedMutations  = {}
local acf_selectedRarities   = {}
local acf_selectedPlacePacks = {}
local acf_buyFilterEnabled   = false
local acf_grade_currency     = "cash"
local acf_target_grades      = {}
local acf_target_traits      = {}
local acf_packInfoCache      = {}

local acf_upgradeStates = {
    speed = false, time = false, cash = false, luck = false, base = false,
}

local acf_bossRaidDoneThisWindow = false
local acf_bossRaidWasOpen        = false

local acf_selected_potions = {}
local acf_potion_delay     = 1.0

-- ══════════════════════════════════════════
--   CONVEYOR NETWORKING
-- ══════════════════════════════════════════

local function acf_shouldBuy(itemId)
    if not acf_buyFilterEnabled then return true end
    local info = acf_packInfoCache[itemId]
    if not info then return true end
    if next(acf_selectedPacks)     and not acf_selectedPacks[info.PackId]       then return false end
    if next(acf_selectedMutations) and not acf_selectedMutations[info.Mutation] then return false end
    if next(acf_selectedRarities)  and not acf_selectedRarities[info.Rarity]    then return false end
    return true
end

ConveyorRE.OnClientEvent:Connect(function(action, data)
    if not data then return end
    if data.PlotNumber ~= acf_plotNumber then return end
    if action == "SpawnAndMoveToB" and data.ItemId then
        acf_packInfoCache[data.ItemId] = {
            PackId   = data.PackId   or "Unknown",
            Rarity   = data.Rarity   or "Unknown",
            Mutation = data.Mutation or "Normal",
            Price    = data.Price    or 0,
        }
    end
    if action == "PackAtB" and isOn("AutoBuy") and data.ItemId then
        if acf_shouldBuy(data.ItemId) then
            task.wait(acf_buy_delay)
            pcall(function()
                ConveyorRE:FireServer("TryBuy", { ItemId = data.ItemId })
            end)
            SessionStats.packsBought = SessionStats.packsBought + 1
        end
        local count = 0
        for _ in pairs(acf_packInfoCache) do count = count + 1 end
        if count > 50 then
            local toRemove = {}
            local i = 0
            for k in pairs(acf_packInfoCache) do
                i = i + 1
                if i <= count - 50 then table.insert(toRemove, k) end
            end
            for _, k in ipairs(toRemove) do acf_packInfoCache[k] = nil end
        end
    end
end)

-- ══════════════════════════════════════════
--   TOWER CORE MODULE
-- ══════════════════════════════════════════

local function acf_getTowerBattleFrame()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil end
    local ok, frame = pcall(function()
        return pg.InfinityTowerGui.Handler.InfinityTowerFrame
    end)
    if ok and frame and frame:IsA("Frame") then return frame end
    return nil
end

local function acf_enableAutoReplay(frame, maxAttempts)
    maxAttempts = maxAttempts or 10
    if not frame then return end
    for attempt = 1, maxAttempts do
        pcall(function() acf_safeClick(frame.AutoReplay) end)
        task.wait(0.3)
        local arBtn = frame:FindFirstChild("AutoReplay")
        if arBtn then
            local indicator = arBtn:FindFirstChild("Active")
                           or arBtn:FindFirstChild("On")
                           or arBtn:FindFirstChild("Check")
            if indicator and (indicator.Value == true or indicator.Visible == true) then return end
        end
    end
end

local function acf_launchTower()
    acf_tower_session_id = acf_tower_session_id + 1
    local mySession = acf_tower_session_id
    local pg = LocalPlayer:WaitForChild("PlayerGui")

    acf_fireEquipBest()
    task.wait(1)

    local savedSlots = acf_removeCardsFromSlots(4)
    task.wait(0.5)

    for _ = 1, 3 do
        pcall(function() acf_safeClick(pg.GuiMid.InfinityTower.InfinityTowerFrame.EQUIPEBEST) end)
        task.wait(0.5)
    end

    for _ = 1, 3 do
        pcall(function() acf_safeClick(pg.GuiMid.InfinityTower.InfinityTowerFrame.BATTLE) end)
        task.wait(0.5)
    end

    local battleFrame = nil
    for _ = 1, 20 do
        battleFrame = acf_getTowerBattleFrame()
        if battleFrame and battleFrame.Visible then break end
        task.wait(0.5)
    end

    if battleFrame then acf_enableAutoReplay(battleFrame, 10) end

    pcall(function() acf_safeClick(pg.GuiMid.HideBattle.Hide) end)
    task.wait(0.5)

    acf_restoreCardsToSlots(savedSlots)

    acf_tower_last_floor        = -1
    acf_tower_floor_stuck_start = tick()
    acf_tower_no_gui_start      = 0

    Library:Notify("Auto Tower - Running! Session #" .. mySession .. " - Cards restored.")
    return mySession
end

-- ══════════════════════════════════════════
--   KNOWN REDEEM CODES
-- ══════════════════════════════════════════

local acf_knownCodes = {
    { code = "POTIONS", reward = "1x Cash Potion, 1x Luck Potion, 1x Mutation Potion" },
    { code = "TRAIT!",  reward = "1x Time II Potion, 100x Trait Gems" },
}

-- ══════════════════════════════════════════
--   CHAR CACHING (NOCLIP SPEED BOOSTER)
-- ══════════════════════════════════════════

local function updateCharParts(char)
    table.clear(characterParts)
    if not char then return end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            table.insert(characterParts, p)
        end
    end
end

local charAddedConn = LocalPlayer.CharacterAdded:Connect(function(char)
    updateCharParts(char)
    local childAdded = char.DescendantAdded:Connect(function(p)
        if p:IsA("BasePart") then table.insert(characterParts, p) end
    end)
    local childRemoved = char.DescendantRemoving:Connect(function(p)
        local idx = table.find(characterParts, p)
        if idx then table.remove(characterParts, idx) end
    end)
    local deathConn
    deathConn = char:WaitForChild("Humanoid").Died:Connect(function()
        childAdded:Disconnect()
        childRemoved:Disconnect()
        deathConn:Disconnect()
    end)
end)

if LocalPlayer.Character then
    updateCharParts(LocalPlayer.Character)
end

-- ══════════════════════════════════════════
--   CREATE WINDOW
-- ══════════════════════════════════════════

local Window = Library:CreateWindow({
    Title            = "Prism",
    Footer           = "Prism  |  Anime Card Farm  |  v3.1",
    Icon             = "rbxassetid://117487160988921",
    MobileButtonSide = "Right",
    NotifySide       = "Right",
    ShowCustomCursor = false,
    CornerRadius     = 2,
	Animations = {
		ToggleWindow = false, -- Fade/scale the window when it is shown or hidden
		TabSwitch = true, -- Fade + slide the tab content when you switch tabs
		Groupbox = false,
		Dropdown = true,
		KeyPicker = true,
		SubTabUnderline = true, -- Slide the underline under the active sub tab (Default value = true)
	},
})

-- ══════════════════════════════════════════
--   TABS
-- ══════════════════════════════════════════

local Tabs = {
    Info     = Window:AddTab("Info",      "activity"),
    Main     = Window:AddTab("Main",      "zap"),
    Conveyor = Window:AddTab("Conveyor",  "package"),
    Cards    = Window:AddTab("Cards",     "layers"),
    Grading  = Window:AddTab("Grading",   "sparkles"),
    Upgrades = Window:AddTab("Upgrades",  "trending-up"),
    Potions  = Window:AddTab("Potions",   "droplet"),     -- <-- ADD THIS HERE
    Tower    = Window:AddTab("Tower",     "swords"),
    BossRaid = Window:AddTab("Boss Raid", "shield"),
    Player   = Window:AddTab("Player",    "user-check"),
    Settings = Window:AddTab("Settings",  "settings"),
}

Tabs.Spawn     = Tabs.Conveyor:AddSubTab("Spawn",    "plus-circle")
Tabs.Buy       = Tabs.Conveyor:AddSubTab("Buy",      "shopping-cart")
Tabs.BuyFilter = Tabs.Conveyor:AddSubTab("Filters",  "funnel")
Tabs.CarrySell = Tabs.Conveyor:AddSubTab("Carry",    "box")

Tabs.Place     = Tabs.Cards:AddSubTab("Place & Open", "hand")
Tabs.Equip     = Tabs.Cards:AddSubTab("Equip",        "award")
Tabs.Sell      = Tabs.Cards:AddSubTab("Sell",          "dollar-sign")

Tabs.Grade     = Tabs.Grading:AddSubTab("Grade",      "sparkles")
Tabs.Trait     = Tabs.Grading:AddSubTab("Trait",       "gem")

Tabs.StatUpg   = Tabs.Upgrades:AddSubTab("Stats",     "trending-up")
Tabs.ConvUpg   = Tabs.Upgrades:AddSubTab("Conveyor",  "zap")


-- ══════════════════════════════════════════
--   INFO TAB (GRADIENT ENABLED)
-- ══════════════════════════════════════════

do
    local PrismBox = Tabs.Info:AddLeftGroupbox("Prism", "sparkles")
    PrismBox:AddLabel(sz(b(createMultiGradientText("PRISM", PALETTE.prism)), 20), true)
    PrismBox:AddLabel(c(i("keyless forever, always will be"), "#9ca3af"), true)
    PrismBox:AddLabel(
        c(b("status "),  "#6b7280") .. c(b("online"), "#4ade80") ..
        c("     ",       "#374151") ..
        c(b("version "), "#6b7280") .. c(b("3.1"), "#38bdf8"),
    true)
    PrismBox:AddDivider()
    PrismBox:AddLabel(sz(b(createMultiGradientText("if you enjoy the script or want to report a bug, please consider the following:", PALETTE.ice)), 14), true)
    PrismBox:AddLabel(sz(b(createMultiGradientText("more than 60 keyless scripts in this hub, I would love your support!", PALETTE.ice)), 14), true)    PrismBox:AddButton({ Text = "Discord for Support 💝",     Func = function() copyText(DISCORD_INVITE, "Discord invite copied!") end })
    PrismBox:AddButton({ Text = "Follow Rscripts 🙏", Func = function() copyText(RSCRIPTS_LINK, "Rscripts link copied!") end })

    local FeaturesBox = Tabs.Info:AddLeftGroupbox("Features", "layers")
    local featureList = {
        "Auto Spawn Packs",
        "Auto Buy Packs",
        "Auto Place Packs",
        "Auto Open Packs",
        "Auto Take out Cards When Full",
        "Auto Equip Best Cards",
        "Auto Infinity Tower",
        "Auto Boss Raid",
        "Auto Grade",
        "Auto Trait",
        "Auto Conveyor Upgrades",
        "Auto Stat Upgrades",
        "Anti AFK",
        "Fly, NoClip, WalkSpeed",
    }
    for _, item in ipairs(featureList) do
        FeaturesBox:AddLabel(gradPlus(PALETTE.prism) .. c(" " .. item, "#f3f4f6"), true)
    end

    local DiagnosticBox = Tabs.Info:AddRightGroupbox("Live", "cpu")
    local FpsLabel     = DiagnosticBox:AddLabel(b("FPS: ")    .. c("...", "#60a5fa"), true)
    local PingLabel    = DiagnosticBox:AddLabel(b("Ping: ")   .. c("...", "#4ade80"), true)
    local MemoryLabel  = DiagnosticBox:AddLabel(b("Memory: ") .. c("...", "#fbbf24"), true)
    local SessionLabel = DiagnosticBox:AddLabel(b("Uptime: ") .. c("0s",  "#a78bfa"), true)

    local sessionStart = SessionStats.startTime
    local frameCount = 0
    local lastFpsUpdate = os.clock()

    RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local now = os.clock()
        if now - lastFpsUpdate >= 0.5 then
            local fps = math.floor(frameCount / (now - lastFpsUpdate))
            frameCount = 0
            lastFpsUpdate = now
            if not Library.Unloaded then
                local ping = math.floor(StatsService.PerformanceStats.Ping:GetValue())
                local mem  = math.floor(StatsService:GetTotalMemoryUsageMb())
                local fpsColor  = fps > 45 and "#4ade80" or (fps > 25 and "#fbbf24" or "#ef4444")
                local pingColor = ping < 80 and "#4ade80" or (ping < 150 and "#fbbf24" or "#ef4444")
                FpsLabel:SetText(b("FPS: ")    .. c(tostring(fps), fpsColor))
                PingLabel:SetText(b("Ping: ")  .. c(tostring(ping) .. " ms", pingColor))
                MemoryLabel:SetText(b("Memory: ") .. c(tostring(mem) .. " MB", "#fbbf24"))
            end
        end
    end)

    task.spawn(function()
        while not Library.Unloaded do
            task.wait(1)
            SessionLabel:SetText(b("Uptime: ") .. c(formatDuration(os.clock() - sessionStart), "#a78bfa"))
        end
    end)

    local SessionBox = Tabs.Info:AddRightGroupbox("Roblox", "server")
    SessionBox:AddLabel(b(createMultiGradientText("EXTRA INFO", PALETTE.aurora)), true)
    SessionBox:AddDivider()
    SessionBox:AddLabel(b("User: ")     .. c(LocalPlayer.Name, "#ffffff"), true)
    SessionBox:AddLabel(b("Executor: ") .. c(executorName, "#fb923c"), true)
    SessionBox:AddLabel(b("Place ID: ") .. c(tostring(game.PlaceId), "#60a5fa"), true)
    SessionBox:AddLabel(b("Job ID: ")   .. c(string.sub(tostring(game.JobId), 1, 14) .. "...", "#9ca3af"), true)
    SessionBox:AddDivider()
    SessionBox:AddButton({
        Text = "Copy Server ID",
        Func = function() copyText(game.JobId, "Server JobId copied!") end,
    })
    SessionBox:AddButton({
        Text = "Copy Rejoin Script",
        Func = function()
            copyText(string.format('game:GetService("TeleportService"):TeleportToPlaceInstance(%s, "%s", game.Players.LocalPlayer)', game.PlaceId, game.JobId), "Rejoin script copied!")
        end,
    })
end

-- ══════════════════════════════════════════
--   MAIN TAB (NO GRADIENTS)
-- ══════════════════════════════════════════

do
    local EssentialGroup = Tabs.Main:AddLeftGroupbox("Automation", "zap")
    EssentialGroup:AddLabel(b("CORE AUTOMATION"), true)
    EssentialGroup:AddDivider()
    EssentialGroup:AddToggle("AutoPlaytime",  { Text = "Auto Claim Playtime Rewards", Default = false, Tooltip = "Claims playtime reward slots 1-12 every 30 seconds" })

    local CodesGroup = Tabs.Main:AddLeftGroupbox("Redeem Codes", "gift")
    CodesGroup:AddLabel(b("CODE REDEEMER"), true)
    CodesGroup:AddDivider()
    for _, entry in ipairs(acf_knownCodes) do
        CodesGroup:AddLabel(b(entry.code) .. " - " .. entry.reward, true)
    end
    CodesGroup:AddDivider()
    CodesGroup:AddButton({
        Text = "Redeem All Known Codes",
        Func = function()
            Library:Notify("Redeeming Codes - Attempting all codes...")
            task.spawn(function()
                local CodesRE = Remotes:FindFirstChild("CodesRE")
                if not CodesRE then Library:Notify("Error - CodesRE not found!"); return end
                for _, entry in ipairs(acf_knownCodes) do
                    pcall(function() CodesRE:FireServer("Redeem", entry.code) end)
                    task.wait(3.5)
                end
                Library:Notify("Codes Redeemed - All codes submitted!")
            end)
        end,
    })
    CodesGroup:AddDivider()
    CodesGroup:AddInput("CodeInput", {
        Default = "", Numeric = false, Finished = false,
        Text = "Enter Code", Placeholder = "Enter code here...",
    })
    CodesGroup:AddButton({
        Text = "Redeem Custom Code",
        Func = function()
            local code = Options.CodeInput and Options.CodeInput.Value or ""
            if code == "" then Library:Notify("Redeem - Please enter a code first!"); return end
            local CodesRE = Remotes:FindFirstChild("CodesRE")
            if CodesRE then
                pcall(function() CodesRE:FireServer("Redeem", code) end)
                Library:Notify("Code Submitted - '" .. code .. "'!")
            end
        end,
    })

    local StatsGroup = Tabs.Main:AddRightGroupbox("Live Stats", "trending-up")
    StatsGroup:AddLabel(b("YOUR PROGRESS"), true)
    StatsGroup:AddDivider()
    local PlotLabel           = StatsGroup:AddLabel(b("Plot Number: ") .. c("...", "#fbbf24"), true)
    StatsGroup:AddDivider()
    local PacksLabel          = StatsGroup:AddLabel(b("Packs Bought: ") .. c("0", "#38bdf8"), true)
    local CardsGradedLabel    = StatsGroup:AddLabel(b("Cards Graded: ") .. c("0", "#a78bfa"), true)
    local TraitsRolledLabel   = StatsGroup:AddLabel(b("Traits Rolled: ") .. c("0", "#ec4899"), true)
    local RaidsCompletedLabel = StatsGroup:AddLabel(b("Raids Completed: ") .. c("0", "#ef4444"), true)
    local FloorsClearedLabel  = StatsGroup:AddLabel(b("Tower Floors: ") .. c("0", "#4ade80"), true)

    task.spawn(function()
        while not Library.Unloaded do
            task.wait(2)
            PlotLabel:SetText(b("Plot Number: ") .. c(tostring(acf_plotNumber or "N/A"), "#fbbf24"))
            PacksLabel:SetText(b("Packs Bought: ") .. c(formatNumber(SessionStats.packsBought), "#38bdf8"))
            CardsGradedLabel:SetText(b("Cards Graded: ") .. c(formatNumber(SessionStats.cardsGraded), "#a78bfa"))
            TraitsRolledLabel:SetText(b("Traits Rolled: ") .. c(formatNumber(SessionStats.traitsRolled), "#ec4899"))
            RaidsCompletedLabel:SetText(b("Raids Completed: ") .. c(formatNumber(SessionStats.raidsCompleted), "#ef4444"))
            FloorsClearedLabel:SetText(b("Tower Floors: ") .. c(formatNumber(SessionStats.floorsCleared), "#4ade80"))
        end
    end)
end

-- ══════════════════════════════════════════
--   CONVEYOR SUBTABS (NO GRADIENTS)
-- ══════════════════════════════════════════

do
    local SpawnGroup = Tabs.Spawn:AddLeftGroupbox("Auto Spawn", "plus-circle")
    SpawnGroup:AddLabel(b("SPAWN SETTINGS"), true)
    SpawnGroup:AddDivider()
    SpawnGroup:AddToggle("AutoSpawn", { Text = "Auto Spawn Packs", Default = false })
    SpawnGroup:AddSlider("SpawnDelay", {
        Text = "Spawn Delay (s)", Default = 1, Min = 0.1, Max = 5, Rounding = 2,
        Callback = function(v) acf_spawn_delay = v end,
    })
end

do
    local BuyGroup = Tabs.Buy:AddLeftGroupbox("Auto Buy", "shopping-cart")
    BuyGroup:AddLabel(b("BUY SETTINGS"), true)
    BuyGroup:AddDivider()
    BuyGroup:AddToggle("AutoBuy", { Text = "Auto Buy Packs", Default = false })
    BuyGroup:AddSlider("BuyDelay", {
        Text = "Buy Delay (s)", Default = 0.1, Min = 0, Max = 3, Rounding = 2,
        Callback = function(v) acf_buy_delay = v end,
    })
end

do
    local FilterGroup = Tabs.BuyFilter:AddLeftGroupbox("Buy Filters", "filter")
    FilterGroup:AddLabel(b("PACK FILTERS"), true)
    FilterGroup:AddDivider()
    FilterGroup:AddToggle("EnableBuyFilter", {
        Text    = "Enable Buy Filters",
        Default = false,
        Tooltip = "When disabled buys ALL packs. When enabled only buys matching packs.",
        Callback = function(v) acf_buyFilterEnabled = v end,
    })
    FilterGroup:AddDropdown("PackFilter", {
        Values = acf_getPackNames(), Multi = true, Text = "Filter by Pack",
        Callback = function(selected)
            acf_selectedPacks = {}
            if type(selected) == "table" then
                for k, v in pairs(selected) do
                    if type(k) == "string" and v == true then acf_selectedPacks[k] = true end
                end
            end
        end,
    })
    FilterGroup:AddDropdown("MutationFilter", {
        Values = acf_getMutationNames(), Multi = true, Text = "Filter by Mutation",
        Callback = function(selected)
            acf_selectedMutations = {}
            if type(selected) == "table" then
                for k, v in pairs(selected) do
                    if type(k) == "string" and v == true then acf_selectedMutations[k] = true end
                end
            end
        end,
    })
    FilterGroup:AddDropdown("RarityFilter", {
        Values = acf_getRarityNames(), Multi = true, Text = "Filter by Rarity",
        Callback = function(selected)
            acf_selectedRarities = {}
            if type(selected) == "table" then
                for k, v in pairs(selected) do
                    if type(k) == "string" and v == true then acf_selectedRarities[k] = true end
                end
            end
        end,
    })
    FilterGroup:AddButton({
        Text = "Refresh Filter Options",
        Func = function()
            acf_conveyorPacksModule = nil
            local packs     = acf_getPackNames()
            local mutations = acf_getMutationNames()
            local rarities  = acf_getRarityNames()
            Options.PackFilter:SetValues(packs)
            Options.MutationFilter:SetValues(mutations)
            Options.RarityFilter:SetValues(rarities)
            if Options.PlacePackFilter then Options.PlacePackFilter:SetValues(packs) end
            Library:Notify("Lists Refreshed - " .. #packs .. " packs, " .. #mutations .. " mutations, " .. #rarities .. " rarities!")
        end,
    })
end

do
    local CarryGroup = Tabs.CarrySell:AddLeftGroupbox("Auto Carry", "box")
    CarryGroup:AddLabel(b("CARRY & SELL"), true)
    CarryGroup:AddDivider()
    CarryGroup:AddToggle("AutoCarrySell", { Text = "Auto Carry & Sell Boxes", Default = false })
    CarryGroup:AddSlider("SellDelay", {
        Text = "Cycle Delay (s)", Default = 1.0, Min = 0.5, Max = 10, Rounding = 1,
        Callback = function(v) acf_sell_delay = v end,
    })
end

-- ══════════════════════════════════════════
--   CARDS SUBTABS (NO GRADIENTS)
-- ══════════════════════════════════════════

do
    local PlaceGroup = Tabs.Place:AddLeftGroupbox("Placement", "layout")
    PlaceGroup:AddLabel(b("AUTO PLACE & OPEN"), true)
    PlaceGroup:AddDivider()
    PlaceGroup:AddDropdown("PlacePackFilter", {
        Values = acf_getPackNames(), Multi = true, Text = "Select Packs to Place",
        Callback = function(selected)
            acf_selectedPlacePacks = {}
            if type(selected) == "table" then
                for k, v in pairs(selected) do
                    if type(k) == "string" and v == true then acf_selectedPlacePacks[k] = true end
                end
            end
        end,
    })
    PlaceGroup:AddToggle("AutoRemoveForPlace", { Text = "Auto Remove Cards if Full", Default = false })
    PlaceGroup:AddToggle("AutoPlace",          { Text = "Auto Place Packs on Slots", Default = false })
    PlaceGroup:AddSlider("PlaceDelay", {
        Text = "Place Delay (s)", Default = 0.5, Min = 0.1, Max = 3, Rounding = 2,
        Callback = function(v) acf_place_delay = v end,
    })
    PlaceGroup:AddToggle("AutoOpen", { Text = "Auto Open Placed Packs", Default = false })
    PlaceGroup:AddSlider("OpenDelay", {
        Text = "Open Delay (s)", Default = 0.5, Min = 0.1, Max = 5, Rounding = 2,
        Callback = function(v) acf_open_delay = v end,
    })
end

do
    local EquipGroup = Tabs.Equip:AddLeftGroupbox("Equip", "award")
    EquipGroup:AddLabel(b("EQUIP & UPGRADE"), true)
    EquipGroup:AddDivider()
    EquipGroup:AddToggle("AutoEquipBest", { Text = "Auto Equip Best Cards", Default = false })
    EquipGroup:AddToggle("AutoUpgradeCards", { Text = "Auto Upgrade Cards (All Slots)", Default = false })
    EquipGroup:AddSlider("CardUpgradeDelay", {
        Text = "Upgrade Delay (s)", Default = 0.05, Min = 0.01, Max = 1, Rounding = 2,
        Callback = function(v) acf_cardupgrade_delay = v end,
    })
end

do
    local SellGroup = Tabs.Sell:AddLeftGroupbox("Sell System", "dollar-sign")
    SellGroup:AddLabel(b("AUTO SELL CARDS"), true)
    SellGroup:AddDivider()
    SellGroup:AddToggle("AutoSellAll",   { Text = "Auto Sell All",        Default = false })
    SellGroup:AddToggle("AutoSellCards", { Text = "Auto Sell Cards Only", Default = false })
    SellGroup:AddToggle("AutoSellPacks", { Text = "Auto Sell Packs Only", Default = false })
    SellGroup:AddToggle("AutoSellHand",  { Text = "Auto Sell Hand",       Default = false })
end

-- ══════════════════════════════════════════
--   GRADING SUBTABS (NO GRADIENTS)
-- ══════════════════════════════════════════

local acf_initialCardDisplayNames = acf_getInventoryCardDisplayNames()

local function acf_refreshCardDropdowns()
    local displayNames = acf_getInventoryCardDisplayNames()
    if Options.GradeCardSelect then Options.GradeCardSelect:SetValues(displayNames) end
    if Options.TraitCardSelect then Options.TraitCardSelect:SetValues(displayNames) end
    Library:Notify("Cards Refreshed - Found " .. #displayNames .. " card instance(s)!")
end

do
    local GradeGroup = Tabs.Grade:AddLeftGroupbox("Auto Grade", "sparkles")
    GradeGroup:AddLabel(b("GRADE MODIFICATIONS"), true)
    GradeGroup:AddDivider()
    GradeGroup:AddLabel(c(i("Selection is tracked by card name - grades update live."), "#9ca3af"), true)
    GradeGroup:AddDivider()
    GradeGroup:AddDropdown("GradeCardSelect", {
        Values     = acf_initialCardDisplayNames,
        Multi      = true,
        Text       = "Select Cards to Grade",
        Searchable = true,
        Callback   = function(selected)
            acf_selected_grade_displays = {}
            if type(selected) == "table" then
                for k, v in pairs(selected) do
                    if type(k) == "string" and v == true then
                        acf_selected_grade_displays[k] = true
                    end
                end
            end
            acf_selected_grade_baseNames = acf_displaySelectionToBaseNames(acf_selected_grade_displays)
        end,
    })
    GradeGroup:AddButton({ Text = "Refresh Card List", Func = acf_refreshCardDropdowns })
    GradeGroup:AddDivider()
    GradeGroup:AddDropdown("GradeCurrency", {
        Values = { "Cash", "Gems" }, Default = "Cash", Multi = false, Text = "Currency to Use",
        Callback = function(v) acf_grade_currency = v:lower() end,
    })
    GradeGroup:AddDropdown("TargetGrade", {
        Values = acf_getGradeNames(), Default = 1, Multi = true, Text = "Stop at Grade(s)",
        Callback = function(selected)
            acf_target_grades = {}
            if type(selected) == "table" then
                for k, v in pairs(selected) do
                    if type(k) == "string" and v == true then acf_target_grades[k] = true end
                end
            end
        end,
    })
    GradeGroup:AddDivider()
    GradeGroup:AddToggle("AutoGrade", { Text = "Auto Grade Selected Cards", Default = false })
    GradeGroup:AddSlider("GradeDelay", {
        Text = "Grade Delay (s)", Default = 0.5, Min = 0.1, Max = 3, Rounding = 2,
        Callback = function(v) acf_grade_delay = v end,
    })
end

do
    local TraitGroup = Tabs.Trait:AddLeftGroupbox("Auto Trait", "gem")
    TraitGroup:AddLabel(b("TRAIT ROLLING"), true)
    TraitGroup:AddDivider()
    TraitGroup:AddLabel(c(i("Selection is tracked by card name - traits update live."), "#9ca3af"), true)
    TraitGroup:AddDivider()
    TraitGroup:AddDropdown("TraitCardSelect", {
        Values     = acf_initialCardDisplayNames,
        Multi      = true,
        Text       = "Select Cards to Trait Roll",
        Searchable = true,
        Callback   = function(selected)
            acf_selected_trait_displays = {}
            if type(selected) == "table" then
                for k, v in pairs(selected) do
                    if type(k) == "string" and v == true then
                        acf_selected_trait_displays[k] = true
                    end
                end
            end
            acf_selected_trait_baseNames = acf_displaySelectionToBaseNames(acf_selected_trait_displays)
        end,
    })
    TraitGroup:AddButton({ Text = "Refresh Card List", Func = acf_refreshCardDropdowns })
    TraitGroup:AddDivider()
    TraitGroup:AddDropdown("TargetTrait", {
        Values     = acf_getTraitNames(),
        Default    = 1,
        Multi      = true,
        Text       = "Stop at Trait(s)",
        Searchable = true,
        Callback   = function(selected)
            acf_target_traits = {}
            if type(selected) == "table" then
                for k, v in pairs(selected) do
                    if type(k) == "string" and v == true then acf_target_traits[k] = true end
                end
            end
        end,
    })
    TraitGroup:AddDivider()
    TraitGroup:AddToggle("AutoTrait", { Text = "Auto Trait Roll Selected Cards", Default = false })
    TraitGroup:AddSlider("TraitDelay", {
        Text = "Trait Roll Delay (s)", Default = 0.5, Min = 0.1, Max = 3, Rounding = 2,
        Callback = function(v) acf_trait_delay = v end,
    })
    TraitGroup:AddDivider()
    TraitGroup:AddButton({
        Text = "Check Current Grades & Traits",
        Func = function()
            local displayNames = acf_getInventoryCardDisplayNames()
            if #displayNames > 0 then
                local text = table.concat(displayNames, "\n")
                if setclipboard then setclipboard(text) end
                Library:Notify("Info Copied! - " .. #displayNames .. " card(s) info copied to clipboard!")
            else
                Library:Notify("No Cards - No cards found in inventory.")
            end
        end,
    })
end

-- ══════════════════════════════════════════
--   UPGRADES SUBTABS (NO GRADIENTS)
-- ══════════════════════════════════════════

local acf_upgradeMap = {
    { id = "speed", label = "Speed Boost" },
    { id = "time",  label = "Time Boost" },
    { id = "cash",  label = "Cash Boost" },
    { id = "luck",  label = "Luck Boost" },
    { id = "base",  label = "Base Expansion" },
}

do
    local StatUpgGroup = Tabs.StatUpg:AddLeftGroupbox("Auto Upgrades", "trending-up")
    StatUpgGroup:AddLabel(b("STAT BOOSTERS"), true)
    StatUpgGroup:AddDivider()
    for _, upgrade in ipairs(acf_upgradeMap) do
        StatUpgGroup:AddToggle("AutoUpgrade_" .. upgrade.id, {
            Text    = "Auto " .. upgrade.label,
            Default = false,
            Callback = function(v) acf_upgradeStates[upgrade.id] = v end,
        })
    end
    StatUpgGroup:AddSlider("UpgradeDelay", {
        Text = "Upgrade Delay (s)", Default = 0.1, Min = 0.05, Max = 2, Rounding = 2,
        Callback = function(v) acf_upgrade_delay = v end,
    })
end

do
    local ConvUpgGroup = Tabs.ConvUpg:AddLeftGroupbox("Conveyor Upgrade", "zap")
    ConvUpgGroup:AddLabel(b("CONVEYOR ENGINE"), true)
    ConvUpgGroup:AddDivider()
    ConvUpgGroup:AddToggle("AutoConveyorUpgrade", { Text = "Auto Upgrade Conveyor", Default = false })
end

do
    local PotionGroup = Tabs.Potions:AddLeftGroupbox("Auto Potions", "droplet")
    PotionGroup:AddLabel(b("POTION CONSUMPTION"), true)
    PotionGroup:AddDivider()

    local potionOptions = acf_getPotionDisplayNames()

    PotionGroup:AddDropdown("PotionSelect", {
        Values     = potionOptions,
        Multi      = true,
        Text       = "Select Potions to Auto-Use",
        Searchable = true,
        Callback   = function(selected)
            acf_selected_potions = {}
            if type(selected) == "table" then
                for dispName, state in pairs(selected) do
                    if state == true then
                        local rawId = acf_potionDisplayToId[dispName]
                        if rawId then
                            acf_selected_potions[rawId] = true
                        end
                    end
                end
            end
        end,
    })

    PotionGroup:AddToggle("AutoUsePotions", {
        Text    = "Auto Use Selected Potions",
        Default = false,
        Tooltip = "Continuously uses chosen potions when off cooldown / depleted.",
    })

    PotionGroup:AddSlider("PotionDelay", {
        Text     = "Use Delay (s)",
        Default  = 1.0,
        Min      = 0.1,
        Max      = 10.0,
        Rounding = 1,
        Callback = function(v) acf_potion_delay = v end,
    })
end

-- ══════════════════════════════════════════
--   INFINITY TOWER (NO GRADIENTS)
-- ══════════════════════════════════════════

do
    local TowerGroup = Tabs.Tower:AddLeftGroupbox("Auto Tower", "swords")
    TowerGroup:AddLabel(b("AUTO TOWER"), true)
    TowerGroup:AddDivider()
    TowerGroup:AddDropdown("TowerExitFloor", {
        Values = (function()
            local v = { "Never" }
            for i = 1, 1000 do table.insert(v, tostring(i)) end
            return v
        end)(),
        Default    = "Never",
        Text       = "Exit at Floor",
        Searchable = true,
        Callback   = function(v) acf_tower_exit_floor = (v == "Never") and 0 or (tonumber(v) or 0) end,
    })
    TowerGroup:AddToggle("AutoTower", { Text = "Auto Infinity Tower", Default = false })
end

-- ══════════════════════════════════════════
--   BOSS RAID (NO GRADIENTS)
-- ══════════════════════════════════════════

do
    local BossRaidGroup = Tabs.BossRaid:AddLeftGroupbox("Auto Boss Raid", "shield")
    BossRaidGroup:AddLabel(b("RAID SETTINGS"), true)
    BossRaidGroup:AddDivider()
    BossRaidGroup:AddDropdown("BossRaidDifficulty", {
        Values  = { "Easy", "Medium", "Hard", "Nightmare" },
        Default = "Hard",
        Text    = "Difficulty",
        Callback = function(v) acf_bossraid_difficulty = v end,
    })
    BossRaidGroup:AddToggle("AutoBossRaid", { Text = "Auto Boss Raid (timer-based)", Default = false })

    local BossRaidInfoGroup = Tabs.BossRaid:AddRightGroupbox("Info", "info")
    BossRaidInfoGroup:AddLabel(b("RAID UTILITIES"), true)
    BossRaidInfoGroup:AddDivider()
    BossRaidInfoGroup:AddLabel("Timer status (read-only):", false)
    BossRaidInfoGroup:AddButton({
        Text = "Check Raid Timer Now",
        Func = function()
            local isOpen, text = acf_getBossRaidTimerInfo()
            local status = isOpen and "OPEN - " or "Waiting - "
            Library:Notify("Boss Raid Timer - " .. status .. tostring(text))
        end,
    })
    BossRaidInfoGroup:AddDivider()
    BossRaidInfoGroup:AddLabel("Manual - fires one raid right now:", true)
    BossRaidInfoGroup:AddButton({
        Text = "Do ONE Raid Now (Manual)",
        Func = function()
            task.spawn(function()
                Library:Notify("Boss Raid - Manual raid on " .. acf_bossraid_difficulty .. "...")
                local pg = LocalPlayer:WaitForChild("PlayerGui")

                if isOn("AutoTower") then
                    acf_tower_in_raid_process = true
                    pcall(function() acf_safeClick(pg.InfinityTowerGui.Handler.InfinityTowerFrame.Exit) end)
                    task.wait(2)
                end

                acf_fireEquipBest()
                task.wait(1)
                local savedSlots = acf_removeCardsFromSlots(4)
                task.wait(0.5)
                pcall(function() acf_safeClick(pg.GuiMid.BossRaid.BossRaidFrame.EQUIPEBEST) end)
                task.wait(1)
                pcall(function()
                    local diffFrame = pg.GuiMid.BossRaid.DifficultyFrame.ScrollingFrameDifficulty
                    local diffBtn   = diffFrame:FindFirstChild(acf_bossraid_difficulty)
                    if diffBtn then acf_safeClick(diffBtn:FindFirstChild("FrameButton") or diffBtn) end
                end)
                task.wait(1)
                pcall(function() acf_safeClick(pg.GuiMid.BossRaid.BossRaidFrame.BATTLE) end)
                task.wait(1)
                acf_restoreCardsToSlots(savedSlots)
                Library:Notify("Manual Raid Done! - " .. acf_bossraid_difficulty .. ". Cards restored!")

                if isOn("AutoTower") then
                    task.wait(1)
                    acf_launchTower()
                    acf_tower_in_raid_process = false
                end
            end)
        end,
    })
end

-- ══════════════════════════════════════════
--   PLAYER TAB (GRADIENT ENABLED)
-- ══════════════════════════════════════════

FLYING = false
QEfly = true
iyflyspeed = 1
vehicleflyspeed = 1
local flyKeyDown, flyKeyUp

local currentWalkSpeed = 16
local currentJumpPower = 50
local currentFlySpeed  = 60

local function sFLY(vfly)
    local plr = Players.LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        repeat task.wait() until char:FindFirstChildOfClass("Humanoid")
        humanoid = char:FindFirstChildOfClass("Humanoid")
    end

    if flyKeyDown or flyKeyUp then
        if flyKeyDown then flyKeyDown:Disconnect() end
        if flyKeyUp then flyKeyUp:Disconnect() end
    end

    local T = acf_getRoot()
    if not T then return end

    local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local SPEED = 0

    local function FLY()
        FLYING = true
        local BG = Instance.new('BodyGyro')
        local BV = Instance.new('BodyVelocity')
        BG.P = 9e4
        BG.Parent = T
        BV.Parent = T
        BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        BG.CFrame = T.CFrame
        BV.Velocity = Vector3.new(0, 0, 0)
        BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)

        task.spawn(function()
            repeat task.wait()
                local camera = workspace.CurrentCamera
                if not camera then continue end

                if not vfly and humanoid then
                    humanoid.PlatformStand = true
                end

                if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
                    SPEED = currentFlySpeed
                elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
                    SPEED = 0
                end

                if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
                    BV.Velocity = ((camera.CFrame.LookVector * (CONTROL.F + CONTROL.B)) + ((camera.CFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - camera.CFrame.p)) * SPEED
                    lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
                elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
                    BV.Velocity = ((camera.CFrame.LookVector * (lCONTROL.F + lCONTROL.B)) + ((camera.CFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - camera.CFrame.p)) * SPEED
                else
                    BV.Velocity = Vector3.new(0, 0, 0)
                end
                BG.CFrame = camera.CFrame
            until not FLYING or Library.Unloaded

            CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
            lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
            SPEED = 0
            BG:Destroy()
            BV:Destroy()

            if humanoid then humanoid.PlatformStand = false end
        end)
    end

    flyKeyDown = UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        local multi = (vfly and vehicleflyspeed or iyflyspeed)
        if input.KeyCode == Enum.KeyCode.W then CONTROL.F = multi
        elseif input.KeyCode == Enum.KeyCode.S then CONTROL.B = -multi
        elseif input.KeyCode == Enum.KeyCode.A then CONTROL.L = -multi
        elseif input.KeyCode == Enum.KeyCode.D then CONTROL.R = multi
        elseif input.KeyCode == Enum.KeyCode.E and QEfly then CONTROL.Q = multi * 2
        elseif input.KeyCode == Enum.KeyCode.Q and QEfly then CONTROL.E = -multi * 2
        end
    end)

    flyKeyUp = UserInputService.InputEnded:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.W then CONTROL.F = 0
        elseif input.KeyCode == Enum.KeyCode.S then CONTROL.B = 0
        elseif input.KeyCode == Enum.KeyCode.A then CONTROL.L = 0
        elseif input.KeyCode == Enum.KeyCode.D then CONTROL.R = 0
        elseif input.KeyCode == Enum.KeyCode.E then CONTROL.Q = 0
        elseif input.KeyCode == Enum.KeyCode.Q then CONTROL.E = 0
        end
    end)

    FLY()
end

do
    local PlayerGroup = Tabs.Player:AddLeftGroupbox("Player", "user-check")
    PlayerGroup:AddLabel(b(createMultiGradientText("USER", PALETTE.fire)), true)
    PlayerGroup:AddPlayerInfo("PlayerCardCompact", {
	-- "Bust" is the default here; "Avatar" is the full body, which some clients
	-- fail to load, and "HeadShot" is the tight head crop
	ThumbnailType = "Bust",
	Height = 190,
    })


    local FlyGroup = Tabs.Player:AddRightGroupbox("Movement", "feather")
    FlyGroup:AddLabel(b(createMultiGradientText("FLIGHT", PALETTE.prism)), true)
    FlyGroup:AddDivider()
    FlyGroup:AddToggle("Fly",      { Text = "Fly", Default = false })
    FlyGroup:AddSlider("FlySpeed", { Text = "Fly Speed", Default = 60, Min = 10, Max = 350, Rounding = 0, Callback = function(v) currentFlySpeed = v end })
    FlyGroup:AddDivider()
    FlyGroup:AddToggle("AntiSit", {
        Text = "Anti-Sit",
        Default = false,
        Callback = function(v)
            local h = getHumanoid()
            if h then h:SetStateEnabled(Enum.HumanoidStateType.Seated, not v) end
        end,
    })
    FlyGroup:AddDivider()
    FlyGroup:AddLabel(b(createMultiGradientText("MOBILITY", PALETTE.ocean)), true)
    FlyGroup:AddDivider()
    FlyGroup:AddToggle("WalkSpeedEnabled", { Text = "Speed", Default = false })
    FlyGroup:AddSlider("WalkSpeed",        { Text = "Speed Value", Default = 16, Min = 16, Max = 250, Rounding = 0, Callback = function(v) currentWalkSpeed = v end })
    FlyGroup:AddDivider()
    FlyGroup:AddToggle("JumpPowerEnabled", { Text = "Jump", Default = false })
    MoveGroup = FlyGroup -- Backward compatibility wrapper to prevent breaking other elements if referenced
    FlyGroup:AddSlider("JumpPower",        { Text = "Jump Value", Default = 50, Min = 50, Max = 300, Rounding = 0, Callback = function(v) currentJumpPower = v end })
    FlyGroup:AddDivider()
    FlyGroup:AddToggle("InfJump", { Text = "Infinite Jump", Default = false })
    FlyGroup:AddToggle("NoClip",  { Text = "NoClip", Default = false })
end


-- ══════════════════════════════════════════
--   SETTINGS TAB (GRADIENT ENABLED)
-- ══════════════════════════════════════════

do
    local PerfGroup = Tabs.Settings:AddLeftGroupbox("Performance", "cpu")
    PerfGroup:AddLabel(b(createMultiGradientText("OPTIMIZATION", PALETTE.aurora)), true)
    PerfGroup:AddDivider()
    PerfGroup:AddToggle("PotatoMode", {
        Text = "Disable 3D Rendering",
        Default = false,
        Tooltip = "Cuts GPU/CPU usage to near zero while AFK farming",
        Callback = function(v) RunService:Set3dRenderingEnabled(not v) end,
    })
    PerfGroup:AddToggle("AntiAFK", {
    Text = "Anti-AFK",
    Default = true,
    Tooltip = "Prevents 20-minute inactivity kicks while AFK"
})

    local MenuGroup = Tabs.Settings:AddRightGroupbox("Interface", "settings")
    MenuGroup:AddLabel(b(createMultiGradientText("UI PREFERENCES", PALETTE.prism)), true)
    MenuGroup:AddDivider()
    MenuGroup:AddToggle("KeybindMenuOpen", {
        Text     = "Show Keybind Menu",
        Default  = false,
        Callback = function(v) if Library.KeybindFrame then Library.KeybindFrame.Visible = v end end,
    })
    MenuGroup:AddDropdown("NotificationSide", {
        Values   = { "Left", "Right" },
        Default  = "Right",
        Text     = "Notification Placement",
        Callback = function(v) pcall(function() Library:SetNotifySide(v) end) end,
    })
    MenuGroup:AddDivider()
    MenuGroup:AddLabel("Menu Keybind"):AddKeyPicker("MenuKeybind", { Default = "G", NoUI = true, Text = "Menu keybind" })
    Library.ToggleKeybind = Options.MenuKeybind
    MenuGroup:AddButton("Unload Prism", function() Library:Unload() end)
end

-- ══════════════════════════════════════════
--   HIGH PERFORMANCE EVENT LISTENERS
-- ══════════════════════════════════════════

local steppedConnection = RunService.Stepped:Connect(function()
    if Library.Unloaded then return end
    if isOn("NoClip") then
        for i = 1, #characterParts do
            local p = characterParts[i]
            if p and p.Parent then
                p.CanCollide = false
            end
        end
    end
end)

local jumpConnection = UserInputService.JumpRequest:Connect(function()
    if Library.Unloaded then return end
    if isOn("InfJump") then
        local h = getHumanoid()
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

local renderConnection = RunService.RenderStepped:Connect(function()
    if Library.Unloaded then return end
    if isOn("WalkSpeedEnabled") then
        local h = getHumanoid()
        if h then h.WalkSpeed = currentWalkSpeed end
    end
    if isOn("JumpPowerEnabled") then
        local h = getHumanoid()
        if h then h.JumpPower = currentJumpPower end
    end
end)

Toggles.Fly:OnChanged(function(v)
    if v then
        sFLY(false)
    else
        FLYING = false
        if flyKeyDown then flyKeyDown:Disconnect() flyKeyDown = nil end
        if flyKeyUp then flyKeyUp:Disconnect() flyKeyUp = nil end
        local h = getHumanoid()
        if h then h.PlatformStand = false end
    end
end)

Toggles.WalkSpeedEnabled:OnChanged(function()
    if not isOn("WalkSpeedEnabled") then
        local h = getHumanoid()
        if h then h.WalkSpeed = 16 end
    end
end)

Toggles.JumpPowerEnabled:OnChanged(function()
    if not isOn("JumpPowerEnabled") then
        local h = getHumanoid()
        if h then h.JumpPower = 50 end
    end
end)

-- ══════════════════════════════════════════
--   ANTI-AFK UTILITIES
-- ══════════════════════════════════════════

local antiAfkLastInput = tick()
local antiAfkLastTap   = tick()

pcall(function()
    for _, conn in ipairs(getconnections(LocalPlayer.Idled)) do
        pcall(function() conn:Disable() end)
    end
end)

local function antiAfkTap()
    local cam = workspace.CurrentCamera
    if not cam then return end
    VirtualUser:Button2Down(Vector2.new(0, 0), cam.CFrame)
    task.wait(0.1)
    VirtualUser:Button2Up(Vector2.new(0, 0), cam.CFrame)
    antiAfkLastTap = tick()
end

local antiAfkBeganConnection = UserInputService.InputBegan:Connect(function()
    antiAfkLastInput = tick()
end)

local antiAfkChangedConnection = UserInputService.InputChanged:Connect(function(input)
    local t = input.UserInputType
    if t == Enum.UserInputType.MouseMovement or t == Enum.UserInputType.Gamepad1 then
        antiAfkLastInput = tick()
    end
end)

task.spawn(function()
    while not Library.Unloaded do
        task.wait(2)
        if isOn("AntiAFK") then
            local idle     = tick() - antiAfkLastInput
            local sinceTap = tick() - antiAfkLastTap
            if idle >= 300 and sinceTap >= 60 then pcall(antiAfkTap)
            elseif idle < 300 and sinceTap >= 300 then pcall(antiAfkTap) end
        end
    end
end)

-- ══════════════════════════════════════════
--   CONSOLIDATED GAME LOOPS
-- ══════════════════════════════════════════

-- Auto Playtime Claimer
task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoPlaytime") then
            for i = 1, 12 do
                if Library.Unloaded or not isOn("AutoPlaytime") then break end
                pcall(function() PlayTimeRewardRE:FireServer("ClaimReward", { RewardIndex = i }) end)
                task.wait(0.3)
            end
            task.wait(30)
        else
            task.wait(1)
        end
    end
end)

-- Auto Pack Spawner
task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoSpawn") then
            local click = acf_getClickDetector()
            if click then pcall(function() fireclickdetector(click) end) end
            task.wait(acf_spawn_delay)
        else
            task.wait(0.5)
        end
    end
end)

-- Auto Carry & Sell Box Loop
task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoCarrySell") then
            local carryPrompt, proxiBox = acf_getProxiBoxPrompt()
            if carryPrompt and carryPrompt.Enabled and proxiBox then
                acf_teleportTo(proxiBox, 3)
                task.wait(0.5)
                if carryPrompt and carryPrompt.Enabled then
                    pcall(function() fireproximityprompt(carryPrompt) end)
                    task.wait(0.5)
                    local tool = acf_getCardBoxTool()
                    if tool then
                        acf_equipTool(tool)
                        task.wait(0.3)
                        local sellPrompt, sellPart = acf_getSellPrompt()
                        if sellPrompt and sellPart then
                            acf_teleportTo(sellPart, 3)
                            task.wait(0.5)
                            if sellPrompt and sellPrompt.Enabled then
                                pcall(function() fireproximityprompt(sellPrompt) end)
                            end
                            task.wait(0.3)
                            local plotN0 = acf_getPlotN0()
                            if plotN0 then
                                local bp = plotN0:FindFirstChild("ButtonPart")
                                if bp then acf_teleportTo(bp, 3) end
                            end
                        end
                    end
                end
            end
            task.wait(acf_sell_delay)
        else
            task.wait(0.5)
        end
    end
end)

-- Auto Slot Placement Loop
task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoPlace") then
            local packs = acf_getPackTools()
            if next(acf_selectedPlacePacks) then
                local filtered = {}
                for _, pack in ipairs(packs) do
                    for packName in pairs(acf_selectedPlacePacks) do
                        if pack.Name:lower():find(packName:lower():gsub(" pack", "")) then
                            table.insert(filtered, pack); break
                        end
                    end
                end
                packs = filtered
            end
            if #packs > 0 then
                for slotNum = 1, 20 do
                    if Library.Unloaded or not isOn("AutoPlace") or #packs == 0 then break end
                    local prompt, slot = acf_getSlotPrompt(slotNum)
                    if prompt and prompt.Enabled and slot then
                        if prompt.ActionText == "Remove" and isOn("AutoRemoveForPlace") then
                            acf_teleportTo(slot, 3)
                            task.wait(0.3)
                            pcall(function() fireproximityprompt(prompt) end)
                            task.wait(0.5)
                            prompt, slot = acf_getSlotPrompt(slotNum)
                        end
                        if prompt and prompt.Enabled and prompt.ActionText == "Place" then
                            local pack = table.remove(packs, 1)
                            if pack then
                                acf_equipTool(pack)
                                task.wait(0.2)
                                acf_teleportTo(slot, 3)
                                task.wait(0.3)
                                pcall(function() fireproximityprompt(prompt) end)
                                task.wait(acf_place_delay)
                            end
                        end
                    end
                end
            end
            task.wait(1)
        else
            task.wait(0.5)
        end
    end
end)

-- Auto Open Loop
task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoOpen") then
            for slotNum = 1, 20 do
                if Library.Unloaded or not isOn("AutoOpen") then break end
                local prompt, slot = acf_getSlotPrompt(slotNum)
                if prompt and prompt.Enabled and prompt.ActionText == "Open" and slot then
                    acf_teleportTo(slot, 3)
                    task.wait(0.3)
                    pcall(function() fireproximityprompt(prompt) end)
                    task.wait(acf_open_delay)
                end
            end
            task.wait(1)
        else
            task.wait(0.5)
        end
    end
end)

-- Auto Equip Best Cards
task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoEquipBest") then
            acf_fireEquipBest()
            task.wait(5)
        else
            task.wait(1)
        end
    end
end)

-- Auto Upgrade Active Cards
task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoUpgradeCards") then
            for slotNum = 1, 40 do
                if Library.Unloaded or not isOn("AutoUpgradeCards") then break end
                pcall(function() CardSlotRE:FireServer("UpgradeCard", { SlotIndex = slotNum }) end)
            end
            task.wait(acf_cardupgrade_delay)
        else
            task.wait(0.5)
        end
    end
end)

-- Card Sell Consolidations
task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoSellAll") then
            pcall(function() SellRE:FireServer("SellAll") end)
            task.wait(3)
        else task.wait(1) end
    end
end)

task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoSellCards") then
            pcall(function() SellRE:FireServer("SellCards") end)
            task.wait(3)
        else task.wait(1) end
    end
end)

task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoSellPacks") then
            pcall(function() SellRE:FireServer("SellPacks") end)
            task.wait(3)
        else task.wait(1) end
    end
end)

task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoSellHand") then
            pcall(function() SellRE:FireServer("SellHand") end)
            task.wait(3)
        else task.wait(1) end
    end
end)

-- Player Upgrades (Stats) Execution Loop
task.spawn(function()
    while not Library.Unloaded do
        for _, upgrade in ipairs(acf_upgradeMap) do
            if acf_upgradeStates[upgrade.id] then
                pcall(function() UpgradesRE:FireServer("BuyCash", { Id = upgrade.id }) end)
                task.wait(acf_upgrade_delay)
            end
        end
        task.wait(0.5)
    end
end)

-- Auto Conveyor Line Upgrading
task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoConveyorUpgrade") then
            pcall(function() ConveyorUpgradeRE:FireServer("ConfirmUpgrade") end)
            task.wait(2)
        else task.wait(1) end
    end
end)

-- Auto Card Grade Real-time Loop
task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoGrade") and next(acf_selected_grade_baseNames) then
            local tools = acf_resolveToolsByBaseName(acf_selected_grade_baseNames)

            if #tools == 0 then
                task.wait(1)
            else
                local rolledAny = false
                local allDone   = true

                for _, tool in ipairs(tools) do
                    if Library.Unloaded or not isOn("AutoGrade") then break end
                    if not tool or not tool.Parent then continue end

                    local currentGrade = acf_getCardGrade(tool)
                    local hasTarget    = next(acf_target_grades) ~= nil

                    local metTarget = hasTarget
                        and currentGrade ~= nil
                        and acf_gradeMetTarget(currentGrade, acf_target_grades)

                    if not metTarget then
                        allDone = false
                        pcall(function()
                            GradeRollRE:FireServer("RollGrade", {
                                Tool     = tool,
                                Currency = acf_grade_currency,
                            })
                        end)
                        rolledAny = true
                        SessionStats.cardsGraded = SessionStats.cardsGraded + 1
                        task.wait(acf_grade_delay)
                    end
                end

                if next(acf_target_grades) and allDone and #tools > 0 then
                    Library:Notify("Auto Grade Complete! - All selected cards reached target grade(s)!")
                    Toggles.AutoGrade:SetValue(false)
                end

                if not rolledAny then
                    task.wait(0.5)
                end
            end
        else
            task.wait(0.5)
        end
    end
end)

-- Auto Card Trait Real-time Loop
task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoTrait") and next(acf_selected_trait_baseNames) then
            local tools = acf_resolveToolsByBaseName(acf_selected_trait_baseNames)

            if #tools == 0 then
                task.wait(1)
            else
                local rolledAny = false
                local allDone   = true

                for _, tool in ipairs(tools) do
                    if Library.Unloaded or not isOn("AutoTrait") then break end
                    if not tool or not tool.Parent then continue end

                    local currentTrait = acf_getCardTrait(tool)
                    local hasTarget    = next(acf_target_traits) ~= nil

                    local metTarget = hasTarget
                        and currentTrait ~= nil
                        and acf_traitMetTarget(currentTrait, acf_target_traits)

                    if not metTarget then
                        allDone = false
                        pcall(function()
                            TraitRollRE:FireServer("RollTrait", { Tool = tool })
                        end)
                        rolledAny = true
                        SessionStats.traitsRolled = SessionStats.traitsRolled + 1
                        task.wait(acf_trait_delay)
                    end
                end

                if next(acf_target_traits) and allDone and #tools > 0 then
                    Library:Notify("Auto Trait Complete! - All selected cards reached target trait(s)!")
                    Toggles.AutoTrait:SetValue(false)
                end

                if not rolledAny then
                    task.wait(0.5)
                end
            end
        else
            task.wait(0.5)
        end
    end
end)

-- Auto Infinity Tower Loop
task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoTower") then
            local pg = LocalPlayer:WaitForChild("PlayerGui")

            acf_tower_last_floor        = -1
            acf_tower_floor_stuck_start = 0
            acf_tower_no_gui_start      = 0
            acf_tower_in_raid_process   = false

            acf_tower_in_raid_process = true
            local currentSession = acf_launchTower()
            acf_tower_in_raid_process = false

            while isOn("AutoTower") and not Library.Unloaded do
                task.wait(1)
                if not isOn("AutoTower") or Library.Unloaded then break end
                if acf_tower_in_raid_process then continue end

                if acf_tower_session_id ~= currentSession then
                    currentSession              = acf_tower_session_id
                    acf_tower_last_floor        = -1
                    acf_tower_floor_stuck_start = tick()
                    acf_tower_no_gui_start      = 0
                    continue
                end

                local currentFloor = 0
                local guiVisible   = false

                pcall(function()
                    local frame = pg.InfinityTowerGui.Handler.InfinityTowerFrame
                    guiVisible  = frame.Visible
                    if guiVisible then
                        local txt = frame.FloorFrame.Floor.Text
                        currentFloor = tonumber(txt:match("%d+")) or 0
                    end
                end)

                if guiVisible and currentFloor > 0 then
                    acf_tower_no_gui_start = 0

                    if currentFloor ~= acf_tower_last_floor then
                        acf_tower_last_floor        = currentFloor
                        acf_tower_floor_stuck_start = tick()
                        SessionStats.floorsCleared  = SessionStats.floorsCleared + 1
                    else
                        local stuck = tick() - acf_tower_floor_stuck_start
                        if stuck >= 60 then
                            Library:Notify("Tower Stuck! - Floor " .. currentFloor .. " for 60s. Restarting...")
                            pcall(function() acf_safeClick(pg.InfinityTowerGui.Handler.InfinityTowerFrame.Exit) end)
                            task.wait(2)
                            acf_tower_in_raid_process = true
                            currentSession = acf_launchTower()
                            acf_tower_in_raid_process = false
                            continue
                        end
                    end

                    if acf_tower_exit_floor > 0 and currentFloor >= acf_tower_exit_floor then
                        Library:Notify("Auto Tower - Floor " .. currentFloor .. " reached! Restarting...")
                        pcall(function() acf_safeClick(pg.InfinityTowerGui.Handler.InfinityTowerFrame.Exit) end)
                        task.wait(2)
                        acf_tower_in_raid_process = true
                        currentSession = acf_launchTower()
                        acf_tower_in_raid_process = false
                        continue
                    end
                else
                    if acf_tower_last_floor > 0 then
                        if acf_tower_no_gui_start == 0 then
                            acf_tower_no_gui_start = tick()
                        end
                        local grace = math.max(10, math.min(acf_tower_last_floor * 0.05, 20))
                        local gone  = tick() - acf_tower_no_gui_start
                        if gone >= grace then
                            Library:Notify("Tower Defeated - Last floor: " .. acf_tower_last_floor .. ". Relaunching...")
                            acf_tower_in_raid_process = true
                            currentSession = acf_launchTower()
                            acf_tower_in_raid_process = false
                        end
                    else
                        acf_tower_no_gui_start = 0
                    end
                end
            end

            Library:Notify("Auto Tower - Stopped.")
            while not isOn("AutoTower") and not Library.Unloaded do task.wait(0.5) end
        else
            task.wait(0.5)
        end
    end
end)

-- Auto Boss Raid Monitoring Loop
task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoBossRaid") then
            local isOpen, timerText = acf_getBossRaidTimerInfo()

            if isOpen then
                if not acf_bossRaidDoneThisWindow then
                    acf_bossRaidDoneThisWindow = true
                    acf_bossRaidWasOpen        = true

                    local pg = LocalPlayer:WaitForChild("PlayerGui")

                    if isOn("AutoTower") then
                        acf_tower_in_raid_process = true
                        Library:Notify("Boss Raid - Exiting Infinity Tower for raid...")
                        pcall(function() acf_safeClick(pg.InfinityTowerGui.Handler.InfinityTowerFrame.Exit) end)
                        task.wait(2)
                    end

                    acf_fireEquipBest()
                    task.wait(1)
                    local savedSlots = acf_removeCardsFromSlots(4)
                    task.wait(0.5)
                    pcall(function() acf_safeClick(pg.GuiMid.BossRaid.BossRaidFrame.EQUIPEBEST) end)
                    task.wait(1)
                    pcall(function()
                        local diffFrame = pg.GuiMid.BossRaid.DifficultyFrame.ScrollingFrameDifficulty
                        local diffBtn   = diffFrame:FindFirstChild(acf_bossraid_difficulty)
                        if diffBtn then acf_safeClick(diffBtn:FindFirstChild("FrameButton") or diffBtn) end
                    end)
                    task.wait(1)
                    pcall(function() acf_safeClick(pg.GuiMid.BossRaid.BossRaidFrame.BATTLE) end)
                    task.wait(1)
                    acf_restoreCardsToSlots(savedSlots)
                    SessionStats.raidsCompleted = SessionStats.raidsCompleted + 1
                    Library:Notify("Boss Raid Done! - " .. acf_bossraid_difficulty .. ". Cards restored.")

                    if isOn("AutoTower") then
                        Library:Notify("Boss Raid - Waiting 2 minutes before rejoining tower...")
                        task.wait(120)
                        Library:Notify("Boss Raid - Rejoining Infinity Tower now!")
                        acf_launchTower()
                        acf_tower_in_raid_process = false
                    end
                end
                acf_bossRaidWasOpen = true
            else
                if acf_bossRaidWasOpen then
                    Library:Notify("Boss Raid - Window closed. Waiting for next cycle...")
                    acf_bossRaidDoneThisWindow = false
                    acf_bossRaidWasOpen        = false
                end
            end

            task.wait(5)
        else
            task.wait(1)
        end
    end
end)

-- Auto Potions Execution Loop
task.spawn(function()
    while not Library.Unloaded do
        if isOn("AutoUsePotions") and next(acf_selected_potions) then
            for itemId, _ in pairs(acf_selected_potions) do
                if Library.Unloaded or not isOn("AutoUsePotions") then break end
                pcall(function()
                    ItemsRE:FireServer("UseItem", {
                        ItemId = itemId,
                        Amount = 1
                    })
                end)
                task.wait(acf_potion_delay)
            end
        else
            task.wait(1)
        end
    end
end)

-- ══════════════════════════════════════════
--   UNLOAD
-- ══════════════════════════════════════════

Library:OnUnload(function()
    steppedConnection:Disconnect()
    jumpConnection:Disconnect()
    renderConnection:Disconnect()
    antiAfkBeganConnection:Disconnect()
    antiAfkChangedConnection:Disconnect()
    if charAddedConn then charAddedConn:Disconnect() end

    FLYING = false
    if flyKeyDown then flyKeyDown:Disconnect() end
    if flyKeyUp then flyKeyUp:Disconnect() end

    RunService:Set3dRenderingEnabled(true)
    local h = getHumanoid()
    if h then
        h.PlatformStand = false
        h.WalkSpeed     = 16
        h.JumpPower     = 50
    end
end)

-- ══════════════════════════════════════════
--   FINALIZE
-- ══════════════════════════════════════════

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("PrismHub")
SaveManager:SetFolder("PrismHub/AnimeCardFarm")

SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)
ThemeManager:SaveDefault("Claude")
ThemeManager:LoadDefault()

acf_isLoadingConfig = true
SaveManager:LoadAutoloadConfig()
task.defer(function() acf_isLoadingConfig = false end)

Library:Notify("Prism loaded, welcome " .. LocalPlayer.Name, 5)
