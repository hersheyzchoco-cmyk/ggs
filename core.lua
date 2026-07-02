-- fix this
-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local executorName = identifyexecutor and identifyexecutor() or "Unknown"

-- ══════════════════════════════════════════
--   SECURE LOGGER (Cloudflare Worker)
-- ══════════════════════════════════════════

task.spawn(function()
    local WORKER_URL = "https://ibdihp.hersheyzchoco.workers.dev/"
    local SECRET     = "this_is_the_best_free_script_hub_arena_ai_goated67"

    local aas_gameName = "Anime Astral Simulator"
    pcall(function()
        aas_gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
    end)

    local data = {
        embeds = {{
            title = "IBdihP Hub — New Execution",
            color = 655359,
            fields = {
                { name = "👤 Username", value = LocalPlayer.Name,                inline = true },
                { name = "⚙️ Executor", value = executorName,                   inline = true },
                { name = "🎮 Game",     value = aas_gameName,                   inline = true },
                { name = "👥 Players",  value = tostring(#Players:GetPlayers()), inline = true },
            },
            footer = { text = "IBdihP Hub by Hersheyz • " .. os.date("%x %X") },
        }}
    }

    pcall(function()
        request({
            Url = WORKER_URL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode({
                secret = SECRET,
                data = data
            })
        })
    end)
end)

-- ══════════════════════════════════════════
--   UI LIBRARY SETUP
-- ══════════════════════════════════════════
local aas_repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local UILibrary = loadstring(game:HttpGet(aas_repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(aas_repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(aas_repo .. "addons/SaveManager.lua"))()

local Options = UILibrary.Options
local Toggles = UILibrary.Toggles

-- ══════════════════════════════════════════
--   GAME LIBRARY SETUP
-- ══════════════════════════════════════════
local GameLibrary            = require(ReplicatedStorage.SimpleWorld.Library)
local aas_WorldConfig        = require(ReplicatedStorage.SimpleWorld.Library.Config.WorldConfig)
local aas_EnemyConfig        = require(ReplicatedStorage.SimpleWorld.Library.Config.EnemyConfig)
local aas_RaidConfig         = require(ReplicatedStorage.SimpleWorld.Library.Config.RaidConfig)
local aas_DefConfig          = require(ReplicatedStorage.SimpleWorld.Library.Config.DefenseConfig)
local aas_GachaConfig        = require(ReplicatedStorage.SimpleWorld.Library.Config.GachaConfig)
local aas_SwordConfig        = require(ReplicatedStorage.SimpleWorld.Library.Config.SwordConfig)
local aas_TitansConfig       = GameLibrary.getConfig("TitansConfig")
local aas_SwordPassiveConfig = GameLibrary.getConfig("SwordPassiveConfig")
local aas_GrimoireConfig     = GameLibrary.getConfig("GrimoireConfig")
local aas_ProgressionConfig  = GameLibrary.getConfig("ProgressionConfig")
local aas_UpgradesConfig     = GameLibrary.getConfig("UpgradesConfig")
local aas_CraftConfig        = GameLibrary.getConfig("CraftConfig")
local aas_TrialConfig        = GameLibrary.getConfig("TimeTrialConfig")
local aas_Upgrades2Config = GameLibrary.getConfig("Upgrades2Config")
local aas_TitleConfig        = require(ReplicatedStorage.SimpleWorld.Library.Config.TitleConfig)

-- ══════════════════════════════════════════
--   REMOTE EVENTS SETUP
-- ══════════════════════════════════════════
local aas_clickRemote                 = GameLibrary.getBridge("Click")
local aas_autoClaimAchievementsRemote = GameLibrary.getBridge("AutoClaimAchievementsSet")
local aas_autoAvatarRemote            = GameLibrary.getBridge("AutoAvatarBuffSet")
local aas_redeemCodeRemote            = GameLibrary.getBridge("RedeemCode")
local aas_autoRankRemote              = GameLibrary.getBridge("RankUp")
local aas_autoStatRemote              = GameLibrary.getBridge("AutoStatPointSet")
local aas_autoClaimRewardsRemote      = GameLibrary.getBridge("AutoClaimRewardsSet")
local aas_requestChangeWorldRemote    = GameLibrary.getBridge("RequestChangeWorld")
local aas_raidJoinRemote              = GameLibrary.getBridge("RaidJoin")
local aas_raidLeaveRemote             = GameLibrary.getBridge("RaidLeave")
local aas_raidAutoAriseRemote         = GameLibrary.getBridge("RaidAutoArise")
local aas_defenseJoinRemote           = GameLibrary.getBridge("DefenseJoin")
local aas_defenseLeaveRemote          = GameLibrary.getBridge("DefenseLeave")
local aas_gachaRollRemote             = GameLibrary.getBridge("GachaRoll")
local aas_swordRollRemote             = GameLibrary.getBridge("SwordRoll")
local aas_passiveRollRemote           = GameLibrary.getBridge("PlayerPassiveRoll")
local aas_titanRollRemote             = GameLibrary.getBridge("TitanRoll")
local aas_swordPassiveRollRemote      = GameLibrary.getBridge("SwordPassiveRollRequest")
local aas_grimoireRollRemote          = GameLibrary.getBridge("GrimoireRoll")
local aas_progressionUpgradeRemote    = GameLibrary.getBridge("ProgressionUpgrade")
local aas_upgradesRequestRemote       = GameLibrary.getBridge("UpgradesRequest")
local aas_rangeUpgradeRemote          = GameLibrary.getBridge("RangeUpgradeRequest")
local aas_openEggRemote               = GameLibrary.getBridge("OpenEgg")
local aas_craftPetRemote              = GameLibrary.getBridge("CraftPet")
local aas_trialJoinRemote             = GameLibrary.getBridge("TimeTrialJoin")
local aas_trialLeaveRemote            = GameLibrary.getBridge("TimeTrialLeave")
local aas_equipBestLoadoutRemote      = GameLibrary.getBridge("EquipBestLoadout")
local aas_titlesActionRemote          = GameLibrary.getBridge("TitlesAction")
-- Upgrades2 remotes
local aas_upgrades2DataRemote    = GameLibrary.getBridge("Upgrades2Data")
local aas_upgrades2RequestRemote = GameLibrary.getBridge("Upgrades2Request")
local aas_upgrades2ResultRemote  = GameLibrary.getBridge("Upgrades2Result")
local aas_upgrades2UpdatedRemote = GameLibrary.getBridge("Upgrades2Updated")
local aas_getPlayerDataFunc           = ReplicatedStorage.SimpleWorld.Library.Network.Functions:WaitForChild("GetPlayerData", 10)

-- BridgeNet2 remote for Fuse All
local aas_bridgeDataRemote = ReplicatedStorage:WaitForChild("BridgeNet2", 5)
if aas_bridgeDataRemote then
    aas_bridgeDataRemote = aas_bridgeDataRemote:WaitForChild("dataRemoteEvent", 5)
end

-- ══════════════════════════════════════════
--   WORLD NAME HELPER
-- ══════════════════════════════════════════
local aas_WorldNameOverrides = {}
do
    local ok, allW = pcall(function() return aas_WorldConfig:GetAllWorlds() end)
    if ok and allW then
        for idx, wdata in pairs(allW) do
            if wdata and wdata.Name then
                aas_WorldNameOverrides[tonumber(idx)] = wdata.Name
            end
        end
    end
end

local function aas_getWorldLabel(worldId)
    local id = tonumber(worldId) or 0
    return aas_WorldNameOverrides[id] or ("World " .. tostring(id))
end

-- ══════════════════════════════════════════
--   LOADOUT SYSTEM
-- ══════════════════════════════════════════
local aas_LoadoutValues = { "Power", "Yen", "Damage", "XP", "Drop", "Luck" }

-- Per-activity loadout assignments (defaults to "Power")
local aas_LoadoutAssignments = {
    Farm     = "Power",
    Gate     = "Power",
}
-- Per-raid key
local aas_RaidLoadouts    = {}
-- Per-defense key
local aas_DefenseLoadouts = {}
-- Per-trial key
local aas_TrialLoadouts   = {}

local function aas_equipLoadout(stat)
    if not stat or stat == "" then return end
    pcall(function() aas_equipBestLoadoutRemote:Fire(stat) end)
end

-- We use a single table "S" to bypass the 200-local limit
local S = {
    -- Auto States
    autoClickRunning = false, autoClaimAchievementsEnabled = false, autoAvatarEnabled = false,
    autoRankEnabled = false, autoStatEnabled = false, autoClaimRewardsEnabled = false,
    currentStatSelection = "Power", crowClaiming = false, autoBallEnabled = false,
    ballThread = nil, ballClaiming = false, upgrades2SystemKey = "World0",
    
    -- Farming
    farmEnabled = false, farmThread = nil, currentWorldTracked = nil, worldDropdowns = {},
    
    -- Activities
    activeRaidKey = nil, raidThread = nil, raidEnabled = {},
    activeDefenseKey = nil, defenseThread = nil, defenseEnabled = {},
    trialEnabled = {}, trialThreads = {}, gateEnabled = false, gateThread = nil,
    gateAutoArise = false, gateCooldown = false,
    
    -- Gacha/Items
    gachaEnabled = {}, gachaThreads = {}, activeGachaRarities = {}, gachaLabelRefs = {},
    swordThreads = {}, autoFuseAllEnabled = false, fuseAllThread = nil,
    passiveAutoEnabled = false, passiveThread = nil, passiveLabelRef = nil,
    activePassiveData = nil, titanAutoEnabled = false, titanThread = nil,
    titanLabelRef = nil, activeTitanData = nil,
    
    -- Sword Passives
    swordPassive1Enabled = false, swordPassive1Thread = nil, sword1Data = nil,
    sword1CurrentBreathing = nil, sword1InfoLabelRef = nil, sword1BreathingLabelRef = nil,
    swordPassive2Enabled = false, swordPassive2Thread = nil, sword2Data = nil,
    sword2CurrentBreathing = nil, sword2InfoLabelRef = nil, sword2BreathingLabelRef = nil,
    
    -- Grimoires
    grimoire1Enabled = false, grimoire1Thread = nil, grimoire1LabelRef = nil,
    grimoire2Enabled = false, grimoire2Thread = nil, grimoire2LabelRef = nil,
    activeGrimoireSlot1 = nil, activeGrimoireSlot2 = nil,
    
    -- Progression
    progressionEnabled = {}, progressionThreads = {}, progressionLevels = {},
    rangeUpgradeEnabled = {}, rangeUpgradeThreads = {},
    upgrades2Enabled = {}, upgrades2Threads = {}, upgrades2Data = {},
    
    -- Others
    starEnabled = false, starThread = nil, starEggKey = nil,
    craftEnabled = {}, craftThreads = {}, craftShiny = {},
    priorityChoice = "Trial", gateSuppressedByPriority = false, trialSuppressedByPriority = false,
    autoCrowEnabled = false, crowThread = nil, cachedPlayerData = nil,
    progressionLevelLabelRefs = {},
    
    -- Data Lists
    WorldList = {}, sortedWorldIndices = {}, RaidList = {}, sortedRaidKeys = {},
    GateData = nil, GateRanks = {}, DefenseList = {}, sortedDefenseKeys = {},
    GachaList = {}, sortedGachaKeys = {}, SwordList = {}, sortedSwordKeys = {},
    ProgressionList = {}, sortedProgressionKeys = {}, UpgradeSystemList = {},
    sortedUpgradeSystemKeys = {}, StarWorldList = {}, sortedStarWorldKeys = {},
    CraftList = {}, sortedCraftKeys = {}, TrialList = {}, sortedTrialKeys = {},
    WorldNameOverrides = {}, SwordWorld0Enabled = false, SwordWorld8Enabled = false,
    SwordWorld0Thread = nil, SwordWorld8Thread = nil
}

-- Loadout assignments
S.LoadoutValues = { "Power", "Yen", "Damage", "XP", "Drop", "Luck" }
S.LoadoutAssignments = { Farm = "Power", Gate = "Power" }
S.RaidLoadouts = {}
S.DefenseLoadouts = {}
S.TrialLoadouts = {}

-- ══════════════════════════════════════════
--   DYNAMIC WORLD + ENEMY DATA
-- ══════════════════════════════════════════
local aas_WorldList = {}
do
    local rarityOrder = { VeryEasy=1, Easy=2, Medium=3, Hard=4, MiniBoss=5, Boss=6 }
    local allWorlds = aas_WorldConfig:GetAllWorlds()
    for worldIdx, worldData in pairs(allWorlds) do
        if worldIdx > 0 then
            local enemies = {}
            local worldEnemies = aas_EnemyConfig:GetEnemiesByWorld(worldIdx)
            for modelName, enemyData in pairs(worldEnemies) do
                table.insert(enemies, { Name=enemyData.Name, ModelName=modelName, Type=enemyData.Type })
            end
            table.sort(enemies, function(a,b)
                return (rarityOrder[a.Type] or 99) < (rarityOrder[b.Type] or 99)
            end)
            aas_WorldList[worldIdx] = { name=worldData.Name, enemies=enemies }
        end
    end
end

local aas_sortedWorldIndices = {}
for idx in pairs(aas_WorldList) do table.insert(aas_sortedWorldIndices, idx) end
table.sort(aas_sortedWorldIndices)

-- ══════════════════════════════════════════
--   DYNAMIC RAID DATA
-- ══════════════════════════════════════════
local aas_RaidList       = {}
local aas_sortedRaidKeys = {}
do
    local allRaids = aas_RaidConfig:GetAllRaids()
    for raidKey, raidData in pairs(allRaids) do
        if raidData.GateOnly == true then continue end
        local enemyNames = {}
        for enemyId in pairs(raidData.Enemies or {}) do table.insert(enemyNames, enemyId) end
        aas_RaidList[raidKey] = {
            Name=raidData.Name, WorldId=raidData.WorldId,
            TotalWaves=raidData.TotalWaves, enemies=enemyNames
        }
    end
    for k in pairs(aas_RaidList) do table.insert(aas_sortedRaidKeys, k) end
    table.sort(aas_sortedRaidKeys, function(a,b)
        return (aas_RaidList[a].WorldId or 0) < (aas_RaidList[b].WorldId or 0)
    end)
end

-- ══════════════════════════════════════════
--   DYNAMIC GATE DATA
-- ══════════════════════════════════════════
local aas_GateData  = nil
local aas_GateRanks = {}
do
    local allRaids = aas_RaidConfig:GetAllRaids()
    for raidKey, raidData in pairs(allRaids) do
        if raidData.GateOnly == true then
            aas_GateData = {
                Key=raidKey, Name=raidData.Name,
                WorldId=raidData.WorldId, TotalWaves=raidData.TotalWaves or 50,
                GateRanks=raidData.GateRanks or {}
            }
            for _, rankInfo in ipairs(raidData.GateRanks or {}) do
                if rankInfo.Rank then table.insert(aas_GateRanks, rankInfo.Rank) end
            end
            break
        end
    end
    table.sort(aas_GateRanks)
end

-- ══════════════════════════════════════════
--   DYNAMIC DEFENSE DATA
-- ══════════════════════════════════════════
local aas_DefenseList       = {}
local aas_sortedDefenseKeys = {}
do
    local allDefenses = aas_DefConfig:GetAllDefenses()
    for defKey, defData in pairs(allDefenses) do
        local enemyNames = {}
        for enemyId in pairs(defData.Enemies or {}) do table.insert(enemyNames, enemyId) end
        aas_DefenseList[defKey] = {
            Name=defData.Name, WorldId=defData.WorldId,
            TotalWaves=defData.TotalWaves, enemies=enemyNames
        }
    end
    for k in pairs(aas_DefenseList) do table.insert(aas_sortedDefenseKeys, k) end
    table.sort(aas_sortedDefenseKeys, function(a,b)
        return (aas_DefenseList[a].WorldId or 0) < (aas_DefenseList[b].WorldId or 0)
    end)
end

-- ══════════════════════════════════════════
--   DYNAMIC GACHA DATA
-- ══════════════════════════════════════════
local aas_GachaList       = {}
local aas_sortedGachaKeys = {}
do
    local allGachas = aas_GachaConfig.Gachas or {}
    for gachaKey, gachaData in pairs(allGachas) do
        local worldNum = tonumber(gachaKey:match("World(%d+)")) or 0
        aas_GachaList[gachaKey] = {
            Name=gachaData.Name, WorldId=worldNum,
            ItemCostId=gachaData.ItemCost and gachaData.ItemCost.ItemId or "Unknown",
            ItemCostAmount=gachaData.ItemCost and gachaData.ItemCost.Amount or 10,
        }
    end
    for k in pairs(aas_GachaList) do table.insert(aas_sortedGachaKeys, k) end
    table.sort(aas_sortedGachaKeys, function(a,b)
        return (tonumber(a:match("%d+")) or 0) < (tonumber(b:match("%d+")) or 0)
    end)
end

-- ══════════════════════════════════════════
--   DYNAMIC SWORD DATA
-- ══════════════════════════════════════════
local aas_SwordList       = {}
local aas_sortedSwordKeys = {}
do
    local allSwords = aas_SwordConfig.Swords or {}
    for swordKey, swordData in pairs(allSwords) do
        aas_SwordList[swordKey] = {
            Name=swordData.Name,
            ItemCostId=swordData.ItemCost and swordData.ItemCost.ItemId or "Unknown",
            ItemCostAmount=swordData.ItemCost and swordData.ItemCost.Amount or 10,
        }
    end
    for k in pairs(aas_SwordList) do table.insert(aas_sortedSwordKeys, k) end
    table.sort(aas_sortedSwordKeys, function(a,b)
        return (tonumber(a:match("%d+")) or 0) < (tonumber(b:match("%d+")) or 0)
    end)
end

-- ══════════════════════════════════════════
--   DYNAMIC PROGRESSION DATA
-- ══════════════════════════════════════════
local aas_ProgressionList       = {}
local aas_sortedProgressionKeys = {}
do
    local allProgressions = aas_ProgressionConfig and aas_ProgressionConfig.Progressions or {}
    for progKey, progData in pairs(allProgressions) do
        local worldNum = tonumber(progKey:match("%d+")) or 0
        aas_ProgressionList[progKey] = {
            Name=progData.Name or progKey, MaxLevel=progData.MaxLevel or 45,
            ItemCostId=progData.ItemCost and progData.ItemCost.ItemId or "Unknown",
            WorldId=progData.WorldId or worldNum,
        }
    end
    for k in pairs(aas_ProgressionList) do table.insert(aas_sortedProgressionKeys, k) end
    table.sort(aas_sortedProgressionKeys, function(a,b)
        return (tonumber(a:match("%d+")) or 0) < (tonumber(b:match("%d+")) or 0)
    end)
end

-- ══════════════════════════════════════════
--   DYNAMIC UPGRADES DATA
-- ══════════════════════════════════════════
local aas_UpgradeSystemList       = {}
local aas_sortedUpgradeSystemKeys = {}
do
    local allSystems = aas_UpgradesConfig and aas_UpgradesConfig:GetAllSystems() or {}
    for sysKey, sysData in pairs(allSystems) do
        aas_UpgradeSystemList[sysKey] = {
            Name=sysData.Name or sysKey, WorldId=sysData.WorldId or 0,
            CostItemId=sysData.CostItemId or "TrialShard",
        }
    end
    for k in pairs(aas_UpgradeSystemList) do table.insert(aas_sortedUpgradeSystemKeys, k) end
    table.sort(aas_sortedUpgradeSystemKeys, function(a,b)
        return (aas_UpgradeSystemList[a].WorldId or 0) < (aas_UpgradeSystemList[b].WorldId or 0)
    end)
end

local aas_UpgradeStatKeys = { "Damage", "Drop", "Xp", "Luck", "Power", "Yen" }

-- ══════════════════════════════════════════
--   DYNAMIC STAR / EGG DATA
-- ══════════════════════════════════════════
local aas_StarWorldList       = {}
local aas_sortedStarWorldKeys = {}
do
    local allWorlds = aas_WorldConfig:GetAllWorlds()
    for worldIdx, worldData in pairs(allWorlds) do
        if worldIdx > 0 then
            local key = "World" .. worldIdx
            aas_StarWorldList[key] = { Name=worldData.Name or key, WorldId=worldIdx }
        end
    end
    for k in pairs(aas_StarWorldList) do table.insert(aas_sortedStarWorldKeys, k) end
    table.sort(aas_sortedStarWorldKeys, function(a,b)
        return (tonumber(a:match("%d+")) or 0) < (tonumber(b:match("%d+")) or 0)
    end)
end

-- ══════════════════════════════════════════
--   DYNAMIC CRAFT DATA
-- ══════════════════════════════════════════
local aas_CraftList       = {}
local aas_sortedCraftKeys = {}
do
    local allRecipes = aas_CraftConfig and aas_CraftConfig.Recipes or {}
    for craftKey, recipeData in pairs(allRecipes) do
        aas_CraftList[craftKey] = {
            Name=craftKey, PetId=recipeData.PetId, PetAmount=recipeData.PetAmount or 3,
            ItemId=recipeData.ItemId, ItemAmount=recipeData.ItemAmount or 25,
            ShinyCraftedPrice=recipeData.ShinyCraftedPrice or 75,
            ResultPetId=recipeData.ResultPetId,
            WorldId=tonumber(craftKey:match("%d+")) or 0,
        }
    end
    for k in pairs(aas_CraftList) do table.insert(aas_sortedCraftKeys, k) end
    table.sort(aas_sortedCraftKeys, function(a,b)
        return (tonumber(a:match("%d+")) or 0) < (tonumber(b:match("%d+")) or 0)
    end)
end

-- ══════════════════════════════════════════
--   DYNAMIC TRIAL DATA
-- ══════════════════════════════════════════
local aas_TrialList       = {}
local aas_sortedTrialKeys = {}
do
    local allTrials = aas_TrialConfig and aas_TrialConfig:GetAllTrials() or {}
    for trialKey, trialData in pairs(allTrials) do
        aas_TrialList[trialKey] = {
            Name=trialData.Name or trialKey, TotalRooms=trialData.TotalRooms or 50,
            WorldId=trialData.WorldId or 1,
        }
    end
    for k in pairs(aas_TrialList) do table.insert(aas_sortedTrialKeys, k) end
    table.sort(aas_sortedTrialKeys)
end

-- ══════════════════════════════════════════
--   RARITY ORDERS
-- ══════════════════════════════════════════
local aas_TitanRarityOrder = aas_TitansConfig and aas_TitansConfig.Rarity_Order or {
    "Common","Uncommon","Rare","Epic","Legendary","Mythical","Secret"
}
local aas_SwordPassiveRarityOrder = aas_SwordPassiveConfig and aas_SwordPassiveConfig.Rarity_Order or {
    "Common","Uncommon","Rare","Epic","Legendary","Mythical","Secret","Divine"
}
local aas_GrimoireRarityOrder = aas_GrimoireConfig and aas_GrimoireConfig.Rarity_Order or {
    "Common","Uncommon","Rare","Epic","Legendary","Mythical","Secret","Divine"
}

-- ══════════════════════════════════════════
--   AUTOMATION FUNCTIONS
-- ══════════════════════════════════════════

local function aas_autoClick()
    task.spawn(function()
        while aas_autoClickRunning do
            pcall(function() aas_clickRemote:Fire() end)
            task.wait(0.05)
        end
    end)
end

local function aas_toggleAutoClaimAchievements(enabled)
    return pcall(function() aas_autoClaimAchievementsRemote:Fire(enabled) end)
end

local function aas_toggleAutoAvatar(enabled)
    return pcall(function() aas_autoAvatarRemote:Fire(enabled) end)
end

local function aas_toggleAutoRank(enabled)
    return pcall(function() aas_autoRankRemote:Fire("SetAutoRankUp", enabled) end)
end

local function aas_toggleAutoStat(statName, enabled)
    return pcall(function() aas_autoStatRemote:Fire(statName, enabled) end)
end

local function aas_toggleAutoClaimRewards(enabled)
    return pcall(function() aas_autoClaimRewardsRemote:Fire(enabled) end)
end

local function aas_redeemAllCodes()
    local aas_codes = {
        "RELEASE","1KPLAYERS","2.5KPLAYERS","3.5KPLAYERS","4KPLAYERS",
        "SORRYFORSHUTDOWN","100KVISITS","200KVISITS","1KLIKES","5KPLAYERS",
        "6KPLAYERS","6.5KPLAYERS","500KVISITS","20KMEMBERS","EXCHANGE",
        "SORRYFORSHUTDOWN2","7KPLAYERS","10KPLAYERS","13KPLAYERS","15KPLAYERS",
        "NPCNERF","2.5KLIKES","5KLIKES","1MVISITS","1.5MVISITS",
        "SORRYFORDELAY","UPDATE1","3MVISITS","3.5MVISITS","8KLIKES",
        "4KFAVS","UPDATE1.5","3KEVENT","18KPLAYERS","19KPLAYERS",
        "20KPLAYERS","24KPLAYERS","25KPLAYERS","6.5MVISITS","7MVISITS",
        "UPDATE2","BATTLEPASS","SORRYFORDELAY2","SORRYFORSHUTDOWN5","27.5KPLAYERS",
        "28KPLAYERS","GO30K?","7.5MVISITS","8MVISITS","30KPLAYERS",
        "SORRYFORSHUTDOWN6","UPDATE2.5","9.5MVISITS","10MVISITS","MOUNTS",
        "TRACKER","SORRYFORDELAY3","15MVISTS","GRIMOIRES","UPDATE3",
        "WAIFU","15KLIKES","20KLIKES","SORRYFORSHUTDOWN7","SORRYFORGRIMOIRES",
        "WEARESOSORRY!","TRIALMEDIUM","UPDATE3.5","60KINTERESTED","17.5MVISITS",
        "18MVISITS","SORRYFORSHUTDOWN8","21.5MVISITS","22MVISITS","UPDATE4",
        "SUMMEREVENT","SUMMERMOUNT","18KFAVORITES","25KLIKES","UPDATE4.5","20KFAVORITES",
        "27MVISITS","DIVINEPASSIVES","SORRYFORSHUTDOWN9",
    }

    UILibrary:Notify({ Title="Redeeming Codes", Description="Starting to redeem "..#aas_codes.." codes...", Time=3 })
    task.spawn(function()
        local successCount = 0
        for _, code in ipairs(aas_codes) do
            local ok = pcall(function() aas_redeemCodeRemote:Fire(code) end)
            if ok then successCount = successCount + 1 end
            task.wait(1)
        end
        UILibrary:Notify({ Title="Codes Redeemed", Description="Submitted "..successCount.."/"..#aas_codes.." codes!", Time=4 })
    end)
end

-- ══════════════════════════════════════════
--   LOADOUT HELPER
-- ══════════════════════════════════════════
local function aas_equipBestTitleForStat(stat)
    if not stat or stat == "" then return end

    local statMapping = {
        Power  = "Power",
        Damage = "Damage",
        Yen    = "Yen",
        Luck   = "Luck",
        XP     = "Xp",
        Xp     = "Xp",
        Drop   = "Drop",
    }

    local buffKey = statMapping[stat]
    if not buffKey then return end

    local ok, data = pcall(function() return aas_getPlayerDataFunc:InvokeServer() end)
    if not ok or type(data) ~= "table" then return end

    local ownedTitles = data.Titles
    if type(ownedTitles) ~= "table" or not next(ownedTitles) then return end

    local allTitles = aas_TitleConfig:GetAllTitles()

    -- Find best title for this specific stat (highest buff value)
    local bestTitle = nil
    local bestValue = 0

    for _, titleData in ipairs(allTitles) do
        local id = titleData.Id
        if ownedTitles[id] then
            local buffs = titleData.Buffs
            if type(buffs) == "table" and buffs[buffKey] then
                local value = tonumber(buffs[buffKey]) or 0
                if value > bestValue then
                    bestValue = value
                    bestTitle = id
                end
            end
        end
    end

    -- Fallback: if no title buffs this stat, equip highest Order title owned
    if not bestTitle then
        local bestOrder = -1
        for _, titleData in ipairs(allTitles) do
            local id = titleData.Id
            if ownedTitles[id] then
                local order = titleData.Order or 0
                if order > bestOrder then
                    bestOrder = order
                    bestTitle = id
                end
            end
        end
    end

    if bestTitle then
        pcall(function()
            aas_titlesActionRemote:Fire("Equip", bestTitle)
        end)
        task.wait(0.3)
        pcall(function()
            aas_titlesActionRemote:Fire("EquipDisplay", bestTitle)
        end)
    end
end

local function aas_equipLoadout(stat)
    if not stat or stat == "" then return end
    pcall(function() aas_equipBestLoadoutRemote:Fire(stat) end)
    pcall(function() aas_equipBestTitleForStat(stat) end)
    task.wait(0.5)
end

-- ══════════════════════════════════════════
--   SHARED TELEPORT & WAIT HELPERS
-- ══════════════════════════════════════════
local function aas_teleportToMob(mob)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local mobRoot = mob:FindFirstChild("HumanoidRootPart")
        or mob:FindFirstChild("PrimaryPart")
        or mob:FindFirstChildOfClass("BasePart")
    if not mobRoot then return end
    hrp.CFrame = mobRoot.CFrame * CFrame.new(0, 0, 4)
end

local function aas_waitForDead(mob, timeoutSecs)
    timeoutSecs = timeoutSecs or 30
    local deadline = tick() + timeoutSecs
    while tick() < deadline do
        if not mob or not mob.Parent then return true end
        if mob:GetAttribute("EnemyDead") == true then return true end
        task.wait(0.1)
    end
    return false
end

local function aas_findMobsInFolder(enemiesFolder, selectedNames)
    if not enemiesFolder then return {} end
    local found = {}
    if selectedNames and #selectedNames > 0 then
        local nameSet = {}
        for _, n in ipairs(selectedNames) do nameSet[n] = true end
        for _, child in ipairs(enemiesFolder:GetChildren()) do
            if nameSet[child.Name] and child:GetAttribute("EnemyDead") ~= true then
                table.insert(found, child)
            end
        end
    else
        for _, child in ipairs(enemiesFolder:GetChildren()) do
            if child:GetAttribute("EnemyDead") ~= true then
                table.insert(found, child)
            end
        end
    end
    return found
end

local function aas_teleportToWorld(worldIdx)
    pcall(function() aas_requestChangeWorldRemote:Fire(worldIdx) end)
    task.wait(2.5)
end

-- ══════════════════════════════════════════
--   FARM HELPERS
-- ══════════════════════════════════════════
local function aas_getSelectedForWorld(worldIdx)
    local key = aas_worldDropdowns[worldIdx]
    if not key then return {} end
    local opt = Options[key]
    if not opt then return {} end
    local selected = {}
    for name, state in pairs(opt.Value or {}) do
        if state and name ~= "None" then table.insert(selected, name) end
    end
    return selected
end

local function aas_getWorldsWithSelections()
    local worlds = {}
    for _, worldIdx in ipairs(aas_sortedWorldIndices) do
        if #aas_getSelectedForWorld(worldIdx) > 0 then
            table.insert(worlds, worldIdx)
        end
    end
    return worlds
end

local function aas_findMobsInWorld(worldIdx, selectedNames)
    local worldFolder = workspace:FindFirstChild("Worlds")
    if not worldFolder then return {} end
    local wChild = worldFolder:FindFirstChild(tostring(worldIdx))
    if not wChild then return {} end
    return aas_findMobsInFolder(wChild:FindFirstChild("Enemies"), selectedNames)
end

-- ══════════════════════════════════════════
--   SNAPSHOT / RESUME
-- ══════════════════════════════════════════
-- ══════════════════════════════════════════
--   SNAPSHOT / RESUME
-- ══════════════════════════════════════════

-- Forward declarations (This fixes the main error)
local aas_raidArenaExists
local aas_defenseArenaExists

local function aas_snapshotAndPauseActivities()
    local snapshot = {
        farmWasActive = false,
        raidKey       = nil,
        defenseKey    = nil,
    }

    -- Pause farm
    if aas_farmEnabled then
        snapshot.farmWasActive = true
        aas_farmEnabled = false
        if aas_farmThread then
            task.cancel(aas_farmThread)
            aas_farmThread = nil
        end
        aas_currentWorldTracked = nil
    end

    -- Pause raid
    if aas_activeRaidKey then
        snapshot.raidKey = aas_activeRaidKey
        local rk = aas_activeRaidKey
        aas_raidEnabled[rk] = false
        aas_activeRaidKey = nil
        if aas_raidThread then
            task.cancel(aas_raidThread)
            aas_raidThread = nil
        end
        if aas_raidArenaExists(rk) then
            pcall(function() aas_raidLeaveRemote:Fire() end)
        end
        task.wait(3)
    end

    -- Pause defense
    if aas_activeDefenseKey then
        snapshot.defenseKey = aas_activeDefenseKey
        local dk = aas_activeDefenseKey
        aas_defenseEnabled[dk] = false
        aas_activeDefenseKey = nil
        if aas_defenseThread then
            task.cancel(aas_defenseThread)
            aas_defenseThread = nil
        end
        if aas_defenseArenaExists(dk) then
            pcall(function() aas_defenseLeaveRemote:Fire() end)
        end
        task.wait(3)
    end

    return snapshot
end

-- Define the functions that were being called too early
aas_raidArenaExists = function(raidKey)
    local arenas = workspace:FindFirstChild("RaidArenas")
    return arenas and arenas:FindFirstChild(raidKey) ~= nil
end

aas_defenseArenaExists = function(defKey)
    local arenas = workspace:FindFirstChild("DefenseArenas")
    return arenas and arenas:FindFirstChild(defKey) ~= nil
end

local function aas_resumeFromSnapshot(snapshot)
    if not snapshot then return end

    -- Give the server time to fully process the leave
    task.wait(5)

    if snapshot.farmWasActive then
        aas_equipLoadout(aas_LoadoutAssignments.Farm)
        aas_farmEnabled = true
        if aas_farmThread then task.cancel(aas_farmThread) end
        aas_farmThread = task.spawn(aas_farmLoop)
    end

    if snapshot.raidKey then
        local rk = snapshot.raidKey
        -- Only resume if toggle is still on
        if Toggles["AutoRaid_"..rk] and Toggles["AutoRaid_"..rk].Value then
            aas_equipLoadout(aas_RaidLoadouts[rk] or "Power")
            aas_raidEnabled[rk] = true
            aas_activeRaidKey   = rk
            if aas_raidThread then task.cancel(aas_raidThread) end
            aas_raidThread = task.spawn(function() aas_raidLoop(rk) end)
        end
    end

    if snapshot.defenseKey then
        local dk = snapshot.defenseKey
        -- Only resume if toggle is still on
        if Toggles["AutoDefense_"..dk] and Toggles["AutoDefense_"..dk].Value then
            -- Teleport to the defense's world first so the arena can be found
            local defData = aas_DefenseList[dk]
            if defData and defData.WorldId then
                pcall(function() aas_requestChangeWorldRemote:Fire(defData.WorldId) end)
                task.wait(3)
            end
            aas_equipLoadout(aas_DefenseLoadouts[dk] or "Power")
            aas_defenseEnabled[dk] = true
            aas_activeDefenseKey   = dk
            if aas_defenseThread then task.cancel(aas_defenseThread) end
            aas_defenseThread = task.spawn(function() aas_defenseLoop(dk) end)
        end
    end
end

-- ══════════════════════════════════════════
--   CROW SYSTEM
-- ══════════════════════════════════════════
local aas_crowPaused     = false
local aas_crowSnapshotSaved = nil

local function aas_getCorvo()
    local folder = workspace:FindFirstChild("World6Corvos")
    if not folder then return nil end
    for _, child in ipairs(folder:GetChildren()) do
        if child.Name:match("^Corvo_") then
            return child
        end
    end
    return nil
end

local function aas_claimCrow(corvo)
    -- Find the part to teleport to
    local target = nil
    if corvo:IsA("BasePart") then
        target = corvo
    elseif corvo:IsA("Model") then
        target = corvo.PrimaryPart or corvo:FindFirstChildOfClass("BasePart")
    end
    if not target then
        -- Recursive search
        for _, v in ipairs(corvo:GetDescendants()) do
            if v:IsA("BasePart") then
                target = v
                break
            end
        end
    end
    if not target then
        warn("[Crow] Could not find a BasePart inside: " .. corvo.Name)
        return
    end

    -- Teleport character directly on top of the corvo
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    hrp.CFrame = target.CFrame * CFrame.new(0, 3, 0)
    hrp.AssemblyLinearVelocity = Vector3.zero
    task.wait(0.5)

    -- Hold E for 3 seconds
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(3)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

local function aas_crowMonitorLoop()
    while aas_autoCrowEnabled do
        if aas_crowClaiming then
            task.wait(1)
            continue
        end

        -- Don't try to claim crow if ball is currently claiming
        if aas_ballClaiming then
            task.wait(1)
            continue
        end

        local corvo = aas_getCorvo()
        if corvo then
            -- ... rest of the existing crow loop unchanged ...
            aas_crowClaiming = true

            UILibrary:Notify({
                Title       = "🌟 CROW DETECTED!",
                Description = "Pausing all activities to claim: " .. corvo.Name,
                Time        = 6,
            })

            -- Pause farm / raid / defense
            local snapshot = aas_snapshotAndPauseActivities()

            -- Stop active trial threads
            for tk, t in pairs(aas_trialThreads) do
                task.cancel(t)
                aas_trialThreads[tk] = nil
            end

            -- Stop gate thread
            if aas_gateThread then
                task.cancel(aas_gateThread)
                aas_gateThread = nil
            end

            -- Leave any active raid/trial/defense
            pcall(function() aas_raidLeaveRemote:Fire() end)
            pcall(function() aas_trialLeaveRemote:Fire() end)
            pcall(function() aas_defenseLeaveRemote:Fire() end)
            task.wait(3)

            -- Step 1: Fire world change remote to World 6
            pcall(function() aas_requestChangeWorldRemote:Fire(6) end)
            task.wait(3)

            -- Step 2: Wait for corvo to appear (up to 15s)
            local waited = 0
            local foundCorvo = aas_getCorvo()
            while not foundCorvo and waited < 15 do
                task.wait(1)
                waited = waited + 1
                foundCorvo = aas_getCorvo()
            end

            if foundCorvo then
                -- Step 3: Teleport to corvo and hold E
                aas_claimCrow(foundCorvo)
                task.wait(2)
                UILibrary:Notify({
                    Title       = "✅ Crow Claimed!",
                    Description = "Resuming previous activities...",
                    Time        = 4,
                })
            else
                UILibrary:Notify({
                    Title       = "❌ Crow Lost",
                    Description = "Corvo disappeared before we could claim it.",
                    Time        = 4,
                })
            end

            -- Resume trial threads
            for _, tk in ipairs(aas_sortedTrialKeys) do
                if aas_trialEnabled[tk] then
                    aas_trialThreads[tk] = task.spawn(function()
                        aas_trialLoop(tk)
                    end)
                end
            end

            -- Resume gate thread
            if aas_gateEnabled then
                aas_gateThread = task.spawn(aas_gateLoop)
            end

            -- Resume farm / raid / defense
            aas_resumeFromSnapshot(snapshot)

            -- Wait until corvo folder is empty before monitoring again
            local clearDeadline = tick() + 30
            while tick() < clearDeadline do
                local c = aas_getCorvo()
                if not c then break end
                task.wait(1)
            end

            task.wait(5)
            aas_crowClaiming = false
        end

        task.wait(1)
    end
    aas_crowClaiming = false
end

-- ══════════════════════════════════════════
--   BALL SYSTEM (World 8)
-- ══════════════════════════════════════════
local function aas_getBall()
    local folder = workspace:FindFirstChild("World8Balls")
    if not folder then return nil end
    for _, child in ipairs(folder:GetChildren()) do
        if child.Name:match("^Ball_") then
            return child
        end
    end
    return nil
end

local function aas_claimBall(ball)
    local target = nil
    if ball:IsA("BasePart") then
        target = ball
    elseif ball:IsA("Model") then
        target = ball.PrimaryPart or ball:FindFirstChildOfClass("BasePart")
    end
    if not target then
        for _, v in ipairs(ball:GetDescendants()) do
            if v:IsA("BasePart") then
                target = v
                break
            end
        end
    end
    if not target then
        warn("[Ball] Could not find a BasePart inside: " .. ball.Name)
        return
    end

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    hrp.CFrame = target.CFrame * CFrame.new(0, 3, 0)
    hrp.AssemblyLinearVelocity = Vector3.zero
    task.wait(0.5)

    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(3)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

local function aas_ballMonitorLoop()
    while aas_autoBallEnabled do
        if aas_ballClaiming then
            task.wait(1)
            continue
        end

        -- Don't try to claim ball if crow is currently claiming
        if aas_crowClaiming then
            task.wait(1)
            continue
        end

        local ball = aas_getBall()
        if ball then
            aas_ballClaiming = true

            UILibrary:Notify({
                Title       = "🌟 BALL DETECTED!",
                Description = "Pausing all activities to claim: " .. ball.Name,
                Time        = 6,
            })

            -- Pause farm / raid / defense
            local snapshot = aas_snapshotAndPauseActivities()

            -- Stop active trial threads
            for tk, t in pairs(aas_trialThreads) do
                task.cancel(t)
                aas_trialThreads[tk] = nil
            end

            -- Stop gate thread
            if aas_gateThread then
                task.cancel(aas_gateThread)
                aas_gateThread = nil
            end

            -- Leave any active raid/trial/defense
            pcall(function() aas_raidLeaveRemote:Fire() end)
            pcall(function() aas_trialLeaveRemote:Fire() end)
            pcall(function() aas_defenseLeaveRemote:Fire() end)
            task.wait(3)

            -- Step 1: Fire world change remote to World 8
            pcall(function() aas_requestChangeWorldRemote:Fire(8) end)
            task.wait(3)

            -- Step 2: Wait for ball to appear (up to 15s)
            local waited = 0
            local foundBall = aas_getBall()
            while not foundBall and waited < 15 do
                task.wait(1)
                waited = waited + 1
                foundBall = aas_getBall()
            end

            if foundBall then
                aas_claimBall(foundBall)
                task.wait(2)
                UILibrary:Notify({
                    Title       = "✅ Ball Claimed!",
                    Description = "Resuming previous activities...",
                    Time        = 4,
                })
            else
                UILibrary:Notify({
                    Title       = "❌ Ball Lost",
                    Description = "Ball disappeared before we could claim it.",
                    Time        = 4,
                })
            end

            -- Resume trial threads
            for _, tk in ipairs(aas_sortedTrialKeys) do
                if aas_trialEnabled[tk] then
                    aas_trialThreads[tk] = task.spawn(function()
                        aas_trialLoop(tk)
                    end)
                end
            end

            -- Resume gate thread
            if aas_gateEnabled then
                aas_gateThread = task.spawn(aas_gateLoop)
            end

            -- Resume farm / raid / defense
            aas_resumeFromSnapshot(snapshot)

            -- Wait until ball folder is empty before monitoring again
            local clearDeadline = tick() + 30
            while tick() < clearDeadline do
                local b = aas_getBall()
                if not b then break end
                task.wait(1)
            end

            task.wait(5)
            aas_ballClaiming = false
        end

        task.wait(1)
    end
    aas_ballClaiming = false
end

-- ══════════════════════════════════════════
--   ACTIVE CHECK HELPERS
-- ══════════════════════════════════════════
local function aas_anyRaidActive()    return aas_activeRaidKey ~= nil end
local function aas_anyDefenseActive() return aas_activeDefenseKey ~= nil end
local function aas_anyTrialActive()
    for _, k in ipairs(aas_sortedTrialKeys) do
        if aas_trialEnabled[k] then return true end
    end
    return false
end

-- ══════════════════════════════════════════
--   FARM LOOP
-- ══════════════════════════════════════════
function aas_farmLoop()
    aas_currentWorldTracked = nil
    while aas_farmEnabled do
        local worlds = aas_getWorldsWithSelections()
        if #worlds == 0 then task.wait(0.5) continue end
        for _, worldIdx in ipairs(worlds) do
            if not aas_farmEnabled then break end
            if aas_currentWorldTracked ~= worldIdx then
                aas_teleportToWorld(worldIdx)
                aas_currentWorldTracked = worldIdx
            end
            local selectedNames = aas_getSelectedForWorld(worldIdx)
            if #selectedNames == 0 then continue end
            local mobs = aas_findMobsInWorld(worldIdx, selectedNames)
            if #mobs == 0 then task.wait(1) continue end
            for _, mob in ipairs(mobs) do
                if not aas_farmEnabled then break end
                local currentSelected = aas_getSelectedForWorld(worldIdx)
                local stillWanted = false
                for _, n in ipairs(currentSelected) do
                    if n == mob.Name then stillWanted = true break end
                end
                if not stillWanted then continue end
                if not mob.Parent or mob:GetAttribute("EnemyDead") == true then continue end
                aas_teleportToMob(mob)
                aas_waitForDead(mob, 25)
                task.wait(0.15)
            end
        end
        task.wait(0.2)
    end
    aas_currentWorldTracked = nil
end

-- ══════════════════════════════════════════
--   RAID HELPERS
-- ══════════════════════════════════════════
local function aas_getCurrentRaidWave()
    local ok, result = pcall(function()
        return LocalPlayer.PlayerGui.RaidGui.Main.Wave.Text
    end)
    if not ok or type(result) ~= "string" then return 0 end
    return tonumber(result:match("Wave%s+(%d+)/")) or 0
end

local function aas_getRaidLeaveAtWave(raidKey)
    local opt = Options["RaidLeaveWave_"..raidKey]
    if not opt then return 0 end
    local v = tostring(opt.Value or "")
    if v:match("Never") then return 0 end
    return tonumber(v:match("%d+")) or 0
end

local function aas_raidArenaExists(raidKey)
    local arenas = workspace:FindFirstChild("RaidArenas")
    return arenas and arenas:FindFirstChild(raidKey) ~= nil
end

local function aas_getRaidEnemiesFolder(raidKey)
    local arenas = workspace:FindFirstChild("RaidArenas")
    if not arenas then return nil end
    local arena = arenas:FindFirstChild(raidKey)
    if not arena then return nil end
    return arena:FindFirstChild("Enemies")
end

local function aas_joinOrCreateRaid(raidKey)
    if aas_raidArenaExists(raidKey) then
        pcall(function() aas_raidJoinRemote:Fire("Join", raidKey) end)
    else
        pcall(function() aas_raidJoinRemote:Fire("Create", raidKey) end)
    end
end

local function aas_leaveRaid()
    pcall(function() aas_raidLeaveRemote:Fire() end)
end

local function aas_waitForRaidArena(raidKey, timeoutSecs)
    timeoutSecs = timeoutSecs or 10
    local deadline = tick() + timeoutSecs
    while tick() < deadline do
        if aas_raidArenaExists(raidKey) then return true end
        task.wait(0.5)
    end
    return false
end

local function aas_disableOtherRaids(exceptKey)
    for _, rk in ipairs(aas_sortedRaidKeys) do
        if rk ~= exceptKey and aas_raidEnabled[rk] then
            aas_raidEnabled[rk] = false
            local tk = "AutoRaid_"..rk
            if Toggles[tk] then Toggles[tk]:SetValue(false) end
        end
    end
end

local function aas_disableAllDefenses()
    for _, dk in ipairs(aas_sortedDefenseKeys) do
        if aas_defenseEnabled[dk] then
            aas_defenseEnabled[dk] = false
            local tk = "AutoDefense_"..dk
            if Toggles[tk] then Toggles[tk]:SetValue(false) end
        end
    end
    if aas_defenseThread then task.cancel(aas_defenseThread) aas_defenseThread = nil end
    aas_activeDefenseKey = nil
end

local function aas_disableAllGachas()
    for _, gk in ipairs(aas_sortedGachaKeys) do
        if aas_gachaEnabled[gk] then
            aas_gachaEnabled[gk] = false
            local tk = "AutoGacha_"..gk
            if Toggles[tk] then Toggles[tk]:SetValue(false) end
        end
        if aas_gachaThreads[gk] then
            task.cancel(aas_gachaThreads[gk])
            aas_gachaThreads[gk] = nil
        end
    end
end

-- ══════════════════════════════════════════
--   RAID LOOP
-- ══════════════════════════════════════════
function aas_raidLoop(raidKey)
    local raidData = aas_RaidList[raidKey]
    if not raidData then return end
    aas_equipLoadout(aas_RaidLoadouts[raidKey] or "Power")
    aas_joinOrCreateRaid(raidKey)
    aas_waitForRaidArena(raidKey, 10)
    task.wait(5)
    while aas_raidEnabled[raidKey] do
        local leaveAt = aas_getRaidLeaveAtWave(raidKey)
        if leaveAt > 0 then
            local currentWave = aas_getCurrentRaidWave()
            if currentWave > 0 and currentWave >= leaveAt then
                aas_leaveRaid()
                task.wait(6)
                if not aas_raidEnabled[raidKey] then break end
                aas_joinOrCreateRaid(raidKey)
                aas_waitForRaidArena(raidKey, 10)
                task.wait(5)
                continue
            end
        end
        if not aas_raidArenaExists(raidKey) then
            task.wait(6)
            if not aas_raidEnabled[raidKey] then break end
            aas_joinOrCreateRaid(raidKey)
            aas_waitForRaidArena(raidKey, 10)
            task.wait(5)
            continue
        end
        local mobs = aas_findMobsInFolder(aas_getRaidEnemiesFolder(raidKey), nil)
        if #mobs == 0 then task.wait(0.5) continue end
        for _, mob in ipairs(mobs) do
            if not aas_raidEnabled[raidKey] then break end
            local leaveAtNow = aas_getRaidLeaveAtWave(raidKey)
            if leaveAtNow > 0 then
                local waveNow = aas_getCurrentRaidWave()
                if waveNow > 0 and waveNow >= leaveAtNow then break end
            end
            if not aas_raidArenaExists(raidKey) then break end
            if not mob.Parent or mob:GetAttribute("EnemyDead") == true then continue end
            aas_teleportToMob(mob)
            aas_waitForDead(mob, 30)
            task.wait(0.15)
        end
        task.wait(0.2)
    end
    if aas_raidArenaExists(raidKey) then aas_leaveRaid() end
    aas_activeRaidKey = nil
end

-- ══════════════════════════════════════════
--   DEFENSE HELPERS
-- ══════════════════════════════════════════
local function aas_getCurrentDefenseWave()
    local ok, result = pcall(function()
        return LocalPlayer.PlayerGui.DefenseGui.Main.Wave.Text
    end)
    if not ok or type(result) ~= "string" then return 0 end
    return tonumber(result:match("Wave%s+(%d+)/")) or 0
end

local function aas_getDefenseLeaveAtWave(defKey)
    local opt = Options["DefLeaveWave_"..defKey]
    if not opt then return 0 end
    local v = tostring(opt.Value or "")
    if v:match("Never") then return 0 end
    return tonumber(v:match("%d+")) or 0
end

local function aas_defenseArenaExists(defKey)
    local arenas = workspace:FindFirstChild("DefenseArenas")
    return arenas and arenas:FindFirstChild(defKey) ~= nil
end

local function aas_getDefenseEnemiesFolder(defKey)
    local arenas = workspace:FindFirstChild("DefenseArenas")
    if not arenas then return nil end
    local arena = arenas:FindFirstChild(defKey)
    if not arena then return nil end
    return arena:FindFirstChild("Enemies")
end

local function aas_joinOrCreateDefense(defKey)
    if aas_defenseArenaExists(defKey) then
        pcall(function() aas_defenseJoinRemote:Fire("Join", defKey) end)
    else
        pcall(function() aas_defenseJoinRemote:Fire("Create", defKey) end)
    end
end

local function aas_leaveDefense()
    pcall(function() aas_defenseLeaveRemote:Fire() end)
end

local function aas_waitForDefenseArena(defKey, timeoutSecs)
    timeoutSecs = timeoutSecs or 10
    local deadline = tick() + timeoutSecs
    while tick() < deadline do
        if aas_defenseArenaExists(defKey) then return true end
        task.wait(0.5)
    end
    return false
end

-- ══════════════════════════════════════════
--   DEFENSE LOOP
-- ══════════════════════════════════════════
function aas_defenseLoop(defKey)
    local defData = aas_DefenseList[defKey]
    if not defData then return end
    aas_equipLoadout(aas_DefenseLoadouts[defKey] or "Power")
    aas_joinOrCreateDefense(defKey)
    aas_waitForDefenseArena(defKey, 10)
    task.wait(5)
    while aas_defenseEnabled[defKey] do
        local leaveAt = aas_getDefenseLeaveAtWave(defKey)
        if leaveAt > 0 then
            local currentWave = aas_getCurrentDefenseWave()
            if currentWave > 0 and currentWave >= leaveAt then
                aas_leaveDefense()
                task.wait(6)
                if not aas_defenseEnabled[defKey] then break end
                aas_joinOrCreateDefense(defKey)
                aas_waitForDefenseArena(defKey, 10)
                task.wait(5)
                continue
            end
        end
        if not aas_defenseArenaExists(defKey) then
            task.wait(6)
            if not aas_defenseEnabled[defKey] then break end
            aas_joinOrCreateDefense(defKey)
            aas_waitForDefenseArena(defKey, 10)
            task.wait(5)
            continue
        end
        local mobs = aas_findMobsInFolder(aas_getDefenseEnemiesFolder(defKey), nil)
        if #mobs == 0 then task.wait(0.5) continue end
        for _, mob in ipairs(mobs) do
            if not aas_defenseEnabled[defKey] then break end
            local leaveAtNow = aas_getDefenseLeaveAtWave(defKey)
            if leaveAtNow > 0 then
                local waveNow = aas_getCurrentDefenseWave()
                if waveNow > 0 and waveNow >= leaveAtNow then break end
            end
            if not aas_defenseArenaExists(defKey) then break end
            if not mob.Parent or mob:GetAttribute("EnemyDead") == true then continue end
            aas_teleportToMob(mob)
            aas_waitForDead(mob, 30)
            task.wait(0.15)
        end
        task.wait(0.2)
    end
    if aas_defenseArenaExists(defKey) then aas_leaveDefense() end
    aas_activeDefenseKey = nil
end

-- ══════════════════════════════════════════
--   TRIAL HELPERS
-- ══════════════════════════════════════════
local function aas_trialArenaExists(trialKey)
    local arenas = workspace:FindFirstChild("TimeTrialArenas")
    return arenas and arenas:FindFirstChild(trialKey) ~= nil
end

local function aas_getTrialEnemiesFolder(trialKey)
    local arenas = workspace:FindFirstChild("TimeTrialArenas")
    if not arenas then return nil end
    local arena = arenas:FindFirstChild(trialKey)
    if not arena then return nil end
    return arena:FindFirstChild("Enemies")
end

local function aas_getCurrentTrialRoom(trialKey)
    local ok, result = pcall(function()
        return LocalPlayer.PlayerGui.TrialGui.Main.Room.Text
    end)
    if not ok or type(result) ~= "string" then return 0 end
    return tonumber(result:match("Room%s+(%d+)/")) or 0
end

local function aas_getTrialLeaveAtRoom(trialKey)
    local opt = Options["TrialLeaveRoom_"..trialKey]
    if not opt then return 0 end
    local v = tostring(opt.Value or "")
    if v == "0 (Never Leave)" then return 0 end
    return tonumber(v:match("^(%d+)")) or 0
end

local function aas_joinTrial(trialKey)
    pcall(function() aas_trialJoinRemote:Fire("Join", trialKey) end)
end

local function aas_leaveTrial()
    pcall(function() aas_trialLeaveRemote:Fire() end)
end

-- ══════════════════════════════════════════
--   GATE HELPERS
-- ══════════════════════════════════════════
local function aas_gateArenaExists()
    local arenas = workspace:FindFirstChild("RaidArenas")
    return arenas and arenas:FindFirstChild("World5") ~= nil
end

local function aas_getGateEnemiesFolder()
    local arenas = workspace:FindFirstChild("RaidArenas")
    if not arenas then return nil end
    local arena = arenas:FindFirstChild("World5")
    if not arena then return nil end
    return arena:FindFirstChild("Enemies")
end

local function aas_isActiveGatePresent()
    local ok, result = pcall(function()
        return workspace.Worlds["5"].Systems.RaidStation:FindFirstChild("ActiveGate") ~= nil
    end)
    return ok and result
end

local function aas_isWorld5SystemsLoaded()
    local ok, result = pcall(function()
        local systems = workspace.Worlds["5"].Systems
        return systems ~= nil and #systems:GetChildren() > 0
    end)
    return ok and result
end

local function aas_getActiveGateRank()
    local ok2, rankText = pcall(function()
        return workspace.Worlds["5"].Systems.RaidStation.Gui.Main.Rank.Text
    end)
    if not ok2 or type(rankText) ~= "string" then return nil end
    return rankText:match("GATE RANK:%s*(%S+)")
end

local function aas_getGateLeaveAtWave(rank)
    local opt = Options["GateLeaveWave_"..rank]
    if not opt then return 0 end
    local v = tostring(opt.Value or "")
    if v:match("Never") then return 0 end
    return tonumber(v:match("%d+")) or 0
end

local function aas_isGateRankWanted(rank)
    local opt = Options["GateRankSelect"]
    if not opt then return false end
    for r, state in pairs(opt.Value or {}) do
        if state and r == rank then return true end
    end
    return false
end

local function aas_teleportToRaidStation()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Step 1: Make sure we are in World 5
    pcall(function() aas_requestChangeWorldRemote:Fire(5) end)
    task.wait(3)

    -- Step 2: Find RaidStation and physically move character to it
    local ok, stationPart = pcall(function()
        local station = workspace.Worlds["5"].Systems.RaidStation
        -- Try PrimaryPart first, then any BasePart
        if station.PrimaryPart then return station.PrimaryPart end
        for _, v in ipairs(station:GetDescendants()) do
            if v:IsA("BasePart") then return v end
        end
        return nil
    end)

    if ok and stationPart then
        hrp.CFrame = stationPart.CFrame * CFrame.new(0, 0, 3)
        task.wait(0.5)
        -- Teleport again in case of server correction
        hrp.CFrame = stationPart.CFrame * CFrame.new(0, 0, 3)
    end
end

-- ══════════════════════════════════════════
--   PRIORITY SYSTEM
-- ══════════════════════════════════════════
local function aas_applyPriority_GateVsTrial(trialKey)
    if aas_priorityChoice == "Trial" then
        if aas_gateEnabled and not aas_gateSuppressedByPriority then
            aas_gateSuppressedByPriority = true
            UILibrary:Notify({ Title="Priority: Trial", Description="Gate suppressed — trial is active.", Time=4 })
        end
    elseif aas_priorityChoice == "Gate" then
        if trialKey and aas_trialEnabled[trialKey] and not aas_trialSuppressedByPriority then
            aas_trialSuppressedByPriority = true
            UILibrary:Notify({ Title="Priority: Gate", Description="Trial suppressed — gate is active.", Time=4 })
        end
    end
end

-- ══════════════════════════════════════════
--   GATE LOOP (Fixed: properly teleports to RaidStation)
-- ══════════════════════════════════════════
local aas_gateCooldown = false

function aas_gateLoop()
    while aas_gateEnabled do
        -- Cooldown after a gate session (1 minute)
        if aas_gateCooldown then
            task.wait(1)
            continue
        end

        -- Make sure World 5 systems are accessible
        if not aas_isWorld5SystemsLoaded() then
            task.wait(1)
            continue
        end

        -- Priority suppression check
        if aas_gateSuppressedByPriority then
            local anyTrialInSession = false
            for _, tk in ipairs(aas_sortedTrialKeys) do
                if aas_trialEnabled[tk] and aas_trialArenaExists(tk) then
                    anyTrialInSession = true
                    break
                end
            end
            if anyTrialInSession then
                task.wait(1)
                continue
            else
                aas_gateSuppressedByPriority = false
            end
        end

        -- Check if active gate exists
        if not aas_isActiveGatePresent() then
            task.wait(0.5)
            continue
        end

        -- Get gate rank
        local rank = aas_getActiveGateRank()
        if not rank or not aas_isGateRankWanted(rank) then
            task.wait(1)
            continue
        end

        -- Wait 5s to check if a trial also spawns
        local monitorStart = tick()
        local trialAlsoDetected = nil
        while tick() - monitorStart < 5 do
            for _, tk in ipairs(aas_sortedTrialKeys) do
                if aas_trialEnabled[tk] and aas_trialArenaExists(tk) then
                    trialAlsoDetected = tk
                    break
                end
            end
            if trialAlsoDetected then break end
            task.wait(0.5)
        end

        if trialAlsoDetected then
            aas_applyPriority_GateVsTrial(trialAlsoDetected)
            if aas_gateSuppressedByPriority then
                task.wait(1)
                continue
            end
        end

        -- ══════════════════════════════════════════
        -- GATE SESSION STARTS
        -- ══════════════════════════════════════════

        local snapshot = aas_snapshotAndPauseActivities()

        -- Equip per-rank loadout
        local gateLoadoutOptKey = "LoadoutGateRank_" .. rank
        local gateLoadout = "Power"
        if Options[gateLoadoutOptKey] then
            gateLoadout = Options[gateLoadoutOptKey].Value or "Power"
        end
        aas_equipLoadout(gateLoadout)

        -- Step 1: Fire RequestChangeWorld to World 5
        pcall(function() aas_requestChangeWorldRemote:Fire(5) end)
        task.wait(3)

        -- Step 2: Physically teleport to RaidStation
        -- (exactly like the working standalone script)
        local function teleportToStation()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local ok, raidStation = pcall(function()
                return workspace.Worlds["5"].Systems.RaidStation
            end)
            if ok and raidStation then
                hrp.CFrame = raidStation.CFrame + Vector3.new(0, 5, 0)
                hrp.AssemblyLinearVelocity = Vector3.zero
            end
        end

        teleportToStation()
        task.wait(1)

        -- Step 3: Keep teleporting every second until arena loads (max 20s)
        local arenaDeadline = tick() + 20
        while tick() < arenaDeadline do
            if aas_gateArenaExists() then break end
            teleportToStation()
            task.wait(1)
        end

        -- If arena never loaded, give up and resume
        if not aas_gateArenaExists() then
            UILibrary:Notify({
                Title       = "Auto Gate",
                Description = "Gate arena did not load after teleporting. Skipping.",
                Time        = 4,
            })
            aas_resumeFromSnapshot(snapshot)
            aas_trialSuppressedByPriority = false
            task.wait(2)
            continue
        end

        -- Enable Auto Arise if toggled
        if aas_gateAutoArise and aas_raidAutoAriseRemote then
            pcall(function() aas_raidAutoAriseRemote:Fire(true) end)
        end

        -- ══════════════════════════════════════════
        -- GATE FARMING LOOP
        -- ══════════════════════════════════════════
        local sessionActive = true
        while aas_gateEnabled and sessionActive do
            if not aas_gateArenaExists() then
                sessionActive = false
                break
            end

            local leaveAt = aas_getGateLeaveAtWave(rank)
            if leaveAt > 0 then
                local currentWave = aas_getCurrentRaidWave()
                if currentWave > 0 and currentWave >= leaveAt then
                    aas_leaveRaid()
                    task.wait(5)
                    sessionActive = false
                    break
                end
            end

            local mobs = aas_findMobsInFolder(aas_getGateEnemiesFolder(), nil)
            if #mobs == 0 then
                task.wait(0.5)
                continue
            end

            for _, mob in ipairs(mobs) do
                if not aas_gateEnabled then sessionActive = false break end
                if not aas_gateArenaExists() then sessionActive = false break end

                local leaveAtNow = aas_getGateLeaveAtWave(rank)
                if leaveAtNow > 0 then
                    local waveNow = aas_getCurrentRaidWave()
                    if waveNow > 0 and waveNow >= leaveAtNow then
                        sessionActive = false
                        break
                    end
                end

                if not mob.Parent or mob:GetAttribute("EnemyDead") == true then continue end
                aas_teleportToMob(mob)
                aas_waitForDead(mob, 30)
                task.wait(0.15)
            end

            if sessionActive then
                local leaveAtFinal = aas_getGateLeaveAtWave(rank)
                if leaveAtFinal > 0 then
                    local waveNow = aas_getCurrentRaidWave()
                    if waveNow > 0 and waveNow >= leaveAtFinal then
                        aas_leaveRaid()
                        task.wait(5)
                        sessionActive = false
                    end
                end
            end

            task.wait(0.2)
        end

        -- ══════════════════════════════════════════
        -- GATE SESSION ENDS
        -- ══════════════════════════════════════════

        if aas_gateAutoArise and aas_raidAutoAriseRemote then
            pcall(function() aas_raidAutoAriseRemote:Fire(false) end)
        end

        -- Start 1 minute cooldown so we dont re-enter immediately
        aas_gateCooldown = true
        task.spawn(function()
            task.wait(60)
            aas_gateCooldown = false
        end)

        aas_trialSuppressedByPriority = false
        aas_gateSuppressedByPriority  = false
        aas_resumeFromSnapshot(snapshot)
        
        task.wait(3)
    end

    -- Cleanup on toggle off
    if aas_gateAutoArise and aas_raidAutoAriseRemote then
        pcall(function() aas_raidAutoAriseRemote:Fire(false) end)
    end
    aas_gateCooldown = false
end

-- ══════════════════════════════════════════
--   TRIAL LOOP (Fixed: fast room-check every 0.1s)
-- ══════════════════════════════════════════
function aas_trialLoop(trialKey)
    local trialData = aas_TrialList[trialKey]
    if not trialData then return end

    while aas_trialEnabled[trialKey] do
        if aas_trialSuppressedByPriority then
            if aas_gateEnabled and aas_gateArenaExists() then
                task.wait(1)
                continue
            else
                aas_trialSuppressedByPriority = false
            end
        end

        if not aas_trialArenaExists(trialKey) then
            task.wait(1)
            continue
        end

        -- Check if gate also spawns within 5s
        local monitorStart = tick()
        local gateAlsoDetected = false
        while tick() - monitorStart < 5 do
            if aas_gateEnabled and aas_isActiveGatePresent() then
                gateAlsoDetected = true
                break
            end
            task.wait(0.5)
        end

        if gateAlsoDetected then
            aas_applyPriority_GateVsTrial(trialKey)
            if aas_trialSuppressedByPriority then
                task.wait(1)
                continue
            end
        end

        local sessionSnapshot = aas_snapshotAndPauseActivities()

        -- Equip trial loadout
        aas_equipLoadout(aas_TrialLoadouts[trialKey] or "Power")

        aas_joinTrial(trialKey)
        task.wait(5)

        local sessionActive = true
        local needsLeave = false

        while aas_trialEnabled[trialKey] and sessionActive do
            if not aas_trialArenaExists(trialKey) then
                sessionActive = false
                needsLeave = false
                break
            end

            -- Fast leave-at-room check (every 0.1s via tight loop)
            local leaveAt = aas_getTrialLeaveAtRoom(trialKey)
            if leaveAt > 0 then
                local currentRoom = aas_getCurrentTrialRoom(trialKey)
                if currentRoom > 0 and currentRoom >= leaveAt then
                    needsLeave = true
                    sessionActive = false
                    break
                end
            end

            local enemiesFolder = aas_getTrialEnemiesFolder(trialKey)
            local mobs = aas_findMobsInFolder(enemiesFolder, nil)

            if #mobs == 0 then
                task.wait(0.1)
                continue
            end

            for _, mob in ipairs(mobs) do
                if not aas_trialEnabled[trialKey] then
                    sessionActive = false
                    break
                end
                if not aas_trialArenaExists(trialKey) then
                    sessionActive = false
                    break
                end

                local leaveAtNow = aas_getTrialLeaveAtRoom(trialKey)
                if leaveAtNow > 0 then
                    local roomNow = aas_getCurrentTrialRoom(trialKey)
                    if roomNow > 0 and roomNow >= leaveAtNow then
                        needsLeave = true
                        sessionActive = false
                        break
                    end
                end

                if not mob.Parent or mob:GetAttribute("EnemyDead") == true then continue end
                aas_teleportToMob(mob)
                aas_waitForDead(mob, 30)

                -- Immediate check after mob dies
                local leaveCheck = aas_getTrialLeaveAtRoom(trialKey)
                if leaveCheck > 0 then
                    local roomCheck = aas_getCurrentTrialRoom(trialKey)
                    if roomCheck > 0 and roomCheck >= leaveCheck then
                        needsLeave = true
                        sessionActive = false
                        break
                    end
                end

                task.wait(0.05)
            end

            if sessionActive then
                local leaveAtFinal = aas_getTrialLeaveAtRoom(trialKey)
                if leaveAtFinal > 0 then
                    local roomFinal = aas_getCurrentTrialRoom(trialKey)
                    if roomFinal > 0 and roomFinal >= leaveAtFinal then
                        needsLeave = true
                        sessionActive = false
                    end
                end
            end
        end

        if needsLeave and aas_trialArenaExists(trialKey) then
            aas_leaveTrial()
            task.wait(5)
        end

        aas_resumeFromSnapshot(sessionSnapshot)
        aas_gateSuppressedByPriority = false
        task.wait(1)
    end

    aas_trialSuppressedByPriority = false
end

-- ══════════════════════════════════════════
--   PLAYER DATA SYNC
-- ══════════════════════════════════════════
local function aas_getRarityIndex(rarityOrder, rarity)
    for i, r in ipairs(rarityOrder) do
        if r == rarity then return i end
    end
    return 0
end

local aas_progressionLevelLabelRefs = {}

local function aas_updateSword1Labels()
    if aas_sword1InfoLabelRef then
        if aas_sword1Data then
            local stars = string.rep("⭐", aas_sword1Data.Level or 0)
            if stars == "" then stars = "0" end
            pcall(function()
                aas_sword1InfoLabelRef:SetText("Sword 1: "..tostring(aas_sword1Data.Rarity).." | Stars: "..stars)
            end)
        else
            pcall(function() aas_sword1InfoLabelRef:SetText("Sword 1: Not Found") end)
        end
    end
    if aas_sword1BreathingLabelRef then
        local breathingText = "Breathing: None"
        if aas_sword1CurrentBreathing then
            breathingText = "Breathing: "..tostring(aas_sword1CurrentBreathing.Name or "Unknown")
                .." ("..tostring(aas_sword1CurrentBreathing.Rarity or "?")..")"
        end
        pcall(function() aas_sword1BreathingLabelRef:SetText(breathingText) end)
    end
end

local function aas_updateSword2Labels()
    if aas_sword2InfoLabelRef then
        if aas_sword2Data then
            local stars = string.rep("⭐", aas_sword2Data.Level or 0)
            if stars == "" then stars = "0" end
            pcall(function()
                aas_sword2InfoLabelRef:SetText("Sword 2: "..tostring(aas_sword2Data.Rarity).." | Stars: "..stars)
            end)
        else
            pcall(function() aas_sword2InfoLabelRef:SetText("Sword 2: Not Found") end)
        end
    end
    if aas_sword2BreathingLabelRef then
        local breathingText = "Breathing: None"
        if aas_sword2CurrentBreathing then
            breathingText = "Breathing: "..tostring(aas_sword2CurrentBreathing.Name or "Unknown")
                .." ("..tostring(aas_sword2CurrentBreathing.Rarity or "?")..")"
        end
        pcall(function() aas_sword2BreathingLabelRef:SetText(breathingText) end)
    end
end

local function aas_updateGrimoireLabels()
    if aas_grimoire1LabelRef then
        pcall(function() aas_grimoire1LabelRef:SetText("Slot 1: "..(aas_activeGrimoireSlot1 or "None")) end)
    end
    if aas_grimoire2LabelRef then
        pcall(function() aas_grimoire2LabelRef:SetText("Slot 2: "..(aas_activeGrimoireSlot2 or "None")) end)
    end
end

local function aas_updateProgressionLabels()
    for _, progKey in ipairs(aas_sortedProgressionKeys) do
        local labelRef = aas_progressionLevelLabelRefs[progKey]
        if labelRef then
            local level = aas_progressionLevels[progKey] or 0
            local maxLevel = aas_ProgressionList[progKey] and aas_ProgressionList[progKey].MaxLevel or "?"
            pcall(function()
                labelRef:SetText("Level: "..tostring(level).." / "..tostring(maxLevel))
            end)
        end
    end
end

local function aas_syncAllPlayerData()
    if not aas_getPlayerDataFunc then return end
    local ok, data = pcall(function() return aas_getPlayerDataFunc:InvokeServer() end)
    if not ok or type(data) ~= "table" then return end
    aas_cachedPlayerData = data

    local activeGachas = data.ActiveGachas
    if type(activeGachas) == "table" then
        for gachaKey, rarity in pairs(activeGachas) do
            aas_activeGachaRarities[gachaKey] = tostring(rarity)
            local labelRef = aas_gachaLabelRefs[gachaKey]
            if labelRef then
                pcall(function() labelRef:SetText("Current: "..tostring(rarity)) end)
            end
        end
    end

    local activePassive = data.ActivePassive
    if type(activePassive) == "table" and activePassive.Name and activePassive.Rarity then
        aas_activePassiveData = activePassive
        if aas_passiveLabelRef then
            pcall(function()
                aas_passiveLabelRef:SetText("Active: "..tostring(activePassive.Name).." | "..tostring(activePassive.Rarity))
            end)
        end
    else
        aas_activePassiveData = nil
        if aas_passiveLabelRef then
            pcall(function() aas_passiveLabelRef:SetText("Active: None") end)
        end
    end

    local activeTitans = data.ActiveTitans
    if type(activeTitans) == "table" then
        local bestRarity = nil
        local bestIdx = 0
        for _, titanData in pairs(activeTitans) do
            if type(titanData) == "table" and titanData.Rarity then
                local idx = aas_getRarityIndex(aas_TitanRarityOrder, titanData.Rarity)
                if idx > bestIdx then
                    bestIdx = idx
                    bestRarity = titanData.Rarity
                end
            end
        end
        aas_activeTitanData = bestRarity and { rarity=bestRarity } or nil
        if aas_titanLabelRef then
            local titanText = aas_activeTitanData and ("Active Titan: "..aas_activeTitanData.rarity) or "Active Titan: None"
            pcall(function() aas_titanLabelRef:SetText(titanText) end)
        end
    end

    local sword1Raw = data.EquippedSword
    aas_sword1Data = type(sword1Raw) == "table" and {
        SwordKey=sword1Raw.SwordKey or "World0", Rarity=sword1Raw.Rarity or "Common",
        Level=sword1Raw.Level or 0, Index=sword1Raw.Index or 1,
    } or nil

    local sword2Raw = data.EquippedSword2
    aas_sword2Data = type(sword2Raw) == "table" and {
        SwordKey=sword2Raw.SwordKey or "World0", Rarity=sword2Raw.Rarity or "Common",
        Level=sword2Raw.Level or 0, Index=sword2Raw.Index or 1,
    } or nil

    local swordPassives = data.SwordPassives
    if type(swordPassives) == "table" then
        if aas_sword1Data then
            local key1 = string.format("World0_%s_%d_%d",
                aas_sword1Data.Rarity, aas_sword1Data.Level, aas_sword1Data.Index)
            aas_sword1CurrentBreathing = type(swordPassives[key1]) == "table" and swordPassives[key1] or nil
        end
        if aas_sword2Data then
            local key2 = string.format("World0_%s_%d_%d",
                aas_sword2Data.Rarity, aas_sword2Data.Level, aas_sword2Data.Index)
            aas_sword2CurrentBreathing = type(swordPassives[key2]) == "table" and swordPassives[key2] or nil
        end
    end

    local activeGrimoires = data.ActiveGrimoires
    if type(activeGrimoires) == "table" then
        local world7 = activeGrimoires["World7"]
        if type(world7) == "table" then
            aas_activeGrimoireSlot1 = type(world7.Slot1) == "string" and world7.Slot1 or nil
            aas_activeGrimoireSlot2 = type(world7.Slot2) == "string" and world7.Slot2 or nil
        else
            aas_activeGrimoireSlot1 = nil
            aas_activeGrimoireSlot2 = nil
        end
    end

    local activeProgressions = data.ActiveProgressions
    if type(activeProgressions) == "table" then
        for progKey, level in pairs(activeProgressions) do
            aas_progressionLevels[progKey] = tonumber(level) or 0
        end
    end

    aas_updateSword1Labels()
    aas_updateSword2Labels()
    aas_updateGrimoireLabels()
    aas_updateProgressionLabels()
end

-- ══════════════════════════════════════════
--   UPGRADES2 LIVE DATA SYNC
-- ══════════════════════════════════════════
local function aas_applyUpgrades2Payload(systemKey, payload)
    if type(payload) ~= "table" then return end
    if systemKey ~= aas_upgrades2SystemKey then return end
    local upgrades = payload.Upgrades
    if type(upgrades) ~= "table" then return end
    for _, entry in ipairs(upgrades) do
        if type(entry) == "table" and type(entry.Multiplier) == "string" then
            aas_upgrades2Data[entry.Multiplier] = entry
        end
    end
end

-- Connect live update remote (fires when any upgrade changes server-side)
if aas_upgrades2UpdatedRemote then
    aas_upgrades2UpdatedRemote:Connect(function(payload)
        if type(payload) == "table" and type(payload.SystemKey) == "string" then
            aas_applyUpgrades2Payload(payload.SystemKey, payload)
        end
    end)
end

-- Connect data response remote
if aas_upgrades2DataRemote then
    aas_upgrades2DataRemote:Connect(function(payload)
        if type(payload) ~= "table" then return end
        local systems = payload.Systems
        if type(systems) == "table" then
            for sysKey, sysData in pairs(systems) do
                if type(sysKey) == "string" then
                    aas_applyUpgrades2Payload(sysKey, sysData)
                end
            end
        end
    end)
end

-- Request fresh data every 10 seconds
task.spawn(function()
    while true do
        task.wait(10)
        pcall(function()
            if aas_upgrades2DataRemote then
                aas_upgrades2DataRemote:Fire()
            end
        end)
    end
end)

-- Initial data fetch
task.spawn(function()
    task.wait(3)
    pcall(function()
        if aas_upgrades2DataRemote then
            aas_upgrades2DataRemote:Fire()
        end
    end)
end)

task.spawn(function()
    while true do
        task.wait(15)
        pcall(aas_syncAllPlayerData)
    end
end)

-- ══════════════════════════════════════════
--   GACHA LOOP
-- ══════════════════════════════════════════
local function aas_gachaLoop(gachaKey)
    while aas_gachaEnabled[gachaKey] do
        if aas_activeGachaRarities[gachaKey] == AAS_DIVINE then
            aas_gachaEnabled[gachaKey] = false
            local tk = "AutoGacha_"..gachaKey
            if Toggles[tk] then Toggles[tk]:SetValue(false) end
            UILibrary:Notify({
                Title=(aas_GachaList[gachaKey] and aas_GachaList[gachaKey].Name or gachaKey),
                Description="Reached Divine! Auto Gacha stopped.", Time=5
            })
            break
        end
        pcall(function() aas_gachaRollRemote:Fire(gachaKey) end)
        task.wait(0.65)
        pcall(aas_syncAllPlayerData)
        if aas_activeGachaRarities[gachaKey] == AAS_DIVINE then
            aas_gachaEnabled[gachaKey] = false
            local tk = "AutoGacha_"..gachaKey
            if Toggles[tk] then Toggles[tk]:SetValue(false) end
            UILibrary:Notify({
                Title=(aas_GachaList[gachaKey] and aas_GachaList[gachaKey].Name or gachaKey),
                Description="Reached Divine! Auto Gacha stopped.", Time=5
            })
            break
        end
    end
end

-- ══════════════════════════════════════════
--   SWORD LOOPS (Hardcoded)
-- ══════════════════════════════════════════

-- Regular sword (World0)
local aas_swordWorld0Enabled = false
local aas_swordWorld0Thread  = nil

local function aas_swordWorld0Loop()
    while aas_swordWorld0Enabled do
        pcall(function() aas_swordRollRemote:Fire("World0") end)
        task.wait(0.65)
    end
end

-- Summer sword (World8)
local aas_swordWorld8Enabled = false
local aas_swordWorld8Thread  = nil

local function aas_swordWorld8Loop()
    while aas_swordWorld8Enabled do
        pcall(function() aas_swordRollRemote:Fire("World8") end)
        task.wait(0.65)
    end
end

-- ══════════════════════════════════════════
--   AUTO FUSE ALL LOOP
-- ══════════════════════════════════════════
local function aas_fuseAllLoop()
    while aas_autoFuseAllEnabled do
        if aas_bridgeDataRemote then
            pcall(function()
                aas_bridgeDataRemote:FireServer({ [2] = "Q" })
            end)
        end
        task.wait(5)
    end
end

-- ══════════════════════════════════════════
--   PASSIVE LOOP
-- ══════════════════════════════════════════
local function aas_passiveLoop()
    while aas_passiveAutoEnabled do
        pcall(function() aas_passiveRollRemote:Fire() end)
        task.wait(0.65)
    end
end

-- ══════════════════════════════════════════
--   TITAN LOOP
-- ══════════════════════════════════════════
local function aas_titanLoop()
    while aas_titanAutoEnabled do
        pcall(function() aas_titanRollRemote:Fire("World4") end)
        task.wait(0.65)
        pcall(aas_syncAllPlayerData)
    end
end

-- ══════════════════════════════════════════
--   SWORD PASSIVE HELPERS
-- ══════════════════════════════════════════
local function aas_getSword1StopRarities()
    local opt = Options["SwordPassive1StopRarities"]
    if not opt then return {} end
    local selected = {}
    for rarity, state in pairs(opt.Value or {}) do
        if state then table.insert(selected, rarity) end
    end
    return selected
end

local function aas_getSword2StopRarities()
    local opt = Options["SwordPassive2StopRarities"]
    if not opt then return {} end
    local selected = {}
    for rarity, state in pairs(opt.Value or {}) do
        if state then table.insert(selected, rarity) end
    end
    return selected
end

local function aas_swordPassiveRarityReached(currentPassive, stopRarities)
    if not currentPassive or #stopRarities == 0 then return false end
    local currentRarity = currentPassive.Rarity or ""
    for _, r in ipairs(stopRarities) do
        if r == currentRarity then return true end
    end
    return false
end

-- ══════════════════════════════════════════
--   SWORD PASSIVE 1 LOOP
-- ══════════════════════════════════════════
local function aas_swordPassive1Loop()
    while aas_swordPassive1Enabled do
        pcall(aas_syncAllPlayerData)
        local stopRarities = aas_getSword1StopRarities()
        if aas_swordPassiveRarityReached(aas_sword1CurrentBreathing, stopRarities) then
            aas_swordPassive1Enabled = false
            if Toggles["AutoSwordPassive1Enabled"] then Toggles["AutoSwordPassive1Enabled"]:SetValue(false) end
            UILibrary:Notify({ Title="Sword Passive 1 Stopped",
                Description="Reached: "..(aas_sword1CurrentBreathing and aas_sword1CurrentBreathing.Name or "Unknown"), Time=5 })
            break
        end
        if not aas_sword1Data then task.wait(1) continue end
        local args = {
            SwordKey=aas_sword1Data.SwordKey or "World0",
            Rarity=aas_sword1Data.Rarity,
            Level=aas_sword1Data.Level or 0,
            Index=aas_sword1Data.Index or 1,
            SystemKey="World6",
        }
        pcall(function() aas_swordPassiveRollRemote:Fire(args) end)
        task.wait(1.1)
        pcall(aas_syncAllPlayerData)
        if aas_swordPassiveRarityReached(aas_sword1CurrentBreathing, stopRarities) then
            aas_swordPassive1Enabled = false
            if Toggles["AutoSwordPassive1Enabled"] then Toggles["AutoSwordPassive1Enabled"]:SetValue(false) end
            UILibrary:Notify({ Title="Sword Passive 1 Stopped",
                Description="Reached: "..(aas_sword1CurrentBreathing and aas_sword1CurrentBreathing.Name or "Unknown"), Time=5 })
            break
        end
    end
end

-- ══════════════════════════════════════════
--   SWORD PASSIVE 2 LOOP
-- ══════════════════════════════════════════
local function aas_swordPassive2Loop()
    while aas_swordPassive2Enabled do
        pcall(aas_syncAllPlayerData)
        local stopRarities = aas_getSword2StopRarities()
        if aas_swordPassiveRarityReached(aas_sword2CurrentBreathing, stopRarities) then
            aas_swordPassive2Enabled = false
            if Toggles["AutoSwordPassive2Enabled"] then Toggles["AutoSwordPassive2Enabled"]:SetValue(false) end
            UILibrary:Notify({ Title="Sword Passive 2 Stopped",
                Description="Reached: "..(aas_sword2CurrentBreathing and aas_sword2CurrentBreathing.Name or "Unknown"), Time=5 })
            break
        end
        if not aas_sword2Data then task.wait(1) continue end
        local args = {
            SwordKey=aas_sword2Data.SwordKey or "World0",
            Rarity=aas_sword2Data.Rarity,
            Level=aas_sword2Data.Level or 0,
            Index=aas_sword2Data.Index or 1,
            SystemKey="World6",
        }
        pcall(function() aas_swordPassiveRollRemote:Fire(args) end)
        task.wait(1.1)
        pcall(aas_syncAllPlayerData)
        if aas_swordPassiveRarityReached(aas_sword2CurrentBreathing, stopRarities) then
            aas_swordPassive2Enabled = false
            if Toggles["AutoSwordPassive2Enabled"] then Toggles["AutoSwordPassive2Enabled"]:SetValue(false) end
            UILibrary:Notify({ Title="Sword Passive 2 Stopped",
                Description="Reached: "..(aas_sword2CurrentBreathing and aas_sword2CurrentBreathing.Name or "Unknown"), Time=5 })
            break
        end
    end
end

-- ══════════════════════════════════════════
--   GRIMOIRE LOOPS
-- ══════════════════════════════════════════
local function aas_grimoire1Loop()
    while aas_grimoire1Enabled do
        pcall(aas_syncAllPlayerData)
        if aas_activeGrimoireSlot1 == AAS_DIVINE then
            aas_grimoire1Enabled = false
            if Toggles["AutoGrimoire1Enabled"] then Toggles["AutoGrimoire1Enabled"]:SetValue(false) end
            UILibrary:Notify({ Title="Auto Grimoire Slot 1 Stopped", Description="Reached Divine!", Time=5 })
            break
        end
        pcall(function() aas_grimoireRollRemote:Fire("World7", "Slot1") end)
        task.wait(1.1)
        pcall(aas_syncAllPlayerData)
        if aas_activeGrimoireSlot1 == AAS_DIVINE then
            aas_grimoire1Enabled = false
            if Toggles["AutoGrimoire1Enabled"] then Toggles["AutoGrimoire1Enabled"]:SetValue(false) end
            UILibrary:Notify({ Title="Auto Grimoire Slot 1 Stopped", Description="Reached Divine!", Time=5 })
            break
        end
    end
end

local function aas_grimoire2Loop()
    while aas_grimoire2Enabled do
        pcall(aas_syncAllPlayerData)
        if aas_activeGrimoireSlot2 == AAS_DIVINE then
            aas_grimoire2Enabled = false
            if Toggles["AutoGrimoire2Enabled"] then Toggles["AutoGrimoire2Enabled"]:SetValue(false) end
            UILibrary:Notify({ Title="Auto Grimoire Slot 2 Stopped", Description="Reached Divine!", Time=5 })
            break
        end
        pcall(function() aas_grimoireRollRemote:Fire("World7", "Slot2") end)
        task.wait(1.1)
        pcall(aas_syncAllPlayerData)
        if aas_activeGrimoireSlot2 == AAS_DIVINE then
            aas_grimoire2Enabled = false
            if Toggles["AutoGrimoire2Enabled"] then Toggles["AutoGrimoire2Enabled"]:SetValue(false) end
            UILibrary:Notify({ Title="Auto Grimoire Slot 2 Stopped", Description="Reached Divine!", Time=5 })
            break
        end
    end
end

-- ══════════════════════════════════════════
--   PROGRESSION LOOP
-- ══════════════════════════════════════════
local function aas_progressionLoop(progKey)
    local progData = aas_ProgressionList[progKey]
    if not progData then return end
    while aas_progressionEnabled[progKey] do
        local currentLevel = aas_progressionLevels[progKey] or 0
        if currentLevel >= (progData.MaxLevel or 45) then
            aas_progressionEnabled[progKey] = false
            local tk = "AutoProgression_"..progKey
            if Toggles[tk] then Toggles[tk]:SetValue(false) end
            UILibrary:Notify({
                Title=progData.Name.." Stopped",
                Description="Reached max level "..tostring(progData.MaxLevel).."!", Time=5
            })
            break
        end
        pcall(function() aas_progressionUpgradeRemote:Fire(progKey) end)
        task.wait(1.1)
        pcall(aas_syncAllPlayerData)
    end
end

-- ══════════════════════════════════════════
--   UPGRADES2 (PROFESSIONS) LOOP
-- ══════════════════════════════════════════
local function aas_upgrades2Loop(multiplierKey)
    while aas_upgrades2Enabled[multiplierKey] do
        -- Check live data: is this upgrade at max or not upgradeable?
        local entry = aas_upgrades2Data[multiplierKey]

        -- If we have live data and CanUpgrade is explicitly false, wait and retry
        -- (CanUpgrade being nil means we haven't received data yet — still try)
        if entry and entry.CanUpgrade == false then
            -- Could be max level or requirement not met
            local sysConfig = aas_Upgrades2Config:GetSystem(aas_upgrades2SystemKey)
            local upgradeConfig = sysConfig and sysConfig.Upgrades[multiplierKey]
            local currentLevel = entry.Level or 0
            local maxLevel = upgradeConfig and upgradeConfig.MaxLevel or math.huge

            if currentLevel >= maxLevel then
                -- Reached max level, stop
                aas_upgrades2Enabled[multiplierKey] = false
                local tk = "AutoUpgrades2_" .. multiplierKey
                if Toggles[tk] then Toggles[tk]:SetValue(false) end
                UILibrary:Notify({
                    Title       = "Professions: " .. multiplierKey,
                    Description = "Reached max level " .. tostring(currentLevel) .. "! Stopped.",
                    Time        = 5,
                })
                break
            end

            -- Requirement not met yet, wait and retry
            task.wait(2)
            continue
        end

        -- Fire the upgrade request: systemKey, multiplierKey
        pcall(function()
            aas_upgrades2RequestRemote:Fire(aas_upgrades2SystemKey, multiplierKey)
        end)

        -- Wait for result — the Updated remote will update aas_upgrades2Data automatically
        -- Use a moderate delay to avoid rate limiting (controller uses 5s timeout)
        task.wait(1.5)
    end
end

-- ══════════════════════════════════════════
--   RANGE UPGRADE LOOP
-- ══════════════════════════════════════════
local function aas_rangeUpgradeLoop(sysKey)
    while aas_rangeUpgradeEnabled[sysKey] do
        pcall(function() aas_rangeUpgradeRemote:Fire(sysKey) end)
        task.wait(1.0)
    end
end

-- ══════════════════════════════════════════
--   STAR / EGG LOOP
-- ══════════════════════════════════════════
local function aas_starLoop()
    while aas_starEnabled do
        local eggKey = aas_starEggKey
        if not eggKey then task.wait(0.5) continue end
        pcall(function() aas_openEggRemote:Fire(eggKey) end)
        task.wait(0.65)
    end
end

-- ══════════════════════════════════════════
--   CRAFT LOOP
-- ══════════════════════════════════════════
local function aas_craftLoop(craftKey)
    local craftData = aas_CraftList[craftKey]
    if not craftData then return end
    while aas_craftEnabled[craftKey] do
        local isShiny = aas_craftShiny[craftKey] == true
        pcall(function() aas_craftPetRemote:Fire(craftKey, isShiny) end)
        task.wait(1.1)
    end
end

-- ══════════════════════════════════════════
--   CLEANUP FUNCTION
-- ══════════════════════════════════════════
local function aas_cleanup()
    aas_farmEnabled = false
    if aas_farmThread then task.cancel(aas_farmThread) aas_farmThread = nil end

    for rk in pairs(aas_raidEnabled) do aas_raidEnabled[rk] = false end
    if aas_raidThread then task.cancel(aas_raidThread) aas_raidThread = nil end
    if aas_activeRaidKey and aas_raidArenaExists(aas_activeRaidKey) then aas_leaveRaid() end
    aas_activeRaidKey = nil

    for dk in pairs(aas_defenseEnabled) do aas_defenseEnabled[dk] = false end
    if aas_defenseThread then task.cancel(aas_defenseThread) aas_defenseThread = nil end
    if aas_activeDefenseKey and aas_defenseArenaExists(aas_activeDefenseKey) then aas_leaveDefense() end
    aas_activeDefenseKey = nil

    for tk in pairs(aas_trialEnabled) do aas_trialEnabled[tk] = false end
    for tk, t in pairs(aas_trialThreads) do task.cancel(t) aas_trialThreads[tk] = nil end

    aas_gateEnabled = false
    if aas_gateThread then task.cancel(aas_gateThread) aas_gateThread = nil end
    if aas_gateAutoArise and aas_raidAutoAriseRemote then
        pcall(function() aas_raidAutoAriseRemote:Fire(false) end)
    end

    aas_disableAllGachas()

    for sk, t in pairs(aas_swordThreads) do
        task.cancel(t)
        aas_swordThreads[sk] = nil
    end

    aas_autoFuseAllEnabled = false
    if aas_fuseAllThread then task.cancel(aas_fuseAllThread) aas_fuseAllThread = nil end

    aas_autoCrowEnabled = false
    if aas_crowThread then task.cancel(aas_crowThread) aas_crowThread = nil end

    aas_passiveAutoEnabled = false
    if aas_passiveThread then task.cancel(aas_passiveThread) aas_passiveThread = nil end

    aas_titanAutoEnabled = false
    if aas_titanThread then task.cancel(aas_titanThread) aas_titanThread = nil end

    aas_swordPassive1Enabled = false
    if aas_swordPassive1Thread then task.cancel(aas_swordPassive1Thread) aas_swordPassive1Thread = nil end
    aas_swordPassive2Enabled = false
    if aas_swordPassive2Thread then task.cancel(aas_swordPassive2Thread) aas_swordPassive2Thread = nil end

    aas_grimoire1Enabled = false
    if aas_grimoire1Thread then task.cancel(aas_grimoire1Thread) aas_grimoire1Thread = nil end
    aas_grimoire2Enabled = false
    if aas_grimoire2Thread then task.cancel(aas_grimoire2Thread) aas_grimoire2Thread = nil end

    for k in pairs(aas_progressionEnabled) do aas_progressionEnabled[k] = false end
    for k, t in pairs(aas_progressionThreads) do task.cancel(t) aas_progressionThreads[k] = nil end

    for k in pairs(aas_rangeUpgradeEnabled) do aas_rangeUpgradeEnabled[k] = false end
    for k, t in pairs(aas_rangeUpgradeThreads) do task.cancel(t) aas_rangeUpgradeThreads[k] = nil end

    for k in pairs(aas_craftEnabled) do aas_craftEnabled[k] = false end
    for k, t in pairs(aas_craftThreads) do task.cancel(t) aas_craftThreads[k] = nil end

    aas_starEnabled = false
    if aas_starThread then task.cancel(aas_starThread) aas_starThread = nil end

    aas_autoClickRunning = false
    -- inside aas_cleanup(), add this line:
    aas_gateCooldown = false
    aas_toggleAutoClaimAchievements(false)
    aas_toggleAutoAvatar(false)
    aas_toggleAutoRank(false)
    aas_toggleAutoStat(aas_currentStatSelection, false)
    aas_toggleAutoClaimRewards(false)
        -- Hardcoded sword cleanup
    aas_swordWorld0Enabled = false
    if aas_swordWorld0Thread then task.cancel(aas_swordWorld0Thread) aas_swordWorld0Thread = nil end
    aas_swordWorld8Enabled = false
    if aas_swordWorld8Thread then task.cancel(aas_swordWorld8Thread) aas_swordWorld8Thread = nil end
    aas_crowClaiming = false

        -- Ball cleanup (add after crow cleanup lines)
    aas_autoBallEnabled = false
    if aas_ballThread then task.cancel(aas_ballThread) aas_ballThread = nil end
    aas_ballClaiming = false

        -- Upgrades2 (Professions) cleanup
    for k in pairs(aas_upgrades2Enabled) do aas_upgrades2Enabled[k] = false end
    for k, t in pairs(aas_upgrades2Threads) do
        task.cancel(t)
        aas_upgrades2Threads[k] = nil
    end

    print("Anime Astral Simulator script unloaded!")
end
