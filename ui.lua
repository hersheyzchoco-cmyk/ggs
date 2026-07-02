return function(C)
local UILibrary=C.UILibrary
local ThemeManager=C.ThemeManager
local SaveManager=C.SaveManager
local Options=C.Options
local Toggles=C.Toggles
local AAS_DIVINE=C.AAS_DIVINE
local aas_WorldList=C.aas_WorldList
local aas_sortedWorldIndices=C.aas_sortedWorldIndices
local aas_RaidList=C.aas_RaidList
local aas_sortedRaidKeys=C.aas_sortedRaidKeys
local aas_GateData=C.aas_GateData
local aas_GateRanks=C.aas_GateRanks
local aas_DefenseList=C.aas_DefenseList
local aas_sortedDefenseKeys=C.aas_sortedDefenseKeys
local aas_GachaList=C.aas_GachaList
local aas_sortedGachaKeys=C.aas_sortedGachaKeys
local aas_ProgressionList=C.aas_ProgressionList
local aas_sortedProgressionKeys=C.aas_sortedProgressionKeys
local aas_UpgradeSystemList=C.aas_UpgradeSystemList
local aas_sortedUpgradeSystemKeys=C.aas_sortedUpgradeSystemKeys
local aas_StarWorldList=C.aas_StarWorldList
local aas_sortedStarWorldKeys=C.aas_sortedStarWorldKeys
local aas_CraftList=C.aas_CraftList
local aas_sortedCraftKeys=C.aas_sortedCraftKeys
local aas_TrialList=C.aas_TrialList
local aas_sortedTrialKeys=C.aas_sortedTrialKeys
local aas_SwordPassiveRarityOrder=C.aas_SwordPassiveRarityOrder
local aas_UpgradeStatKeys=C.aas_UpgradeStatKeys
local aas_Upgrades2Config=C.aas_Upgrades2Config
local aas_upgrades2SystemKey=C.aas_upgrades2SystemKey
local aas_getWorldLabel=C.aas_getWorldLabel
local aas_equipLoadout=C.aas_equipLoadout
local aas_syncAllPlayerData=C.aas_syncAllPlayerData
local aas_redeemAllCodes=C.aas_redeemAllCodes
local aas_toggleAutoClaimAchievements=C.aas_toggleAutoClaimAchievements
local aas_toggleAutoAvatar=C.aas_toggleAutoAvatar
local aas_toggleAutoRank=C.aas_toggleAutoRank
local aas_toggleAutoStat=C.aas_toggleAutoStat
local aas_toggleAutoClaimRewards=C.aas_toggleAutoClaimRewards
local aas_autoClick=C.aas_autoClick
local aas_farmLoop=C.aas_farmLoop
local aas_raidLoop=C.aas_raidLoop
local aas_defenseLoop=C.aas_defenseLoop
local aas_trialLoop=C.aas_trialLoop
local aas_gateLoop=C.aas_gateLoop
local aas_gachaLoop=C.aas_gachaLoop
local aas_passiveLoop=C.aas_passiveLoop
local aas_titanLoop=C.aas_titanLoop
local aas_swordPassive1Loop=C.aas_swordPassive1Loop
local aas_swordPassive2Loop=C.aas_swordPassive2Loop
local aas_grimoire1Loop=C.aas_grimoire1Loop
local aas_grimoire2Loop=C.aas_grimoire2Loop
local aas_progressionLoop=C.aas_progressionLoop
local aas_rangeUpgradeLoop=C.aas_rangeUpgradeLoop
local aas_upgrades2Loop=C.aas_upgrades2Loop
local aas_starLoop=C.aas_starLoop
local aas_craftLoop=C.aas_craftLoop
local aas_fuseAllLoop=C.aas_fuseAllLoop
local aas_crowMonitorLoop=C.aas_crowMonitorLoop
local aas_ballMonitorLoop=C.aas_ballMonitorLoop
local aas_cleanup=C.aas_cleanup
local aas_raidArenaExists=C.aas_raidArenaExists
local aas_defenseArenaExists=C.aas_defenseArenaExists
local aas_trialArenaExists=C.aas_trialArenaExists
local aas_gateArenaExists=C.aas_gateArenaExists
local aas_disableOtherRaids=C.aas_disableOtherRaids
local aas_disableAllDefenses=C.aas_disableAllDefenses
local aas_disableAllGachas=C.aas_disableAllGachas
local aas_anyRaidActive=C.aas_anyRaidActive
local aas_anyDefenseActive=C.aas_anyDefenseActive
local aas_teleportToWorld=C.aas_teleportToWorld
local aas_swordWorld0Loop=C.aas_swordWorld0Loop
local aas_swordWorld8Loop=C.aas_swordWorld8Loop
local aas_LoadoutAssignments=C.aas_LoadoutAssignments
local aas_RaidLoadouts=C.aas_RaidLoadouts
local aas_DefenseLoadouts=C.aas_DefenseLoadouts
local aas_TrialLoadouts=C.aas_TrialLoadouts
local aas_worldDropdowns=C.aas_worldDropdowns
local aas_autoClickRunning=C.aas_autoClickRunning
local aas_autoStatEnabled=C.aas_autoStatEnabled
local aas_currentStatSelection=C.aas_currentStatSelection
local aas_farmEnabled=C.aas_farmEnabled
local aas_farmThread=C.aas_farmThread
local aas_activeRaidKey=C.aas_activeRaidKey
local aas_raidThread=C.aas_raidThread
local aas_raidEnabled=C.aas_raidEnabled
local aas_activeDefenseKey=C.aas_activeDefenseKey
local aas_defenseThread=C.aas_defenseThread
local aas_defenseEnabled=C.aas_defenseEnabled
local aas_trialEnabled=C.aas_trialEnabled
local aas_trialThreads=C.aas_trialThreads
local aas_gateEnabled=C.aas_gateEnabled
local aas_gateThread=C.aas_gateThread
local aas_gateAutoArise=C.aas_gateAutoArise
local aas_gateSuppressedByPriority=C.aas_gateSuppressedByPriority
local aas_priorityChoice=C.aas_priorityChoice
local aas_gachaEnabled=C.aas_gachaEnabled
local aas_gachaThreads=C.aas_gachaThreads
local aas_activeGachaRarities=C.aas_activeGachaRarities
local aas_gachaLabelRefs=C.aas_gachaLabelRefs
local aas_passiveAutoEnabled=C.aas_passiveAutoEnabled
local aas_passiveThread=C.aas_passiveThread
local aas_passiveLabelRef=C.aas_passiveLabelRef
local aas_activePassiveData=C.aas_activePassiveData
local aas_titanAutoEnabled=C.aas_titanAutoEnabled
local aas_titanThread=C.aas_titanThread
local aas_titanLabelRef=C.aas_titanLabelRef
local aas_swordPassive1Enabled=C.aas_swordPassive1Enabled
local aas_swordPassive1Thread=C.aas_swordPassive1Thread
local aas_sword1InfoLabelRef=C.aas_sword1InfoLabelRef
local aas_sword1BreathingLabelRef=C.aas_sword1BreathingLabelRef
local aas_swordPassive2Enabled=C.aas_swordPassive2Enabled
local aas_swordPassive2Thread=C.aas_swordPassive2Thread
local aas_sword2InfoLabelRef=C.aas_sword2InfoLabelRef
local aas_sword2BreathingLabelRef=C.aas_sword2BreathingLabelRef
local aas_grimoire1Enabled=C.aas_grimoire1Enabled
local aas_grimoire1Thread=C.aas_grimoire1Thread
local aas_grimoire1LabelRef=C.aas_grimoire1LabelRef
local aas_grimoire2Enabled=C.aas_grimoire2Enabled
local aas_grimoire2Thread=C.aas_grimoire2Thread
local aas_grimoire2LabelRef=C.aas_grimoire2LabelRef
local aas_progressionEnabled=C.aas_progressionEnabled
local aas_progressionThreads=C.aas_progressionThreads
local aas_progressionLevelLabelRefs=C.aas_progressionLevelLabelRefs
local aas_rangeUpgradeEnabled=C.aas_rangeUpgradeEnabled
local aas_rangeUpgradeThreads=C.aas_rangeUpgradeThreads
local aas_upgrades2Enabled=C.aas_upgrades2Enabled
local aas_upgrades2Threads=C.aas_upgrades2Threads
local aas_starEnabled=C.aas_starEnabled
local aas_starThread=C.aas_starThread
local aas_starEggKey=C.aas_starEggKey
local aas_craftEnabled=C.aas_craftEnabled
local aas_craftThreads=C.aas_craftThreads
local aas_craftShiny=C.aas_craftShiny
local aas_autoCrowEnabled=C.aas_autoCrowEnabled
local aas_crowThread=C.aas_crowThread
local aas_crowClaiming=C.aas_crowClaiming
local aas_autoBallEnabled=C.aas_autoBallEnabled
local aas_ballThread=C.aas_ballThread
local aas_ballClaiming=C.aas_ballClaiming
local aas_autoFuseAllEnabled=C.aas_autoFuseAllEnabled
local aas_fuseAllThread=C.aas_fuseAllThread
local aas_swordWorld0Enabled=C.aas_swordWorld0Enabled
local aas_swordWorld0Thread=C.aas_swordWorld0Thread
local aas_swordWorld8Enabled=C.aas_swordWorld8Enabled
local aas_swordWorld8Thread=C.aas_swordWorld8Thread
local aas_swordThreads=C.aas_swordThreads

  
-- ══════════════════════════════════════════
--   WINDOW SETUP
-- ══════════════════════════════════════════
local aas_Window = UILibrary:CreateWindow({
    Title             = "IBDihP Hub",
    Footer            = "By Hersheys - Version 2.1",
    MobileButtonsSide = "Right",
    Icon              = "rbxassetid://114748833858413",
    NotifySide        = "Right",
    ShowCustomCursor  = true,
})

