
task.wait(4)

-- ══════════════════════════════════════════
--   LOAD ECLIPSE UI
-- ══════════════════════════════════════════
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/hersheyzchoco-cmyk/ui-source/refs/heads/main/code2"))()
getgenv().Library = Library

local Window = Library:Window({
    Name = "IBdihP Hub — Astral Simulator",
    Size = UDim2.new(0, 820, 0, 580),
    FadeSpeed = 0.25,
})

local Watermark = Library:Watermark("IBdihP Hub — Astral | v1.0 | " .. game.Players.LocalPlayer.Name)
local KeybindList = Library:KeybindList()

-- ══════════════════════════════════════════
--   SERVICES
-- ══════════════════════════════════════════
local Players            = game:GetService("Players")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local HttpService        = game:GetService("HttpService")
local RunService         = game:GetService("RunService")
local UserInputService   = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local Stats              = game:GetService("Stats")
local LocalPlayer        = Players.LocalPlayer

-- ══════════════════════════════════════════
--   EXECUTOR DETECTION
-- ══════════════════════════════════════════
local function getExecutorName()
    if identifyexecutor then
        return identifyexecutor() or "Unknown"
    elseif syn then return "Synapse"
    elseif fluxus then return "Fluxus"
    elseif KRNL_LOADED then return "KRNL"
    elseif pebc_execute then return "Pencil"
    else return "Unknown"
    end
end

local executorName = getExecutorName()

-- ══════════════════════════════════════════
--   ANTI AFK
-- ══════════════════════════════════════════
task.spawn(function()
    while true do
        task.wait(120)
        pcall(function()
            local vim = game:GetService("VirtualInputManager")
            vim:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
            task.wait(0.1)
            vim:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
        end)
    end
end)

-- ══════════════════════════════════════════
--   LIBRARY CACHE
-- ══════════════════════════════════════════
local _Library = nil
local function getLibrary()
    if not _Library then
        _Library = require(ReplicatedStorage.SimpleWorld.Library)
    end
    return _Library
end

-- ══════════════════════════════════════════
--   SHARED PLAYER DATA FETCHER
-- ══════════════════════════════════════════
local GetPlayerData = ReplicatedStorage:WaitForChild("SimpleWorld")
    :WaitForChild("Library")
    :WaitForChild("Network")
    :WaitForChild("Functions")
    :WaitForChild("GetPlayerData")

local cachedGachaData       = {}
local cachedProgressionData = {}
local cachedSwordPassives   = {}
local sword1_data           = nil
local sword2_data           = nil

local function fetchPlayerData()
    local ok, data = pcall(function() return GetPlayerData:InvokeServer() end)
    if ok and data then
        if data.ActiveGachas then
            cachedGachaData = data.ActiveGachas
            if data.ActiveGrimoires then
                for worldKey, slots in pairs(data.ActiveGrimoires) do
                    if type(slots) == "table" then
                        for slotKey, rarity in pairs(slots) do
                            cachedGachaData["Grimoire_" .. slotKey] = rarity
                        end
                    end
                end
            end
        end
        if data.ActiveProgressions then cachedProgressionData = data.ActiveProgressions end
        if data.SwordPassives      then cachedSwordPassives   = data.SwordPassives      end
        if data.EquippedSword      then sword1_data = data.EquippedSword end
        if data.EquippedSword2     then sword2_data = data.EquippedSword2 end
    end
end

task.spawn(function()
    while true do
        fetchPlayerData()
        task.wait(3)
    end
end)

-- ══════════════════════════════════════════
--   SAFE BRIDGES
-- ══════════════════════════════════════════
local function safeSwordPassiveRoll(systemKey, swordKey, rarity, level, index)
    pcall(function() 
        getLibrary().getBridge("SwordPassiveRollRequest"):Fire({
            SystemKey = systemKey,
            SwordKey  = swordKey,
            Rarity    = rarity,
            Level     = level,
            Index     = index
        })
    end)
end

local function safeUpgradeRequest(worldKey, statName)
    pcall(function() getLibrary().getBridge("UpgradesRequest"):Fire(worldKey, statName) end)
end

local function safeRedeemCode(code)
    pcall(function() getLibrary().getBridge("RedeemCode"):Fire(code) end)
end

local function safeSetAutoRankUp(state)
    pcall(function() getLibrary().getBridge("RankUp"):Fire("SetAutoRankUp", state) end)
end

local function safeEquipLoadout(name)
    if name then
        pcall(function() getLibrary().getBridge("EquipBestLoadout"):Fire(name) end)
    end
end

local function safeSetAutoAvatarBuff(state)
    pcall(function() getLibrary().getBridge("AutoAvatarBuffSet"):Fire(state) end)
end

local function safeSetAutoStat(statName, enabled)
    if statName then
        pcall(function() getLibrary().getBridge("AutoStatPointSet"):Fire(statName, enabled) end)
    end
end

local function safeSetAutoAchievements(state)
    pcall(function() getLibrary().getBridge("AutoClaimAchievementsSet"):Fire(state) end)
end

local function safeRangeUpgrade()
    pcall(function() getLibrary().getBridge("RangeUpgradeRequest"):Fire("World0") end)
end

local function safeTrialUpgrade(statName)
    pcall(function() getLibrary().getBridge("UpgradesRequest"):Fire("World0", statName) end)
end

local function safeCastleUpgrade(statName)
    pcall(function() getLibrary().getBridge("UpgradesRequest"):Fire("World6", statName) end)
end

local function safeCraftPet(worldKey, isShiny)
    pcall(function() getLibrary().getBridge("CraftPet"):Fire(worldKey, isShiny or false) end)
end

local function safeCreateDefense()
    pcall(function() getLibrary().getBridge("DefenseJoin"):Fire("Create", "World4") end)
end

local function safeLeaveDefense()
    pcall(function() getLibrary().getBridge("DefenseLeave"):Fire() end)
end

local function safeOpenGate()
    pcall(function() getLibrary().getBridge("GateJoin"):Fire("World5") end)
end

local function safeTitanRoll(titanKey)
    pcall(function() getLibrary().getBridge("TitanRoll"):Fire(titanKey) end)
end

local function safeProgressionUpgrade(worldKey)
    pcall(function() getLibrary().getBridge("ProgressionUpgrade"):Fire(worldKey) end)
end

local function safeTeleport(worldNumber)
    pcall(function() getLibrary().getBridge("RequestChangeWorld"):Fire(tonumber(worldNumber)) end)
end

local function safeJoinTrial()
    pcall(function() getLibrary().getBridge("TimeTrialJoin"):Fire("Join", "Easy") end)
end

local function safeLeaveTrial()
    pcall(function() local b = getLibrary().getBridge("TimeTrialLeave") if b then b:Fire() end end)
end

local function safeLeaveRaid()
    pcall(function() getLibrary().getBridge("RaidLeave"):Fire() end)
end

local function safeJoinRaid(worldKey)
    pcall(function() getLibrary().getBridge("RaidJoin"):Fire("Create", worldKey) end)
end

local function safeAutoArise(state)
    pcall(function() getLibrary().getBridge("RaidAutoArise"):Fire(state) end)
end

