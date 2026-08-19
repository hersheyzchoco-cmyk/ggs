local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local DISCORD_LINK = "https://discord.gg/DHeCNzTypH"
local VALID_KEYS = {"ilyguys"}
local KEY_FILE = "IBdihPHub_SavedKey.txt"
local BASE_URL = "https://raw.githubusercontent.com/hersheyzchoco-cmyk/ggs/refs/heads/main/games/"
local BANNED_USERS = {"8kruo"}
local LOBBY_PLACE_IDS = {87810101348327}

local SCRIPTS = {
    { Name = "+1 Wood per Click", Icon = "🪵", File = "%2B1wood-per-click.lua", GameId = 112231208081788 },
    { Name = "1 Keyboard = 1$/s", Icon = "⌨️", File = "1keyboard%3D1%24s.lua", GameId = 121003786627094 },
    { Name = "Airline Idle", Icon = "🛩️", File = "airline-idle.lua", GameId = 70437719899064 },
    { Name = "Anime Astral Simulator", Icon = "🔥", File = "anime-astral-simulator.lua", GameId = 102072869879193 },
    { Name = "Anime Battles", Icon = "🤺", File = "anime-battles.lua", GameId = 126229277218112 },
    { Name = "Anime Capture", Icon = "🖐", File = "anime-capture.lua", GameId = 94717504417144 },
    { Name = "Anime Card Farm", Icon = "🃏", File = "anime-card-farm.lua", GameId = 125039473548047 }, 
    { Name = "Anime Dimensions Simulator - Battle", Icon = "⚔️", File = "anime-dimensions-simulator.lua", GameId = 6990129309 },
    { Name = "Anime Dimensions Simulator - High Level Lobby", Icon = "⚔️", File = "anime-dimensions-simulator.lua", GameId = 7274690025 },
    { Name = "Anime Dimensions Simulator - Lobby", Icon = "⚔️", File = "anime-dimensions-simulator.lua", GameId = 6938803436 },
    { Name = "Anime Dimensions Simulator - Raid", Icon = "⚔️", File = "anime-dimensions-simulator.lua", GameId = 7338881230 },
    { Name = "Anime Duelists", Icon = "⚔️", File = "anime-duelists.lua", GameId = 135858844777165 },
    { Name = "Anime Dungeons - Demon Train Dungeon", Icon = "🏰", File = "anime-dungeons.lua", GameId = 127204771568038 },
    { Name = "Anime Dungeons - Frozen Forest Dungeon", Icon = "🏰", File = "anime-dungeons.lua", GameId = 123509790592616 },
    { Name = "Anime Dungeons - Lobby", Icon = "🏰", File = "anime-dungeons-lobby.lua", GameId = 70863683083739 },
    { Name = "Anime Dungeons - Ninja Village Dungeon", Icon = "🏰", File = "anime-dungeons.lua", GameId = 109955310601194 },
    { Name = "Anime Dungeons - Soul Valley Dungeon", Icon = "🏰", File = "anime-dungeons.lua", GameId = 82475659339476 },
    { Name = "Anime Dungeons - Trials", Icon = "🏰", File = "anime-dungeons.lua", GameId = 70972455539417 },
    { Name = "Anime Dungeons - Raids", Icon = "🏰", File = "anime-dungeons.lua", GameId = 122377279703567 },
    { Name = "Anime Dungeons - Boss Rush", Icon = "🏰", File = "anime-dungeons.lua", GameId = 71585686583516 },
    { Name = "Anime Powerscaling Card Collection", Icon = "🌟", File = "anime-powerscaling-card-collection.lua", GameId = 85580552562948 },
    { Name = "Anime RNG Defense", Icon = "🏰", File = "anime-rng-defense.lua", GameId = 104693964860826 },
    { Name = "Anime Stars", Icon = "🌠", File = "anime-stars.lua", GameId = 122553263569744 },
    { Name = "Anime Stars Card Collection", Icon = "🌸", File = "anime-stars-card-collection.lua", GameId = 109715918987082 },
    { Name = "Anime Universe", Icon = "🌌", File = "anime-universe.lua", GameId = 95992966043247 },
    { Name = "Become an Anime Billionaire", Icon = "💸", File = "become-an-anime-billionaire.lua", GameId = 96891089305948 },
    { Name = "Bomb Fishing", Icon = "🎣", File = "bomb-fishing.lua", GameId = 118677256126351 },
    { Name = "Build a Base and Steal", Icon = "🏯", File = "build-a-base-and-steal.lua", GameId = 132016691802922 },
    { Name = "Build a Base and Steal", Icon = "🏯", File = "build-a-base-and-steal.lua", GameId = 82441325527385 },
    { Name = "Build a Gun Army", Icon = "🔫", File = "build-a-gun-army.lua", GameId = 134162299584012 },
    { Name = "Catch and Tame", Icon = "🐒", File = "catch-and-tame.lua", GameId = 96645548064314 },
    { Name = "Chicken Farm", Icon = "🐓", File = "chicken-farm.lua", GameId = 137233438285284 },
    { Name = "Clean the Squishies", Icon = "😻", File = "clean-the-squishies.lua", GameId = 84016394196827 },
    { Name = "Crab Tycoon", Icon = "🦀", File = "crab-tycoon.lua", GameId = 92605157087535 },
    { Name = "Crunch my Butter", Icon = "🧈", File = "crunch-my-butter.lua", GameId = 87555052900625 },
    { Name = "Digimon Era", Icon = "🦖", File = "digimon-era.lua", GameId = 77192431769439 },
    { Name = "Dungeon Leveling Origin", Icon = "🏰", File = "dungeon-leveling-origin.lua", GameId = 113526284476060 },
    { Name = "Egg Case Farm", Icon = "🥚", File = "egg-case-farm.lua", GameId = 74144293690546 },
    { Name = "Elemental Dungeons - Dungeon", Icon = "🏰", File = "elemental-dungeons.lua", GameId = 10771129745 },
    { Name = "Elemental Dungeons - Raids", Icon = "🏰", File = "elemental-dungeons.lua", GameId = 15278089327 },
    { Name = "Fantasy RNG", Icon = "🧚‍♂️", File = "fantasy-rng.lua", GameId = 85167011669131 },
    { Name = "Farm an Island", Icon = "🧑‍🌾", File = "farm-an-island.lua", GameId = 78769336859161 },
    { Name = "Grow it RNG", Icon = "🪴", File = "grow-it-rng.lua", GameId = 78292727217500 },
    { Name = "Hatch a Dragon", Icon = "🐲", File = "hatch-a-dragon.lua", GameId = 105420216739306 },
    { Name = "Jump to Steal Soccer Players", Icon = "⚽️", File = "jump-to-steal-soccer-players.lua", GameId = 133294838637122 },
    { Name = "Loot RNG", Icon = "🗡️", File = "loot-rng.lua", GameId = 118575129990331 },
    { Name = "Make a Drill Farm", Icon = "⛏️", File = "make-a-drill-farm.lua", GameId = 79315121100812 },
    { Name = "Make Hotsauce", Icon = "🌶️", File = "make-hotsauce.lua", GameId = 122391683154858 },
    { Name = "Merge a Blackhole", Icon = "🪐", File = "merge-a-blackhole.lua", GameId = 118605709428489 },
    { Name = "Mine a Mountain", Icon = "🏔️", File = "mine-a-mountain.lua", GameId = 125927821145949 },
    { Name = "Mine a Planet", Icon = "🌎", File = "mine-a-planet.lua", GameId = 121125129560252 },
    { Name = "Missiles vs Cities", Icon = "🚀", File = "missiles-vs-cities.lua", GameId = 112641748896693 },
    { Name = "Mount RNG", Icon = "🐶", File = "mount-rng.lua", GameId = 133341016381877 },
    { Name = "My Fishing Anime", Icon = "🪝", File = "my-fishing-anime.lua", GameId = 112244246405144 },
    { Name = "My Giant Sandwich", Icon = "🥪", File = "my-giant-sandwich.lua", GameId = 139546619723000 },
    { Name = "My Shrimp Farm", Icon = "🦐", File = "my-shrimp-farm.lua", GameId = 104065269680557 },
    { Name = "My Sword Empire", Icon = "🗡️", File = "my-sword-empire.lua", GameId = 108364799245223 },
    { Name = "My Wood Farm", Icon = "🪵", File = "my-wood-farm.lua", GameId = 79267089300389 },
    { Name = "Own a Cafe", Icon = "🍵", File = "own-a-cafe.lua", GameId = 131906518201863 },
    { Name = "Pack RNG", Icon = "📦", File = "pack-rng.lua", GameId = 117752943664280 },
    { Name = "Penguin Tycoon", Icon = "🐧", File = "penguin-tycoon.lua", GameId = 89561601601392 },
    { Name = "Place the Keycaps", Icon = "⌨️", File = "place-the-keycaps.lua", GameId = 103984418130080 },
    { Name = "RNG Heroes", Icon = "🦸", File = "rng-heroes.lua", GameId = 108307565942574 },
    { Name = "Roll a Keycap", Icon = "⌨️", File = "roll-a-keycap.lua", GameId = 91679585668032 },
    { Name = "Roll Anime Fighters", Icon = "🎲", File = "roll-anime-fighters.lua", GameId = 115113242795436 },
    { Name = "Roll Anime", Icon = "🎲", File = "roll-anime.lua", GameId = 107706720875645 },
    { Name = "Roll to Defend", Icon = "🛡️", File = "roll-to-defend.lua", GameId = 129559579789369 },
    { Name = "Scratchy Loot", Icon = "🎰", File = "scratchy-loot.lua", GameId = 78105732598311 },
    { Name = "Snowcone Stand", Icon = "❄️", File = "snowcone-stand.lua", GameId = 76113971506717 },
    { Name = "Soccer Manager", Icon = "🏟️", File = "soccer-manager.lua", GameId = 83988958116126 },
    { Name = "Spin a Car", Icon = "🏎️", File = "spin-a-car.lua", GameId = 136758055891411 },
    { Name = "Spin a Duel Monster", Icon = "🧌", File = "spin-a-duel-monster.lua", GameId = 86789126516616 },
    { Name = "Tap Incremental", Icon = "👆", File = "tap-incremental.lua", GameId = 82103875404639 },
    { Name = "Throw a Coin - World 1", Icon = "🪙", File = "throw-a-coin.lua", GameId = 115681808123944 },
    { Name = "Throw a Coin - World 2", Icon = "🪙", File = "throw-a-coin.lua", GameId = 72042130041700 },
    { Name = "Throw a Coin - World 3", Icon = "🪙", File = "throw-a-coin.lua", GameId = 100875131717601 },
    { Name = "Throw a Coin - World 4", Icon = "🪙", File = "throw-a-coin.lua", GameId = 81335362752013 },
    { Name = "World Cup Album", Icon = "🏆", File = "world-cup-album.lua", GameId = 71724366181884 },
    { Name = "Youtuber Card Collection", Icon = "💻", File = "youtuber-card-collection.lua", GameId = 81440501385895 },
    { Name = "Zombie Turret Farm", Icon = "🧟‍♂️", File = "zombie-turret-farm.lua", GameId = 70790155462881 },
}