-- ══════════════════════════════════════════
--   TABS
-- ══════════════════════════════════════════
local aas_Tabs = {
    Main        = aas_Window:AddTab("Main",                "star"),
    Farm        = aas_Window:AddTab("Auto Farm Mob",       "sword"),
    RaidDef     = aas_Window:AddTab("Auto Raid / Defense", "shield"),
    Trial       = aas_Window:AddTab("Auto Trial / Gate",   "clock"),
    Loadouts    = aas_Window:AddTab("Loadouts",            "layout"),
    Gacha       = aas_Window:AddTab("Auto Gacha",          "sparkles"),
    Progression = aas_Window:AddTab("Auto Progression",    "trending-up"),
    Star        = aas_Window:AddTab("Auto Star",           "star"),
    Settings    = aas_Window:AddTab("Settings",            "settings"),
}

-- ══════════════════════════════════════════
--   MAIN TAB
-- ══════════════════════════════════════════
local aas_BannerGroup = aas_Tabs.Main:AddLeftGroupbox("🌐 JOIN DISCORD FOR ACTIVE COMMUNITY", "users")
aas_BannerGroup:AddLabel("Suggestions • Bug Fixes • Updates • Community Support", true)
aas_BannerGroup:AddButton({
    Text    = "📋 COPY DISCORD INVITE LINK",
    Func    = function()
        setclipboard("https://discord.gg/dhecnztyph")
        UILibrary:Notify({ Title="Discord Invite Copied!", Description="Paste the link in your browser to join our community", Time=4 })
    end,
    Tooltip = "Copy Discord invite to clipboard",
})
aas_BannerGroup:AddDivider()

local aas_MainGroup = aas_Tabs.Main:AddLeftGroupbox("Main Automation", "zap")

aas_MainGroup:AddToggle("AutoClick", {
    Text    = "Auto Click",
    Tooltip = "Automatically clicks every 0.05 seconds (20 clicks/sec)",
    Default = false,
    Callback = function(value)
        aas_autoClickRunning = value
        if value then
            aas_autoClick()
            UILibrary:Notify({ Title="Auto Click", Description="Started!", Time=3 })
        else
            UILibrary:Notify({ Title="Auto Click", Description="Stopped.", Time=3 })
        end
    end,
})

aas_MainGroup:AddToggle("AutoClaimAchievements", {
    Text    = "Auto Claim Achievements",
    Tooltip = "Automatically claims achievements when completed",
    Default = false,
    Callback = function(value)
        aas_autoClaimAchievementsEnabled = value
        if aas_toggleAutoClaimAchievements(value) then
            UILibrary:Notify({ Title="Auto Claim Achievements", Description=value and "Enabled!" or "Disabled", Time=3 })
        else
            UILibrary:Notify({ Title="Auto Claim Achievements", Description="Failed to toggle", Time=4 })
            Toggles.AutoClaimAchievements:SetValue(not value)
        end
    end,
})

aas_MainGroup:AddToggle("AutoAvatar", {
    Text    = "Auto Equip Best Avatar",
    Tooltip = "Automatically equips the best avatar for buffs",
    Default = false,
    Callback = function(value)
        aas_autoAvatarEnabled = value
        if aas_toggleAutoAvatar(value) then
            UILibrary:Notify({ Title="Auto Equip Avatar", Description=value and "Enabled!" or "Disabled", Time=3 })
        else
            UILibrary:Notify({ Title="Auto Equip Avatar", Description="Failed to toggle", Time=4 })
            Toggles.AutoAvatar:SetValue(not value)
        end
    end,
})

aas_MainGroup:AddToggle("AutoRank", {
    Text    = "Auto Rank Up",
    Tooltip = "Automatically ranks up when you have enough power",
    Default = false,
    Callback = function(value)
        aas_autoRankEnabled = value
        if aas_toggleAutoRank(value) then
            UILibrary:Notify({ Title="Auto Rank Up", Description=value and "Enabled!" or "Disabled", Time=3 })
        else
            UILibrary:Notify({ Title="Auto Rank Up", Description="Failed to toggle", Time=4 })
            Toggles.AutoRank:SetValue(not value)
        end
    end,
})

aas_MainGroup:AddToggle("AutoClaimRewards", {
    Text    = "Auto Claim Time Rewards",
    Tooltip = "Automatically claims time-based rewards when ready",
    Default = false,
    Callback = function(value)
        aas_autoClaimRewardsEnabled = value
        if aas_toggleAutoClaimRewards(value) then
            UILibrary:Notify({ Title="Auto Claim Rewards", Description=value and "Enabled!" or "Disabled", Time=3 })
        else
            UILibrary:Notify({ Title="Auto Claim Rewards", Description="Failed to toggle", Time=4 })
            Toggles.AutoClaimRewards:SetValue(not value)
        end
    end,
})

-- ── Auto Crow (World 6) ────────────────────────────────────────────
local aas_CrowGroup = aas_Tabs.Main:AddLeftGroupbox("Auto Crow (World 6)", "feather")
aas_CrowGroup:AddLabel(
    "⚠ IMPORTANT: You MUST have manually visited\n"..
    "World 6 at least once before enabling this!\n"..
    "When a crow spawns, ALL active farming will\n"..
    "be paused, crow will be claimed, then resumed.",
    true
)
aas_CrowGroup:AddToggle("AutoCrow", {
    Text    = "Enable Auto Crow (World 6)",
    Tooltip = "Monitors workspace.World6Corvos for crows. Pauses all activities to claim the crow, then resumes.",
    Default = false,
    Callback = function(value)
        aas_autoCrowEnabled = value
        if value then
            if aas_crowThread then task.cancel(aas_crowThread) end
            aas_crowThread = task.spawn(aas_crowMonitorLoop)
            UILibrary:Notify({
                Title       = "Auto Crow",
                Description = "Enabled! Monitoring World 6 Corvos...",
                Time        = 5,
            })
        else
            if aas_crowThread then
                task.cancel(aas_crowThread)
                aas_crowThread = nil
            end
            aas_crowClaiming = false
            UILibrary:Notify({ Title = "Auto Crow", Description = "Disabled.", Time = 3 })
        end
    end,
})

-- ── Auto Ball (World 8) ────────────────────────────────────────────
local aas_BallGroup = aas_Tabs.Main:AddLeftGroupbox("Auto Ball (World 8)", "circle")
aas_BallGroup:AddLabel(
    "⚠ IMPORTANT: You MUST have World 8 unlocked\n"..
    "before enabling this!\n"..
    "When a ball spawns, ALL active farming will\n"..
    "be paused, ball will be claimed, then resumed.",
    true
)
aas_BallGroup:AddToggle("AutoBall", {
    Text    = "Enable Auto Ball (World 8)",
    Tooltip = "Monitors workspace.World8Balls for balls. Pauses all activities to claim the ball, then resumes.",
    Default = false,
    Callback = function(value)
        aas_autoBallEnabled = value
        if value then
            if aas_ballThread then task.cancel(aas_ballThread) end
            aas_ballThread = task.spawn(aas_ballMonitorLoop)
            UILibrary:Notify({
                Title       = "Auto Ball",
                Description = "Enabled! Monitoring World 8 Balls...",
                Time        = 5,
            })
        else
            if aas_ballThread then
                task.cancel(aas_ballThread)
                aas_ballThread = nil
            end
            aas_ballClaiming = false
            UILibrary:Notify({ Title = "Auto Ball", Description = "Disabled.", Time = 3 })
        end
    end,
})