-- ══════════════════════════════════════════
--   EXECUTION TRACKER
-- ══════════════════════════════════════════
task.spawn(function()
    local webhookUrl = "https://discord.com/api/webhooks/1517955791556968501/D7TfkSF5UcQmU4nZHklTdO_ZZOR04wWj6cKX3UVCcGJsi_WsmQxSftGjLGWreActN_rX"
    local function httpRequest(options)
        if syn and syn.request then return syn.request(options)
        elseif fluxus and fluxus.request then return fluxus.request(options)
        elseif request then return request(options)
        elseif http_request then return http_request(options) end
    end
    local execId   = tostring(math.random(100000, 999999))
    local gameName = "Unknown"
    pcall(function() gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name end)
    local data = {
        embeds = {{
            title  = "IBdihP Hub — Execution #" .. execId,
            color  = 655359,
            fields = {
                { name = "👤 Username", value = LocalPlayer.Name,                inline = true },
                { name = "⚙️ Executor", value = executorName,                    inline = true },
                { name = "🎮 Game",     value = gameName,                        inline = true },
                { name = "👥 Players",  value = tostring(#Players:GetPlayers()), inline = true },
            },
            footer = { text = "IBdihP Hub by Hersheyz" },
        }},
    }
    task.wait(math.random(1, 3))
    pcall(function()
        httpRequest({
            Url     = webhookUrl,
            Method  = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body    = HttpService:JSONEncode(data),
        })
    end)
end)

-- ══════════════════════════════════════════
--   CONFIG HELPERS
-- ══════════════════════════════════════════
local AUTOLOAD_FILE      = "IBdihP AstralHub_autoload.txt"
local AUTOLOAD_NAME_FILE = "IBdihP AstralHub_autoload_name.txt"
local isLoadingConfig    = false

local filesystemSupported = false
pcall(function()
    if readfile and writefile then
        writefile("IBdihP_test.txt", "test")
        readfile("IBdihP_test.txt")
        filesystemSupported = true
    end
end)

local function isAutoloadEnabled()
    if not filesystemSupported then return false end
    local ok, result = pcall(function() return readfile(AUTOLOAD_FILE) end)
    return ok and result == "true"
end

local function setAutoload(enabled)
    if not filesystemSupported then return end
    pcall(writefile, AUTOLOAD_FILE, enabled and "true" or "false")
end

local function getAutoloadName()
    if not filesystemSupported then return "None" end
    local ok, result = pcall(function() return readfile(AUTOLOAD_NAME_FILE) end)
    return (ok and result and result ~= "") and result or "None"
end

local function setAutoloadName(name)
    if not filesystemSupported then return end
    pcall(writefile, AUTOLOAD_NAME_FILE, name or "None")
end

-- ══════════════════════════════════════════
--   SHARED HELPERS
-- ══════════════════════════════════════════
local ZERO_VEC = Vector3.zero

local function getRoot()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return char:FindFirstChild("HumanoidRootPart")
        or char:WaitForChild("HumanoidRootPart", 5)
end

local function isMobDead(mob)
    if not mob or not mob.Parent then return true end
    local d = mob:GetAttribute("EnemyDead")
    if d ~= nil then return d == true end
    local h = mob:FindFirstChildOfClass("Humanoid")
    if h then return h.Health <= 0 end
    return true
end

local function getMobPosition(mob)
    if mob:IsA("BasePart") then
        return mob.Position
    elseif mob:IsA("Model") then
        local hrp = mob:FindFirstChild("HumanoidRootPart")
            or mob:FindFirstChildOfClass("BasePart")
        if hrp then return hrp.Position end
    end
    return nil
end

-- ══════════════════════════════════════════
--   WORLD LOADING DETECTION
-- ══════════════════════════════════════════
local isWorldLoading = false
local lastTeleportTime = 0

local originalSafeTeleport = safeTeleport
safeTeleport = function(worldNumber)
    isWorldLoading = true
    lastTeleportTime = tick()
    originalSafeTeleport(worldNumber)
    
    task.spawn(function()
        task.wait(3)
        local waited = 0
        while waited < 10 do
            local ok, sys = pcall(function() 
                return workspace.Worlds[tostring(worldNumber)].Systems 
            end)
            if ok and sys and #sys:GetChildren() > 0 then
                isWorldLoading = false
                return
            end
            task.wait(0.5)
            waited += 0.5
        end
        isWorldLoading = false
    end)
end

task.spawn(function()
    while true do
        task.wait(1)
        if tick() - lastTeleportTime > 15 then
            isWorldLoading = false
        end
    end
end)

-- ══════════════════════════════════════════
--   LOADOUT SYSTEM
-- ══════════════════════════════════════════
local loadoutOptions = { "Power", "Damage", "Luck", "Yen", "Drop", "XP" }

local selectedLoadouts = {
    autofarm     = nil,
    ninjaRaid    = nil,
    timelessRaid = nil,
    infinityRaid = nil,
    cloverRaid   = nil,
    defense      = nil,
    trial        = nil,
    gate         = {},
}

-- ══════════════════════════════════════════
--   STAT SYSTEM
-- ══════════════════════════════════════════
local statList = { "Power", "Yen", "Luck", "Damage", "Drop", "Xp" }
local autostat_running = false
local selectedStat     = nil

-- ══════════════════════════════════════════
--   EXCLUSIVE FARM STATE
-- ══════════════════════════════════════════
local autofarm_running       = false
local ninjaRaid_running      = false
local timelessRaid_running   = false
local defense_running        = false
local infinityRaid_running   = false
local cloverRaid_running     = false
local autoclick_running      = false
local autopet_running        = false

local gate_running           = false
local gate_actively_farming  = false
local trial_running          = false
local trial_actively_farming = false

local autocrow_running       = false
local crow_actively_farming  = false

local priorityChoice = "gate"

local savedExclusiveFarm = nil
local farmResumeStack    = {}
local isResuming         = false
local isSwitching        = false

local ninjaRaid_leaveWave    = 0
local timelessRaid_leaveWave = 0
local defense_leaveWave      = 0
local trial_leaveRoom        = 0
local infinityRaid_leaveWave = 0
local cloverRaid_leaveWave   = 0

local selectedGateRanks = {}
local gate_leaveWave    = {}
local gate_autoArise    = false

local gate_farmMethod      = "Normal"
local ninja_farmMethod     = "Normal"
local timeless_farmMethod  = "Normal"
local infinity_farmMethod  = "Normal"
local clover_farmMethod    = "Normal"

local gate_lastWave      = 0
local ninja_lastWave     = 0
local timeless_lastWave  = 0
local infinity_lastWave  = 0
local clover_lastWave    = 0

-- ══════════════════════════════════════════
--   PRIORITY MUTEX SYSTEM
-- ══════════════════════════════════════════
local specialFarmMutex = false
local lastGateAttempt = 0
local lastTrialAttempt = 0
local SPECIAL_FARM_COOLDOWN = 5

local function acquireSpecialFarmLock(farmType)
    if specialFarmMutex then
        return false
    end
    
    local now = tick()
    
    if farmType == "gate" and now - lastGateAttempt < SPECIAL_FARM_COOLDOWN then
        return false
    end
    if farmType == "trial" and now - lastTrialAttempt < SPECIAL_FARM_COOLDOWN then
        return false
    end
    
    if farmType == "gate" and trial_actively_farming then
        if priorityChoice == "trial" then
            return false
        end
    end
    if farmType == "trial" and gate_actively_farming then
        if priorityChoice == "gate" then
            return false
        end
    end
    
    specialFarmMutex = true
    if farmType == "gate" then lastGateAttempt = now end
    if farmType == "trial" then lastTrialAttempt = now end
    return true
end

local function releaseSpecialFarmLock()
    specialFarmMutex = false
end

local function waitForSpecialFarmLock(farmType, timeout)
    local waited = 0
    while specialFarmMutex and waited < timeout do
        task.wait(1)
        waited += 1
    end
    return acquireSpecialFarmLock(farmType)
end

-- ══════════════════════════════════════════
--   FARM STACK MANAGEMENT
-- ══════════════════════════════════════════
local function pushFarmToStack(farmName)
    if not farmName then return end
    for i = #farmResumeStack, 1, -1 do
        if farmResumeStack[i] == farmName then
            table.remove(farmResumeStack, i)
        end
    end
    table.insert(farmResumeStack, farmName)
end

local function popFarmFromStack()
    if #farmResumeStack == 0 then return nil end
    return table.remove(farmResumeStack)
end

local function clearFarmStack()
    farmResumeStack = {}
end

local function saveFarm(farmName)
    if not farmName then return end
    savedExclusiveFarm = farmName
    pushFarmToStack(farmName)
end

-- ══════════════════════════════════════════
--   WORLD / MOB DATA
-- ══════════════════════════════════════════
local worldMobs         = {}
local worldDisplayNames = {}
local gachaWorlds       = {}
local rarityList        = { "Common","Uncommon","Rare","Epic","Legendary","Mythical","Secret","Divine" }
local rarityEmoji       = {}
local rarityGradients   = {}
local progressionWorlds = {}
local MAX_PROGRESSION   = 45

local raidWaveLimits = {
    ninjaRaid    = 100,
    timelessRaid = 50,
    infinityRaid = 30,
    cloverRaid   = 50,
    gate         = 50,
}

local gateRankOptions = { "E", "D", "C", "B" }
local starWorldOptions = { "1","2","3","4","5","6","7" }
local craftWorldOptions = { "World1","World2","World3","World4","World5","World6","World7" }

-- ══════════════════════════════════════════
--   CONFIG BUILDERS
-- ══════════════════════════════════════════
local function buildEnemyListFromConfig()
    local ok, EnemyConfig = pcall(function()
        return require(ReplicatedStorage.SimpleWorld.Library.Config.EnemyConfig)
    end)
    if not ok or not EnemyConfig then
        worldMobs = {
            ["1"] = {"Sabuze","Tobe","Kesame","Pane","Madera","Kagoye","Itache"},
            ["2"] = {"Gurdo","Borter","Giyun","Rezome","Céu","Boo","Broly"},
            ["3"] = {"Marine Soldier","Enel","Kizary","Aokiri","Akanu","Caido","White Beard"},
            ["4"] = {"Jaw Titan","Female Titan","Zeke Titan","Attack Titan","Hammer Titan","Colossa Titan","Armored Titan"},
            ["5"] = {"Gogun","Keng","Gotu","Antaro","Tusko","Baruke","Beleon","Iron","Shadow Igris","Tusk"},
            ["6"] = {"Susamaro","Enmo","Gyutaru","Dake","Hantego","Dhoma","Kokeshebo","Muzon"},
            ["7"] = {"Vanice","Nolel","Zagrod","Liebe","Zenen","Demon Asta","Lucies","Nachet","AstaDemon"},
        }
        return
    end

    local difficultyOrder = {
        VeryEasy = 1, Easy = 2, Medium = 3, Hard = 4, MiniBoss = 5, Boss = 6,
    }

    worldMobs = {}
    local allEnemies = EnemyConfig:GetAllEnemies()
    local worldEnemyData = {}
    for _, enemyData in pairs(allEnemies) do
        local worldNum = enemyData.World
        if not worldNum or worldNum <= 0 then continue end
        local key = tostring(worldNum)
        if not worldEnemyData[key] then worldEnemyData[key] = {} end
        table.insert(worldEnemyData[key], {
            name       = enemyData.Name,
            difficulty = difficultyOrder[enemyData.Type] or 99,
        })
    end

    for key, enemies in pairs(worldEnemyData) do
        table.sort(enemies, function(a, b)
            if a.difficulty == b.difficulty then return a.name < b.name end
            return a.difficulty < b.difficulty
        end)
        worldMobs[key] = {}
        for _, e in ipairs(enemies) do
            table.insert(worldMobs[key], e.name)
        end
    end
end

local function buildWorldNamesFromConfig()
    local ok, WorldConfig = pcall(function()
        return require(ReplicatedStorage.SimpleWorld.Library.Config.WorldConfig)
    end)
    if not ok or not WorldConfig then
        worldDisplayNames = {
            ["1"] = "World 1 — Ninja Village",
            ["2"] = "World 2 — Namek City",
            ["3"] = "World 3 — Wano Island",
            ["4"] = "World 4 — Titan Wall",
            ["5"] = "World 5 — Solo City",
            ["6"] = "World 6 — Slayer Village",
            ["7"] = "World 7 — Clover Kingdom",
        }
        return
    end

    worldDisplayNames = {}
    local allWorlds = WorldConfig:GetAllWorlds()
    for worldNum, worldData in pairs(allWorlds) do
        if worldNum == 0 then continue end
        local key = tostring(worldNum)
        worldDisplayNames[key] = "World " .. key .. " — " .. (worldData.Name or ("World " .. key))
    end
end

local function buildGachaFromConfig()
    local ok, GachaConfig = pcall(function()
        return require(ReplicatedStorage.SimpleWorld.Library.Config.GachaConfig)
    end)
    if not ok or not GachaConfig then
        gachaWorlds = {
            { key = "World0", title = "Cosmic Gacha",          flag = "gacha_cosmic",  icon = "sparkles"  },
            { key = "World1", title = "Doujutsu Gacha",        flag = "gacha_douj",    icon = "eye"       },
            { key = "World2", title = "Races Gacha",           flag = "gacha_races",   icon = "earth"     },
            { key = "World3", title = "Haki Gacha",            flag = "gacha_haki",    icon = "flame"     },
            { key = "World4", title = "Family System Gacha",   flag = "gacha_family",  icon = "users"     },
            { key = "World5", title = "Hunter Class Gacha",    flag = "gacha_hunter",  icon = "crosshair" },
            { key = "World6", title = "Demon Moons Gacha",     flag = "gacha_demon",   icon = "moon"      },
            { key = "World7", title = "Magic Attributes Gacha",flag = "gacha_magic",   icon = "sparkles"  },
        }
        rarityList = { "Common","Uncommon","Rare","Epic","Legendary","Mythical","Secret","Divine" }
        return
    end

    if GachaConfig.Rarity_Order then
        rarityList = {}
        for _, rarity in ipairs(GachaConfig.Rarity_Order) do
            table.insert(rarityList, rarity)
        end
    end

    local emojiMap = {
        Common = "⚪", Uncommon = "🟢", Rare = "🔵",
        Epic = "🟣", Legendary = "🟡", Mythical = "🔴",
        Secret = "🟠", Divine = "✨",
    }
    rarityEmoji = {}
    for _, rarity in ipairs(rarityList) do
        rarityEmoji[rarity] = emojiMap[rarity] or "❓"
    end

    local iconMap = {
        World0 = "sparkles", World1 = "eye",       World2 = "earth",
        World3 = "flame",    World4 = "users",     World5 = "crosshair",
        World6 = "moon",     World7 = "sparkles",
    }

    gachaWorlds = {}
    local gachaKeys = {}
    for worldKey, _ in pairs(GachaConfig.Gachas) do
        table.insert(gachaKeys, worldKey)
    end
    table.sort(gachaKeys)

    for _, worldKey in ipairs(gachaKeys) do
        local data = GachaConfig.Gachas[worldKey]
        local flag = "gacha_" .. worldKey:lower()
        table.insert(gachaWorlds, {
            key   = worldKey,
            title = (data.Name or worldKey) .. " Gacha",
            flag  = flag,
            icon  = iconMap[worldKey] or "sparkles",
        })
    end
end

local function buildProgressionFromConfig()
    local ok, ProgressionConfig = pcall(function()
        return require(ReplicatedStorage.SimpleWorld.Library.Config.ProgressionConfig)
    end)
    if not ok or not ProgressionConfig then
        progressionWorlds = {
            { key = "World1", title = "Ninja Progression",  flag = "prog_world1", icon = "zap",        maxLevel = 45 },
            { key = "World2", title = "Ki Progression",     flag = "prog_world2", icon = "wind",       maxLevel = 45 },
            { key = "World3", title = "Fruit Progression",  flag = "prog_world3", icon = "apple",      maxLevel = 45 },
            { key = "World4", title = "DMT Progression",    flag = "prog_world4", icon = "shield",     maxLevel = 45 },
            { key = "World5", title = "Mana Measuring",     flag = "prog_world5", icon = "sparkles",   maxLevel = 45 },
            { key = "World6", title = "Slayer Progression", flag = "prog_world6", icon = "sword",      maxLevel = 45 },
            { key = "World7", title = "Magic Progression",  flag = "prog_world7", icon = "trending-up",maxLevel = 45 },
        }
        return
    end

    local iconMap = {
        World1 = "zap",    World2 = "wind",      World3 = "apple",
        World4 = "shield", World5 = "sparkles",  World6 = "sword",
        World7 = "trending-up",
    }

    progressionWorlds = {}
    local progKeys = {}
    for worldKey, _ in pairs(ProgressionConfig.Progressions) do
        table.insert(progKeys, worldKey)
    end
    table.sort(progKeys)

    for _, worldKey in ipairs(progKeys) do
        local data = ProgressionConfig.Progressions[worldKey]
        local flag = "prog_" .. worldKey:lower()
        table.insert(progressionWorlds, {
            key      = worldKey,
            title    = data.Name or (worldKey .. " Progression"),
            flag     = flag,
            icon     = iconMap[worldKey] or "trending-up",
            maxLevel = data.MaxLevel or 45,
        })
    end
end

local function buildRaidDataFromConfig()
    local ok, RaidConfig = pcall(function()
        return require(ReplicatedStorage.SimpleWorld.Library.Config.RaidConfig)
    end)
    if not ok or not RaidConfig then return end

    local allRaids = RaidConfig:GetAllRaids()
    for _, raidData in pairs(allRaids) do
        local worldId    = raidData.WorldId
        local totalWaves = raidData.TotalWaves or 50

        if worldId == 0 then
            raidWaveLimits.timelessRaid = totalWaves
        elseif worldId == 1 then
            raidWaveLimits.ninjaRaid = totalWaves
        elseif worldId == 6 then
            raidWaveLimits.infinityRaid = totalWaves
        elseif worldId == 7 then
            raidWaveLimits.cloverRaid = totalWaves
        elseif worldId == 5 then
            raidWaveLimits.gate = totalWaves
            if raidData.GateRanks then
                gateRankOptions = {}
                for _, rankData in ipairs(raidData.GateRanks) do
                    table.insert(gateRankOptions, rankData.Rank)
                end
            end
        end
    end
end

local function buildEggWorldsFromConfig()
    local ok, EggsData = pcall(function()
        return require(ReplicatedStorage.SimpleWorld.Library.Config.EggsData)
    end)
    if not ok or not EggsData then return end

    starWorldOptions = {}
    local eggKeys = {}
    for worldKey, _ in pairs(EggsData) do
        table.insert(eggKeys, worldKey)
    end
    table.sort(eggKeys)

    for _, worldKey in ipairs(eggKeys) do
        local num = worldKey:match("World(%d+)")
        if num then table.insert(starWorldOptions, num) end
    end
end

local function buildCraftWorldsFromConfig()
    local ok, CraftConfig = pcall(function()
        return require(ReplicatedStorage.SimpleWorld.Library.Config.CraftConfig)
    end)
    if not ok or not CraftConfig then return end

    craftWorldOptions = {}
    local recipeKeys = {}
    for worldKey, _ in pairs(CraftConfig.Recipes) do
        table.insert(recipeKeys, worldKey)
    end
    table.sort(recipeKeys)

    for _, worldKey in ipairs(recipeKeys) do
        table.insert(craftWorldOptions, worldKey)
    end
end

buildEnemyListFromConfig()
buildWorldNamesFromConfig()
buildGachaFromConfig()
buildProgressionFromConfig()
buildRaidDataFromConfig()
buildEggWorldsFromConfig()
buildCraftWorldsFromConfig()

for _, rank in ipairs(gateRankOptions) do
    gate_leaveWave[rank] = 0
end

local selectedMobs = {}
local function initSelectedMobs()
    for key, _ in pairs(worldMobs) do
        if not selectedMobs[key] then selectedMobs[key] = {} end
    end
end
initSelectedMobs()

local function hasAnyMobSelected()
    for _, mobs in pairs(selectedMobs) do
        if #mobs > 0 then return true end
    end
    return false
end

local function isMobStillSelected(worldKey, mobName)
    local ws = selectedMobs[worldKey]
    if not ws then return false end
    for _, n in ipairs(ws) do
        if n == mobName then return true end
    end
    return false
end

-- ══════════════════════════════════════════
--   POSITION LOCK HELPERS
-- ══════════════════════════════════════════
local farmLock     = { conn = nil, pos = nil }
local ninjaLock    = { conn = nil, pos = nil }
local timelessLock = { conn = nil, pos = nil }
local defenseLock  = { conn = nil, pos = nil }
local gateLock     = { conn = nil, pos = nil }
local trialLock    = { conn = nil, pos = nil }
local infinityLock = { conn = nil, pos = nil }
local cloverLock   = { conn = nil, pos = nil }
local starLock     = { conn = nil, pos = nil }

local function stopLockTable(t)
    if t.conn then t.conn:Disconnect() t.conn = nil end
    t.pos = nil
end

local function startLockTable(t, pos, runningCheck)
    stopLockTable(t)
    t.pos = pos
    t.conn = RunService.Heartbeat:Connect(function()
        if not t.pos or not runningCheck() then stopLockTable(t) return end
        local r = getRoot()
        if not r then return end
        r.CFrame = CFrame.new(t.pos)
        r.AssemblyLinearVelocity  = ZERO_VEC
        r.AssemblyAngularVelocity = ZERO_VEC
    end)
end

local function stopFarmLock()     stopLockTable(farmLock)     end
local function stopNinjaLock()    stopLockTable(ninjaLock)    end
local function stopTimelessLock() stopLockTable(timelessLock) end
local function stopDefenseLock()  stopLockTable(defenseLock)  end
local function stopGateLock()     stopLockTable(gateLock)     end
local function stopTrialLock()    stopLockTable(trialLock)    end
local function stopInfinityLock() stopLockTable(infinityLock) end
local function stopCloverLock()   stopLockTable(cloverLock)   end
local function stopStarLock()     stopLockTable(starLock)     end

local function startFarmLock(pos)
    startLockTable(farmLock, pos, function() return autofarm_running end)
end
local function startNinjaLock(pos)
    startLockTable(ninjaLock, pos, function() return ninjaRaid_running end)
end
local function startTimelessLock(pos)
    startLockTable(timelessLock, pos, function() return timelessRaid_running end)
end
local function startDefenseLock(pos)
    startLockTable(defenseLock, pos, function() return defense_running end)
end
local function startGateLock(pos)
    startLockTable(gateLock, pos, function() return gate_actively_farming end)
end
local function startTrialLock(pos)
    startLockTable(trialLock, pos, function() return trial_actively_farming end)
end
local function startCloverLock(pos)
    startLockTable(cloverLock, pos, function() return cloverRaid_running end)
end

-- ══════════════════════════════════════════
--   LEAVE REMOTES
-- ══════════════════════════════════════════
local function fireLeaveRaid()
    safeLeaveRaid()
end

local function fireLeaveDefense()
    safeLeaveDefense()
end

local function fireLeaveTrial()
    safeLeaveTrial()
end

-- ══════════════════════════════════════════
--   ARENA EXISTENCE CHECKS
-- ══════════════════════════════════════════
local RaidArenas    = workspace:WaitForChild("RaidArenas",    10)
local DefenseArenas = workspace:WaitForChild("DefenseArenas", 10)
local TrialArenas   = workspace:WaitForChild("TimeTrialArenas", 10)

local function ninjaRaidExists()
    local f = RaidArenas and RaidArenas:FindFirstChild("World1")
    return f ~= nil and f.Parent ~= nil
end

local function timelessRaidExists()
    local f = RaidArenas and RaidArenas:FindFirstChild("World0")
    return f ~= nil and f.Parent ~= nil
end

local function infinityRaidExists()
    local f = RaidArenas and RaidArenas:FindFirstChild("World6")
    return f ~= nil and f.Parent ~= nil
end

local function cloverRaidExists()
    local f = RaidArenas and RaidArenas:FindFirstChild("World7")
    return f ~= nil and f.Parent ~= nil
end

local function defenseExists()
    local f = DefenseArenas and DefenseArenas:FindFirstChild("World4")
    return f ~= nil and f.Parent ~= nil
end

local function gateArenaExists()
    local f = RaidArenas and RaidArenas:FindFirstChild("World5")
    return f ~= nil and f.Parent ~= nil
end

local function trialArenaHasEnemies(difficulty)
    local arena = TrialArenas and TrialArenas:FindFirstChild(difficulty)
    if not arena then return false end
    local enemies = arena:FindFirstChild("Enemies")
    return enemies ~= nil and #enemies:GetChildren() > 0
end

local function trialArenaExistsByDifficulty(difficulty)
    if not TrialArenas then return false end
    return TrialArenas:FindFirstChild(difficulty) ~= nil
end

local function trialArenaExists()
    if not TrialArenas then return false end
    return #TrialArenas:GetChildren() > 0
end

local function gateActiveExists()
    local ok, f = pcall(function()
        return workspace.Worlds["5"].Systems.RaidStation.ActiveGate
    end)
    return ok and f ~= nil and f.Parent ~= nil
end

-- ══════════════════════════════════════════
--   WAVE / ROOM HELPERS
-- ══════════════════════════════════════════
local _raidWaveLabel    = nil
local _defenseWaveLabel = nil
local _trialRoomLabel   = nil

local function getRaidWave()
    if not _raidWaveLabel or not _raidWaveLabel.Parent then
        local ok, lbl = pcall(function() return LocalPlayer.PlayerGui.RaidGui.Main.Wave end)
        _raidWaveLabel = ok and lbl or nil
    end
    if not _raidWaveLabel then return nil end
    local t = _raidWaveLabel.Text
    local n = t:match("Wave%s+(%d+)") or t:match("(%d+)")
    return tonumber(n)
end

local function getDefenseWave()
    if not _defenseWaveLabel or not _defenseWaveLabel.Parent then
        local ok, lbl = pcall(function() return LocalPlayer.PlayerGui.DefenseGui.Main.Wave end)
        _defenseWaveLabel = ok and lbl or nil
    end
    if not _defenseWaveLabel then return nil end
    local t = _defenseWaveLabel.Text
    local n = t:match("Wave%s+(%d+)") or t:match("(%d+)")
    return tonumber(n)
end

local function getTrialRoom()
    if not _trialRoomLabel or not _trialRoomLabel.Parent then
        local ok, lbl = pcall(function() return LocalPlayer.PlayerGui.TrialGui.Main.Room end)
        _trialRoomLabel = ok and lbl or nil
    end
    if not _trialRoomLabel then return nil end
    local t = _trialRoomLabel.Text
    local n = t:match("Room%s+(%d+)") or t:match("(%d+)")
    return tonumber(n)
end

local function getGateRank()
    local ok, text = pcall(function()
        return workspace.Worlds["5"].Systems.RaidStation.Gui.Main.Rank.Text
    end)
    if not ok or not text then return nil end
    return text:match("RANK:%s*(%a)") or text:match("(%a)$")
end

-- ══════════════════════════════════════════
--   DROPDOWN VALUES
-- ══════════════════════════════════════════
local function buildWaveDropdown(maxWaves)
    local t = {"0"}
    for i = 1, maxWaves do table.insert(t, tostring(i)) end
    return t
end

local waveDropdown50       = buildWaveDropdown(raidWaveLimits.gate)
local waveDropdown100      = buildWaveDropdown(raidWaveLimits.ninjaRaid)
local waveDropdown30       = buildWaveDropdown(raidWaveLimits.infinityRaid)
local waveDropdownTimeless = buildWaveDropdown(raidWaveLimits.timelessRaid)
local waveDropdownClover   = buildWaveDropdown(raidWaveLimits.cloverRaid)
local roomDropdown50       = buildWaveDropdown(50)

-- ══════════════════════════════════════════
--   STOP ALL FARMS
-- ══════════════════════════════════════════
local function stopAllExclusiveFarms(saveCurrent)
    if isSwitching then
        local waited = 0
        while isSwitching and waited < 15 do
            task.wait(0.5)
            waited += 0.5
        end
        if isSwitching then return end
    end
    isSwitching = true

    local wasRunning = nil
    if autofarm_running      then wasRunning = "autofarm"     end
    if ninjaRaid_running     then wasRunning = "ninjaRaid"    end
    if timelessRaid_running  then wasRunning = "timelessRaid" end
    if infinityRaid_running  then wasRunning = "infinityRaid" end
    if cloverRaid_running    then wasRunning = "cloverRaid"   end
    if defense_running       then wasRunning = "defense"      end

    Library:Notification("Switching", "Stopping all farms...", 2)

    autofarm_running      = false
    ninjaRaid_running     = false
    timelessRaid_running  = false
    infinityRaid_running  = false
    cloverRaid_running    = false
    defense_running       = false

    stopFarmLock()
    stopNinjaLock()
    stopTimelessLock()
    stopInfinityLock()
    stopCloverLock()
    stopDefenseLock()

    task.wait(2)

    if ninjaRaidExists()    then Library:Notification("Switching", "Leaving Ninja Raid...", 2) pcall(fireLeaveRaid);    task.wait(3) end
    if timelessRaidExists() then Library:Notification("Switching", "Leaving Timeless Raid...", 2) pcall(fireLeaveRaid);    task.wait(3) end
    if infinityRaidExists() then Library:Notification("Switching", "Leaving Infinity Castle...", 2) pcall(fireLeaveRaid);    task.wait(3) end
    if cloverRaidExists()   then Library:Notification("Switching", "Leaving Clover Raid...", 2) pcall(fireLeaveRaid);    task.wait(3) end
    if defenseExists()      then Library:Notification("Switching", "Leaving Defense...", 2) pcall(fireLeaveDefense); task.wait(3) end

    if saveCurrent and wasRunning then
        saveFarm(wasRunning)
    end

    task.wait(2)
    isSwitching = false
    
    Library:Notification("Switching", "All farms stopped. Ready!", 2)
end

local function stopEverythingForCrow()
    if isSwitching then
        local waited = 0
        while isSwitching and waited < 10 do
            task.wait(0.5)
            waited += 0.5
        end
    end
    isSwitching = true

    local wasRunning = nil
    if autofarm_running     then wasRunning = "autofarm"     end
    if ninjaRaid_running    then wasRunning = "ninjaRaid"    end
    if timelessRaid_running then wasRunning = "timelessRaid" end
    if infinityRaid_running then wasRunning = "infinityRaid" end
    if cloverRaid_running   then wasRunning = "cloverRaid"   end
    if defense_running      then wasRunning = "defense"      end

    autofarm_running      = false
    ninjaRaid_running     = false
    timelessRaid_running  = false
    infinityRaid_running  = false
    cloverRaid_running    = false
    defense_running       = false
    gate_actively_farming = false
    trial_actively_farming = false

    stopFarmLock()
    stopNinjaLock()
    stopTimelessLock()
    stopDefenseLock()
    stopGateLock()
    stopTrialLock()
    stopInfinityLock()
    stopCloverLock()

    task.wait(1)

    if ninjaRaidExists()    then pcall(fireLeaveRaid);    task.wait(1.5) end
    if timelessRaidExists() then pcall(fireLeaveRaid);    task.wait(1.5) end
    if infinityRaidExists() then pcall(fireLeaveRaid);    task.wait(1.5) end
    if cloverRaidExists()   then pcall(fireLeaveRaid);    task.wait(1.5) end
    if defenseExists()      then pcall(fireLeaveDefense); task.wait(1.5) end
    if gateArenaExists()    then pcall(fireLeaveRaid);    task.wait(1.5) end
    if trialArenaExists()   then pcall(fireLeaveTrial);   task.wait(1.5) end

    if wasRunning then
        saveFarm(wasRunning)
    end

    task.wait(0.5)
    isSwitching = false
end

-- ══════════════════════════════════════════
--   FORWARD DECLARATIONS
-- ══════════════════════════════════════════
local spawnAutofarmLoop
local spawnNinjaRaidLoop
local spawnTimelessRaidLoop
local spawnDefenseLoop
local spawnInfinityRaidLoop
local spawnCloverRaidLoop
local resumeSavedFarm

-- ══════════════════════════════════════════
--   AUTO BOOST SYSTEM
-- ══════════════════════════════════════════
local ALL_POTIONS = {
    "DropPotion1","DropPotion2",
    "DamagePotion1","DamagePotion2",
    "PowerPotion1","PowerPotion2",
    "XPPotion1","XPPotion2",
    "YenPotion1","YenPotion2",
    "LuckPotion1","LuckPotion2",
}

local boostConfig = {
    autofarm     = {},
    ninjaRaid    = {},
    timelessRaid = {},
    infinityRaid = {},
    cloverRaid   = {},
    defense      = {},
    trial        = {},
    gate         = { E = {}, D = {}, C = {}, B = {} },
    autostar     = {},
}

local autoboost_enabled    = false
local currentActivePotions = {}

local _PotionStateBridge = nil
local _PotionPauseToggle = nil

local function getBoostBridges()
    if not _PotionStateBridge or not _PotionPauseToggle then
        local lib = getLibrary()
        _PotionStateBridge = lib.getBridge("PotionState")
        _PotionPauseToggle = lib.getBridge("PotionPauseToggle")
    end
    return _PotionStateBridge, _PotionPauseToggle
end

local function getBoostStates()
    local PotionStateBridge, _ = getBoostBridges()
    if not PotionStateBridge then return {} end
    local states   = {}
    local received = false
    local conn = PotionStateBridge:Connect(function(state)
        if type(state) == "table" then
            states   = state
            received = true
        end
    end)
    PotionStateBridge:Fire({ Request = true })
    local timeout = 0
    while not received and timeout < 50 do
        task.wait(0.1); timeout += 1
    end
    conn:Disconnect()
    return states
end

local function pauseAllBoosts()
    if not autoboost_enabled then return end
    local states = getBoostStates()
    local _, PotionPauseToggle = getBoostBridges()
    if not PotionPauseToggle then return end
    for _, potionID in ipairs(ALL_POTIONS) do
        local data = states[potionID]
        if type(data) == "table" and data.Paused ~= true then
            pcall(function() PotionPauseToggle:Fire(potionID) end)
            task.wait(0.1)
        end
    end
    currentActivePotions = {}
    Library:Notification("Auto Boost", "All boosts paused.", 3)
end

local function applyBoostSet(desiredActive, farmLabel)
    if not autoboost_enabled then return end
    task.spawn(function()
        local states = getBoostStates()
        local _, PotionPauseToggle = getBoostBridges()
        if not PotionPauseToggle then return end

        local desiredMap = {}
        for _, id in ipairs(desiredActive) do desiredMap[id] = true end
        local currentMap = {}
        for _, id in ipairs(currentActivePotions) do currentMap[id] = true end

        for _, potionID in ipairs(ALL_POTIONS) do
            if currentMap[potionID] and not desiredMap[potionID] then
                local data = states[potionID]
                if type(data) == "table" and data.Paused ~= true then
                    pcall(function() PotionPauseToggle:Fire(potionID) end)
                    task.wait(0.1)
                end
            end
        end
        for _, potionID in ipairs(desiredActive) do
            if not currentMap[potionID] then
                local data = states[potionID]
                if type(data) == "table" and data.Paused == true then
                    pcall(function() PotionPauseToggle:Fire(potionID) end)
                    task.wait(0.1)
                end
            end
        end
        currentActivePotions = desiredActive
        if farmLabel and #desiredActive > 0 then
            Library:Notification("Auto Boost", farmLabel .. ": " .. #desiredActive .. " boost(s) active", 3)
        end
    end)
end

local function applyBoostsForFarm(farmKey, gateRank)
    if not autoboost_enabled then return end
    if farmKey == "gate" then
        local rank    = gateRank or "E"
        local desired = (boostConfig.gate and boostConfig.gate[rank]) or {}
        applyBoostSet(desired, "Gate Rank " .. rank)
    else
        local desired = boostConfig[farmKey] or {}
        applyBoostSet(desired, farmKey)
    end
end

-- ══════════════════════════════════════════
--   RESUME SAVED FARM
-- ══════════════════════════════════════════
resumeSavedFarm = function(source)
    if isResuming then return end
    if isSwitching then return end
    if crow_actively_farming then return end
    
    isResuming = true

    task.spawn(function()
        local waited = 0
        while (crow_actively_farming or gate_actively_farming or trial_actively_farming or isSwitching or isWorldLoading) and waited < 30 do
            task.wait(1)
            waited += 1
        end

        if crow_actively_farming or isSwitching then
            isResuming = false
            return
        end

        if autofarm_running or ninjaRaid_running or timelessRaid_running
            or infinityRaid_running or cloverRaid_running or defense_running then
            isResuming = false
            return
        end

        if ninjaRaidExists()    then pcall(fireLeaveRaid);    task.wait(1.5) end
        if timelessRaidExists() then pcall(fireLeaveRaid);    task.wait(1.5) end
        if infinityRaidExists() then pcall(fireLeaveRaid);    task.wait(1.5) end
        if cloverRaidExists()   then pcall(fireLeaveRaid);    task.wait(1.5) end
        if defenseExists()      then pcall(fireLeaveDefense); task.wait(1.5) end

        local farm = popFarmFromStack()
        if not farm then farm = savedExclusiveFarm end
        if not farm then isResuming = false return end
        savedExclusiveFarm = nil

        Library:Notification(source or "Auto Resume", "Resuming: " .. farm, 3)

        task.wait(1)

        if farm == "autofarm" then
            if selectedLoadouts.autofarm then safeEquipLoadout(selectedLoadouts.autofarm) task.wait(0.5) end
            autofarm_running = true
            spawnAutofarmLoop()
        elseif farm == "ninjaRaid" then
            if selectedLoadouts.ninjaRaid then safeEquipLoadout(selectedLoadouts.ninjaRaid) task.wait(0.5) end
            safeTeleport(1)
            task.wait(3)
            ninjaRaid_running = true
            spawnNinjaRaidLoop()
        elseif farm == "timelessRaid" then
            if selectedLoadouts.timelessRaid then safeEquipLoadout(selectedLoadouts.timelessRaid) task.wait(0.5) end
            safeTeleport(0)
            task.wait(3)
            timelessRaid_running = true
            spawnTimelessRaidLoop()
        elseif farm == "infinityRaid" then
            if selectedLoadouts.infinityRaid then safeEquipLoadout(selectedLoadouts.infinityRaid) task.wait(0.5) end
            safeTeleport(6)
            task.wait(3)
            infinityRaid_running = true
            spawnInfinityRaidLoop()
        elseif farm == "cloverRaid" then
            if selectedLoadouts.cloverRaid then safeEquipLoadout(selectedLoadouts.cloverRaid) task.wait(0.5) end
            safeTeleport(7)
            task.wait(3)
            cloverRaid_running = true
            spawnCloverRaidLoop()
        elseif farm == "defense" then
            if selectedLoadouts.defense then safeEquipLoadout(selectedLoadouts.defense) task.wait(0.5) end
            safeTeleport(4)
            task.wait(3)
            defense_running = true
            spawnDefenseLoop()
        end

        isResuming = false
    end)
end

-- ══════════════════════════════════════════
--   RESUME WATCHDOG
-- ══════════════════════════════════════════
local lastFarmActivityTime = tick()
local WATCHDOG_GRACE_PERIOD = 30

task.spawn(function()
    while true do
        task.wait(10)

        if crow_actively_farming or gate_actively_farming or trial_actively_farming
            or autofarm_running or ninjaRaid_running or timelessRaid_running
            or infinityRaid_running or cloverRaid_running or defense_running
            or isWorldLoading or isSwitching or isResuming then
            lastFarmActivityTime = tick()
            continue
        end

        if (gate_running and not gate_actively_farming) or (trial_running and not trial_actively_farming) then
            if tick() - lastFarmActivityTime < WATCHDOG_GRACE_PERIOD then
                continue
            end
        end

        if #farmResumeStack == 0 and not savedExclusiveFarm then 
            continue 
        end

        if tick() - lastFarmActivityTime >= WATCHDOG_GRACE_PERIOD then
            Library:Notification("Watchdog", "Detected idle for 30s — resuming farm...", 4)
            lastFarmActivityTime = tick()
            resumeSavedFarm("Watchdog")
        end
    end
end)

-- ══════════════════════════════════════════
--   MUTUAL EXCLUSIVITY CHECK
-- ══════════════════════════════════════════
local function getRunningExclusiveName()
    if crow_actively_farming  then return "Auto Crow"           end
    if gate_actively_farming  then return "Auto Gate (active)"  end
    if trial_actively_farming then return "Auto Trial (active)" end
    if autofarm_running       then return "Auto Farm Mob"       end
    if ninjaRaid_running      then return "Ninja Raid"          end
    if timelessRaid_running   then return "Timeless Raid"       end
    if infinityRaid_running   then return "Infinity Castle"     end
    if cloverRaid_running     then return "Clover Raid"         end
    if defense_running        then return "Auto Defense"        end
    return nil
end

-- ══════════════════════════════════════════
--   AUTO CROW SYSTEM
-- ══════════════════════════════════════════
local function getCrowFolder()
    return workspace:FindFirstChild("World6Corvos")
end

local function world6SystemsHasChildren()
    local ok, sys = pcall(function() return workspace.Worlds["6"].Systems end)
    return ok and sys and #sys:GetChildren() > 0
end

local function getCrowPosition(crow)
    if not crow or not crow.Parent then return nil end
    if crow:IsA("BasePart") then return crow.Position end
    if crow:IsA("Model") then
        local part = crow:FindFirstChild("HumanoidRootPart")
            or crow:FindFirstChild("Torso")
            or crow:FindFirstChildOfClass("BasePart")
        if part then return part.Position end
        local ok, cf = pcall(function() return crow:GetPivot() end)
        if ok and cf then return cf.Position end
    end
    return nil
end

local function setEHeld(held)
    local done = pcall(function()
        game:GetService("VirtualInputManager"):SendKeyEvent(held, Enum.KeyCode.E, false, game)
    end)
    if not done then
        if held and keypress then pcall(keypress, 0x45) end
        if not held and keyrelease then pcall(keyrelease, 0x45) end
    end
end

local function collectCrow(crow)
    local pos = getCrowPosition(crow)
    if not pos then
        local f = getCrowFolder()
        if f and #f:GetChildren() > 0 then pos = getCrowPosition(f:GetChildren()[1]) end
    end
    if not pos then return false end

    local r = getRoot()
    if r then
        r.CFrame = CFrame.new(pos)
        r.AssemblyLinearVelocity  = ZERO_VEC
        r.AssemblyAngularVelocity = ZERO_VEC
    end
    task.wait(0.3)

    Library:Notification("Auto Crow", "Holding E to collect (3s)...", 4)
    setEHeld(true)

    local holdStart = tick()
    while tick() - holdStart < 3 do
        local f = getCrowFolder()
        if f and #f:GetChildren() > 0 then
            local np = getCrowPosition(f:GetChildren()[1])
            if np then
                local r2 = getRoot()
                if r2 then
                    r2.CFrame = CFrame.new(np)
                    r2.AssemblyLinearVelocity  = ZERO_VEC
                    r2.AssemblyAngularVelocity = ZERO_VEC
                end
            end
        end
        task.wait(0.1)
    end
    setEHeld(false)
    return true
end

local handleCrowDetected
handleCrowDetected = function(crow)
    if crow_actively_farming then return end
    crow_actively_farming = true

    Library:Notification("🐦 Crow Detected!", "Stopping all farms...", 4)
    
    if specialFarmMutex then
        releaseSpecialFarmLock()
    end
    
    stopEverythingForCrow()
    task.wait(3)

    Library:Notification("Auto Crow", "Going to World 6...", 3)
    safeTeleport(6)
    task.wait(3)

    local ok = collectCrow(crow)
    Library:Notification("Auto Crow", ok and "Crow collected!" or "Crow gone / not found.", 4)

    task.wait(2)
    crow_actively_farming = false
    resumeSavedFarm("Auto Crow")
end

local function spawnCrowLoop()
    task.spawn(function()
        if not world6SystemsHasChildren() then
            Library:Notification("Auto Crow", "Loading World 6 first...", 3)
            stopEverythingForCrow()
            task.wait(3)
            safeTeleport(6)
            task.wait(3)
            local waited = 0
            while not world6SystemsHasChildren() and waited < 15 do
                task.wait(0.5); waited += 0.5
            end
            task.wait(1)
            resumeSavedFarm("Auto Crow")
        end

        local folder = getCrowFolder()
        local conn
        if folder then
            conn = folder.ChildAdded:Connect(function(child)
                if not autocrow_running or crow_actively_farming then return end
                task.spawn(function() handleCrowDetected(child) end)
            end)
        end

        while autocrow_running do
            task.wait(5)
            if crow_actively_farming or isWorldLoading then continue end
            local f = getCrowFolder()
            if not f then continue end
            local crows = f:GetChildren()
            if #crows > 0 and crows[1] and crows[1].Parent then
                handleCrowDetected(crows[1])
            end
        end

        if conn then conn:Disconnect() end
        crow_actively_farming = false
    end)
end

-- ══════════════════════════════════════════
--   AUTO SWORD PASSIVE SYSTEM
-- ══════════════════════════════════════════
local passiveOptions = {
    "WaterBreathing", "BeastBreathing", "ThunderBreathing", "FlameBreathing",
    "SerpentBreathing", "WindBreathing", "MoonBreathing", "SunBreathing"
}

local passiveDisplayNames = {
    WaterBreathing   = "Water Breathing",
    BeastBreathing   = "Beast Breathing",
    ThunderBreathing = "Thunder Breathing",
    FlameBreathing   = "Flame Breathing",
    SerpentBreathing = "Serpent Breathing",
    WindBreathing    = "Wind Breathing",
    MoonBreathing    = "Moon Breathing",
    SunBreathing     = "Sun Breathing"
}

local sword1_running = false
local sword2_running = false
local sword1_target  = nil
local sword2_target  = nil
local sword1_waiting = false
local sword2_waiting = false
local sword1InfoLabel = nil
local sword2InfoLabel = nil

local function getSwordPassiveKey(swordData)
    if not swordData then return nil end
    return string.format("World0_%s_%s_%s", 
        swordData.Rarity, 
        swordData.Level, 
        swordData.Index
    )
end

local function getCurrentPassiveId(swordData)
    local key = getSwordPassiveKey(swordData)
    if not key or not cachedSwordPassives[key] then return nil end
    return cachedSwordPassives[key].Id
end

local function updateSwordInfo()
    fetchPlayerData()
end

local function spawnSword1Loop()
    task.spawn(function()
        applyBoostsForFarm("autofarm")
        
        while sword1_running do
            if isWorldLoading then task.wait(0.5) continue end
            
            if not sword1_data then
                Library:Notification("Sword 1", "No sword equipped!", 3)
                sword1_running = false
                break
            end
            
            local currentPassive = getCurrentPassiveId(sword1_data)
            if currentPassive == sword1_target then
                Library:Notification("Sword 1 Complete!", "Reached " .. passiveDisplayNames[sword1_target], 4)
                sword1_running = false
                
                if sword2_waiting then
                    sword2_waiting = false
                    sword2_running = true
                    spawnSword2Loop()
                end
                break
            end
            
            safeSwordPassiveRoll("World6", "World0", sword1_data.Rarity, sword1_data.Level, sword1_data.Index)
            task.wait(1.5)
        end
    end)
end

local function spawnSword2Loop()
    task.spawn(function()
        applyBoostsForFarm("autofarm")
        
        while sword2_running do
            if isWorldLoading then task.wait(0.5) continue end
            
            if not sword2_data then
                Library:Notification("Sword 2", "No sword equipped!", 3)
                sword2_running = false
                break
            end
            
            local currentPassive = getCurrentPassiveId(sword2_data)
            if currentPassive == sword2_target then
                Library:Notification("Sword 2 Complete!", "Reached " .. passiveDisplayNames[sword2_target], 4)
                sword2_running = false
                break
            end
            
            safeSwordPassiveRoll("World6", "World0", sword2_data.Rarity, sword2_data.Level, sword2_data.Index)
            task.wait(1.5)
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(3)
        pcall(function()
            if sword1_data then
                local passive = passiveDisplayNames[getCurrentPassiveId(sword1_data)] or "Unknown"
                if sword1InfoLabel then
                    sword1InfoLabel:SetText(string.format("Rarity: %s | Level: %d | Current: %s",
                        sword1_data.Rarity,
                        sword1_data.Level,
                        passive
                    ))
                end
            else
                if sword1InfoLabel then
                    sword1InfoLabel:SetText("No sword equipped")
                end
            end
        end)
        pcall(function()
            if sword2_data then
                local passive = passiveDisplayNames[getCurrentPassiveId(sword2_data)] or "Unknown"
                if sword2InfoLabel then
                    sword2InfoLabel:SetText(string.format("Rarity: %s | Level: %d | Current: %s",
                        sword2_data.Rarity,
                        sword2_data.Level,
                        passive
                    ))
                end
            else
                if sword2InfoLabel then
                    sword2InfoLabel:SetText("No sword equipped")
                end
            end
        end)
    end
end)

task.spawn(function()
    task.wait(5)
    pcall(function()
        local ResultBridge = getLibrary().getBridge("SwordPassiveResult")
        ResultBridge:Connect(function(success, errorCode, data)
            if success and type(data) == "table" then
                if data.SwordPassives then
                    cachedSwordPassives = data.SwordPassives
                end
            end
        end)
    end)
end)

-- ══════════════════════════════════════════
--   MIDDLE FARM HELPER
-- ══════════════════════════════════════════
local function findHighestHPEnemy(enemiesFolder)
    if not enemiesFolder then return nil end
    
    local highestEnemy = nil
    local highestHP = 0
    
    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
        if isMobDead(enemy) then continue end
        
        local maxHP = enemy:GetAttribute("MaxHealthReal")
        if maxHP and maxHP > highestHP then
            highestHP = maxHP
            highestEnemy = enemy
        end
    end
    
    return highestEnemy, highestHP
end

-- ══════════════════════════════════════════
--   RAID LOOP FACTORY
-- ══════════════════════════════════════════
local function makeRaidLoop(cfg)
    return function()
        task.spawn(function()
            applyBoostsForFarm(cfg.boostKey)

            while cfg.runningRef() do
                if isWorldLoading then task.wait(0.5) continue end
                if crow_actively_farming then
                    cfg.stopLock(); task.wait(1) continue
                end

                if not cfg.arenaExists() then
                    Library:Notification(cfg.title, "Creating...", 3)
                    safeTeleport(cfg.worldNum)
                    task.wait(5)
                    
                    Library:Notification(cfg.title, "Sending join request...", 2)
                    pcall(cfg.joinFn)
                    task.wait(6)
                end

                if not cfg.runningRef() then break end

                local createAttempts = 0
                while not cfg.arenaExists() and cfg.runningRef() and createAttempts < 5 do
                    if createAttempts > 0 then
                        Library:Notification(cfg.title, "Waiting for arena... (attempt " .. createAttempts .. ")", 2)
                    end
                    task.wait(2)
                    createAttempts += 1
                end

                if not cfg.arenaExists() then
                    Library:Notification(cfg.title, "Failed to create (timeout). Retrying...", 4)
                    task.wait(5)
                    continue
                end

                Library:Notification(cfg.title, "Arena created! Loading...", 2)
                task.wait(3)

                local farmMethod = cfg.getFarmMethod and cfg.getFarmMethod() or "Normal"
                Library:Notification(cfg.title, "Ready! Farming (" .. farmMethod .. " mode)", 3)
                task.wait(1)

                if cfg.resetLastWave then cfg.resetLastWave() end
                local hasTeleportedThisWave = false

                while cfg.runningRef() do
                    if isWorldLoading then cfg.stopLock() task.wait(0.5) continue end
                    if crow_actively_farming then
                        cfg.stopLock(); task.wait(1) continue
                    end

                    if not cfg.arenaExists() then
                        Library:Notification(cfg.title, "Ended. Restarting...", 4)
                        cfg.stopLock(); task.wait(5); break
                    end

                    local leaveW = cfg.leaveWaveRef()
                    local currentWave = nil
                    if leaveW > 0 and cfg.getWave then
                        currentWave = cfg.getWave()
                        if currentWave and currentWave >= leaveW then
                            Library:Notification(cfg.title, "Wave " .. currentWave .. " — leaving.", 3)
                            cfg.stopLock(); pcall(cfg.leaveFn); task.wait(5); break
                        end
                    end

                    local ok, ef = pcall(cfg.getEnemies)
                    if not ok or not ef then task.wait(0.5) continue end

                    farmMethod = cfg.getFarmMethod and cfg.getFarmMethod() or "Normal"

                    if farmMethod == "Middle" then
                        if not currentWave and cfg.getWave then
                            currentWave = cfg.getWave()
                        end
                        
                        local lastWave = cfg.getLastWave and cfg.getLastWave() or 0
                        if currentWave and currentWave ~= lastWave then
                            hasTeleportedThisWave = false
                            if cfg.setLastWave then cfg.setLastWave(currentWave) end
                        end

                        if not hasTeleportedThisWave then
                            local highestEnemy, highestHP = findHighestHPEnemy(ef)
                            
                            if highestEnemy then
                                local mp = getMobPosition(highestEnemy)
                                if mp then
                                    local lp = Vector3.new(mp.X, mp.Y, mp.Z)
                                    local r  = getRoot()
                                    if r then
                                        r.CFrame = CFrame.new(lp)
                                        r.AssemblyLinearVelocity  = ZERO_VEC
                                        r.AssemblyAngularVelocity = ZERO_VEC
                                        task.wait(0.2)
                                    end
                                    cfg.startLock(lp)
                                    hasTeleportedThisWave = true
                                    
                                    Library:Notification(cfg.title, "Wave " .. (currentWave or "?") .. " - Middle mob (HP: " .. math.floor(highestHP) .. ")", 2)
                                end
                            end
                        end
                        
                        task.wait(1)
                        
                    else
                        local farmedAny = false
                        for _, mob in ipairs(ef:GetChildren()) do
                            if not cfg.runningRef() then break end
                            if crow_actively_farming then break end
                            if isMobDead(mob) then continue end
                            farmedAny = true

                            local mp = getMobPosition(mob)
                            if mp then
                                local lp = Vector3.new(mp.X + 4, mp.Y, mp.Z + 4)
                                local r  = getRoot()
                                if r then
                                    r.CFrame = CFrame.new(lp)
                                    r.AssemblyLinearVelocity  = ZERO_VEC
                                    r.AssemblyAngularVelocity = ZERO_VEC
                                    task.wait(0.05)
                                end
                                cfg.startLock(lp)
                            end

                            while cfg.runningRef() and not isMobDead(mob) do
                                if crow_actively_farming then break end
                                if leaveW > 0 and cfg.getWave then
                                    local cw = cfg.getWave()
                                    if cw and cw >= leaveW then break end
                                end
                                if not cfg.arenaExists() then break end
                                local newMp = getMobPosition(mob)
                                if newMp and cfg.lockTable.conn then
                                    cfg.lockTable.pos = Vector3.new(newMp.X + 4, newMp.Y, newMp.Z + 4)
                                end
                                task.wait(0.05)
                            end
                            cfg.stopLock(); task.wait(0.05)
                        end

                        if not farmedAny then task.wait(0.3) end
                    end
                end
            end
            cfg.stopLock()
        end)
    end
end

-- ══════════════════════════════════════════
--   RAID LOOP INSTANCES
-- ══════════════════════════════════════════
spawnNinjaRaidLoop = makeRaidLoop({
    runningRef     = function() return ninjaRaid_running end,
    lockTable      = ninjaLock,
    stopLock       = stopNinjaLock,
    startLock      = startNinjaLock,
    arenaExists    = ninjaRaidExists,
    getEnemies     = function() return workspace.RaidArenas.World1.Enemies end,
    getWave        = getRaidWave,
    leaveWaveRef   = function() return ninjaRaid_leaveWave end,
    worldNum       = "1",
    joinFn         = function() safeJoinRaid("World1") end,
    leaveFn        = fireLeaveRaid,
    title          = "Ninja Raid",
    icon           = "shield",
    boostKey       = "ninjaRaid",
    getFarmMethod  = function() return ninja_farmMethod end,
    getLastWave    = function() return ninja_lastWave end,
    setLastWave    = function(w) ninja_lastWave = w end,
    resetLastWave  = function() ninja_lastWave = 0 end,
})

spawnTimelessRaidLoop = makeRaidLoop({
    runningRef     = function() return timelessRaid_running end,
    lockTable      = timelessLock,
    stopLock       = stopTimelessLock,
    startLock      = startTimelessLock,
    arenaExists    = timelessRaidExists,
    getEnemies     = function() return workspace.RaidArenas.World0.Enemies end,
    getWave        = getRaidWave,
    leaveWaveRef   = function() return timelessRaid_leaveWave end,
    worldNum       = "0",
    joinFn         = function() safeJoinRaid("World0") end,
    leaveFn        = fireLeaveRaid,
    title          = "Timeless Raid",
    icon           = "clock",
    boostKey       = "timelessRaid",
    getFarmMethod  = function() return timeless_farmMethod end,
    getLastWave    = function() return timeless_lastWave end,
    setLastWave    = function(w) timeless_lastWave = w end,
    resetLastWave  = function() timeless_lastWave = 0 end,
})

spawnInfinityRaidLoop = makeRaidLoop({
    runningRef     = function() return infinityRaid_running end,
    lockTable      = infinityLock,
    stopLock       = stopInfinityLock,
    startLock      = function(pos) startLockTable(infinityLock, pos, function() return infinityRaid_running end) end,
    arenaExists    = infinityRaidExists,
    getEnemies     = function() return workspace.RaidArenas.World6.Enemies end,
    getWave        = getRaidWave,
    leaveWaveRef   = function() return infinityRaid_leaveWave end,
    worldNum       = "6",
    joinFn         = function() safeJoinRaid("World6") end,
    leaveFn        = fireLeaveRaid,
    title          = "Infinity Castle",
    icon           = "castle",
    boostKey       = "infinityRaid",
    getFarmMethod  = function() return infinity_farmMethod end,
    getLastWave    = function() return infinity_lastWave end,
    setLastWave    = function(w) infinity_lastWave = w end,
    resetLastWave  = function() infinity_lastWave = 0 end,
})

spawnCloverRaidLoop = makeRaidLoop({
    runningRef     = function() return cloverRaid_running end,
    lockTable      = cloverLock,
    stopLock       = stopCloverLock,
    startLock      = startCloverLock,
    arenaExists    = cloverRaidExists,
    getEnemies     = function() return workspace.RaidArenas.World7.Enemies end,
    getWave        = getRaidWave,
    leaveWaveRef   = function() return cloverRaid_leaveWave end,
    worldNum       = "7",
    joinFn         = function() safeJoinRaid("World7") end,
    leaveFn        = fireLeaveRaid,
    title          = "Clover Raid",
    icon           = "clover",
    boostKey       = "cloverRaid",
    getFarmMethod  = function() return clover_farmMethod end,
    getLastWave    = function() return clover_lastWave end,
    setLastWave    = function(w) clover_lastWave = w end,
    resetLastWave  = function() clover_lastWave = 0 end,
})

spawnDefenseLoop = makeRaidLoop({
    runningRef     = function() return defense_running end,
    lockTable      = defenseLock,
    stopLock       = stopDefenseLock,
    startLock      = startDefenseLock,
    arenaExists    = defenseExists,
    getEnemies     = function() return workspace.DefenseArenas.World4.Enemies end,
    getWave        = getDefenseWave,
    leaveWaveRef   = function() return defense_leaveWave end,
    worldNum       = "4",
    joinFn         = safeCreateDefense,
    leaveFn        = fireLeaveDefense,
    title          = "Auto Defense",
    icon           = "shield",
    boostKey       = "defense",
})

-- ══════════════════════════════════════════
--   AUTO FARM MOB LOOP
-- ══════════════════════════════════════════
spawnAutofarmLoop = function()
    task.spawn(function()
        applyBoostsForFarm("autofarm")

        local startWorld = nil
        for _, wk in ipairs({"1","2","3","4","5","6","7"}) do
            if selectedMobs[wk] and #selectedMobs[wk] > 0 then
                startWorld = wk; break
            end
        end
        local currentWorld = nil
        if startWorld then
            safeTeleport(startWorld)
            currentWorld = startWorld
            task.wait(3)
        end

        while autofarm_running do
            if isWorldLoading then task.wait(0.5) continue end
            if crow_actively_farming or gate_actively_farming or trial_actively_farming then
                stopFarmLock(); task.wait(1) continue
            end

            local farmedAny = false
            for _, worldKey in ipairs({"1","2","3","4","5","6","7"}) do
                if not autofarm_running then break end
                if crow_actively_farming or gate_actively_farming or trial_actively_farming then break end

                local mobs = selectedMobs[worldKey]
                if not mobs or #mobs == 0 then continue end

                if worldKey ~= currentWorld then
                    stopFarmLock()
                    safeTeleport(worldKey)
                    currentWorld = worldKey
                    task.wait(3)
                end

                local ok, enemiesFolder = pcall(function()
                    return workspace.Worlds[worldKey].Enemies
                end)
                if not ok or not enemiesFolder then task.wait(0.5) continue end

                for _, mobName in ipairs(mobs) do
                    if not autofarm_running then break end
                    if crow_actively_farming or gate_actively_farming or trial_actively_farming then break end
                    if not isMobStillSelected(worldKey, mobName) then continue end

                    for _, mob in ipairs(enemiesFolder:GetChildren()) do
                        if not autofarm_running then break end
                        if crow_actively_farming or gate_actively_farming or trial_actively_farming then break end
                        if mob.Name ~= mobName then continue end
                        if isMobDead(mob) then continue end
                        if not isMobStillSelected(worldKey, mobName) then break end

                        farmedAny = true
                        local mp = getMobPosition(mob)
                        if mp then
                            local lp = Vector3.new(mp.X + 4, mp.Y, mp.Z + 4)
                            local r  = getRoot()
                            if r then
                                r.CFrame = CFrame.new(lp)
                                r.AssemblyLinearVelocity  = ZERO_VEC
                                r.AssemblyAngularVelocity = ZERO_VEC
                                task.wait(0.1)
                                startFarmLock(lp)
                            end
                        end

                        while autofarm_running and not isMobDead(mob) do
                            if crow_actively_farming or gate_actively_farming or trial_actively_farming then break end
                            if not isMobStillSelected(worldKey, mobName) then break end
                            local newMp = getMobPosition(mob)
                            if newMp and farmLock.conn then
                                farmLock.pos = Vector3.new(newMp.X + 4, newMp.Y, newMp.Z + 4)
                            end
                            task.wait(0.05)
                        end
                        stopFarmLock()
                        task.wait(0.05)
                    end
                end
            end

            if not farmedAny then task.wait(0.5) end
        end
        stopFarmLock()
    end)
end

-- ══════════════════════════════════════════
--   PRIORITY-AWARE GATE LOOP
-- ══════════════════════════════════════════
local function isRankSelected(rank)
    for _, r in ipairs(selectedGateRanks) do
        if r == rank then return true end
    end
    return false
end

local function spawnGateLoop()
    task.spawn(function()
        Library:Notification("Auto Gate", "Monitoring started!", 3)
        
        while gate_running do
            task.wait(3)

            if isWorldLoading or crow_actively_farming or isSwitching then 
                continue 
            end

            if trial_actively_farming and priorityChoice == "trial" then 
                task.wait(5)
                continue 
            end

            if specialFarmMutex and priorityChoice == "trial" then
                task.wait(5)
                continue
            end

            if gateArenaExists() then
                if not gate_actively_farming then
                    if not acquireSpecialFarmLock("gate") then
                        Library:Notification("Auto Gate", "Priority conflict - skipping.", 2)
                        continue
                    end
                end
                
                Library:Notification("Auto Gate", "Gate arena detected! Starting farm...", 3)
                
                gate_actively_farming = true
                local rank = getGateRank() or "E"
                
                local lo = selectedLoadouts.gate and selectedLoadouts.gate[rank]
                if lo then 
                    safeEquipLoadout(lo) 
                    task.wait(1)
                end
                
                applyBoostsForFarm("gate", rank)
                task.wait(0.5)

                Library:Notification("Auto Gate", "Farming Rank " .. rank .. " gate!", 4)

                local farmStartTime = tick()
                local lastEnemySeenTime = tick()

                while gate_running and gateArenaExists() do
                    if isWorldLoading then 
                        stopGateLock() 
                        task.wait(0.5) 
                        continue 
                    end

                    if crow_actively_farming then
                        Library:Notification("Auto Gate", "Crow detected - pausing gate.", 3)
                        stopGateLock()
                        gate_actively_farming = false
                        releaseSpecialFarmLock()
                        break
                    end

                    if trial_actively_farming and priorityChoice == "trial" then
                        Library:Notification("Auto Gate", "Trial priority - leaving gate.", 3)
                        stopGateLock()
                        pcall(fireLeaveRaid)
                        task.wait(2)
                        gate_actively_farming = false
                        releaseSpecialFarmLock()
                        break
                    end

                    local currentRank = getGateRank() or rank
                    local currentWave = getRaidWave()
                    local leaveW = gate_leaveWave[currentRank] or 0
                    if leaveW > 0 and currentWave and currentWave >= leaveW then
                        Library:Notification("Auto Gate", "Wave " .. currentWave .. " reached - leaving.", 3)
                        stopGateLock()
                        pcall(fireLeaveRaid)
                        task.wait(2)
                        gate_actively_farming = false
                        releaseSpecialFarmLock()
                        break
                    end

                    local ok, ef = pcall(function() 
                        return workspace.RaidArenas.World5.Enemies 
                    end)
                    
                    if not ok or not ef then 
                        task.wait(0.5) 
                        continue 
                    end

                    local enemyList = ef:GetChildren()
                    
                    if #enemyList > 0 then
                        lastEnemySeenTime = tick()
                    end

                    if tick() - lastEnemySeenTime > 180 then
                        Library:Notification("Auto Gate", "No enemies for 3min - gate may be bugged. Leaving...", 4)
                        stopGateLock()
                        pcall(fireLeaveRaid)
                        task.wait(2)
                        gate_actively_farming = false
                        releaseSpecialFarmLock()
                        break
                    end

                    if gate_farmMethod == "Middle" then
                        if #enemyList == 0 then
                            task.wait(1)
                            continue
                        end
                        
                        if currentWave and currentWave ~= gate_lastWave then
                            gate_lastWave = currentWave
                            
                            local highestEnemy, highestHP = findHighestHPEnemy(ef)
                            
                            if highestEnemy then
                                local mp = getMobPosition(highestEnemy)
                                if mp then
                                    local lp = Vector3.new(mp.X, mp.Y, mp.Z)
                                    local r  = getRoot()
                                    if r then
                                        r.CFrame = CFrame.new(lp)
                                        r.AssemblyLinearVelocity  = ZERO_VEC
                                        r.AssemblyAngularVelocity = ZERO_VEC
                                        task.wait(0.2)
                                    end
                                    startGateLock(lp)
                                    
                                    Library:Notification("Auto Gate", "Wave " .. currentWave .. " - Middle (HP: " .. math.floor(highestHP) .. ")", 2)
                                end
                            end
                        end
                        
                        task.wait(1)
                        
                    else
                        if #enemyList == 0 then
                            task.wait(0.5)
                            continue
                        end

                        local farmedAny = false
                        for _, mob in ipairs(enemyList) do
                            if not gate_running then break end
                            if not gateArenaExists() then break end
                            if crow_actively_farming then break end
                            if isMobDead(mob) then continue end

                            farmedAny = true
                            local mp = getMobPosition(mob)
                            if mp then
                                local lp = Vector3.new(mp.X + 4, mp.Y, mp.Z + 4)
                                local r  = getRoot()
                                if r then
                                    r.CFrame = CFrame.new(lp)
                                    r.AssemblyLinearVelocity  = ZERO_VEC
                                    r.AssemblyAngularVelocity = ZERO_VEC
                                    task.wait(0.1)
                                end
                                startGateLock(lp)
                            end

                            while gate_running and not isMobDead(mob) and gateArenaExists() do
                                if crow_actively_farming then break end
                                if not gate_actively_farming then break end
                                
                                local newMp = getMobPosition(mob)
                                if newMp and gateLock.conn then
                                    gateLock.pos = Vector3.new(newMp.X + 4, newMp.Y, newMp.Z + 4)
                                end
                                task.wait(0.05)
                            end
                            stopGateLock()
                            task.wait(0.05)
                        end

                        if not farmedAny then 
                            task.wait(0.3) 
                        end
                    end
                end
                
                stopGateLock()
                gate_actively_farming = false
                releaseSpecialFarmLock()

                Library:Notification("Auto Gate", "Gate completed. Resuming farm in 3s...", 4)
                task.wait(3)

                if not gateActiveExists() then
                    resumeSavedFarm("Auto Gate")
                end
                continue
            end

            local ok5, sys5 = pcall(function() return workspace.Worlds["5"].Systems end)
            local systemsLoaded = ok5 and sys5 and #sys5:GetChildren() > 0

            if not systemsLoaded then
                Library:Notification("Auto Gate", "Loading World 5...", 3)
                
                if not acquireSpecialFarmLock("gate") then
                    Library:Notification("Auto Gate", "Another farm is starting - skipping.", 2)
                    task.wait(10)
                    continue
                end
                
                stopAllExclusiveFarms(true)
                task.wait(2)
                safeTeleport(5)
                task.wait(5)
                releaseSpecialFarmLock()
                continue
            end

            if not gateActiveExists() then 
                task.wait(2)
                continue 
            end

            local rank = getGateRank()
            if not rank then 
                task.wait(2)
                continue 
            end
            
            if not isRankSelected(rank) then 
                task.wait(5)
                continue 
            end

            if priorityChoice == "trial" then
                if trialArenaExists() or trialArenaHasEnemies() then
                    Library:Notification("Auto Gate", "Trial has priority - skipping gate.", 3)
                    task.wait(10)
                    continue
                end
            end

            Library:Notification("Auto Gate", "Rank " .. rank .. " gate found! Acquiring lock...", 2)
            
            if not acquireSpecialFarmLock("gate") then
                Library:Notification("Auto Gate", "Another farm is active - will retry.", 3)
                task.wait(10)
                continue
            end

            if trial_actively_farming and priorityChoice == "trial" then
                Library:Notification("Auto Gate", "Trial started - releasing lock.", 2)
                releaseSpecialFarmLock()
                task.wait(10)
                continue
            end

            Library:Notification("Auto Gate", "Entering Rank " .. rank .. " gate...", 4)

            stopAllExclusiveFarms(true)
            task.wait(3)

            safeTeleport(5)
            task.wait(5)

            local lo = selectedLoadouts.gate and selectedLoadouts.gate[rank]
            if lo then 
                safeEquipLoadout(lo) 
                task.wait(1.5)
            end

            if gate_autoArise then
                safeAutoArise(true)
                task.wait(0.5)
            end

            Library:Notification("Auto Gate", "Going to gate station...", 2)
            local okS, station = pcall(function()
                return workspace.Worlds["5"].Systems.RaidStation
            end)
            if okS and station then
                local r = getRoot()
                if r then
                    local cf = station:IsA("BasePart") and station.CFrame or station:GetPivot()
                    r.CFrame = cf * CFrame.new(0, 5, 0)
                    r.AssemblyLinearVelocity  = ZERO_VEC
                    r.AssemblyAngularVelocity = ZERO_VEC
                end
            end
            task.wait(2)

            Library:Notification("Auto Gate", "Opening gate...", 2)
            safeOpenGate()
            task.wait(3)

            local waited = 0
            while not gateArenaExists() and waited < 25 do
                if waited % 5 == 0 and waited > 0 then
                    Library:Notification("Auto Gate", "Waiting for gate to open... (" .. waited .. "s)", 2)
                end
                task.wait(0.5)
                waited += 0.5
            end

            if not gateArenaExists() then
                Library:Notification("Auto Gate", "Failed to open gate (timeout).", 4)
                releaseSpecialFarmLock()
                resumeSavedFarm("Auto Gate Failed")
                task.wait(5)
                continue
            end

            Library:Notification("Auto Gate", "Gate opened! Loading arena...", 3)
            task.wait(4)

            Library:Notification("Auto Gate", "Ready! Waiting for enemies...", 2)
            task.wait(2)
        end

        Library:Notification("Auto Gate", "Monitoring stopped.", 3)
        gate_actively_farming = false
        stopGateLock()
        releaseSpecialFarmLock()
    end)
end

-- ══════════════════════════════════════════
--   PRIORITY-AWARE TRIAL LOOP
-- ══════════════════════════════════════════
local function spawnTrialLoop()
    task.spawn(function()
        Library:Notification("Auto Trial", "Monitoring started!", 3)
        
        while trial_running do
            task.wait(3)
            
            if isWorldLoading or crow_actively_farming or isSwitching then 
                continue 
            end

            if gate_actively_farming and priorityChoice == "gate" then 
                task.wait(5)
                continue 
            end

            if specialFarmMutex and priorityChoice == "gate" then
                task.wait(5)
                continue
            end

            if trialArenaHasEnemies() then
                if not trial_actively_farming then
                    if not acquireSpecialFarmLock("trial") then
                        Library:Notification("Auto Trial", "Priority conflict - skipping.", 2)
                        continue
                    end
                end
                
                trial_actively_farming = true
                
                Library:Notification("Auto Trial", "Trial enemies detected! Farming...", 3)

                if selectedLoadouts.trial then 
                    safeEquipLoadout(selectedLoadouts.trial) 
                    task.wait(1)
                end
                applyBoostsForFarm("trial")
                task.wait(0.5)

                local ok, arena = pcall(function() return workspace.TimeTrialArenas.Easy end)
                if ok and arena then
                    local spawnPart = arena:FindFirstChild("SpawnLocation") or arena:FindFirstChildOfClass("SpawnLocation")
                    if spawnPart then
                        local r = getRoot()
                        if r then
                            r.CFrame = spawnPart.CFrame * CFrame.new(0, 3, 0)
                            r.AssemblyLinearVelocity  = ZERO_VEC
                            r.AssemblyAngularVelocity = ZERO_VEC
                            task.wait(0.5)
                        end
                    end
                end

                while trial_running and trialArenaExists() do
                    if isWorldLoading or isSwitching then 
                        stopTrialLock() 
                        task.wait(0.5) 
                        continue 
                    end

                    if crow_actively_farming then
                        Library:Notification("Auto Trial", "Crow detected - pausing trial.", 3)
                        stopTrialLock()
                        trial_actively_farming = false
                        releaseSpecialFarmLock()
                        break
                    end

                    if gate_actively_farming and priorityChoice == "gate" then
                        Library:Notification("Auto Trial", "Gate priority - leaving trial.", 3)
                        stopTrialLock()
                        pcall(fireLeaveTrial)
                        task.wait(2)
                        trial_actively_farming = false
                        releaseSpecialFarmLock()
                        break
                    end

                    if trial_leaveRoom > 0 then
                        local cr = getTrialRoom()
                        if cr and cr >= trial_leaveRoom then
                            Library:Notification("Auto Trial", "Room " .. cr .. " reached - leaving.", 3)
                            stopTrialLock()
                            fireLeaveTrial()
                            task.wait(2)
                            trial_actively_farming = false
                            releaseSpecialFarmLock()
                            break
                        end
                    end

                    local ok, ef = pcall(function() return workspace.TimeTrialArenas.Easy.Enemies end)
                    if not ok or not ef then 
                        task.wait(0.3) 
                        continue 
                    end

                    local enemyList = ef:GetChildren()
                    if #enemyList == 0 then
                        task.wait(0.5)
                        
                        if not trialArenaExists() then
                            Library:Notification("Auto Trial", "Trial complete!", 3)
                            break
                        end
                        continue
                    end

                    local farmedAny = false
                    for _, mob in ipairs(enemyList) do
                        if not trial_running or not trialArenaExists() or crow_actively_farming or isSwitching then 
                            break 
                        end
                        if isMobDead(mob) then continue end
                        
                        farmedAny = true
                        local mp = getMobPosition(mob)
                        if mp then
                            local lp = Vector3.new(mp.X + 4, mp.Y, mp.Z + 4)
                            local r  = getRoot()
                            if r then
                                r.CFrame = CFrame.new(lp)
                                r.AssemblyLinearVelocity  = ZERO_VEC
                                r.AssemblyAngularVelocity = ZERO_VEC
                                task.wait(0.1)
                            end
                            startTrialLock(lp)
                        end

                        while trial_running and not isMobDead(mob) and trialArenaExists() do
                            if crow_actively_farming or isSwitching then break end
                            if gate_actively_farming and priorityChoice == "gate" then break end
                            if not trial_actively_farming then break end
                            
                            if trial_leaveRoom > 0 then
                                local cr = getTrialRoom()
                                if cr and cr >= trial_leaveRoom then break end
                            end
                            
                            local newMp = getMobPosition(mob)
                            if newMp and trialLock.conn then
                                trialLock.pos = Vector3.new(newMp.X + 4, newMp.Y, newMp.Z + 4)
                            end
                            task.wait(0.05)
                        end
                        stopTrialLock()
                        task.wait(0.05)
                    end

                    if not farmedAny then
                        task.wait(0.3)
                    end
                end

                stopTrialLock()
                trial_actively_farming = false
                releaseSpecialFarmLock()
                
                Library:Notification("Auto Trial", "Trial ended. Resuming farm in 3s...", 3)
                task.wait(3)
                resumeSavedFarm("Auto Trial")
                continue
            end

            if not trialArenaExists() then 
                task.wait(2)
                continue 
            end

            if priorityChoice == "gate" then
                if gateActiveExists() then
                    Library:Notification("Auto Trial", "Gate has priority - skipping trial.", 3)
                    task.wait(10)
                    continue
                end
            end

            Library:Notification("Auto Trial", "Trial detected! Acquiring lock...", 2)
            
            if not acquireSpecialFarmLock("trial") then
                Library:Notification("Auto Trial", "Another farm is active - will retry.", 3)
                task.wait(10)
                continue
            end

            if gate_actively_farming and priorityChoice == "gate" then
                Library:Notification("Auto Trial", "Gate started - releasing lock.", 2)
                releaseSpecialFarmLock()
                task.wait(10)
                continue
            end

            Library:Notification("Auto Trial", "Joining trial...", 3)

            stopAllExclusiveFarms(true)
            task.wait(3)

            if selectedLoadouts.trial then 
                safeEquipLoadout(selectedLoadouts.trial) 
                task.wait(1.5)
            end

            Library:Notification("Auto Trial", "Sending join request...", 2)
            safeJoinTrial()
            task.wait(5)

            local joinWaited = 0
            while not trialArenaExists() and joinWaited < 15 do
                task.wait(0.5)
                joinWaited += 0.5
            end

            if not trialArenaExists() then
                Library:Notification("Auto Trial", "Failed to join. Retrying...", 3)
                releaseSpecialFarmLock()
                task.wait(5)
                continue
            end

            Library:Notification("Auto Trial", "Arena loaded! Positioning...", 2)
            task.wait(2)

            local ok, arena = pcall(function() return workspace.TimeTrialArenas.Easy end)
            if ok and arena then
                local waited = 0
                while waited < 10 do
                    local spawnPart = arena:FindFirstChild("SpawnLocation") or arena:FindFirstChildOfClass("SpawnLocation")
                    if spawnPart then
                        local r = getRoot()
                        if r then
                            r.CFrame = spawnPart.CFrame * CFrame.new(0, 3, 0)
                            r.AssemblyLinearVelocity  = ZERO_VEC
                            r.AssemblyAngularVelocity = ZERO_VEC
                            break
                        end
                    end
                    task.wait(0.5)
                    waited += 0.5
                end
            end

            Library:Notification("Auto Trial", "Ready! Waiting for enemies...", 3)
            task.wait(3)
            trial_actively_farming = true
        end

        Library:Notification("Auto Trial", "Monitoring stopped.", 3)
        trial_actively_farming = false
        stopTrialLock()
        releaseSpecialFarmLock()
    end)
end

-- ══════════════════════════════════════════
--   UI PAGES - MAIN PAGE
-- ══════════════════════════════════════════
local MainPage = Window:Page({
    Name = "Main",
    Columns = 2
})

local CodesSection = MainPage:Section({
    Name = "Auto Codes",
    Side = 1
})

local allCodes = {
    "RELEASE","1KPLAYERS","2.5KPLAYERS","3.5KPLAYERS","4KPLAYERS",
    "SORRYFORSHUTDOWN","100KVISITS","200KVISITS","1KLIKES","5KPLAYERS",
    "6KPLAYERS","6.5KPLAYERS","500KVISITS","20KMEMBERS","EXCHANGE",
    "SORRYFORSHUTDOWN2","7KPLAYERS","10KPLAYERS","13KPLAYERS","15KPLAYERS",
    "NPCNERF","2.5KLIKES","5KLIKES","1MVISITS","1.5MVISITS","SORRYFORDELAY",
    "UPDATE1","3MVISITS","3.5MVISITS","8KLIKES","4KFAVS","UPDATE1.5",
    "3KEVENT","18KPLAYERS","19KPLAYERS","20KPLAYERS","24KPLAYERS",
    "25KPLAYERS","6.5MVISITS","7MVISITS","UPDATE2","BATTLEPASS",
    "SORRYFORDELAY2","SORRYFORSHUTDOWN5","27.5KPLAYERS","28KPLAYERS",
    "GO30K?","7.5MVISITS","8MVISITS","30KPLAYERS","SORRYFORSHUTDOWN6",
    "BATTLEPAS","UPDATE2.5","9.5MVISITS","10MVISITS","MOUNTS",
    "TRACKER","SORRYFORDELAY3","15MVISTS","GRIMOIRES","UPDATE3",
    "WAIFU","15KLIKES","20KLIKES","SORRYFORSHUTDOWN7","SORRYFORGRIMOIRES",
    "WEARESOSORRY!"
}

local CodesButton = CodesSection:Button()
CodesButton:Add("🎁 Redeem All Codes", function()
    Library:Notification("Redeeming", "Starting " .. #allCodes .. " codes...", 3)
    task.spawn(function()
        for i, code in ipairs(allCodes) do
            safeRedeemCode(code)
            if i % 10 == 0 then
                Library:Notification("Progress", i .. "/" .. #allCodes, 2)
            end
            task.wait(1)
        end
        Library:Notification("Done!", "All codes submitted!", 4)
    end)
end)

local ClickSection = MainPage:Section({
    Name = "Auto Click",
    Side = 1
})

ClickSection:Toggle({
    Name = "Auto Click",
    Flag = "main_auto_click",
    Default = false,
    Callback = function(state)
        autoclick_running = state
        if state then
            if not isLoadingConfig then
                Library:Notification("Auto Click", "Enabled!", 3)
            end
            task.spawn(function()
                local clickBridge = getLibrary().getBridge("Click")
                while autoclick_running do
                    pcall(function() clickBridge:Fire() end)
                    task.wait(0.15)
                end
            end)
        else
            if not isLoadingConfig then
                Library:Notification("Auto Click", "Disabled.", 3)
            end
        end
    end,
})

local RankSection = MainPage:Section({
    Name = "Auto Rank Up",
    Side = 2
})

RankSection:Toggle({
    Name = "Auto Rank Up",
    Flag = "main_auto_rankup",
    Default = false,
    Callback = function(state)
        safeSetAutoRankUp(state)
        if not isLoadingConfig then
            Library:Notification("Auto Rank Up", state and "Enabled!" or "Disabled.", 3)
        end
    end,
})

local StatSection = MainPage:Section({
    Name = "Auto Stat",
    Side = 2
})

StatSection:Dropdown({
    Name = "Select Stat",
    Flag = "main_stat_select",
    Items = statList,
    Multi = false,
    Default = nil,
    Callback = function(selected)
        selectedStat = (selected ~= "" and selected ~= nil) and selected or nil
        if autostat_running and selectedStat then
            safeSetAutoStat(selectedStat, true)
        end
    end,
})

StatSection:Toggle({
    Name = "Auto Stat",
    Flag = "main_stat_toggle",
    Default = false,
    Callback = function(state)
        autostat_running = state
        if state then
            if not selectedStat then
                autostat_running = false
                if not isLoadingConfig then
                    Library:Notification("Auto Stat", "Select a stat first!", 3)
                end
                return
            end
            safeSetAutoStat(selectedStat, true)
            if not isLoadingConfig then
                Library:Notification("Auto Stat", "Upgrading: " .. selectedStat, 3)
            end
        else
            if selectedStat then safeSetAutoStat(selectedStat, false) end
            if not isLoadingConfig then
                Library:Notification("Auto Stat", "Stopped.", 3)
            end
        end
    end,
})

local AvatarSection = MainPage:Section({
    Name = "Auto Equip Avatar",
    Side = 1
})

AvatarSection:Toggle({
    Name = "Auto Equip Best Avatar",
    Flag = "main_auto_equip",
    Default = false,
    Callback = function(state)
        safeSetAutoAvatarBuff(state)
        if not isLoadingConfig then
            Library:Notification("Auto Equip Avatar", state and "Enabled!" or "Disabled.", 3)
        end
    end,
})

local AchieveSection = MainPage:Section({
    Name = "Auto Achievements",
    Side = 1
})

AchieveSection:Toggle({
    Name = "Auto Claim Achievements",
    Flag = "main_auto_achievements",
    Default = false,
    Callback = function(state)
        safeSetAutoAchievements(state)
        if not isLoadingConfig then
            Library:Notification("Auto Achievements", state and "Enabled!" or "Disabled.", 3)
        end
    end,
})

local PlaytimeSection = MainPage:Section({
    Name = "Auto Playtime",
    Side = 2
})

PlaytimeSection:Toggle({
    Name = "Auto Claim Playtime Reward",
    Flag = "main_auto_playtime",
    Default = false,
    Callback = function(state)
        pcall(function()
            getLibrary().Network.Functions.GetPlayerData:InvokeServer({ AutoClaim = state })
        end)
        if not isLoadingConfig then
            Library:Notification("Auto Playtime", state and "Enabled!" or "Disabled.", 3)
        end
    end,
})

-- ══════════════════════════════════════════
--   AUTO FARM MOB PAGE
-- ══════════════════════════════════════════
local AutoFarmPage = Window:Page({
    Name = "Auto Farm Mob",
    Columns = 2
})

local FarmControlSection = AutoFarmPage:Section({
    Name = "Farm Control",
    Side = 1
})

FarmControlSection:Toggle({
    Name = "Start Auto Farm",
    Flag = "autofarm_toggle",
    Default = false,
    Callback = function(state)
        if state then
            local running = getRunningExclusiveName()
            if running and running ~= "Auto Gate (active)"
                and running ~= "Auto Trial (active)"
                and running ~= "Auto Crow" then
                Library:Notification("Cannot Start", running .. " is active.", 4)
                task.defer(function()
                    pcall(function() Library.Flags.autofarm_toggle:Set(false) end)
                end)
                return
            end
            if not hasAnyMobSelected() then
                Library:Notification("Auto Farm", "No mobs selected!", 4)
                task.defer(function()
                    pcall(function() Library.Flags.autofarm_toggle:Set(false) end)
                end)
                return
            end
            if selectedLoadouts.autofarm then safeEquipLoadout(selectedLoadouts.autofarm) task.wait(0.3) end
            autofarm_running = true
            spawnAutofarmLoop()
            if not isLoadingConfig then
                Library:Notification("Auto Farm", "Started!", 3)
            end
        else
            autofarm_running = false
            stopFarmLock()
            if not isLoadingConfig then
                Library:Notification("Auto Farm", "Stopped.", 3)
            end
        end
    end,
})

local sortedWorldKeys = {}
for k, _ in pairs(worldMobs) do table.insert(sortedWorldKeys, k) end
table.sort(sortedWorldKeys)

for _, worldKey in ipairs(sortedWorldKeys) do
    local MobSection = AutoFarmPage:Section({
        Name = worldDisplayNames[worldKey] or ("World " .. worldKey),
        Side = tonumber(worldKey) % 2 == 1 and 1 or 2
    })
    
    local TeleportBtn = MobSection:Button()
    TeleportBtn:Add("📍 Teleport to World " .. worldKey, function()
        safeTeleport(worldKey)
        Library:Notification("Teleport", "Teleporting to World " .. worldKey .. "...", 3)
    end)
    
    MobSection:ToggleDropdown({
        Name = "Select Mobs",
        Flag = "farm_world_" .. worldKey .. "_mobs",
        Items = worldMobs[worldKey] or {},
        Multi = true,
        Callback = function(selected)
            local newList = {}
            if type(selected) == "table" then
                for k, v in pairs(selected) do
                    local mobName = nil
                    if type(k) == "string" and v == true then mobName = k
                    elseif type(k) == "number" and type(v) == "string" then mobName = v end
                    if mobName then table.insert(newList, mobName) end
                end
            end
            selectedMobs[worldKey] = newList
        end,
    })
end

-- ══════════════════════════════════════════
--   AUTO CROW PAGE
-- ══════════════════════════════════════════
local CrowPage = Window:Page({
    Name = "Auto Crow",
    Columns = 2
})

local CrowSection = CrowPage:Section({
    Name = "Auto Crow Collector",
    Side = 1
})

CrowSection:Label("ℹ️ How it works", "Left")
CrowSection:Label("Leaves any gate/trial/raids to collect the crow.", "Left")
CrowSection:Label("Stops mob farming and resumes after.", "Left")
CrowSection:Label("⚠️ On First Enable:", "Left")
CrowSection:Label("Will teleport to World 6 first to monitor.", "Left")

CrowSection:Toggle({
    Name = "Auto Crow",
    Flag = "autocrow_toggle",
    Default = false,
    Callback = function(state)
        autocrow_running = state
        if state then
            spawnCrowLoop()
            if not isLoadingConfig then
                Library:Notification("Auto Crow", "Monitoring started!", 3)
            end
        else
            autocrow_running      = false
            crow_actively_farming = false
            if not isLoadingConfig then
                Library:Notification("Auto Crow", "Stopped.", 3)
            end
        end
    end,
})

-- ══════════════════════════════════════════
--   AUTO SWORD PASSIVE PAGE
-- ══════════════════════════════════════════
local PassivePage = Window:Page({
    Name = "Sword Passives",
    Columns = 2
})

local Sword1Section = PassivePage:Section({
    Name = "Equipped Sword 1",
    Side = 1
})

sword1InfoLabel = Sword1Section:Label("Loading sword info...", "Left")

Sword1Section:Dropdown({
    Name = "Target Passive",
    Flag = "sword1_target_passive",
    Items = passiveOptions,
    Multi = false,
    Default = nil,
    Callback = function(v)
        sword1_target = (v ~= "" and v ~= nil) and v or nil
    end
})

Sword1Section:Toggle({
    Name = "Auto Roll Sword 1",
    Flag = "sword1_auto_roll",
    Default = false,
    Callback = function(state)
        if state then
            if not sword1_target then
                Library:Notification("Sword 1", "Select target passive first!", 3)
                task.defer(function()
                    pcall(function() Library.Flags.sword1_auto_roll:Set(false) end)
                end)
                return
            end
            
            if not sword1_data then
                updateSwordInfo()
                if not sword1_data then
                    Library:Notification("Sword 1", "No sword equipped!", 3)
                    task.defer(function()
                        pcall(function() Library.Flags.sword1_auto_roll:Set(false) end)
                    end)
                    return
                end
            end
            
            if sword2_running then
                sword1_waiting = true
                Library:Notification("Sword 1", "Waiting for Sword 2 to finish...", 3)
                return
            end
            
            sword1_running = true
            spawnSword1Loop()
            Library:Notification("Sword 1", "Rolling started!", 3)
        else
            sword1_running = false
            sword1_waiting = false
            Library:Notification("Sword 1", "Stopped.", 3)
        end
    end
})

local Sword2Section = PassivePage:Section({
    Name = "Equipped Sword 2",
    Side = 2
})

sword2InfoLabel = Sword2Section:Label("Loading sword info...", "Left")

Sword2Section:Dropdown({
    Name = "Target Passive",
    Flag = "sword2_target_passive",
    Items = passiveOptions,
    Multi = false,
    Default = nil,
    Callback = function(v)
        sword2_target = (v ~= "" and v ~= nil) and v or nil
    end
})

Sword2Section:Toggle({
    Name = "Auto Roll Sword 2",
    Flag = "sword2_auto_roll",
    Default = false,
    Callback = function(state)
        if state then
            if not sword2_target then
                Library:Notification("Sword 2", "Select target passive first!", 3)
                task.defer(function()
                    pcall(function() Library.Flags.sword2_auto_roll:Set(false) end)
                end)
                return
            end
            
            if not sword2_data then
                updateSwordInfo()
                if not sword2_data then
                    Library:Notification("Sword 2", "No sword equipped!", 3)
                    task.defer(function()
                        pcall(function() Library.Flags.sword2_auto_roll:Set(false) end)
                    end)
                    return
                end
            end
            
            if sword1_running then
                sword2_waiting = true
                Library:Notification("Sword 2", "Waiting for Sword 1 to finish...", 3)
                return
            end
            
            sword2_running = true
            spawnSword2Loop()
            Library:Notification("Sword 2", "Rolling started!", 3)
        else
            sword2_running = false
            sword2_waiting = false
            Library:Notification("Sword 2", "Stopped.", 3)
        end
    end
})

-- ══════════════════════════════════════════
--   LOADOUTS PAGE
-- ══════════════════════════════════════════
local LoadoutPage = Window:Page({
    Name = "Loadouts",
    Columns = 2
})

local LoadoutSection = LoadoutPage:Section({
    Name = "Loadout Selection",
    Side = 1
})

LoadoutSection:Label("ℹ️ How it works", "Left")
LoadoutSection:Label("Assign a loadout per farm. Equips when that farm starts.", "Left")

local loadoutDefs = {
    { title = "Auto Farm Mob Loadout",   key = "autofarm",     flag = "loadout_autofarm", side = 1 },
    { title = "Ninja Raid Loadout",      key = "ninjaRaid",    flag = "loadout_ninjraid", side = 1 },
    { title = "Timeless Raid Loadout",   key = "timelessRaid", flag = "loadout_timeless", side = 1 },
    { title = "Infinity Castle Loadout", key = "infinityRaid", flag = "loadout_infinity", side = 2 },
    { title = "Clover Raid Loadout",     key = "cloverRaid",   flag = "loadout_clover",   side = 2 },
    { title = "Auto Defense Loadout",    key = "defense",      flag = "loadout_defense",  side = 2 },
    { title = "Auto Trial Loadout",      key = "trial",        flag = "loadout_trial",    side = 2 },
}

for _, def in ipairs(loadoutDefs) do
    local section = LoadoutPage:Section({
        Name = def.title,
        Side = def.side
    })
    
    section:Dropdown({
        Name = "Select Loadout",
        Flag = def.flag,
        Items = loadoutOptions,
        Multi = false,
        Default = nil,
        Callback = function(v)
            selectedLoadouts[def.key] = (v ~= "" and v ~= nil) and v or nil
        end,
    })
end

local GateLoadoutSection = LoadoutPage:Section({
    Name = "Gate Loadouts (per rank)",
    Side = 1
})

GateLoadoutSection:Label("Gate each rank loadouts below", "Left")

for _, rank in ipairs(gateRankOptions) do
    GateLoadoutSection:Dropdown({
        Name = "Gate Rank " .. rank .. " Loadout",
        Flag = "loadout_gate_" .. rank,
        Items = loadoutOptions,
        Multi = false,
        Default = nil,
        Callback = function(v)
            if not selectedLoadouts.gate then selectedLoadouts.gate = {} end
            selectedLoadouts.gate[rank] = (v ~= "" and v ~= nil) and v or nil
        end,
    })
end

-- ══════════════════════════════════════════
--   AUTO BOOST PAGE
-- ══════════════════════════════════════════
local BoostPage = Window:Page({
    Name = "Auto Boost",
    Columns = 2
})

local BoostControlSection = BoostPage:Section({
    Name = "Boost Control",
    Side = 1
})

BoostControlSection:Label("ℹ️ How it works", "Left")
BoostControlSection:Label("Enable Auto Boost, assign potions per farm.", "Left")
BoostControlSection:Label("Switching farms auto-pauses/unpauses boosts.", "Left")

BoostControlSection:Toggle({
    Name = "Enable Auto Boost",
    Flag = "autoboost_master",
    Default = false,
    Callback = function(state)
        autoboost_enabled = state
        if not isLoadingConfig then
            Library:Notification("Auto Boost", state and "Enabled!" or "Disabled.", 3)
        end
    end,
})

local PauseButton = BoostControlSection:Button()
PauseButton:Add("⏸️ Pause All Boosts Now", function()
    if not autoboost_enabled then
        Library:Notification("Auto Boost", "Enable Auto Boost first.", 3)
        return
    end
    task.spawn(pauseAllBoosts)
end)

local farmBoostRows = {
    { key = "autofarm",     label = "Auto Farm Mob",   side = 1 },
    { key = "ninjaRaid",    label = "Ninja Raid",      side = 1 },
    { key = "timelessRaid", label = "Timeless Raid",   side = 1 },
    { key = "infinityRaid", label = "Infinity Castle", side = 2 },
    { key = "cloverRaid",   label = "Clover Raid",     side = 2 },
    { key = "defense",      label = "Auto Defense",    side = 2 },
    { key = "trial",        label = "Auto Trial",      side = 2 },
    { key = "autostar",     label = "Auto Star",       side = 2 },
}

for _, row in ipairs(farmBoostRows) do
    local section = BoostPage:Section({
        Name = row.label .. " Potions",
        Side = row.side
    })
    
    section:ToggleDropdown({
        Name = "Select Potions",
        Flag = "boost_" .. row.key,
        Items = ALL_POTIONS,
        Multi = true,
        Callback = function(selected)
            local newList = {}
            if type(selected) == "table" then
                for k, v in pairs(selected) do
                    local id = nil
                    if type(k) == "string" and v == true then id = k
                    elseif type(k) == "number" and type(v) == "string" then id = v end
                    if id then table.insert(newList, id) end
                end
            end
            boostConfig[row.key] = newList
        end,
    })
end

local GateBoostSection = BoostPage:Section({
    Name = "Gate Per-Rank Boost Selection",
    Side = 1
})

for _, rank in ipairs(gateRankOptions) do
    GateBoostSection:ToggleDropdown({
        Name = "Gate Rank " .. rank .. " Potions",
        Flag = "boost_gate_" .. rank,
        Items = ALL_POTIONS,
        Multi = true,
        Callback = function(selected)
            local newList = {}
            if type(selected) == "table" then
                for k, v in pairs(selected) do
                    local id = nil
                    if type(k) == "string" and v == true then id = k
                    elseif type(k) == "number" and type(v) == "string" then id = v end
                    if id then table.insert(newList, id) end
                end
            end
            if not boostConfig.gate then boostConfig.gate = {} end
            boostConfig.gate[rank] = newList
        end,
    })
end

-- ══════════════════════════════════════════
--   GAMEMODES - RAIDS PAGE
-- ══════════════════════════════════════════
local RaidPage = Window:Page({
    Name = "Auto Raid",
    Columns = 2
})

-- Ninja Raid
local NinjaSection = RaidPage:Section({
    Name = "Ninja Raid (World 1)",
    Side = 1
})

NinjaSection:Toggle({
    Name = "Auto Ninja Raid",
    Flag = "ninja_raid_toggle",
    Default = false,
    Callback = function(state)
        if state then
            local running = getRunningExclusiveName()
            if running and running ~= "Auto Gate (active)"
                and running ~= "Auto Trial (active)"
                and running ~= "Auto Crow" then
                Library:Notification("Cannot Start", running .. " is active.", 4)
                task.defer(function()
                    pcall(function() Library.Flags.ninja_raid_toggle:Set(false) end)
                end)
                return
            end
            local lo = selectedLoadouts.ninjaRaid
            if lo then safeEquipLoadout(lo) task.wait(0.3) end
            ninjaRaid_running = true
            spawnNinjaRaidLoop()
            if not isLoadingConfig then
                Library:Notification("Ninja Raid", "Started!", 3)
            end
        else
            ninjaRaid_running = false
            stopNinjaLock()
            if not isLoadingConfig then
                Library:Notification("Ninja Raid", "Stopped.", 3)
            end
        end
    end,
})

NinjaSection:Dropdown({
    Name = "Leave at Wave",
    Flag = "ninja_leave_wave",
    Items = waveDropdown100,
    Multi = false,
    Default = "0",
    Callback = function(v) ninjaRaid_leaveWave = tonumber(v) or 0 end,
})

NinjaSection:Dropdown({
    Name = "Farm Method",
    Flag = "ninja_farm_method",
    Items = { "Normal", "Middle" },
    Multi = false,
    Default = "Normal",
    Callback = function(v) 
        ninja_farmMethod = v or "Normal"
        Library:Notification("Ninja Raid", "Method: " .. ninja_farmMethod, 2)
    end,
})

-- Timeless Raid
local TimelessSection = RaidPage:Section({
    Name = "Timeless Raid (World 0)",
    Side = 1
})

TimelessSection:Toggle({
    Name = "Auto Timeless Raid",
    Flag = "timeless_raid_toggle",
    Default = false,
    Callback = function(state)
        if state then
            local running = getRunningExclusiveName()
            if running and running ~= "Auto Gate (active)"
                and running ~= "Auto Trial (active)"
                and running ~= "Auto Crow" then
                Library:Notification("Cannot Start", running .. " is active.", 4)
                task.defer(function()
                    pcall(function() Library.Flags.timeless_raid_toggle:Set(false) end)
                end)
                return
            end
            local lo = selectedLoadouts.timelessRaid
            if lo then safeEquipLoadout(lo) task.wait(0.3) end
            timelessRaid_running = true
            spawnTimelessRaidLoop()
            if not isLoadingConfig then
                Library:Notification("Timeless Raid", "Started!", 3)
            end
        else
            timelessRaid_running = false
            stopTimelessLock()
            if not isLoadingConfig then
                Library:Notification("Timeless Raid", "Stopped.", 3)
            end
        end
    end,
})

TimelessSection:Dropdown({
    Name = "Leave at Wave",
    Flag = "timeless_leave_wave",
    Items = waveDropdownTimeless,
    Multi = false,
    Default = "0",
    Callback = function(v) timelessRaid_leaveWave = tonumber(v) or 0 end,
})

TimelessSection:Dropdown({
    Name = "Farm Method",
    Flag = "timeless_farm_method",
    Items = { "Normal", "Middle" },
    Multi = false,
    Default = "Normal",
    Callback = function(v) 
        timeless_farmMethod = v or "Normal"
        Library:Notification("Timeless Raid", "Method: " .. timeless_farmMethod, 2)
    end,
})

-- Infinity Castle
local InfinitySection = RaidPage:Section({
    Name = "Infinity Castle (World 6)",
    Side = 2
})

InfinitySection:Toggle({
    Name = "Auto Infinity Castle",
    Flag = "infinity_raid_toggle",
    Default = false,
    Callback = function(state)
        if state then
            local running = getRunningExclusiveName()
            if running and running ~= "Auto Gate (active)"
                and running ~= "Auto Trial (active)"
                and running ~= "Auto Crow" then
                Library:Notification("Cannot Start", running .. " is active.", 4)
                task.defer(function()
                    pcall(function() Library.Flags.infinity_raid_toggle:Set(false) end)
                end)
                return
            end
            local lo = selectedLoadouts.infinityRaid
            if lo then safeEquipLoadout(lo) task.wait(0.3) end
            infinityRaid_running = true
            spawnInfinityRaidLoop()
            if not isLoadingConfig then
                Library:Notification("Infinity Castle", "Started!", 3)
            end
        else
            infinityRaid_running = false
            stopInfinityLock()
            if not isLoadingConfig then
                Library:Notification("Infinity Castle", "Stopped.", 3)
            end
        end
    end,
})

InfinitySection:Dropdown({
    Name = "Leave at Wave",
    Flag = "infinity_leave_wave",
    Items = waveDropdown30,
    Multi = false,
    Default = "0",
    Callback = function(v) infinityRaid_leaveWave = tonumber(v) or 0 end,
})

InfinitySection:Dropdown({
    Name = "Farm Method",
    Flag = "infinity_farm_method",
    Items = { "Normal", "Middle" },
    Multi = false,
    Default = "Normal",
    Callback = function(v) 
        infinity_farmMethod = v or "Normal"
        Library:Notification("Infinity Castle", "Method: " .. infinity_farmMethod, 2)
    end,
})

-- Clover Raid
local CloverSection = RaidPage:Section({
    Name = "Clover Raid (World 7)",
    Side = 2
})

CloverSection:Toggle({
    Name = "Auto Clover Raid",
    Flag = "clover_raid_toggle",
    Default = false,
    Callback = function(state)
        if state then
            local running = getRunningExclusiveName()
            if running and running ~= "Auto Gate (active)"
                and running ~= "Auto Trial (active)"
                and running ~= "Auto Crow" then
                Library:Notification("Cannot Start", running .. " is active.", 4)
                task.defer(function()
                    pcall(function() Library.Flags.clover_raid_toggle:Set(false) end)
                end)
                return
            end
            local lo = selectedLoadouts.cloverRaid
            if lo then safeEquipLoadout(lo) task.wait(0.3) end
            cloverRaid_running = true
            spawnCloverRaidLoop()
            if not isLoadingConfig then
                Library:Notification("Clover Raid", "Started!", 3)
            end
        else
            cloverRaid_running = false
            stopCloverLock()
            if not isLoadingConfig then
                Library:Notification("Clover Raid", "Stopped.", 3)
            end
        end
    end,
})

CloverSection:Dropdown({
    Name = "Leave at Wave",
    Flag = "clover_leave_wave",
    Items = waveDropdownClover,
    Multi = false,
    Default = "0",
    Callback = function(v) cloverRaid_leaveWave = tonumber(v) or 0 end,
})

CloverSection:Dropdown({
    Name = "Farm Method",
    Flag = "clover_farm_method",
    Items = { "Normal", "Middle" },
    Multi = false,
    Default = "Normal",
    Callback = function(v) 
        clover_farmMethod = v or "Normal"
        Library:Notification("Clover Raid", "Method: " .. clover_farmMethod, 2)
    end,
})

-- ══════════════════════════════════════════
--   GAMEMODES - DEFENSE PAGE
-- ══════════════════════════════════════════
local DefensePage = Window:Page({
    Name = "Auto Defense",
    Columns = 2
})

local DefenseSection = DefensePage:Section({
    Name = "Defense (World 4)",
    Side = 1
})

DefenseSection:Toggle({
    Name = "Auto Defense",
    Flag = "defense_toggle",
    Default = false,
    Callback = function(state)
        if state then
            local running = getRunningExclusiveName()
            if running and running ~= "Auto Gate (active)"
                and running ~= "Auto Trial (active)"
                and running ~= "Auto Crow" then
                Library:Notification("Cannot Start", running .. " is active.", 4)
                task.defer(function()
                    pcall(function() Library.Flags.defense_toggle:Set(false) end)
                end)
                return
            end
            if selectedLoadouts.defense then safeEquipLoadout(selectedLoadouts.defense) task.wait(0.3) end
            defense_running = true
            spawnDefenseLoop()
            if not isLoadingConfig then
                Library:Notification("Auto Defense", "Started!", 3)
            end
        else
            defense_running = false
            stopDefenseLock()
            if not isLoadingConfig then
                Library:Notification("Auto Defense", "Stopped.", 3)
            end
        end
    end,
})

DefenseSection:Dropdown({
    Name = "Leave at Wave",
    Flag = "defense_leave_wave",
    Items = waveDropdown100,
    Multi = false,
    Default = "0",
    Callback = function(v) defense_leaveWave = tonumber(v) or 0 end,
})

-- ══════════════════════════════════════════
--   GAMEMODES - GATE & TRIAL PAGE
-- ══════════════════════════════════════════
local GatePage = Window:Page({
    Name = "Gate & Trial",
    Columns = 2
})

-- Priority Section
local PrioritySection = GatePage:Section({
    Name = "Gate vs Trial Priority",
    Side = 1
})

PrioritySection:Label("ℹ️ How priority works", "Left")
PrioritySection:Label("If both Gate and Trial are available,", "Left")
PrioritySection:Label("this decides which takes priority.", "Left")
PrioritySection:Label("Crow always wins.", "Left")

PrioritySection:Dropdown({
    Name = "Priority",
    Flag = "priority_select",
    Items = { "gate", "trial" },
    Multi = false,
    Default = "gate",
    Callback = function(v)
        priorityChoice = (v ~= "" and v ~= nil) and v or "gate"
        Library:Notification("Priority Updated", "Set to: " .. tostring(priorityChoice), 3)
    end,
})

-- Gate Control
local GateMainSection = GatePage:Section({
    Name = "Gate Control (World 5)",
    Side = 1
})

GateMainSection:Label("ℹ️ How it works", "Left")
GateMainSection:Label("Monitors World 5 for gates. Stops farms,", "Left")
GateMainSection:Label("teleports, opens gate, farms it, then resumes.", "Left")

GateMainSection:ToggleDropdown({
    Name = "Select Gate Ranks",
    Flag = "gate_ranks_select",
    Items = gateRankOptions,
    Multi = true,
    Callback = function(selected)
        local newList = {}
        if type(selected) == "table" then
            for k, v in pairs(selected) do
                local r = nil
                if type(k) == "string" and v == true then r = k
                elseif type(k) == "number" and type(v) == "string" then r = v end
                if r then table.insert(newList, r) end
            end
        end
        selectedGateRanks = newList
    end,
})

GateMainSection:Toggle({
    Name = "Auto Arise",
    Flag = "gate_auto_arise",
    Default = false,
    Callback = function(state)
        gate_autoArise = state
        safeAutoArise(state)
        if not isLoadingConfig then
            Library:Notification("Auto Arise", state and "Enabled!" or "Disabled.", 3)
        end
    end,
})

GateMainSection:Dropdown({
    Name = "Farm Method",
    Flag = "gate_farm_method",
    Items = { "Normal", "Middle" },
    Multi = false,
    Default = "Normal",
    Callback = function(v) 
        gate_farmMethod = v or "Normal"
        Library:Notification("Auto Gate", "Method: " .. gate_farmMethod, 2)
    end,
})

GateMainSection:Toggle({
    Name = "Auto Gate",
    Flag = "gate_toggle",
    Default = false,
    Callback = function(state)
        gate_running = state
        if state then
            spawnGateLoop()
            Library:Notification("Auto Gate", "Monitor started!", 3)
        else
            gate_running          = false
            gate_actively_farming = false
            stopGateLock()
            Library:Notification("Auto Gate", "Stopped.", 3)
        end
    end,
})

GateMainSection:Label("Per-Rank Leave Wave (0 = never leave)", "Left")

for _, rank in ipairs(gateRankOptions) do
    GateMainSection:Dropdown({
        Name = "Rank " .. rank .. " Leave at Wave",
        Flag = "gate_rank_" .. rank .. "_leave",
        Items = waveDropdown50,
        Multi = false,
        Default = "0",
        Callback = function(v) gate_leaveWave[rank] = tonumber(v) or 0 end,
    })
end

-- Trial Control
local TrialSection = GatePage:Section({
    Name = "Easy Time Trial (World 0)",
    Side = 2
})

TrialSection:Label("ℹ️ How it works", "Left")
TrialSection:Label("Stops exclusive farms, joins trial, farms,", "Left")
TrialSection:Label("leaves at chosen room, then resumes.", "Left")

TrialSection:Toggle({
    Name = "Auto Easy Trial",
    Flag = "trial_toggle",
    Default = false,
    Callback = function(state)
        trial_running = state
        if state then
            spawnTrialLoop()
            Library:Notification("Auto Trial", "Monitor started!", 3)
        else
            trial_running          = false
            trial_actively_farming = false
            stopTrialLock()
            Library:Notification("Auto Trial", "Stopped.", 3)
        end
    end,
})

TrialSection:Dropdown({
    Name = "Leave at Room",
    Flag = "trial_leave_room",
    Items = roomDropdown50,
    Multi = false,
    Default = "0",
    Callback = function(v) trial_leaveRoom = tonumber(v) or 0 end,
})

-- ══════════════════════════════════════════
--   AUTO UPGRADES PAGE
-- ══════════════════════════════════════════
local UpgradesPage = Window:Page({
    Name = "Auto Upgrades",
    Columns = 2
})

-- Range Upgrade
local RangeSection = UpgradesPage:Section({
    Name = "Range Upgrade (World 0)",
    Side = 1
})

local range_running = false

RangeSection:Toggle({
    Name = "Auto Range Upgrade",
    Flag = "auto_range_upgrade",
    Default = false,
    Callback = function(state)
        range_running = state
        if not state then
            if not isLoadingConfig then Library:Notification("Range Upgrade", "Stopped.", 3) end
            return
        end
        if not isLoadingConfig then Library:Notification("Range Upgrade", "Started!", 3) end
        task.spawn(function()
            while range_running do
                safeRangeUpgrade()
                task.wait(0.5)
            end
        end)
    end,
})

-- Trial Upgrades
local TrialUpgradeSection = UpgradesPage:Section({
    Name = "Trial Upgrades (World 0)",
    Side = 1
})

TrialUpgradeSection:Label("ℹ️ Uses Trial Shards", "Left")
TrialUpgradeSection:Label("Max: 40 levels (30 for Luck)", "Left")

local trialUpgradeStats = {}
local trial_upg_running = false

TrialUpgradeSection:ToggleDropdown({
    Name = "Select Trial Stats",
    Flag = "trial_upgrades_select",
    Items = statList,
    Multi = true,
    Callback = function(selected)
        local newList = {}
        if type(selected) == "table" then
            for k, v in pairs(selected) do
                local s = nil
                if type(k) == "string" and v == true then s = k
                elseif type(k) == "number" and type(v) == "string" then s = v end
                if s then table.insert(newList, s) end
            end
        end
        trialUpgradeStats = newList
    end,
})

TrialUpgradeSection:Toggle({
    Name = "Auto Trial Upgrades",
    Flag = "auto_trial_upgrades",
    Default = false,
    Callback = function(state)
        trial_upg_running = state
        if not state then
            if not isLoadingConfig then Library:Notification("Trial Upgrades", "Stopped.", 3) end
            return
        end
        if #trialUpgradeStats == 0 then
            trial_upg_running = false
            if not isLoadingConfig then Library:Notification("Trial Upgrades", "Select stats first!", 3) end
            task.defer(function()
                pcall(function() Library.Flags.auto_trial_upgrades:Set(false) end)
            end)
            return
        end
        if not isLoadingConfig then Library:Notification("Trial Upgrades", "Started!", 3) end
        task.spawn(function()
            while trial_upg_running do
                for _, s in ipairs(trialUpgradeStats) do
                    if not trial_upg_running then break end
                    safeTrialUpgrade(s)
                    task.wait(0.1)
                end
                task.wait(0.5)
            end
        end)
    end,
})

-- Castle Upgrades
local CastleUpgradeSection = UpgradesPage:Section({
    Name = "Castle Upgrades (World 6)",
    Side = 2
})

CastleUpgradeSection:Label("ℹ️ Uses Castle Coins", "Left")
CastleUpgradeSection:Label("Max: 40 levels (30 for Luck)", "Left")

local castleUpgradeStats = {}
local castle_upg_running = false

CastleUpgradeSection:ToggleDropdown({
    Name = "Select Castle Stats",
    Flag = "castle_upgrades_select",
    Items = statList,
    Multi = true,
    Callback = function(selected)
        local newList = {}
        if type(selected) == "table" then
            for k, v in pairs(selected) do
                local s = nil
                if type(k) == "string" and v == true then s = k
                elseif type(k) == "number" and type(v) == "string" then s = v end
                if s then table.insert(newList, s) end
            end
        end
        castleUpgradeStats = newList
    end,
})

CastleUpgradeSection:Toggle({
    Name = "Auto Castle Upgrades",
    Flag = "auto_castle_upgrades",
    Default = false,
    Callback = function(state)
        castle_upg_running = state
        if not state then
            if not isLoadingConfig then Library:Notification("Castle Upgrades", "Stopped.", 3) end
            return
        end
        if #castleUpgradeStats == 0 then
            castle_upg_running = false
            if not isLoadingConfig then Library:Notification("Castle Upgrades", "Select stats first!", 3) end
            task.defer(function()
                pcall(function() Library.Flags.auto_castle_upgrades:Set(false) end)
            end)
            return
        end
        if not isLoadingConfig then Library:Notification("Castle Upgrades", "Started!", 3) end
        task.spawn(function()
            while castle_upg_running do
                for _, s in ipairs(castleUpgradeStats) do
                    if not castle_upg_running then break end
                    safeCastleUpgrade(s)
                    task.wait(0.1)
                end
                task.wait(0.5)
            end
        end)
    end,
})

-- ══════════════════════════════════════════
--   AUTO STAR PAGE
-- ══════════════════════════════════════════
local StarPage = Window:Page({
    Name = "Auto Star",
    Columns = 2
})

local starDeleteRarities    = {}
local selectedStarWorld     = starWorldOptions[1] or "1"
local star_teleport_running = false
local star_gamepass_running = false

local function fireStarRoll(worldKey)
    local payload = {}
    for _, r in ipairs(rarityList) do
        if starDeleteRarities[r] then payload[r] = starDeleteRarities[r] end
    end
    pcall(function()
        getLibrary().getBridge("OpenEgg"):Fire("World" .. worldKey, payload)
    end)
end

local RaritySection = StarPage:Section({
    Name = "Rarity Settings",
    Side = 1
})

RaritySection:Label("ℹ️ Info", "Left")
RaritySection:Label("Auto Delete: deletes normal on roll.", "Left")
RaritySection:Label("Auto Delete Shiny: deletes shiny variant.", "Left")
RaritySection:Label("Auto Lock: locks normal on roll.", "Left")
RaritySection:Label("Auto Lock Shiny: locks shiny variant.", "Left")
RaritySection:Label("⚠️ Shiny actions also affect normal rolls.", "Left")

RaritySection:ToggleDropdown({
    Name = "Auto Delete Rarities",
    Flag = "star_delete",
    Items = rarityList,
    Multi = true,
    Callback = function(selected)
        for _, r in ipairs(rarityList) do
            if starDeleteRarities[r] == "delete" then starDeleteRarities[r] = nil end
        end
        if type(selected) == "table" then
            for k, v in pairs(selected) do
                local rarity = nil
                if type(k) == "string" and v == true then rarity = k
                elseif type(k) == "number" and type(v) == "string" then rarity = v end
                if rarity then starDeleteRarities[rarity] = "delete" end
            end
        end
    end,
})

RaritySection:ToggleDropdown({
    Name = "Auto Delete Shiny Rarities",
    Flag = "star_delete_shiny",
    Items = rarityList,
    Multi = true,
    Callback = function(selected)
        for _, r in ipairs(rarityList) do
            if starDeleteRarities[r] == "deleteShiny" then starDeleteRarities[r] = nil end
        end
        if type(selected) == "table" then
            for k, v in pairs(selected) do
                local rarity = nil
                if type(k) == "string" and v == true then rarity = k
                elseif type(k) == "number" and type(v) == "string" then rarity = v end
                if rarity then
                    if starDeleteRarities[rarity] ~= "delete" and starDeleteRarities[rarity] ~= "lock" and starDeleteRarities[rarity] ~= "lockShiny" then
                        starDeleteRarities[rarity] = "deleteShiny"
                    end
                end
            end
        end
    end,
})

RaritySection:ToggleDropdown({
    Name = "Auto Lock Rarities",
    Flag = "star_lock",
    Items = rarityList,
    Multi = true,
    Callback = function(selected)
        for _, r in ipairs(rarityList) do
            if starDeleteRarities[r] == "lock" then starDeleteRarities[r] = nil end
        end
        if type(selected) == "table" then
            for k, v in pairs(selected) do
                local rarity = nil
                if type(k) == "string" and v == true then rarity = k
                elseif type(k) == "number" and type(v) == "string" then rarity = v end
                if rarity then starDeleteRarities[rarity] = "lock" end
            end
        end
    end,
})

RaritySection:ToggleDropdown({
    Name = "Auto Lock Shiny Rarities",
    Flag = "star_lock_shiny",
    Items = rarityList,
    Multi = true,
    Callback = function(selected)
        for _, r in ipairs(rarityList) do
            if starDeleteRarities[r] == "lockShiny" then starDeleteRarities[r] = nil end
        end
        if type(selected) == "table" then
            for k, v in pairs(selected) do
                local rarity = nil
                if type(k) == "string" and v == true then rarity = k
                elseif type(k) == "number" and type(v) == "string" then rarity = v end
                if rarity then
                    if starDeleteRarities[rarity] ~= "delete" and starDeleteRarities[rarity] ~= "lock" and starDeleteRarities[rarity] ~= "deleteShiny" then
                        starDeleteRarities[rarity] = "lockShiny"
                    end
                end
            end
        end
    end,
})

local StarControlSection = StarPage:Section({
    Name = "Star Roll Control",
    Side = 2
})

StarControlSection:Dropdown({
    Name = "Select World",
    Flag = "star_world",
    Items = starWorldOptions,
    Multi = false,
    Default = starWorldOptions[1] or "1",
    Callback = function(v) if v and v ~= "" then selectedStarWorld = v end end,
})

StarControlSection:Toggle({
    Name = "Auto Roll Star (Teleport)",
    Flag = "star_teleport_toggle",
    Default = false,
    Callback = function(state)
        star_teleport_running = state
        if not state then
            stopStarLock()
            if not isLoadingConfig then
                Library:Notification("Auto Star", "Stopped.", 3)
            end
            return
        end
        if not isLoadingConfig then
            Library:Notification("Auto Star", "Starting in World " .. selectedStarWorld, 3)
        end
        task.spawn(function()
            safeTeleport(selectedStarWorld)
            task.wait(3)
            if not star_teleport_running then return end
            local ok, station = pcall(function()
                return workspace.Worlds[selectedStarWorld].Systems.EggStation
            end)
            if not ok or not station then
                Library:Notification("Auto Star", "EggStation not found!", 4)
                star_teleport_running = false; return
            end
            local cf = station:IsA("BasePart") and station.CFrame or station:GetPivot()
            local lp = (cf * CFrame.new(0, 3, 0)).Position
            local r  = getRoot()
            if r then
                r.CFrame = CFrame.new(lp)
                r.AssemblyLinearVelocity  = ZERO_VEC
                r.AssemblyAngularVelocity = ZERO_VEC
            end
            task.wait(0.5)
            startLockTable(starLock, lp, function() return star_teleport_running end)
            applyBoostsForFarm("autostar")
            while star_teleport_running do
                fireStarRoll(selectedStarWorld)
                task.wait(1.5)
            end
            stopStarLock()
        end)
    end,
})

StarControlSection:Label("⭐ Gamepass Only", "Left")
StarControlSection:Label("Rolls from anywhere — requires gamepass.", "Left")

StarControlSection:Toggle({
    Name = "Auto Roll Star (Gamepass)",
    Flag = "star_gamepass_toggle",
    Default = false,
    Callback = function(state)
        star_gamepass_running = state
        if not state then
            if not isLoadingConfig then
                Library:Notification("Auto Star (GP)", "Stopped.", 3)
            end
            return
        end
        if not isLoadingConfig then
            Library:Notification("Auto Star (GP)", "Rolling World " .. selectedStarWorld, 3)
        end
        task.spawn(function()
            while star_gamepass_running do
                fireStarRoll(selectedStarWorld)
                task.wait(1.5)
            end
        end)
    end,
})

local PetStarSection = StarPage:Section({
    Name = "Auto Equip Best Pet",
    Side = 2
})

PetStarSection:Toggle({
    Name = "Auto Equip Best Pet",
    Flag = "star_auto_pet",
    Default = false,
    Callback = function(state)
        autopet_running = state
        if state then
            if not isLoadingConfig then
                Library:Notification("Auto Equip Pet", "Enabled!", 3)
            end
            task.spawn(function()
                local equipBridge = getLibrary().getBridge("EquipBest")
                while autopet_running do
                    pcall(function() equipBridge:Fire() end)
                    task.wait(5)
                end
            end)
        else
            if not isLoadingConfig then
                Library:Notification("Auto Equip Pet", "Disabled.", 3)
            end
        end
    end,
})

-- ══════════════════════════════════════════
--   AUTO GACHA PAGE
-- ══════════════════════════════════════════
local GachaPage = Window:Page({
    Name = "Auto Gacha",
    Columns = 2
})

local gachaRunning    = {}
local gachaParagraphs = {}

local _gachaRollBridge = nil
local function getGachaRollBridge()
    if not _gachaRollBridge then
        _gachaRollBridge = getLibrary().getBridge("GachaRoll")
    end
    return _gachaRollBridge
end

for i, g in ipairs(gachaWorlds) do
    gachaRunning[g.key] = false

    local sec = GachaPage:Section({
        Name = g.title .. " (" .. g.key .. ")",
        Side = i % 2 == 1 and 1 or 2
    })

    local topRarity = rarityList[#rarityList] or "Divine"

    gachaParagraphs[g.key] = sec:Label("⏳ Loading...", "Left")

    sec:Toggle({
        Name = "Auto Roll",
        Flag = g.flag,
        Default = false,
        Callback = function(state)
            gachaRunning[g.key] = state
            if not state then
                if not isLoadingConfig then
                    Library:Notification(g.title, "Stopped.", 3)
                end
                return
            end
            local current = cachedGachaData[g.key]
            if current == topRarity then
                gachaRunning[g.key] = false
                Library:Notification(g.title, "Already at max rarity!", 4)
                task.defer(function()
                    pcall(function() Library.Flags[g.flag]:Set(false) end)
                end)
                return
            end
            if not isLoadingConfig then
                Library:Notification(g.title, "Started!", 3)
            end
            task.spawn(function()
                local bridge = getGachaRollBridge()
                while gachaRunning[g.key] do
                    local cur = cachedGachaData[g.key]
                    if cur == topRarity then
                        gachaRunning[g.key] = false
                        Library:Notification(g.title, "✨ Max rarity! Auto-stopped.", 5)
                        task.defer(function()
                            pcall(function() Library.Flags[g.flag]:Set(false) end)
                        end)
                        break
                    end
                    pcall(function() bridge:Fire(g.key) end)
                    task.wait(0.6)
                end
            end)
        end,
    })
end

task.spawn(function()
    while true do
        task.wait(5)
        for _, g in ipairs(gachaWorlds) do
            local para = gachaParagraphs[g.key]
            if not para then continue end
            local current   = cachedGachaData[g.key]
            local emoji     = rarityEmoji[current] or "❓"
            local topRarity = rarityList[#rarityList] or "Divine"
            local isMax     = current == topRarity
            pcall(function()
                para:SetText(emoji .. " " .. (current or "None") .. (isMax and " — MAX ✅" or ""))
            end)
        end
    end
end)

-- ══════════════════════════════════════════
--   AUTO MISC GACHA PAGE
-- ══════════════════════════════════════════
local MiscGachaPage = Window:Page({
    Name = "Misc Gacha",
    Columns = 2
})

-- Sword Gacha
do
    local sword_running = false
    local sec = MiscGachaPage:Section({
        Name = "Sword Gacha (World 0)",
        Side = 1
    })
    sec:Toggle({
        Name = "Auto Roll Sword Gacha",
        Flag = "gacha_sword",
        Default = false,
        Callback = function(state)
            sword_running = state
            if not state then
                if not isLoadingConfig then Library:Notification("Sword Gacha", "Stopped.", 3) end
                return
            end
            if not isLoadingConfig then Library:Notification("Sword Gacha", "Started!", 3) end
            task.spawn(function()
                local bridge = getLibrary().getBridge("SwordRoll")
                while sword_running do
                    pcall(function() bridge:Fire("World0") end)
                    task.wait(0.5)
                end
            end)
        end,
    })
end

-- Player Passives
do
    local passives_running = false
    local sec = MiscGachaPage:Section({
        Name = "Player Passives (World 2)",
        Side = 1
    })
    sec:Toggle({
        Name = "Auto Roll Player Passives",
        Flag = "gacha_passives",
        Default = false,
        Callback = function(state)
            passives_running = state
            if not state then
                if not isLoadingConfig then Library:Notification("Player Passives", "Stopped.", 3) end
                return
            end
            if not isLoadingConfig then Library:Notification("Player Passives", "Started!", 3) end
            task.spawn(function()
                local bridge = getLibrary().getBridge("PlayerPassiveRoll")
                while passives_running do
                    pcall(function() bridge:Fire() end)
                    task.wait(0.5)
                end
            end)
        end,
    })
end

-- Titans Gacha
do
    local titans_running = false
    local sec = MiscGachaPage:Section({
        Name = "Titans Gacha (World 4)",
        Side = 2
    })
    sec:Toggle({
        Name = "Auto Roll Titans",
        Flag = "gacha_titans",
        Default = false,
        Callback = function(state)
            titans_running = state
            if not state then
                if not isLoadingConfig then Library:Notification("Titans Gacha", "Stopped.", 3) end
                return
            end
            if not isLoadingConfig then Library:Notification("Titans Gacha", "Started!", 3) end
            task.spawn(function()
                while titans_running do
                    safeTitanRoll("World4")
                    task.wait(0.5)
                end
            end)
        end,
    })
end

-- Grimoire Gacha
do
    local grimoire1_running = false
    local grimoire2_running = false
    local grimoire_topRarity = "Divine"

    local sec = MiscGachaPage:Section({
        Name = "Grimoire Gacha (World 7)",
        Side = 2
    })

    sec:Label("ℹ️ Info", "Left")
    sec:Label("Rolls Grimoire slots separately.", "Left")
    sec:Label("Stops when Divine is reached.", "Left")

    local grimoire1Para = sec:Label("Slot 1: ⏳ Loading...", "Left")
    local grimoire2Para = sec:Label("Slot 2: ⏳ Loading...", "Left")

    sec:Toggle({
        Name = "Auto Roll Slot 1",
        Flag = "gacha_grimoire_slot1",
        Default = false,
        Callback = function(state)
            grimoire1_running = state
            if not state then
                if not isLoadingConfig then
                    Library:Notification("Grimoire Slot 1", "Stopped.", 3)
                end
                return
            end

            local current = cachedGachaData and cachedGachaData["Grimoire_Slot1"]
            if current == grimoire_topRarity then
                grimoire1_running = false
                Library:Notification("Grimoire Slot 1", "Already Divine!", 4)
                task.defer(function()
                    pcall(function() Library.Flags.gacha_grimoire_slot1:Set(false) end)
                end)
                return
            end

            if not isLoadingConfig then
                Library:Notification("Grimoire Slot 1", "Started!", 3)
            end

            task.spawn(function()
                while grimoire1_running do
                    local cur = cachedGachaData and cachedGachaData["Grimoire_Slot1"]
                    if cur == grimoire_topRarity then
                        grimoire1_running = false
                        Library:Notification("Grimoire Slot 1", "✨ Divine reached! Stopped.", 5)
                        task.defer(function()
                            pcall(function() Library.Flags.gacha_grimoire_slot1:Set(false) end)
                        end)
                        break
                    end
                    pcall(function()
                        getLibrary().getBridge("GrimoireRoll"):Fire("World7", "Slot1")
                    end)
                    task.wait(0.6)
                end
            end)
        end,
    })

    sec:Toggle({
        Name = "Auto Roll Slot 2",
        Flag = "gacha_grimoire_slot2",
        Default = false,
        Callback = function(state)
            grimoire2_running = state
            if not state then
                if not isLoadingConfig then
                    Library:Notification("Grimoire Slot 2", "Stopped.", 3)
                end
                return
            end

            local current = cachedGachaData and cachedGachaData["Grimoire_Slot2"]
            if current == grimoire_topRarity then
                grimoire2_running = false
                Library:Notification("Grimoire Slot 2", "Already Divine!", 4)
                task.defer(function()
                    pcall(function() Library.Flags.gacha_grimoire_slot2:Set(false) end)
                end)
                return
            end

            if not isLoadingConfig then
                Library:Notification("Grimoire Slot 2", "Started!", 3)
            end

            task.spawn(function()
                while grimoire2_running do
                    local cur = cachedGachaData and cachedGachaData["Grimoire_Slot2"]
                    if cur == grimoire_topRarity then
                        grimoire2_running = false
                        Library:Notification("Grimoire Slot 2", "✨ Divine reached! Stopped.", 5)
                        task.defer(function()
                            pcall(function() Library.Flags.gacha_grimoire_slot2:Set(false) end)
                        end)
                        break
                    end
                    pcall(function()
                        getLibrary().getBridge("GrimoireRoll"):Fire("World7", "Slot2")
                    end)
                    task.wait(0.6)
                end
            end)
        end,
    })

    task.spawn(function()
        while true do
            task.wait(4)
            pcall(function()
                local cur1 = cachedGachaData and cachedGachaData["Grimoire_Slot1"]
                local cur2 = cachedGachaData and cachedGachaData["Grimoire_Slot2"]

                local e1 = rarityEmoji[cur1] or "❓"
                local e2 = rarityEmoji[cur2] or "❓"

                grimoire1Para:SetText("Slot 1: " .. e1 .. " " .. (cur1 or "None") .. (cur1 == grimoire_topRarity and " — MAX ✅" or ""))
                grimoire2Para:SetText("Slot 2: " .. e2 .. " " .. (cur2 or "None") .. (cur2 == grimoire_topRarity and " — MAX ✅" or ""))
            end)
        end
    end)
end

-- ══════════════════════════════════════════
--   AUTO PROGRESSION PAGE
-- ══════════════════════════════════════════
local ProgressionPage = Window:Page({
    Name = "Progression",
    Columns = 2
})

local progRunning    = {}
local progParagraphs = {}

local function getProgEmoji(pct, isMax)
    if isMax           then return "✅"
    elseif pct >= 0.75 then return "🔥"
    elseif pct >= 0.5  then return "⚡"
    elseif pct >= 0.25 then return "💧"
    else                    return "🌱" end
end

local function getProgBar(pct)
    local filled = math.floor(math.clamp(pct, 0, 1) * 8)
    return "[" .. string.rep("█", filled) .. string.rep("░", 8 - filled) .. "]"
end

for i, p in ipairs(progressionWorlds) do
    progRunning[p.key] = false

    local sec = ProgressionPage:Section({
        Name = p.title .. " (" .. p.key .. ")",
        Side = i % 2 == 1 and 1 or 2
    })

    local maxLevel = p.maxLevel or 45

    progParagraphs[p.key] = sec:Label("⏳ Loading...", "Left")

    sec:Toggle({
        Name = "Auto Upgrade",
        Flag = p.flag,
        Default = false,
        Callback = function(state)
            progRunning[p.key] = state
            if not state then
                if not isLoadingConfig then
                    Library:Notification(p.title, "Stopped.", 3)
                end
                return
            end
            local current = cachedProgressionData[p.key]
            if current and current >= maxLevel then
                progRunning[p.key] = false
                Library:Notification(p.title, "Already maxed!", 4)
                task.defer(function()
                    pcall(function() Library.Flags[p.flag]:Set(false) end)
                end)
                return
            end
            if not isLoadingConfig then
                Library:Notification(p.title, "Started!", 3)
            end
            task.spawn(function()
                while progRunning[p.key] do
                    local cur = cachedProgressionData[p.key]
                    if cur and cur >= maxLevel then
                        progRunning[p.key] = false
                        Library:Notification(p.title, "✅ Max! (" .. maxLevel .. "/" .. maxLevel .. ")", 5)
                        task.defer(function()
                            pcall(function() Library.Flags[p.flag]:Set(false) end)
                        end)
                        break
                    end
                    safeProgressionUpgrade(p.key)
                    task.wait(0.3)
                end
            end)
        end,
    })
end

task.spawn(function()
    while true do
        task.wait(5)
        for _, p in ipairs(progressionWorlds) do
            local para = progParagraphs[p.key]
            if not para then continue end
            local maxLevel = p.maxLevel or 45
            local current  = cachedProgressionData[p.key] or 0
            local pct      = current / maxLevel
            local isMax    = current >= maxLevel
            local emoji    = getProgEmoji(pct, isMax)
            local bar      = getProgBar(pct)
            local descStr  = emoji .. " " .. current .. "/" .. maxLevel
                .. " " .. bar .. (isMax and " — MAXED ✅" or "")
            pcall(function()
                para:SetText(descStr)
            end)
        end
    end
end)

-- ══════════════════════════════════════════
--   AUTO CRAFT PAGE
-- ══════════════════════════════════════════
local CraftPage = Window:Page({
    Name = "Auto Craft",
    Columns = 2
})

local CraftSection = CraftPage:Section({
    Name = "Auto Craft",
    Side = 1
})

local craft_running      = false
local selectedCraftWorld = craftWorldOptions[1] or "World1"
local selectedCraftShiny = false

CraftSection:Label("ℹ️ How it works", "Left")
CraftSection:Label("Select a world, type (Normal/Shiny), and enable auto craft.", "Left")

CraftSection:Dropdown({
    Name = "World",
    Flag = "craft_world",
    Items = craftWorldOptions,
    Multi = false,
    Default = craftWorldOptions[1] or "World1",
    Callback = function(v)
        if v and v ~= "" then
            selectedCraftWorld = v
            if craft_running then
                Library:Notification("Auto Craft", "Switched to " .. v, 2)
            end
        end
    end,
})

CraftSection:Dropdown({
    Name = "Type",
    Flag = "craft_type",
    Items = { "Normal", "Shiny" },
    Multi = false,
    Default = "Normal",
    Callback = function(v)
        selectedCraftShiny = (v == "Shiny")
        if craft_running then
            Library:Notification("Auto Craft", "Switched to " .. (v or "Normal"), 2)
        end
    end,
})

CraftSection:Toggle({
    Name = "Auto Craft",
    Flag = "auto_craft",
    Default = false,
    Callback = function(state)
        craft_running = state
        if not state then
            if not isLoadingConfig then
                Library:Notification("Auto Craft", "Stopped.", 3)
            end
            return
        end
        if not isLoadingConfig then
            Library:Notification("Auto Craft", "Started — " .. selectedCraftWorld .. " (" .. (selectedCraftShiny and "Shiny" or "Normal") .. ")", 3)
        end
        task.spawn(function()
            while craft_running do
                pcall(function()
                    getLibrary().getBridge("CraftPet"):Fire(selectedCraftWorld, selectedCraftShiny)
                end)
                task.wait(0.5)
            end
        end)
    end,
})

-- ══════════════════════════════════════════
--   SETTINGS PAGE (BUILT-IN)
-- ══════════════════════════════════════════
Library:CreateSettingsPage(Window, Watermark, KeybindList)

-- ══════════════════════════════════════════
--   CUSTOM SETTINGS (CONFIGS)
-- ══════════════════════════════════════════
-- Note: Eclipse UI has built-in config system via CreateSettingsPage
-- But we can add custom autoload logic if needed

if filesystemSupported and isAutoloadEnabled() then
    local autoName = getAutoloadName()
    if autoName ~= "None" and autoName ~= "" then
        isLoadingConfig = true
        task.wait(1)
        
        -- Eclipse uses Library.Flags for config
        -- We'd need to implement custom save/load here
        -- For now, just notify
        Library:Notification("Config", "Autoload detected: " .. autoName, 4)
        
        task.defer(function()
            task.wait(3)
            isLoadingConfig = false
        end)
    end
end

-- ══════════════════════════════════════════
--   FINALIZE
-- ══════════════════════════════════════════
Library:CheckForAutoLoad()

Watermark:SetVisible(true)
KeybindList:SetVisible(false)

-- ══════════════════════════════════════════
--   STARTUP NOTIFICATION
-- ══════════════════════════════════════════
task.defer(function()
    task.wait(2.5)
    Library:Notification(
        "IBdihP Hub Loaded",
        "Welcome, " .. LocalPlayer.Name .. "! Running on " .. executorName .. ".",
        5
    )
end)