-- ═══ HELPERS ═══
local function trim(s) return s:gsub("^%s+", ""):gsub("%s+$", "") end

local function isKeyValid(key)
    if not key or key == "" then return false end
    key = trim(key)
    for _, k in ipairs(VALID_KEYS) do
        if key == k then return true end
    end
    return false
end

local function saveKey(key) pcall(function() if writefile then writefile(KEY_FILE, key) end end) end

local function loadKey()
    local ok, res = pcall(function()
        return (isfile and readfile and isfile(KEY_FILE)) and readfile(KEY_FILE) or nil
    end)
    return ok and res or nil
end

local function isLobbyPlace()
    for _, id in ipairs(LOBBY_PLACE_IDS) do
        if game.PlaceId == id then return true end
    end
    return false
end

local function isUserBanned()
    local name = LocalPlayer.Name:lower()
    for _, banned in ipairs(BANNED_USERS) do
        if name == banned:lower() then return true end
    end
    return false
end

local function getGameScript()
    for _, s in ipairs(SCRIPTS) do
        if s.GameId == game.PlaceId then return s end
    end
end

local function launch(scriptData)
    pcall(function() loadstring(game:HttpGet(BASE_URL .. scriptData.File))() end)
end

-- ═══ UI HELPERS ═══
local function new(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then pcall(function() inst[k] = v end) end
    end
    if props.Parent then inst.Parent = props.Parent end
    return inst
end

local function corner(p, r) return new("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = p }) end
local function stroke(p, col, thick) return new("UIStroke", { Color = col or Color3.fromRGB(55,55,78), Thickness = thick or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = p }) end

local function tween(obj, props, dur, style, dir)
    if not obj or not obj.Parent then return end
    TweenService:Create(obj, TweenInfo.new(dur or 0.25, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props):Play()
end

local function label(props)
    props.BackgroundTransparency = 1
    props.Font = props.Font or Enum.Font.GothamMedium
    return new("TextLabel", props)
end

local function animateGradient(grad, bar)
    task.spawn(function()
        local t = 0
        while bar and bar.Parent do
            t += 0.03
            grad.Offset = Vector2.new(math.sin(t) * 0.4, 0)
            RunService.RenderStepped:Wait()
        end
    end)
end

local function pulseStroke(s, col1, col2)
    task.spawn(function()
        while s and s.Parent do
            tween(s, { Color = col1 }, 1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(1.2)
            tween(s, { Color = col2 }, 1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(1.2)
        end
    end)
end

local function flickerLabel(lbl)
    task.spawn(function()
        while lbl and lbl.Parent do
            tween(lbl, { TextTransparency = 0.6 }, 0.08)
            task.wait(0.1)
            tween(lbl, { TextTransparency = 0 }, 0.08)
            task.wait(math.random(20, 60) / 10)
        end
    end)
end

local function animateCardIn(backdrop, card, cardStroke)
    task.wait(0.2)
    tween(backdrop, { BackgroundTransparency = 0.3 }, 0.6, Enum.EasingStyle.Quart)
    task.wait(0.1)
    tween(card, { Size = UDim2.new(0, 480, 0, 268), BackgroundTransparency = 0 }, 0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    tween(cardStroke, { Transparency = 0 }, 0.5)
    task.wait(0.8)
end

local function buildInfoCard(guiName, accentColor, icon, title, titleColor, message, subText, subColor, buttonText, buttonColor, buttonHover, buttonAction, footerText)
    for _, name in ipairs({"IBdihPLoader", guiName}) do
        if CoreGui:FindFirstChild(name) then CoreGui[name]:Destroy() end
    end

    local Gui = new("ScreenGui", { Name = guiName, ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = CoreGui })
    local Backdrop = new("Frame", { Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.fromRGB(0,0,0), BackgroundTransparency = 1, ZIndex = 1, Parent = Gui })

    local Card = new("Frame", {
        Name = "Card", Size = UDim2.new(0,480,0,0),
        Position = UDim2.new(0.5,0,0.5,0), AnchorPoint = Vector2.new(0.5,0.5),
        BackgroundColor3 = Color3.fromRGB(15,10,10), BackgroundTransparency = 1,
        ClipsDescendants = true, ZIndex = 2, Parent = Gui,
    })
    corner(Card, 16)
    local cardStroke = stroke(Card, accentColor, 2)
    cardStroke.Transparency = 1

    local Bar = new("Frame", { Size = UDim2.new(1,0,0,4), BackgroundColor3 = accentColor, BorderSizePixel = 0, ZIndex = 15, Parent = Card })
    local barGrad = new("UIGradient", { Parent = Bar })
    animateGradient(barGrad, Bar)

    label({ Size = UDim2.new(1,0,0,60), Position = UDim2.new(0,0,0,18), Text = icon, TextColor3 = Color3.fromRGB(255,255,255), TextSize = 42, Font = Enum.Font.GothamBold, ZIndex = 6, Parent = Card })
    local titleLabel = label({ Size = UDim2.new(1,-40,0,30), Position = UDim2.new(0,20,0,82), Text = title, TextColor3 = titleColor, TextSize = 22, Font = Enum.Font.GothamBold, ZIndex = 6, Parent = Card })
    new("Frame", { Size = UDim2.new(0.6,0,0,1), Position = UDim2.new(0.2,0,0,118), BackgroundColor3 = accentColor, BackgroundTransparency = 0.5, BorderSizePixel = 0, ZIndex = 6, Parent = Card })
    label({ Size = UDim2.new(1,-60,0,40), Position = UDim2.new(0,30,0,128), Text = message, TextColor3 = Color3.fromRGB(220,220,220), TextSize = 14, Font = Enum.Font.GothamMedium, TextWrapped = true, ZIndex = 6, Parent = Card })
    label({ Size = UDim2.new(1,-60,0,20), Position = UDim2.new(0,30,0,172), Text = subText, TextColor3 = subColor, TextSize = 11, Font = Enum.Font.GothamMedium, ZIndex = 6, Parent = Card })

    local Btn = new("TextButton", { Size = UDim2.new(0,180,0,36), Position = UDim2.new(0.5,-90,0,200), BackgroundColor3 = buttonColor, Text = buttonText, TextColor3 = Color3.fromRGB(255,255,255), TextSize = 13, Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 8, Parent = Card })
    corner(Btn, 10)
    Btn.MouseEnter:Connect(function() tween(Btn, { BackgroundColor3 = buttonHover }, 0.15) end)
    Btn.MouseLeave:Connect(function() tween(Btn, { BackgroundColor3 = buttonColor }, 0.2) end)
    Btn.MouseButton1Click:Connect(function() buttonAction(Btn, Card, Backdrop, cardStroke) end)

    label({ Size = UDim2.new(1,-40,0,16), Position = UDim2.new(0,20,1,-26), Text = footerText, TextColor3 = Color3.fromRGB(80,50,50), TextSize = 10, Font = Enum.Font.GothamMedium, ZIndex = 6, Parent = Card })

    animateCardIn(Backdrop, Card, cardStroke)
    flickerLabel(titleLabel)
    pulseStroke(cardStroke,
        Color3.fromRGB(accentColor.R*180, accentColor.G*20, accentColor.B*20),
        accentColor
    )
end

local function buildBanScreen()
    buildInfoCard(
        "IBdihPBanned",
        Color3.fromRGB(255, 50, 50),
        "❗️", "BANNED!", Color3.fromRGB(255, 60, 60),
        "early christmas gift! 🎁💞",
        "account: " .. LocalPlayer.Name .. " (" .. tostring(LocalPlayer.UserId) .. ")",
        Color3.fromRGB(120, 80, 80),
        "💬  Join Discord", Color3.fromRGB(88, 101, 242), Color3.fromRGB(110, 122, 255),
        function(btn)
            pcall(function() if setclipboard then setclipboard(DISCORD_LINK) end end)
            btn.Text = "✓  Copied!"
            task.delay(2, function() if btn and btn.Parent then btn.Text = "💬  Join Discord" end end)
        end,
        "access permanently revoked — appeals will not be accepted"
    )
end

local function buildLobbyScreen()
    buildInfoCard(
        "IBdihPLobby",
        Color3.fromRGB(255, 200, 60),
        "⚠️", "YOU'RE IN THE LOBBY", Color3.fromRGB(255, 200, 60),
        "Please execute inside one of the gamemodes!\nThe script cannot run from the lobby.",
        "current place: " .. tostring(game.PlaceId) .. " (lobby)",
        Color3.fromRGB(120, 110, 60),
        "✕  Close", Color3.fromRGB(60, 55, 30), Color3.fromRGB(80, 75, 40),
        function(_, card, backdrop, cardStroke)
            tween(card, { Size = UDim2.new(0,480,0,0), BackgroundTransparency = 1 }, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            tween(backdrop, { BackgroundTransparency = 1 }, 0.35)
            tween(cardStroke, { Transparency = 1 }, 0.3)
            task.wait(0.4)
            if CoreGui:FindFirstChild("IBdihPLobby") then CoreGui.IBdihPLobby:Destroy() end
        end,
        "select a gamemode first, then re-execute the script"
    )
end

-- ═══ CHECKS ═══
if isUserBanned() then buildBanScreen(); return end
if isLobbyPlace() then buildLobbyScreen(); return end

-- ═══ AUTO-LAUNCH ═══
local savedKey = loadKey()
local gameScript = getGameScript()

if isKeyValid(savedKey) and gameScript then
    launch(gameScript); return
end

-- ═══ COLORS ═══
local C = {
    bg          = Color3.fromRGB(20, 20, 30),
    card        = Color3.fromRGB(32, 32, 48),
    surface     = Color3.fromRGB(36, 36, 52),
    surfaceL    = Color3.fromRGB(44, 44, 62),
    accent      = Color3.fromRGB(140, 120, 255),
    accentH     = Color3.fromRGB(160, 142, 255),
    accentP     = Color3.fromRGB(120, 100, 230),
    accentGhost = Color3.fromRGB(50, 42, 85),
    accentSoft  = Color3.fromRGB(65, 55, 110),
    discord     = Color3.fromRGB(88, 101, 242),
    discordH    = Color3.fromRGB(110, 122, 255),
    discordP    = Color3.fromRGB(72, 84, 220),
    success     = Color3.fromRGB(70, 220, 130),
    error       = Color3.fromRGB(255, 90, 90),
    errorBg     = Color3.fromRGB(60, 25, 25),
    warning     = Color3.fromRGB(255, 200, 60),
    text        = Color3.fromRGB(250, 250, 255),
    textB       = Color3.fromRGB(255, 255, 255),
    textS       = Color3.fromRGB(185, 185, 210),
    textM       = Color3.fromRGB(120, 120, 150),
    border      = Color3.fromRGB(55, 55, 78),
    borderF     = Color3.fromRGB(140, 120, 255),
    inputBg     = Color3.fromRGB(24, 24, 38),
    inputBgF    = Color3.fromRGB(30, 28, 48),
}

-- ═══ MORE UI HELPERS ═══
local function setupHover(btn, normal, hover, press)
    btn.MouseEnter:Connect(function() tween(btn, { BackgroundColor3 = hover }, 0.15) end)
    btn.MouseLeave:Connect(function() tween(btn, { BackgroundColor3 = normal }, 0.2) end)
    btn.MouseButton1Down:Connect(function() tween(btn, { BackgroundColor3 = press or hover }, 0.05) end)
    btn.MouseButton1Up:Connect(function() tween(btn, { BackgroundColor3 = hover }, 0.1) end)
end

local function makeBtn(props, parent)
    local btn = new("TextButton", {
        Size = props.size, Position = props.pos,
        BackgroundColor3 = props.col, Text = "",
        AutoButtonColor = false, ZIndex = props.z or 7,
        ClipsDescendants = true, Parent = parent,
    })
    corner(btn, 10)
    label({ Size = UDim2.new(1,0,1,0), Text = props.text, TextColor3 = C.textB, TextSize = props.ts or 12, Font = Enum.Font.GothamBold, ZIndex = (props.z or 7)+1, Parent = btn })
    setupHover(btn, props.col, props.hov, props.press)
    return btn
end

-- ═══ BUILD MAIN GUI ═══
if CoreGui:FindFirstChild("IBdihPLoader") then CoreGui.IBdihPLoader:Destroy() end

local Gui = new("ScreenGui", { Name = "IBdihPLoader", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = CoreGui })
local Backdrop = new("Frame", { Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.fromRGB(0,0,0), BackgroundTransparency = 1, ZIndex = 1, Parent = Gui })

local CW, CH = 520, 330
local Card = new("Frame", {
    Name = "Card", Size = UDim2.new(0,CW,0,0),
    Position = UDim2.new(0.5,0,0.5,0), AnchorPoint = Vector2.new(0.5,0.5),
    BackgroundColor3 = C.bg, BackgroundTransparency = 1,
    ClipsDescendants = true, ZIndex = 2, Parent = Gui,
})
corner(Card, 16)
local cardStroke = stroke(Card, C.border, 1)
cardStroke.Transparency = 1

local AccentBar = new("Frame", { Size = UDim2.new(1,0,0,3), BackgroundColor3 = C.accent, BorderSizePixel = 0, ZIndex = 15, Parent = Card })
local accentGrad = new("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(140,120,255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200,140,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100,180,255)),
    }),
    Parent = AccentBar,
})
task.spawn(function()
    local t = 0
    while AccentBar and AccentBar.Parent do
        t += 0.02
        accentGrad.Offset = Vector2.new(math.sin(t) * 0.4, 0)
        accentGrad.Rotation = math.sin(t * 0.5) * 25
        RunService.RenderStepped:Wait()
    end
end)

task.wait(0.15)
tween(Backdrop, { BackgroundTransparency = 0.5 }, 0.5)
task.wait(0.05)
tween(Card, { Size = UDim2.new(0,CW,0,CH), BackgroundTransparency = 0 }, 0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
tween(cardStroke, { Transparency = 0 }, 0.4)
task.wait(0.55)

local CloseBtn = new("TextButton", { Size = UDim2.new(0,30,0,30), Position = UDim2.new(1,-40,0,10), BackgroundColor3 = C.surface, BackgroundTransparency = 0.4, Text = "✕", TextColor3 = C.textM, TextSize = 15, Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 20, Parent = Card })
corner(CloseBtn, 8)
CloseBtn.MouseEnter:Connect(function() tween(CloseBtn, { BackgroundTransparency = 0, BackgroundColor3 = C.errorBg, TextColor3 = C.error }, 0.15) end)
CloseBtn.MouseLeave:Connect(function() tween(CloseBtn, { BackgroundTransparency = 0.4, BackgroundColor3 = C.surface, TextColor3 = C.textM }, 0.2) end)
CloseBtn.MouseButton1Click:Connect(function()
    tween(Card, { Size = UDim2.new(0,CW,0,0), BackgroundTransparency = 1 }, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    tween(Backdrop, { BackgroundTransparency = 1 }, 0.35)
    task.wait(0.4); Gui:Destroy()
end)

local Content = new("Frame", { Size = UDim2.new(1,-68,1,-56), Position = UDim2.new(0,34,0,28), BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 4, Parent = Card })

local function closeThenLaunch(scriptData)
    tween(Card, { Size = UDim2.new(0,CW,0,0), BackgroundTransparency = 1 }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    tween(Backdrop, { BackgroundTransparency = 1 }, 0.4)
    task.wait(0.5); Gui:Destroy(); launch(scriptData)
end

local function transitionTo(fromPage, toPage)
    tween(fromPage, { Position = UDim2.new(-1.2,0,0,0) }, 0.4)
    task.wait(0.1)
    toPage.Visible = true
    toPage.Position = UDim2.new(1.2,0,0,0)
    tween(toPage, { Position = UDim2.new(0,0,0,0) }, 0.4)
end

-- ═══ KEY PAGE ═══
local KeyPage = new("Frame", { Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Visible = true, ZIndex = 5, Parent = Content })

local LogoMark = new("Frame", { Size = UDim2.new(0,40,0,40), Position = UDim2.new(0,0,0,2), BackgroundColor3 = C.accentGhost, ZIndex = 6, Parent = KeyPage })
corner(LogoMark, 12); stroke(LogoMark, C.accent, 1)
label({ Size = UDim2.new(1,0,1,0), Text = "✦", TextColor3 = C.accent, TextSize = 20, Font = Enum.Font.GothamBold, ZIndex = 7, Parent = LogoMark })
label({ Size = UDim2.new(0,200,0,20), Position = UDim2.new(0,52,0,3), Text = "IBdihP Hub", TextColor3 = C.textB, TextSize = 18, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6, Parent = KeyPage })
label({ Size = UDim2.new(0,200,0,14), Position = UDim2.new(0,52,0,25), Text = "script loader  v3.0", TextColor3 = C.textS, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6, Parent = KeyPage })
new("Frame", { Size = UDim2.new(1,0,0,1), Position = UDim2.new(0,0,0,54), BackgroundColor3 = C.border, BorderSizePixel = 0, ZIndex = 5, Parent = KeyPage })
label({ Size = UDim2.new(1,0,0,16), Position = UDim2.new(0,0,0,68), Text = "Welcome, " .. LocalPlayer.Name .. " 👋", TextColor3 = C.text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5, Parent = KeyPage })
label({ Size = UDim2.new(1,0,0,14), Position = UDim2.new(0,0,0,87), Text = gameScript and ("✓  " .. gameScript.Name) or "⚠  This game is not supported", TextColor3 = gameScript and C.success or C.warning, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5, Parent = KeyPage })

label({ Size = UDim2.new(1,0,0,12), Position = UDim2.new(0,0,0,114), Text = "ENTER KEY", TextColor3 = C.textM, TextSize = 9, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5, Parent = KeyPage })
local InputWrap = new("Frame", { Size = UDim2.new(1,0,0,44), Position = UDim2.new(0,0,0,132), BackgroundColor3 = C.inputBg, ZIndex = 6, Parent = KeyPage })
corner(InputWrap, 10)
local inputStroke = stroke(InputWrap, C.border, 1.5)
label({ Size = UDim2.new(0,34,1,0), Position = UDim2.new(0,4,0,0), Text = "🔑", TextSize = 14, ZIndex = 7, Parent = InputWrap })
local KeyInput = new("TextBox", { Size = UDim2.new(1,-48,1,0), Position = UDim2.new(0,38,0,0), BackgroundTransparency = 1, Text = "", PlaceholderText = "enter your key here...", PlaceholderColor3 = C.textM, TextColor3 = C.textB, TextSize = 13, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, ZIndex = 7, Parent = InputWrap })

KeyInput.Focused:Connect(function() tween(inputStroke, { Color = C.borderF }, 0.2); tween(InputWrap, { BackgroundColor3 = C.inputBgF }, 0.2) end)
KeyInput.FocusLost:Connect(function() tween(inputStroke, { Color = C.border }, 0.25); tween(InputWrap, { BackgroundColor3 = C.inputBg }, 0.25) end)

local StatusMsg = label({ Size = UDim2.new(1,0,0,16), Position = UDim2.new(0,0,0,184), Text = "", TextColor3 = C.error, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5, Parent = KeyPage })
label({ Size = UDim2.new(1,0,0,14), Position = UDim2.new(0,0,0,204), Text = "free permanent key in our discord — saves automatically ♡", TextColor3 = C.textM, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 5, Parent = KeyPage })

local BtnRow = new("Frame", { Size = UDim2.new(1,0,0,44), Position = UDim2.new(0,0,1,-44), BackgroundTransparency = 1, ZIndex = 6, Parent = KeyPage })
local DiscordBtn = makeBtn({ size = UDim2.new(0,108,1,0), pos = UDim2.new(0,0,0,0),   col = C.discord, hov = C.discordH, press = C.discordP, text = "💬  Get Key",        ts = 12 }, BtnRow)
local PasteBtn   = makeBtn({ size = UDim2.new(0,76,1,0),  pos = UDim2.new(0,116,0,0), col = C.surface, hov = C.surfaceL,                     text = "📋 Paste",          ts = 11 }, BtnRow)
local VerifyBtn  = makeBtn({ size = UDim2.new(1,-200,1,0),pos = UDim2.new(0,200,0,0), col = C.accent,  hov = C.accentH,  press = C.accentP,   text = "Verify & Launch  →", ts = 13 }, BtnRow)
local VerifyLabel = VerifyBtn:FindFirstChildWhichIsA("TextLabel")

-- ═══ UNSUPPORTED PAGE ═══
local UnsupportedPage = new("Frame", { Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Visible = false, ZIndex = 5, Parent = Content })
label({ Size = UDim2.new(1,0,0,50), Position = UDim2.new(0,0,0,20), Text = "😔", TextSize = 42, ZIndex = 6, Parent = UnsupportedPage })
label({ Size = UDim2.new(1,0,0,24), Position = UDim2.new(0,0,0,78), Text = "Game Not Supported", TextColor3 = C.text, TextSize = 18, Font = Enum.Font.GothamBold, ZIndex = 6, Parent = UnsupportedPage })
label({ Size = UDim2.new(1,0,0,16), Position = UDim2.new(0,0,0,108), Text = "IBdihP Hub doesn't support this game yet. Join our Discord to request it!", TextColor3 = C.textS, TextSize = 11, ZIndex = 6, Parent = UnsupportedPage })
local UnsupDiscord = makeBtn({ size = UDim2.new(0,180,0,42), pos = UDim2.new(0.5,-90,1,-50), col = C.discord, hov = C.discordH, press = C.discordP, text = "💬  Join Discord", ts = 13, z = 7 }, UnsupportedPage)
UnsupDiscord.MouseButton1Click:Connect(function()
    pcall(function() if setclipboard then setclipboard(DISCORD_LINK) end end)
    local lbl = UnsupDiscord:FindFirstChildWhichIsA("TextLabel")
    if lbl then lbl.Text = "✓  Copied!"; task.delay(2, function() if lbl and lbl.Parent then lbl.Text = "💬  Join Discord" end end) end
end)

-- ═══ LAUNCH PAGE ═══
local LaunchPage = new("Frame", { Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Visible = false, ZIndex = 5, Parent = Content })

local spinnerDots = {}
local SpinnerWrap = new("Frame", { Size = UDim2.new(0,50,0,50), Position = UDim2.new(0.5,-25,0,40), BackgroundTransparency = 1, ZIndex = 6, Parent = LaunchPage })
local dotColors = { Color3.fromRGB(140,120,255), Color3.fromRGB(180,140,255), Color3.fromRGB(100,180,255) }
for i = 1, 3 do
    local dot = new("Frame", { Size = UDim2.new(0,10,0,10), Position = UDim2.new(0,(i-1)*18+2,0.5,-5), BackgroundColor3 = dotColors[i], ZIndex = 7, Parent = SpinnerWrap })
    corner(dot, 5); spinnerDots[i] = dot
end
task.spawn(function()
    while SpinnerWrap and SpinnerWrap.Parent do
        for i, dot in ipairs(spinnerDots) do
            task.delay((i-1)*0.15, function()
                if not (dot and dot.Parent) then return end
                tween(dot, { Position = dot.Position - UDim2.new(0,0,0,12) }, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                task.wait(0.2)
                if dot and dot.Parent then tween(dot, { Position = dot.Position + UDim2.new(0,0,0,12) }, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In) end
            end)
        end
        task.wait(0.9)
    end
end)

local LaunchTitle = label({ Size = UDim2.new(1,0,0,22), Position = UDim2.new(0,0,0,105), Text = "Launching Script...", TextColor3 = C.text, TextSize = 17, Font = Enum.Font.GothamBold, ZIndex = 6, Parent = LaunchPage })
local LaunchSub   = label({ Size = UDim2.new(1,0,0,16), Position = UDim2.new(0,0,0,132), Text = "", TextColor3 = C.textS, TextSize = 12, ZIndex = 6, Parent = LaunchPage })
label({ Size = UDim2.new(1,0,0,14), Position = UDim2.new(0,0,1,-30), Text = "key saved — you won't need to enter it again ✓", TextColor3 = C.success, TextSize = 10, ZIndex = 6, Parent = LaunchPage })

-- ═══ BUTTON LOGIC ═══
DiscordBtn.MouseButton1Click:Connect(function()
    pcall(function() if setclipboard then setclipboard(DISCORD_LINK) end end)
    StatusMsg.Text = "🔗  Discord invite copied!"; StatusMsg.TextColor3 = C.discord
    task.delay(3, function()
        if not (StatusMsg and StatusMsg.Parent) then return end
        tween(StatusMsg, { TextTransparency = 1 }, 0.3)
        task.wait(0.35)
        if StatusMsg and StatusMsg.Parent then StatusMsg.Text = ""; StatusMsg.TextTransparency = 0 end
    end)
end)

PasteBtn.MouseButton1Click:Connect(function()
    pcall(function() if getclipboard then KeyInput.Text = getclipboard() end end)
end)

local function shakeInput()
    local orig = InputWrap.Position
    for _ = 1, 4 do
        tween(InputWrap, { Position = orig + UDim2.new(0,6,0,0) }, 0.035, Enum.EasingStyle.Linear)
        task.wait(0.04)
        tween(InputWrap, { Position = orig - UDim2.new(0,6,0,0) }, 0.035, Enum.EasingStyle.Linear)
        task.wait(0.04)
    end
    tween(InputWrap, { Position = orig }, 0.06)
end

local function showStatus(msg, col)
    StatusMsg.Text = msg; StatusMsg.TextColor3 = col; StatusMsg.TextTransparency = 0
end

local verifying = false
local function doVerify()
    if verifying then return end
    local key = trim(KeyInput.Text)

    if key == "" then
        showStatus("⚠  please enter a key", C.warning)
        shakeInput(); return
    end

    verifying = true
    VerifyLabel.Text = "Verifying..."
    tween(VerifyBtn, { BackgroundColor3 = C.accentSoft }, 0.15)
    task.wait(0.6)

    if isKeyValid(key) then
        saveKey(key)
        showStatus("✓  Key verified!", C.success)
        tween(VerifyBtn, { BackgroundColor3 = C.success }, 0.2)
        tween(inputStroke, { Color = C.success }, 0.2)
        VerifyLabel.Text = "✓  Verified!"
        task.wait(0.7)

        if gameScript then
            LaunchSub.Text = gameScript.Icon .. "  " .. gameScript.Name
            transitionTo(KeyPage, LaunchPage)
            task.wait(1.5)
            closeThenLaunch(gameScript)
        else
            transitionTo(KeyPage, UnsupportedPage)
        end
    else
        showStatus("✗  Invalid key — join Discord for a free key", C.error)
        tween(inputStroke, { Color = C.error }, 0.15)
        shakeInput()
        task.delay(3.5, function()
            tween(inputStroke, { Color = C.border }, 0.3)
            if not (StatusMsg and StatusMsg.Parent) then return end
            tween(StatusMsg, { TextTransparency = 1 }, 0.4)
            task.wait(0.4)
            if StatusMsg and StatusMsg.Parent then StatusMsg.Text = ""; StatusMsg.TextTransparency = 0 end
        end)
        VerifyLabel.Text = "Verify & Launch  →"
        tween(VerifyBtn, { BackgroundColor3 = C.accent }, 0.2)
        verifying = false
    end
end

VerifyBtn.MouseButton1Click:Connect(doVerify)
KeyInput.FocusLost:Connect(function(enter) if enter then doVerify() end end)

-- ═══ DRAGGING ═══
local dragging, dragInput, dragStart, startPos
Card.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)
    and (input.Position.Y - Card.AbsolutePosition.Y) <= 55 then
        dragging = true; dragStart = input.Position; startPos = Card.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
Card.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local d = input.Position - dragStart
        Card.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

-- ═══ LOGO PULSE ═══
task.spawn(function()
    while LogoMark and LogoMark.Parent do
        tween(LogoMark, { BackgroundColor3 = C.accentSoft }, 1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(1.8)
        tween(LogoMark, { BackgroundColor3 = C.accentGhost }, 1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(1.8)
    end
end)