-- ── Auto Stat ─────────────────────────────
local aas_StatGroup = aas_Tabs.Main:AddRightGroupbox("Auto Stat Points", "trending-up")
aas_StatGroup:AddDropdown("StatSelection", {
    Values   = { "Power", "Yen", "Damage", "Luck", "Xp", "Drop" },
    Default  = 1,
    Text     = "Select Stat to Auto Upgrade",
    Tooltip  = "Choose which stat to automatically upgrade",
    Callback = function(value)
        aas_currentStatSelection = value
        if aas_autoStatEnabled then
            if aas_toggleAutoStat(value, true) then
                UILibrary:Notify({ Title="Auto Stat", Description="Switched to "..value, Time=2 })
            end
        end
    end,
})
aas_StatGroup:AddToggle("AutoStat", {
    Text    = "Enable Auto Stat",
    Tooltip = "Automatically upgrade the selected stat when you have points",
    Default = false,
    Callback = function(value)
        aas_autoStatEnabled = value
        if aas_toggleAutoStat(aas_currentStatSelection, value) then
            UILibrary:Notify({ Title="Auto Stat", Description=value and ("Enabled for "..aas_currentStatSelection) or "Disabled", Time=3 })
        else
            UILibrary:Notify({ Title="Auto Stat", Description="Failed to toggle", Time=4 })
            Toggles.AutoStat:SetValue(not value)
        end
    end,
})

-- ── Redeem Codes ──────────────────────────
local aas_CodesGroup = aas_Tabs.Main:AddRightGroupbox("Redeem Codes", "gift")
aas_CodesGroup:AddButton({
    Text    = "🎁 Redeem All Codes",
    Func    = aas_redeemAllCodes,
    Tooltip = "Redeem all available codes automatically",
})

-- ══════════════════════════════════════════
--   LOADOUTS TAB
-- ══════════════════════════════════════════
local aas_LoadoutInfoGroup = aas_Tabs.Loadouts:AddLeftGroupbox("How Loadouts Work", "info")
aas_LoadoutInfoGroup:AddLabel(
    "Assign a stat loadout to each activity.\n"..
    "Before starting each activity, the script fires\n"..
    "EquipBestLoadout with your chosen stat.\n\n"..
    "Example: Set Raid = Damage, Trial = Drop.\n"..
    "Script will equip Damage before each raid,\n"..
    "and Drop before each trial automatically.",
    true
)

local aas_LoadoutGroup = aas_Tabs.Loadouts:AddLeftGroupbox("Activity Loadout Assignments", "shield")

-- Farm loadout
aas_LoadoutGroup:AddDropdown("LoadoutFarm", {
    Values   = { "Power", "Yen", "Damage", "XP", "Drop", "Luck" },
    Default  = 1,
    Text     = "Auto Farm Mob Loadout",
    Tooltip  = "Equip this loadout before auto farming mobs",
    Callback = function(v) aas_LoadoutAssignments.Farm = v end,
})

aas_LoadoutGroup:AddDivider()
aas_LoadoutGroup:AddLabel("Per-Gate-Rank Loadouts:", true)

for _, rank in ipairs(aas_GateRanks) do
    aas_LoadoutGroup:AddDropdown("LoadoutGateRank_" .. rank, {
        Values   = { "Power", "Yen", "Damage", "XP", "Drop", "Luck" },
        Default  = 1,
        Text     = "Gate Rank " .. rank .. " Loadout",
        Tooltip  = "Equip this loadout when entering a Rank " .. rank .. " gate",
        Callback = function(v)
            -- Stored in Options, read directly in gate loop
        end,
    })
end

aas_LoadoutGroup:AddDivider()
aas_LoadoutGroup:AddLabel("Per-Raid Loadouts:", true)

-- Per-raid loadout dropdowns
for _, raidKey in ipairs(aas_sortedRaidKeys) do
    local raidData   = aas_RaidList[raidKey]
    local worldLabel = aas_getWorldLabel(raidData.WorldId or 0)
    aas_RaidLoadouts[raidKey] = "Power"

    aas_LoadoutGroup:AddDropdown("LoadoutRaid_"..raidKey, {
        Values   = { "Power", "Yen", "Damage", "XP", "Drop", "Luck" },
        Default  = 1,
        Text     = raidData.Name.." ("..worldLabel..") Loadout",
        Tooltip  = "Equip this loadout when auto-farming "..raidData.Name,
        Callback = function(v) aas_RaidLoadouts[raidKey] = v end,
    })
end

local aas_LoadoutGroupRight = aas_Tabs.Loadouts:AddRightGroupbox("Per-Defense & Trial Loadouts", "shield")
aas_LoadoutGroupRight:AddLabel("Per-Defense Loadouts:", true)

-- Per-defense loadout dropdowns
for _, defKey in ipairs(aas_sortedDefenseKeys) do
    local defData    = aas_DefenseList[defKey]
    local worldLabel = aas_getWorldLabel(defData.WorldId or 0)
    aas_DefenseLoadouts[defKey] = "Power"

    aas_LoadoutGroupRight:AddDropdown("LoadoutDef_"..defKey, {
        Values   = { "Power", "Yen", "Damage", "XP", "Drop", "Luck" },
        Default  = 1,
        Text     = defData.Name.." ("..worldLabel..") Loadout",
        Tooltip  = "Equip this loadout when auto-farming "..defData.Name,
        Callback = function(v) aas_DefenseLoadouts[defKey] = v end,
    })
end

aas_LoadoutGroupRight:AddDivider()
aas_LoadoutGroupRight:AddLabel("Per-Trial Loadouts:", true)

-- Per-trial loadout dropdowns
for _, trialKey in ipairs(aas_sortedTrialKeys) do
    local trialData = aas_TrialList[trialKey]
    aas_TrialLoadouts[trialKey] = "Power"

    aas_LoadoutGroupRight:AddDropdown("LoadoutTrial_"..trialKey, {
        Values   = { "Power", "Yen", "Damage", "XP", "Drop", "Luck" },
        Default  = 1,
        Text     = trialData.Name.." Loadout",
        Tooltip  = "Equip this loadout when entering "..trialData.Name,
        Callback = function(v) aas_TrialLoadouts[trialKey] = v end,
    })
end

-- ══════════════════════════════════════════
--   AUTO FARM MOB TAB
-- ══════════════════════════════════════════
local aas_FarmControlGroup = aas_Tabs.Farm:AddLeftGroupbox("Farm Control", "zap")
aas_FarmControlGroup:AddToggle("AutoFarmEnabled", {
    Text    = "Enable Auto Farm",
    Tooltip = "Starts/stops the auto farm loop for all selected mobs",
    Default = false,
    Callback = function(value)
        if value then
            if aas_anyRaidActive() then
                Toggles.AutoFarmEnabled:SetValue(false)
                UILibrary:Notify({ Title="Blocked", Description="Cannot enable Auto Farm while a raid is active.", Time=4 })
                return
            end
            if aas_anyDefenseActive() then
                Toggles.AutoFarmEnabled:SetValue(false)
                UILibrary:Notify({ Title="Blocked", Description="Cannot enable Auto Farm while a defense is active.", Time=4 })
                return
            end
        end
        aas_farmEnabled = value
        if value then
            aas_equipLoadout(aas_LoadoutAssignments.Farm)
            if aas_farmThread then task.cancel(aas_farmThread) end
            aas_farmThread = task.spawn(aas_farmLoop)
            UILibrary:Notify({ Title="Auto Farm", Description="Farm started!", Time=3 })
        else
            if aas_farmThread then task.cancel(aas_farmThread) aas_farmThread = nil end
            aas_currentWorldTracked = nil
            UILibrary:Notify({ Title="Auto Farm", Description="Farm stopped.", Time=3 })
        end
    end,
})
aas_FarmControlGroup:AddDivider()
aas_FarmControlGroup:AddLabel("Click a world button to teleport there.", true)
aas_FarmControlGroup:AddLabel("Select 'None' to stop farming that world.", true)

for i, worldIdx in ipairs(aas_sortedWorldIndices) do
    local worldData = aas_WorldList[worldIdx]
    local dropKey   = "FarmWorld_"..worldIdx
    aas_worldDropdowns[worldIdx] = dropKey

    local enemyNames = { "None" }
    for _, e in ipairs(worldData.enemies) do table.insert(enemyNames, e.Name) end

    local aas_WorldGroup
    if i % 2 == 1 then
        aas_WorldGroup = aas_Tabs.Farm:AddRightGroupbox(aas_getWorldLabel(worldIdx), "map-pin")
    else
        aas_WorldGroup = aas_Tabs.Farm:AddLeftGroupbox(aas_getWorldLabel(worldIdx), "map-pin")
    end

    local capturedIdx = worldIdx
    aas_WorldGroup:AddButton({
        Text    = "Teleport to "..aas_getWorldLabel(worldIdx),
        Func    = function()
            aas_teleportToWorld(capturedIdx)
            UILibrary:Notify({ Title="Teleporting", Description="Teleporting to "..aas_getWorldLabel(capturedIdx).."...", Time=2 })
        end,
        Tooltip = "Teleport to "..aas_getWorldLabel(worldIdx),
    })

    if #enemyNames <= 1 then
        aas_WorldGroup:AddLabel("No enemies found for this world.", true)
    else
        aas_WorldGroup:AddDropdown(dropKey, {
            Values     = enemyNames,
            Multi      = true,
            Default    = nil,
            Text       = "Select Mobs to Farm",
            Tooltip    = "Choose which mobs to farm in "..worldData.name,
            Searchable = #enemyNames > 6,
            Callback   = function(_) end,
        })
    end
end

-- ══════════════════════════════════════════
--   AUTO RAID / DEFENSE TAB
-- ══════════════════════════════════════════
local aas_RaidInfoGroup = aas_Tabs.RaidDef:AddLeftGroupbox("Auto Raid", "shield")
aas_RaidInfoGroup:AddLabel("Active raid blocks farm mob and defense.", true)
aas_RaidInfoGroup:AddDivider()

for _, raidKey in ipairs(aas_sortedRaidKeys) do
    local raidData   = aas_RaidList[raidKey]
    local toggleKey  = "AutoRaid_"..raidKey
    local waveOptKey = "RaidLeaveWave_"..raidKey
    aas_raidEnabled[raidKey] = false
    aas_RaidLoadouts[raidKey] = aas_RaidLoadouts[raidKey] or "Power"

    local worldLabel = aas_getWorldLabel(raidData.WorldId or 0)
    local aas_RaidGroup = aas_Tabs.RaidDef:AddLeftGroupbox(raidData.Name.." ("..worldLabel..")", "zap")

    local waveValues = { "0 (Never Leave)" }
    for w = 1, raidData.TotalWaves do table.insert(waveValues, tostring(w)) end
    aas_RaidGroup:AddDropdown(waveOptKey, {
        Values     = waveValues,
        Default    = 1,
        Text       = "Leave at Wave",
        Tooltip    = "Leave and rejoin at this wave (0 = never leave early)",
        Searchable = raidData.TotalWaves > 20,
        Callback   = function(_) end,
    })
    aas_RaidGroup:AddToggle(toggleKey, {
        Text    = "Enable "..raidData.Name,
        Tooltip = "Auto farm "..raidData.Name.." continuously",
        Default = false,
        Callback = function(value)
            if value then
                if aas_farmEnabled then
                    Toggles[toggleKey]:SetValue(false)
                    UILibrary:Notify({ Title="Blocked", Description="Disable Auto Farm Mob first.", Time=4 })
                    return
                end
                if aas_anyDefenseActive() then
                    Toggles[toggleKey]:SetValue(false)
                    UILibrary:Notify({ Title="Blocked", Description="Disable active defense before starting a raid.", Time=4 })
                    return
                end
                if aas_activeRaidKey and aas_activeRaidKey ~= raidKey then
                    Toggles[toggleKey]:SetValue(false)
                    UILibrary:Notify({ Title="Blocked", Description="Disable "..aas_RaidList[aas_activeRaidKey].Name.." first.", Time=4 })
                    return
                end
                aas_disableOtherRaids(raidKey)
                aas_raidEnabled[raidKey] = true
                aas_activeRaidKey = raidKey
                if aas_raidThread then task.cancel(aas_raidThread) aas_raidThread = nil end
                aas_raidThread = task.spawn(function() aas_raidLoop(raidKey) end)
                UILibrary:Notify({ Title=raidData.Name, Description="Auto Raid started!", Time=3 })
            else
                aas_raidEnabled[raidKey] = false
                if aas_activeRaidKey == raidKey then aas_activeRaidKey = nil end
                if aas_raidThread then task.cancel(aas_raidThread) aas_raidThread = nil end
                UILibrary:Notify({ Title=raidData.Name, Description="Auto Raid stopped.", Time=3 })
            end
        end,
    })
end

local aas_DefInfoGroup = aas_Tabs.RaidDef:AddRightGroupbox("Auto Defense", "shield")
aas_DefInfoGroup:AddLabel("Active defense blocks farm mob and raids.", true)
aas_DefInfoGroup:AddDivider()

for _, defKey in ipairs(aas_sortedDefenseKeys) do
    local defData    = aas_DefenseList[defKey]
    local toggleKey  = "AutoDefense_"..defKey
    local waveOptKey = "DefLeaveWave_"..defKey
    aas_defenseEnabled[defKey] = false
    aas_DefenseLoadouts[defKey] = aas_DefenseLoadouts[defKey] or "Power"

    local worldLabel = aas_getWorldLabel(defData.WorldId or 0)
    local aas_DefGroup = aas_Tabs.RaidDef:AddRightGroupbox(defData.Name.." ("..worldLabel..")", "zap")

    local waveValues = { "0 (Never Leave)" }
    for w = 1, defData.TotalWaves do table.insert(waveValues, tostring(w)) end
    aas_DefGroup:AddDropdown(waveOptKey, {
        Values     = waveValues,
        Default    = 1,
        Text       = "Leave at Wave",
        Tooltip    = "Leave and rejoin at this wave (0 = never leave early)",
        Searchable = defData.TotalWaves > 20,
        Callback   = function(_) end,
    })
    aas_DefGroup:AddToggle(toggleKey, {
        Text    = "Enable "..defData.Name,
        Tooltip = "Auto farm "..defData.Name.." continuously",
        Default = false,
        Callback = function(value)
            if value then
                if aas_farmEnabled then
                    Toggles[toggleKey]:SetValue(false)
                    UILibrary:Notify({ Title="Blocked", Description="Disable Auto Farm Mob first.", Time=4 })
                    return
                end
                if aas_anyRaidActive() then
                    Toggles[toggleKey]:SetValue(false)
                    UILibrary:Notify({ Title="Blocked", Description="Disable active raid before starting a defense.", Time=4 })
                    return
                end
                if aas_activeDefenseKey and aas_activeDefenseKey ~= defKey then
                    Toggles[toggleKey]:SetValue(false)
                    UILibrary:Notify({ Title="Blocked", Description="Disable "..aas_DefenseList[aas_activeDefenseKey].Name.." first.", Time=4 })
                    return
                end
                aas_disableAllDefenses()
                aas_defenseEnabled[defKey] = true
                aas_activeDefenseKey = defKey
                if aas_defenseThread then task.cancel(aas_defenseThread) aas_defenseThread = nil end
                aas_defenseThread = task.spawn(function() aas_defenseLoop(defKey) end)
                UILibrary:Notify({ Title=defData.Name, Description="Auto Defense started!", Time=3 })
            else
                aas_defenseEnabled[defKey] = false
                if aas_activeDefenseKey == defKey then aas_activeDefenseKey = nil end
                if aas_defenseThread then task.cancel(aas_defenseThread) aas_defenseThread = nil end
                UILibrary:Notify({ Title=defData.Name, Description="Auto Defense stopped.", Time=3 })
            end
        end,
    })
end

-- ══════════════════════════════════════════
--   AUTO TRIAL / GATE TAB
-- ══════════════════════════════════════════
local aas_PriorityGroup = aas_Tabs.Trial:AddLeftGroupbox("⚠ Priority System (REQUIRED)", "alert-triangle")
aas_PriorityGroup:AddLabel(
    "When both a Trial AND a Gate are available at the same time,\n"..
    "the priority determines which one runs first.\n"..
    "The other will be paused until it finishes.", true
)
aas_PriorityGroup:AddDropdown("TrialGatePriority", {
    Values   = { "Trial", "Gate" },
    Default  = 1,
    Text     = "Priority When Both Available",
    Tooltip  = "If both a trial and a gate spawn at the same time, which one takes priority?",
    Callback = function(val)
        aas_priorityChoice = val
        UILibrary:Notify({ Title="Priority Set", Description="Priority: "..val, Time=2 })
    end,
})
aas_PriorityGroup:AddDivider()

-- LEFT: Auto Trials
local aas_TrialInfoGroup = aas_Tabs.Trial:AddLeftGroupbox("Auto Trial", "clock")
aas_TrialInfoGroup:AddLabel("Trials spawn on a schedule — script waits for them.", true)
aas_TrialInfoGroup:AddLabel("Multiple trials can run simultaneously.", true)
aas_TrialInfoGroup:AddLabel("Trials temporarily pause Farm / Raid / Defense.", true)
aas_TrialInfoGroup:AddDivider()

for _, trialKey in ipairs(aas_sortedTrialKeys) do
    local trialData  = aas_TrialList[trialKey]
    local toggleKey  = "AutoTrial_"..trialKey
    local roomOptKey = "TrialLeaveRoom_"..trialKey
    aas_trialEnabled[trialKey] = false
    aas_TrialLoadouts[trialKey] = aas_TrialLoadouts[trialKey] or "Power"

    local aas_TrialGroup = aas_Tabs.Trial:AddLeftGroupbox(trialData.Name, "zap")

    local roomValues = { "0 (Never Leave)" }
    for r = 1, trialData.TotalRooms do table.insert(roomValues, tostring(r)) end

    aas_TrialGroup:AddDropdown(roomOptKey, {
        Values     = roomValues,
        Default    = 1,
        Text       = "Leave at Room",
        Tooltip    = "Leave the trial at this room and rejoin next spawn. Change takes effect immediately.",
        Searchable = trialData.TotalRooms > 20,
        Callback   = function(_) end,
    })
    aas_TrialGroup:AddToggle(toggleKey, {
        Text    = "Enable "..trialData.Name,
        Tooltip = "Auto farm "..trialData.Name.." — waits for trial to spawn, then farms enemies",
        Default = false,
        Callback = function(value)
            aas_trialEnabled[trialKey] = value
            if value then
                if aas_trialThreads[trialKey] then
                    task.cancel(aas_trialThreads[trialKey])
                    aas_trialThreads[trialKey] = nil
                end
                aas_trialThreads[trialKey] = task.spawn(function() aas_trialLoop(trialKey) end)
                UILibrary:Notify({ Title=trialData.Name, Description="Auto Trial enabled! Waiting for trial to spawn...", Time=4 })
            else
                if aas_trialThreads[trialKey] then
                    task.cancel(aas_trialThreads[trialKey])
                    aas_trialThreads[trialKey] = nil
                end
                UILibrary:Notify({ Title=trialData.Name, Description="Auto Trial stopped.", Time=3 })
            end
        end,
    })
end

-- RIGHT: Auto Gate
local aas_GateInfoGroup = aas_Tabs.Trial:AddRightGroupbox("Auto Gate", "shield")
aas_GateInfoGroup:AddLabel("Gates spawn every ~10 min for 60 seconds.", true)
aas_GateInfoGroup:AddLabel("Script teleports to World 5 RaidStation (portal).", true)
aas_GateInfoGroup:AddLabel("Gate temporarily pauses Farm / Raid / Defense.", true)
aas_GateInfoGroup:AddDivider()

if aas_GateData then
    aas_GateInfoGroup:AddDropdown("GateRankSelect", {
        Values     = aas_GateRanks,
        Multi      = true,
        Default    = nil,
        Text       = "Select Gate Ranks to Farm",
        Tooltip    = "Only enter the gate if its rank matches one of these.",
        Searchable = false,
        Callback   = function(_) end,
    })

    for _, rank in ipairs(aas_GateRanks) do
        local waveOptKey = "GateLeaveWave_"..rank
        local waveValues = { "0 (Never Leave)" }
        for w = 1, (aas_GateData.TotalWaves or 50) do table.insert(waveValues, tostring(w)) end
        aas_GateInfoGroup:AddDropdown(waveOptKey, {
            Values     = waveValues,
            Default    = 1,
            Text       = "Leave at Wave (Rank "..rank..")",
            Tooltip    = "Leave the gate at this wave for Rank "..rank.." gates (0 = never leave)",
            Searchable = (aas_GateData.TotalWaves or 50) > 20,
            Callback   = function(_) end,
        })
    end

    aas_GateInfoGroup:AddToggle("GateAutoArise", {
        Text    = "Enable Auto Arise",
        Tooltip = "Enables Auto Arise for gates.",
        Default = false,
        Callback = function(value)
            aas_gateAutoArise = value
            if aas_gateEnabled and aas_raidAutoAriseRemote then
                pcall(function() aas_raidAutoAriseRemote:Fire(value) end)
            end
            UILibrary:Notify({ Title="Auto Arise", Description=value and "Enabled!" or "Disabled", Time=3 })
        end,
    })

    aas_GateInfoGroup:AddToggle("AutoGateEnabled", {
        Text    = "Enable Auto Gate",
        Tooltip = "Monitors World 5 for gates and farms them automatically. Teleports to RaidStation portal.",
        Default = false,
        Callback = function(value)
            aas_gateEnabled = value
            if value then
                if aas_gateThread then task.cancel(aas_gateThread) aas_gateThread = nil end
                aas_gateThread = task.spawn(aas_gateLoop)
                UILibrary:Notify({ Title="Auto Gate", Description="Enabled! Monitoring World 5 for gates...", Time=4 })
            else
                if aas_gateThread then task.cancel(aas_gateThread) aas_gateThread = nil end
                aas_gateSuppressedByPriority = false
                if aas_gateAutoArise and aas_raidAutoAriseRemote then
                    pcall(function() aas_raidAutoAriseRemote:Fire(false) end)
                end
                UILibrary:Notify({ Title="Auto Gate", Description="Stopped.", Time=3 })
            end
        end,
    })
else
    aas_GateInfoGroup:AddLabel("No gate data found in config.", true)
end

-- ══════════════════════════════════════════
--   AUTO GACHA TAB
-- ══════════════════════════════════════════
task.spawn(function()
    task.wait(2)
    pcall(aas_syncAllPlayerData)
end)

local aas_GachaInfoGroup = aas_Tabs.Gacha:AddLeftGroupbox("Auto Gacha", "sparkles")
aas_GachaInfoGroup:AddLabel("Multiple gachas can run simultaneously.", true)
aas_GachaInfoGroup:AddLabel("Auto stops when Divine is reached.", true)
aas_GachaInfoGroup:AddDivider()

for _, gachaKey in ipairs(aas_sortedGachaKeys) do
    local gachaData = aas_GachaList[gachaKey]
    local toggleKey = "AutoGacha_"..gachaKey
    aas_gachaEnabled[gachaKey] = false

    local worldLabel = aas_getWorldLabel(gachaData.WorldId)
    local aas_GachaGroup = aas_Tabs.Gacha:AddLeftGroupbox(gachaData.Name.." ("..worldLabel..")", "star")

    local currentRarity  = aas_activeGachaRarities[gachaKey] or "Unknown"
    local rarityLabelObj = aas_GachaGroup:AddLabel("Current: "..currentRarity, false, "GachaRarityLabel_"..gachaKey)
    aas_gachaLabelRefs[gachaKey] = Options["GachaRarityLabel_"..gachaKey] or rarityLabelObj

    aas_GachaGroup:AddToggle(toggleKey, {
        Text    = "Enable Auto Roll",
        Tooltip = "Automatically roll "..gachaData.Name.." (stops at Divine)",
        Default = false,
        Callback = function(value)
            aas_gachaEnabled[gachaKey] = value
            if value then
                if aas_gachaThreads[gachaKey] then task.cancel(aas_gachaThreads[gachaKey]) end
                aas_gachaThreads[gachaKey] = task.spawn(function() aas_gachaLoop(gachaKey) end)
                UILibrary:Notify({ Title=gachaData.Name, Description="Auto Gacha started!", Time=3 })
            else
                if aas_gachaThreads[gachaKey] then task.cancel(aas_gachaThreads[gachaKey]) aas_gachaThreads[gachaKey] = nil end
                UILibrary:Notify({ Title=gachaData.Name, Description="Auto Gacha stopped.", Time=3 })
            end
        end,
    })
end

-- ── Auto Swords ───────────────────────────
do
    local aas_SwordGroup = aas_Tabs.Gacha:AddRightGroupbox("Auto Swords", "sword")
    aas_SwordGroup:AddLabel("Roll regular swords or summer swords independently.", true)
    aas_SwordGroup:AddDivider()

    -- Auto Fuse All
    aas_SwordGroup:AddToggle("AutoFuseAll", {
        Text    = "Auto Fuse All Swords",
        Tooltip = "Automatically fires the fuse-all remote every 5 seconds",
        Default = false,
        Callback = function(value)
            aas_autoFuseAllEnabled = value
            if value then
                if aas_fuseAllThread then task.cancel(aas_fuseAllThread) end
                aas_fuseAllThread = task.spawn(aas_fuseAllLoop)
                UILibrary:Notify({ Title = "Auto Fuse All", Description = "Enabled! (every 5s)", Time = 4 })
            else
                if aas_fuseAllThread then task.cancel(aas_fuseAllThread) aas_fuseAllThread = nil end
                UILibrary:Notify({ Title = "Auto Fuse All", Description = "Disabled.", Time = 3 })
            end
        end,
    })

    aas_SwordGroup:AddDivider()

    -- Regular Sword (World0)
    aas_SwordGroup:AddToggle("AutoSword_World0", {
        Text    = "Auto Roll: Sword (World0)",
        Tooltip = "Automatically roll regular swords (World0) continuously",
        Default = false,
        Callback = function(value)
            aas_swordWorld0Enabled = value
            if value then
                if aas_swordWorld0Thread then task.cancel(aas_swordWorld0Thread) end
                aas_swordWorld0Thread = task.spawn(aas_swordWorld0Loop)
                UILibrary:Notify({ Title = "Auto Sword (World0)", Description = "Started!", Time = 3 })
            else
                aas_swordWorld0Enabled = false
                if aas_swordWorld0Thread then task.cancel(aas_swordWorld0Thread) aas_swordWorld0Thread = nil end
                UILibrary:Notify({ Title = "Auto Sword (World0)", Description = "Stopped.", Time = 3 })
            end
        end,
    })

    -- Summer Sword (World8)
    aas_SwordGroup:AddToggle("AutoSword_World8", {
        Text    = "Auto Roll: Summer Sword (World8)",
        Tooltip = "Automatically roll summer swords (World8) continuously",
        Default = false,
        Callback = function(value)
            aas_swordWorld8Enabled = value
            if value then
                if aas_swordWorld8Thread then task.cancel(aas_swordWorld8Thread) end
                aas_swordWorld8Thread = task.spawn(aas_swordWorld8Loop)
                UILibrary:Notify({ Title = "Auto Summer Sword (World8)", Description = "Started!", Time = 3 })
            else
                aas_swordWorld8Enabled = false
                if aas_swordWorld8Thread then task.cancel(aas_swordWorld8Thread) aas_swordWorld8Thread = nil end
                UILibrary:Notify({ Title = "Auto Summer Sword (World8)", Description = "Stopped.", Time = 3 })
            end
        end,
    })
end

-- ── Auto Player Passive ───────────────────
do
    local aas_PassiveGroup = aas_Tabs.Gacha:AddRightGroupbox("Auto Player Passive", "shield")
    local passiveText    = "Active: None"
    if aas_activePassiveData then
        passiveText = "Active: "..aas_activePassiveData.Name.." | "..aas_activePassiveData.Rarity
    end
    local passiveLabelObj = aas_PassiveGroup:AddLabel(passiveText, false, "PassiveActiveLabel")
    aas_passiveLabelRef = Options["PassiveActiveLabel"] or passiveLabelObj

    aas_PassiveGroup:AddToggle("AutoPassiveEnabled", {
        Text    = "Enable Auto Passive Roll",
        Tooltip = "Automatically roll Player Passive continuously",
        Default = false,
        Callback = function(value)
            aas_passiveAutoEnabled = value
            if value then
                if aas_passiveThread then task.cancel(aas_passiveThread) end
                aas_passiveThread = task.spawn(aas_passiveLoop)
                UILibrary:Notify({ Title="Auto Player Passive", Description="Started!", Time=3 })
            else
                if aas_passiveThread then task.cancel(aas_passiveThread) aas_passiveThread = nil end
                UILibrary:Notify({ Title="Auto Player Passive", Description="Stopped.", Time=3 })
            end
        end,
    })
end

-- ── Auto Titan ────────────────────────────
do
    local aas_TitanGroup = aas_Tabs.Gacha:AddRightGroupbox("Auto Titan", "zap")
    local titanLabelObj = aas_TitanGroup:AddLabel("Active Titan: None", false, "TitanActiveLabel")
    aas_titanLabelRef = Options["TitanActiveLabel"] or titanLabelObj

    aas_TitanGroup:AddToggle("AutoTitanEnabled", {
        Text    = "Enable Auto Titan Roll",
        Tooltip = "Automatically roll Titans (World4) continuously",
        Default = false,
        Callback = function(value)
            aas_titanAutoEnabled = value
            if value then
                if aas_titanThread then task.cancel(aas_titanThread) end
                aas_titanThread = task.spawn(aas_titanLoop)
                UILibrary:Notify({ Title="Auto Titan", Description="Started!", Time=3 })
            else
                if aas_titanThread then task.cancel(aas_titanThread) aas_titanThread = nil end
                UILibrary:Notify({ Title="Auto Titan", Description="Stopped.", Time=3 })
            end
        end,
    })
end

-- ── Auto Sword Passive 1 ─────────────────
do
    local aas_SP1Group = aas_Tabs.Gacha:AddRightGroupbox("Auto Sword Passive (Sword 1)", "wind")
    local sp1InfoObj = aas_SP1Group:AddLabel("Sword 1: Loading...", false, "SwordPassive1InfoLabel")
    aas_sword1InfoLabelRef = Options["SwordPassive1InfoLabel"] or sp1InfoObj
    local sp1BreathObj = aas_SP1Group:AddLabel("Breathing: None", false, "SwordPassive1BreathLabel")
    aas_sword1BreathingLabelRef = Options["SwordPassive1BreathLabel"] or sp1BreathObj

    aas_SP1Group:AddDropdown("SwordPassive1StopRarities", {
        Values     = aas_SwordPassiveRarityOrder,
        Multi      = true,
        Default    = nil,
        Text       = "Stop at Breathing Rarity",
        Tooltip    = "Stop rolling when breathing reaches any selected rarity. Empty = roll forever.",
        Searchable = false,
        Callback   = function(_) end,
    })
    aas_SP1Group:AddToggle("AutoSwordPassive1Enabled", {
        Text    = "Enable Auto Roll (Sword 1)",
        Tooltip = "Automatically roll sword passive for your first equipped sword",
        Default = false,
        Callback = function(value)
            aas_swordPassive1Enabled = value
            if value then
                if aas_swordPassive1Thread then task.cancel(aas_swordPassive1Thread) end
                aas_swordPassive1Thread = task.spawn(aas_swordPassive1Loop)
                UILibrary:Notify({ Title="Sword Passive 1", Description="Started!", Time=3 })
            else
                if aas_swordPassive1Thread then task.cancel(aas_swordPassive1Thread) aas_swordPassive1Thread = nil end
                UILibrary:Notify({ Title="Sword Passive 1", Description="Stopped.", Time=3 })
            end
        end,
    })
end

-- ── Auto Sword Passive 2 ─────────────────
do
    local aas_SP2Group = aas_Tabs.Gacha:AddRightGroupbox("Auto Sword Passive (Sword 2)", "wind")
    local sp2InfoObj = aas_SP2Group:AddLabel("Sword 2: Loading...", false, "SwordPassive2InfoLabel")
    aas_sword2InfoLabelRef = Options["SwordPassive2InfoLabel"] or sp2InfoObj
    local sp2BreathObj = aas_SP2Group:AddLabel("Breathing: None", false, "SwordPassive2BreathLabel")
    aas_sword2BreathingLabelRef = Options["SwordPassive2BreathLabel"] or sp2BreathObj

    aas_SP2Group:AddDropdown("SwordPassive2StopRarities", {
        Values     = aas_SwordPassiveRarityOrder,
        Multi      = true,
        Default    = nil,
        Text       = "Stop at Breathing Rarity",
        Tooltip    = "Stop rolling when breathing reaches any selected rarity. Empty = roll forever.",
        Searchable = false,
        Callback   = function(_) end,
    })
    aas_SP2Group:AddToggle("AutoSwordPassive2Enabled", {
        Text    = "Enable Auto Roll (Sword 2)",
        Tooltip = "Automatically roll sword passive for your second equipped sword",
        Default = false,
        Callback = function(value)
            aas_swordPassive2Enabled = value
            if value then
                if aas_swordPassive2Thread then task.cancel(aas_swordPassive2Thread) end
                aas_swordPassive2Thread = task.spawn(aas_swordPassive2Loop)
                UILibrary:Notify({ Title="Sword Passive 2", Description="Started!", Time=3 })
            else
                if aas_swordPassive2Thread then task.cancel(aas_swordPassive2Thread) aas_swordPassive2Thread = nil end
                UILibrary:Notify({ Title="Sword Passive 2", Description="Stopped.", Time=3 })
            end
        end,
    })
end

-- ── Auto Grimoire Slot 1 ──────────────────
do
    local aas_G1Group = aas_Tabs.Gacha:AddRightGroupbox("Auto Grimoires (Slot 1)", "book-open")
    local g1LabelObj = aas_G1Group:AddLabel("Slot 1: None", false, "Grimoire1Label")
    aas_grimoire1LabelRef = Options["Grimoire1Label"] or g1LabelObj

    aas_G1Group:AddToggle("AutoGrimoire1Enabled", {
        Text    = "Enable Auto Roll (Slot 1)",
        Tooltip = "Automatically roll Grimoire Slot 1 (World7) — stops at Divine",
        Default = false,
        Callback = function(value)
            aas_grimoire1Enabled = value
            if value then
                if aas_grimoire1Thread then task.cancel(aas_grimoire1Thread) end
                aas_grimoire1Thread = task.spawn(aas_grimoire1Loop)
                UILibrary:Notify({ Title="Auto Grimoire Slot 1", Description="Started!", Time=3 })
            else
                if aas_grimoire1Thread then task.cancel(aas_grimoire1Thread) aas_grimoire1Thread = nil end
                UILibrary:Notify({ Title="Auto Grimoire Slot 1", Description="Stopped.", Time=3 })
            end
        end,
    })
end

-- ── Auto Grimoire Slot 2 ──────────────────
do
    local aas_G2Group = aas_Tabs.Gacha:AddRightGroupbox("Auto Grimoires (Slot 2)", "book-open")
    local g2LabelObj = aas_G2Group:AddLabel("Slot 2: None", false, "Grimoire2Label")
    aas_grimoire2LabelRef = Options["Grimoire2Label"] or g2LabelObj

    aas_G2Group:AddToggle("AutoGrimoire2Enabled", {
        Text    = "Enable Auto Roll (Slot 2)",
        Tooltip = "Automatically roll Grimoire Slot 2 (World7) — stops at Divine",
        Default = false,
        Callback = function(value)
            aas_grimoire2Enabled = value
            if value then
                if aas_grimoire2Thread then task.cancel(aas_grimoire2Thread) end
                aas_grimoire2Thread = task.spawn(aas_grimoire2Loop)
                UILibrary:Notify({ Title="Auto Grimoire Slot 2", Description="Started!", Time=3 })
            else
                if aas_grimoire2Thread then task.cancel(aas_grimoire2Thread) aas_grimoire2Thread = nil end
                UILibrary:Notify({ Title="Auto Grimoire Slot 2", Description="Stopped.", Time=3 })
            end
        end,
    })
end

-- ══════════════════════════════════════════
--   AUTO PROGRESSION TAB
-- ══════════════════════════════════════════
local aas_ProgInfoGroup = aas_Tabs.Progression:AddLeftGroupbox("Auto Progressions", "trending-up")
aas_ProgInfoGroup:AddLabel("Each auto progression can be run simultaneously.", true)
aas_ProgInfoGroup:AddLabel("Auto stops at max level.", true)
aas_ProgInfoGroup:AddDivider()

for _, progKey in ipairs(aas_sortedProgressionKeys) do
    local progData  = aas_ProgressionList[progKey]
    local toggleKey = "AutoProgression_"..progKey
    aas_progressionEnabled[progKey] = false

    local worldId    = progData.WorldId or (tonumber(progKey:match("%d+")) or 0)
    local worldLabel = aas_getWorldLabel(worldId)
    local aas_ProgGroup = aas_Tabs.Progression:AddLeftGroupbox(worldLabel, "zap")

    local levelLabelObj = aas_ProgGroup:AddLabel(
        "Level: 0 / "..tostring(progData.MaxLevel), false, "ProgLevel_"..progKey
    )
    aas_progressionLevelLabelRefs[progKey] = Options["ProgLevel_"..progKey] or levelLabelObj

    aas_ProgGroup:AddToggle(toggleKey, {
        Text    = "Enable Auto Upgrade",
        Tooltip = "Automatically upgrade "..progData.Name.." until max level",
        Default = false,
        Callback = function(value)
            aas_progressionEnabled[progKey] = value
            if value then
                if aas_progressionThreads[progKey] then task.cancel(aas_progressionThreads[progKey]) end
                aas_progressionThreads[progKey] = task.spawn(function() aas_progressionLoop(progKey) end)
                UILibrary:Notify({ Title=progData.Name, Description="Auto Progression started!", Time=3 })
            else
                if aas_progressionThreads[progKey] then task.cancel(aas_progressionThreads[progKey]) aas_progressionThreads[progKey] = nil end
                UILibrary:Notify({ Title=progData.Name, Description="Auto Progression stopped.", Time=3 })
            end
        end,
    })
end

-- ── Auto Upgrades (Right side) ────────────
local aas_UpgradeInfoGroup = aas_Tabs.Progression:AddRightGroupbox("Auto Upgrades", "zap")
aas_UpgradeInfoGroup:AddLabel("Select a stat and enable to auto-upgrade.", true)
aas_UpgradeInfoGroup:AddDivider()

for _, sysKey in ipairs(aas_sortedUpgradeSystemKeys) do
    local sysData    = aas_UpgradeSystemList[sysKey]
    local worldLabel = aas_getWorldLabel(sysData.WorldId or 0)
    local statDropKey   = "UpgradeStat_"..sysKey
    local upgradeTogKey = "AutoUpgrade_"..sysKey

    -- Each system gets its own groupbox inside the right side
    local aas_UpgradeGroup = aas_Tabs.Progression:AddRightGroupbox(worldLabel.." Upgrades", "arrow-up")

    local currentStatForSys = { value = "Power" }

    aas_UpgradeGroup:AddDropdown(statDropKey, {
        Values   = aas_UpgradeStatKeys,
        Default  = 1,
        Text     = "Stat to Upgrade",
        Tooltip  = "Select which stat to auto-upgrade for "..sysData.Name,
        Callback = function(val) currentStatForSys.value = val end,
    })

    aas_UpgradeGroup:AddToggle(upgradeTogKey, {
        Text    = "Enable Auto Upgrade",
        Tooltip = "Automatically upgrade selected stat for "..sysData.Name,
        Default = false,
        Callback = function(value)
            if value then
                local thread = task.spawn(function()
                    while Toggles[upgradeTogKey] and Toggles[upgradeTogKey].Value do
                        pcall(function() aas_upgradesRequestRemote:Fire(sysKey, currentStatForSys.value) end)
                        task.wait(1.0)
                    end
                end)
                if aas_rangeUpgradeThreads["upgrade_"..sysKey] then
                    task.cancel(aas_rangeUpgradeThreads["upgrade_"..sysKey])
                end
                aas_rangeUpgradeThreads["upgrade_"..sysKey] = thread
                UILibrary:Notify({ Title=sysData.Name, Description="Auto Upgrade started!", Time=3 })
            else
                local t = aas_rangeUpgradeThreads["upgrade_"..sysKey]
                if t then task.cancel(t) aas_rangeUpgradeThreads["upgrade_"..sysKey] = nil end
                UILibrary:Notify({ Title=sysData.Name, Description="Auto Upgrade stopped.", Time=3 })
            end
        end,
    })

    -- Range Upgrade is INSIDE the same groupbox (fixed layout)
    local rangeTogKey = "AutoRangeUpgrade_"..sysKey
    aas_rangeUpgradeEnabled[sysKey] = false

    aas_UpgradeGroup:AddDivider()
    aas_UpgradeGroup:AddToggle(rangeTogKey, {
        Text    = "Enable Auto Range Upgrade",
        Tooltip = "Automatically fire RangeUpgradeRequest for "..sysData.Name,
        Default = false,
        Callback = function(value)
            aas_rangeUpgradeEnabled[sysKey] = value
            if value then
                if aas_rangeUpgradeThreads[sysKey] then task.cancel(aas_rangeUpgradeThreads[sysKey]) end
                aas_rangeUpgradeThreads[sysKey] = task.spawn(function() aas_rangeUpgradeLoop(sysKey) end)
                UILibrary:Notify({ Title=sysData.Name.." Range", Description="Auto Range Upgrade started!", Time=3 })
            else
                if aas_rangeUpgradeThreads[sysKey] then task.cancel(aas_rangeUpgradeThreads[sysKey]) aas_rangeUpgradeThreads[sysKey] = nil end
                UILibrary:Notify({ Title=sysData.Name.." Range", Description="Auto Range Upgrade stopped.", Time=3 })
            end
        end,
    })
end

-- ══════════════════════════════════════════
--   PROFESSIONS (UPGRADES2) UI
-- ══════════════════════════════════════════
local aas_ProfessionsGroup = aas_Tabs.Progression:AddRightGroupbox("Professions (Upgrades2)", "briefcase")
aas_ProfessionsGroup:AddLabel("Auto upgrades Professions stats using activity-based currencies.", true)
aas_ProfessionsGroup:AddLabel("Auto stops at max level per stat.", true)
aas_ProfessionsGroup:AddLabel("Currencies: Raid Waves, Kills, Gacha Rolls, Star Spins", true)
aas_ProfessionsGroup:AddDivider()

-- Get all upgrades from config for World0 / Professions
local aas_professionSystem = aas_Upgrades2Config:GetSystem(aas_upgrades2SystemKey)
local aas_professionUpgrades = aas_professionSystem and aas_professionSystem.UpgradeList or {}

for _, upgradeData in ipairs(aas_professionUpgrades) do
    local multiplierKey = upgradeData.Multiplier
    local displayName   = upgradeData.DisplayName or multiplierKey
    local costType      = upgradeData.CostType or "?"
    local maxLevel      = upgradeData.MaxLevel
    local maxLevelStr   = (maxLevel == math.huge or maxLevel == nil) and "∞" or tostring(maxLevel)
    local toggleKey     = "AutoUpgrades2_" .. multiplierKey

    aas_upgrades2Enabled[multiplierKey] = false

    local subGroup = aas_ProfessionsGroup

    subGroup:AddLabel(displayName .. " (Cost: " .. costType .. " | Max: " .. maxLevelStr .. ")", true)

    subGroup:AddToggle(toggleKey, {
        Text    = "Enable Auto Upgrade: " .. displayName,
        Tooltip = "Automatically upgrade " .. displayName .. " profession until max level. Costs: " .. costType,
        Default = false,
        Callback = function(value)
            aas_upgrades2Enabled[multiplierKey] = value
            if value then
                -- Request fresh data first
                pcall(function()
                    if aas_upgrades2DataRemote then
                        aas_upgrades2DataRemote:Fire()
                    end
                end)
                task.wait(0.5)

                if aas_upgrades2Threads[multiplierKey] then
                    task.cancel(aas_upgrades2Threads[multiplierKey])
                end
                aas_upgrades2Threads[multiplierKey] = task.spawn(function()
                    aas_upgrades2Loop(multiplierKey)
                end)
                UILibrary:Notify({
                    Title       = "Professions: " .. displayName,
                    Description = "Auto Upgrade started!",
                    Time        = 3,
                })
            else
                if aas_upgrades2Threads[multiplierKey] then
                    task.cancel(aas_upgrades2Threads[multiplierKey])
                    aas_upgrades2Threads[multiplierKey] = nil
                end
                UILibrary:Notify({
                    Title       = "Professions: " .. displayName,
                    Description = "Auto Upgrade stopped.",
                    Time        = 3,
                })
            end
        end,
    })

    subGroup:AddDivider()
end

-- ══════════════════════════════════════════
--   AUTO STAR TAB
-- ══════════════════════════════════════════
local aas_StarInfoGroup = aas_Tabs.Star:AddLeftGroupbox("Auto Star", "star")
aas_StarInfoGroup:AddLabel("Automatically opens eggs from the selected world.", true)
aas_StarInfoGroup:AddDivider()

local aas_starWorldDisplayNames = {}
local aas_starWorldDisplayToKey = {}
for _, key in ipairs(aas_sortedStarWorldKeys) do
    local worldData   = aas_StarWorldList[key]
    local displayName = aas_getWorldLabel(worldData.WorldId)
    table.insert(aas_starWorldDisplayNames, displayName)
    aas_starWorldDisplayToKey[displayName] = key
end

if #aas_sortedStarWorldKeys > 0 then
    aas_starEggKey = aas_sortedStarWorldKeys[1]
end

local aas_StarControlGroup = aas_Tabs.Star:AddLeftGroupbox("Star Control", "zap")
if #aas_starWorldDisplayNames > 0 then
    aas_StarControlGroup:AddDropdown("StarWorldSelect", {
        Values     = aas_starWorldDisplayNames,
        Default    = 1,
        Text       = "Select World (Egg)",
        Tooltip    = "Choose which world's egg to open",
        Searchable = #aas_starWorldDisplayNames > 5,
        Callback   = function(val)
            local key = aas_starWorldDisplayToKey[val]
            if key then
                aas_starEggKey = key
                UILibrary:Notify({ Title="Auto Star", Description="Selected: "..val, Time=2 })
            end
        end,
    })
else
    aas_StarControlGroup:AddLabel("No worlds found in config.", true)
end

aas_StarControlGroup:AddToggle("AutoStarEnabled", {
    Text    = "Enable Auto Star Roll",
    Tooltip = "Automatically open eggs for the selected world",
    Default = false,
    Callback = function(value)
        aas_starEnabled = value
        if value then
            if not aas_starEggKey then
                Toggles["AutoStarEnabled"]:SetValue(false)
                UILibrary:Notify({ Title="Auto Star", Description="No world selected!", Time=4 })
                return
            end
            if aas_starThread then task.cancel(aas_starThread) aas_starThread = nil end
            aas_starThread = task.spawn(aas_starLoop)
            UILibrary:Notify({ Title="Auto Star", Description="Started rolling "..(aas_starEggKey or "?"), Time=3 })
        else
            if aas_starThread then task.cancel(aas_starThread) aas_starThread = nil end
            UILibrary:Notify({ Title="Auto Star", Description="Stopped.", Time=3 })
        end
    end,
})

-- ── Auto Craft ────────────────────────────
local aas_CraftInfoGroup = aas_Tabs.Star:AddRightGroupbox("Auto Craft", "hammer")
aas_CraftInfoGroup:AddLabel("Automatically crafts pets for selected worlds.", true)
aas_CraftInfoGroup:AddLabel("Enable Shiny to craft shiny variants.", true)
aas_CraftInfoGroup:AddDivider()

for _, craftKey in ipairs(aas_sortedCraftKeys) do
    local craftData = aas_CraftList[craftKey]
    local toggleKey = "AutoCraft_"..craftKey
    local shinyKey  = "AutoCraftShiny_"..craftKey
    aas_craftEnabled[craftKey] = false
    aas_craftShiny[craftKey]   = false

    local worldLabel = aas_getWorldLabel(craftData.WorldId or 0)
    local aas_CraftGroup = aas_Tabs.Star:AddRightGroupbox(craftKey.." ("..worldLabel..")", "zap")

    aas_CraftGroup:AddToggle(shinyKey, {
        Text    = "Craft Shiny",
        Tooltip = "Enable to craft shiny version (costs more items)",
        Default = false,
        Callback = function(value) aas_craftShiny[craftKey] = value end,
    })
    aas_CraftGroup:AddToggle(toggleKey, {
        Text    = "Enable Auto Craft",
        Tooltip = "Automatically craft "..craftKey.." continuously",
        Default = false,
        Callback = function(value)
            aas_craftEnabled[craftKey] = value
            if value then
                if aas_craftThreads[craftKey] then task.cancel(aas_craftThreads[craftKey]) end
                aas_craftThreads[craftKey] = task.spawn(function() aas_craftLoop(craftKey) end)
                UILibrary:Notify({ Title=craftKey, Description="Auto Craft started!", Time=3 })
            else
                if aas_craftThreads[craftKey] then task.cancel(aas_craftThreads[craftKey]) aas_craftThreads[craftKey] = nil end
                UILibrary:Notify({ Title=craftKey, Description="Auto Craft stopped.", Time=3 })
            end
        end,
    })
end

-- ══════════════════════════════════════════
--   SETTINGS TAB
-- ══════════════════════════════════════════
local aas_MenuGroup = aas_Tabs.Settings:AddLeftGroupbox("Menu Settings", "settings")

aas_MenuGroup:AddToggle("KeybindMenuOpen", {
    Default  = UILibrary.KeybindFrame.Visible,
    Text     = "Show Keybind Menu",
    Callback = function(value) UILibrary.KeybindFrame.Visible = value end,
})
aas_MenuGroup:AddToggle("ShowCustomCursor", {
    Text     = "Custom Cursor",
    Default  = true,
    Callback = function(Value) UILibrary.ShowCustomCursor = Value end,
})
aas_MenuGroup:AddDropdown("NotificationSide", {
    Values   = { "Left", "Right" },
    Default  = "Right",
    Text     = "Notification Side",
    Callback = function(value) UILibrary:SetNotifySide(value) end,
})
aas_MenuGroup:AddLabel("Menu Keybind"):AddKeyPicker("MenuKeybind", {
    Default = "G",
    NoUI    = true,
    Text    = "Menu toggle keybind",
})
aas_MenuGroup:AddButton({
    Text    = "Unload Script",
    Tooltip = "Completely unload the script",
    Func    = function()
        aas_cleanup()
        UILibrary:Unload()
    end,
})

UILibrary.ToggleKeybind = Options.MenuKeybind

-- ══════════════════════════════════════════
--   THEME AND SAVE MANAGERS
-- ══════════════════════════════════════════
ThemeManager:SetLibrary(UILibrary)
SaveManager:SetLibrary(UILibrary)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("IBdihPHub/AnimeAstralSimulator")
SaveManager:SetFolder("IBdihPHub/AnimeAstralSimulator/Settings")
SaveManager:BuildConfigSection(aas_Tabs.Settings)
ThemeManager:ApplyToTab(aas_Tabs.Settings)
SaveManager:LoadAutoloadConfig()

-- ══════════════════════════════════════════
--   CLEANUP ON UNLOAD
-- ══════════════════════════════════════════
UILibrary:OnUnload(aas_cleanup)

-- ══════════════════════════════════════════
--   FINAL NOTIFICATION
-- ══════════════════════════════════════════
UILibrary:Notify({
    Title       = "Script Loaded",
    Description = "Anime Astral Simulator v2.1 is ready!",
    Time        = 5,
})

end
