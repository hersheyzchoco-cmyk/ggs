local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- ═══ CONFIGURATION ═══
local VALID_KEYS = {
    "ilyguys"
}

local DISCORD_LINK = "https://discord.gg/DHeCNzTypH"
local KEY_SAVE_NAME = "IBdihPHub_SavedKey.txt"

local SCRIPTS = {
    {
        Name = "World Cup Album",
        Description = "Auto collect, buy & open packs, equip best, stick cards, sell dupes",
        Icon = "🏆",
        URL = "https://raw.githubusercontent.com/hersheyzchoco-cmyk/awcc/refs/heads/main/worldcup.lua",
        GameId = 71724366181884,
    },
    {
        Name = "Anime Stars Card Collection",
        Description = "Auto buy, auto grade, auto tokens, auto showdown, and more",
        Icon = "🌸",
        URL = "https://raw.githubusercontent.com/hersheyzchoco-cmyk/awcc/refs/heads/main/ascc.lua",
        GameId = 109715918987082,
    },
    {
        Name = "Anime Powerscaling Card Collection",
        Description = "Auto buy, auto grade, auto tokens, etc",
        Icon = "🌟",
        URL = "https://raw.githubusercontent.com/hersheyzchoco-cmyk/awcc/refs/heads/main/apcc.lua",
        GameId = 85580552562948,
    },
    {
        Name = "Anime Astral Simulator",
        Description = "Auto mobs, auto trial, auto gate, auto raid, auto craft and more",
        Icon = "🔥",
        URL = "https://raw.githubusercontent.com/hersheyzchoco-cmyk/awcc/refs/heads/main/astral.lua",
        GameId = 113236157544232,
    },
    {
        Name = "Youtuber Card Collection",
        Description = "Auto buy, auto grade, auto tokens, and more",
        Icon = "💻",
        URL = "https://raw.githubusercontent.com/hersheyzchoco-cmyk/awcc/refs/heads/main/ycc.lua",
        GameId = 81440501385895,
    },
    {
        Name = "Sports Card Collection",
        Description = "Auto buy, auto grade, auto tokens, and more",
        Icon = "⚡",
        URL = "https://raw.githubusercontent.com/hersheyzchoco-cmyk/awcc/refs/heads/main/sports.lua",
        GameId = 72831706183896,
    },
}

-- ═══ FIND MATCHING SCRIPT ═══
local currentGameScript = nil
for _, scriptData in ipairs(SCRIPTS) do
    if scriptData.GameId == game.PlaceId then
        currentGameScript = scriptData
        break
    end
end

-- ═══ KEY SAVE/LOAD ═══
local function saveKey(key)
    pcall(function()
        if writefile then
            writefile(KEY_SAVE_NAME, key)
        end
    end)
end

local function loadSavedKey()
    local success, result = pcall(function()
        if isfile and readfile and isfile(KEY_SAVE_NAME) then
            return readfile(KEY_SAVE_NAME)
        end
        return nil
    end)
    if success then return result end
    return nil
end

local function isKeyValid(key)
    if not key or key == "" then return false end
    key = key:gsub("^%s+", ""):gsub("%s+$", "")
    for _, k in ipairs(VALID_KEYS) do
        if key == k then return true end
    end
    return false
end

-- ═══ CHECK SAVED KEY — AUTO LAUNCH ═══
local savedKey = loadSavedKey()
if isKeyValid(savedKey) and currentGameScript then
    -- Key already saved and game is supported — skip UI entirely
    pcall(function()
        loadstring(game:HttpGet(currentGameScript.URL))()
    end)
    return
end

-- ═══ COLOR SYSTEM (more colorful, readable) ═══
local C = {
    -- Backgrounds
    bg              = Color3.fromRGB(20, 20, 30),
    bgLight         = Color3.fromRGB(28, 28, 42),
    card            = Color3.fromRGB(32, 32, 48),
    cardHover       = Color3.fromRGB(40, 40, 58),
    cardActive      = Color3.fromRGB(45, 42, 65),
    surface         = Color3.fromRGB(36, 36, 52),
    surfaceLight    = Color3.fromRGB(44, 44, 62),

    -- Accent (vibrant purple-blue)
    accent          = Color3.fromRGB(140, 120, 255),
    accentHover     = Color3.fromRGB(160, 142, 255),
    accentPress     = Color3.fromRGB(120, 100, 230),
    accentGhost     = Color3.fromRGB(50, 42, 85),
    accentSoft      = Color3.fromRGB(65, 55, 110),

    -- Secondary accent (warm)
    warm            = Color3.fromRGB(255, 160, 100),
    warmSoft        = Color3.fromRGB(80, 50, 35),

    -- Status
    success         = Color3.fromRGB(70, 220, 130),
    successBg       = Color3.fromRGB(25, 60, 40),
    successSoft     = Color3.fromRGB(40, 80, 55),
    error           = Color3.fromRGB(255, 90, 90),
    errorBg         = Color3.fromRGB(60, 25, 25),
    warning         = Color3.fromRGB(255, 200, 60),

    -- Text (brighter, more readable)
    text            = Color3.fromRGB(250, 250, 255),
    textBright      = Color3.fromRGB(255, 255, 255),
    textSecondary   = Color3.fromRGB(185, 185, 210),
    textMuted       = Color3.fromRGB(120, 120, 150),
    textOnAccent    = Color3.fromRGB(255, 255, 255),

    -- Borders
    border          = Color3.fromRGB(55, 55, 78),
    borderLight     = Color3.fromRGB(70, 70, 95),
    borderFocus     = Color3.fromRGB(140, 120, 255),

    -- Input
    inputBg         = Color3.fromRGB(24, 24, 38),
    inputBgFocus    = Color3.fromRGB(30, 28, 48),

    -- Discord
    discord         = Color3.fromRGB(88, 101, 242),
    discordHover    = Color3.fromRGB(110, 122, 255),
    discordPress    = Color3.fromRGB(72, 84, 220),

    -- Base
    white           = Color3.fromRGB(255, 255, 255),
    black           = Color3.fromRGB(0, 0, 0),
}

-- ═══ CLEANUP ═══
if CoreGui:FindFirstChild("IBdihPLoader") then
    CoreGui:FindFirstChild("IBdihPLoader"):Destroy()
end

-- ═══ INSTANCE FACTORY ═══
local function new(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then
            pcall(function() inst[k] = v end)
        end
    end
    if props.Parent then inst.Parent = props.Parent end
    return inst
end

local function corner(parent, r)
    return new("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = parent })
end

local function stroke(parent, color, thickness, trans)
    return new("UIStroke", {
        Color = color or C.border,
        Thickness = thickness or 1,
        Transparency = trans or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent,
    })
end

-- ═══ TWEEN UTILITY ═══
local function tween(obj, props, dur, style, dir)
    if not obj or not obj.Parent then return end
    local t = TweenService:Create(obj, TweenInfo.new(
        dur or 0.25,
        style or Enum.EasingStyle.Quart,
        dir or Enum.EasingDirection.Out
    ), props)
    t:Play()
    return t
end

-- ═══ RIPPLE EFFECT ═══
local function createRipple(button, x, y)
    if not button or not button.Parent then return end
    local absPos = button.AbsolutePosition
    local absSize = button.AbsoluteSize
    local localX = x - absPos.X
    local localY = y - absPos.Y
    local maxDist = math.max(
        math.sqrt(localX^2 + localY^2),
        math.sqrt((absSize.X - localX)^2 + localY^2),
        math.sqrt(localX^2 + (absSize.Y - localY)^2),
        math.sqrt((absSize.X - localX)^2 + (absSize.Y - localY)^2)
    )
    local ripple = new("Frame", {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0, localX, 0, localY),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = C.white,
        BackgroundTransparency = 0.82,
        ZIndex = 99,
        Parent = button,
    })
    corner(ripple, 9999)
    local size = maxDist * 2
    tween(ripple, { Size = UDim2.new(0, size, 0, size), BackgroundTransparency = 1 }, 0.55)
    task.delay(0.6, function() if ripple and ripple.Parent then ripple:Destroy() end end)
end

-- ═══ HOVER SETUP ═══
local function setupHover(btn, normalCol, hoverCol, pressCol)
    btn.MouseEnter:Connect(function()
        tween(btn, { BackgroundColor3 = hoverCol }, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, { BackgroundColor3 = normalCol }, 0.2)
    end)
    btn.MouseButton1Down:Connect(function()
        tween(btn, { BackgroundColor3 = pressCol or hoverCol }, 0.05)
    end)
    btn.MouseButton1Up:Connect(function()
        tween(btn, { BackgroundColor3 = hoverCol }, 0.1)
    end)
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            createRipple(btn, input.Position.X, input.Position.Y)
        end
    end)
end

-- ═══ MAIN GUI ═══
local Gui = new("ScreenGui", {
    Name = "IBdihPLoader",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
    Parent = CoreGui,
})

-- Backdrop
local Backdrop = new("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = C.black,
    BackgroundTransparency = 1,
    ZIndex = 1,
    Parent = Gui,
})

-- ═══ MAIN CARD ═══
local cardWidth = 530
local cardHeight = 340
local Card = new("Frame", {
    Name = "Card",
    Size = UDim2.new(0, cardWidth, 0, cardHeight),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = C.bg,
    BackgroundTransparency = 1,
    ClipsDescendants = true,
    ZIndex = 2,
    Parent = Gui,
})
corner(Card, 16)
local cardStroke = stroke(Card, C.border, 1, 1)

-- Accent bar at top (animated gradient)
local AccentBar = new("Frame", {
    Size = UDim2.new(1, 0, 0, 3),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = C.accent,
    BorderSizePixel = 0,
    ZIndex = 15,
    Parent = Card,
})

local accentGrad = new("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(140, 120, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 140, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 180, 255)),
    }),
    Rotation = 0,
    Parent = AccentBar,
})

task.spawn(function()
    local t = 0
    while AccentBar and AccentBar.Parent do
        t = t + 0.02
        accentGrad.Offset = Vector2.new(math.sin(t) * 0.4, 0)
        accentGrad.Rotation = math.sin(t * 0.5) * 25
        RunService.RenderStepped:Wait()
    end
end)

-- Subtle top glow
local TopGlow = new("Frame", {
    Size = UDim2.new(1, 0, 0, 100),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = C.accent,
    ZIndex = 3,
    Parent = Card,
})
new("UIGradient", {
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.9),
        NumberSequenceKeypoint.new(1, 1),
    }),
    Rotation = 90,
    Parent = TopGlow,
})

-- ═══ INTRO ANIMATION ═══
Card.Size = UDim2.new(0, cardWidth, 0, 0)
task.wait(0.15)
tween(Backdrop, { BackgroundTransparency = 0.5 }, 0.5)
task.wait(0.05)
tween(Card, {
    Size = UDim2.new(0, cardWidth, 0, cardHeight),
    BackgroundTransparency = 0,
}, 0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
tween(cardStroke, { Transparency = 0 }, 0.4)
task.wait(0.55)

-- ═══ CLOSE BUTTON ═══
local CloseBtn = new("TextButton", {
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -40, 0, 10),
    BackgroundColor3 = C.surface,
    BackgroundTransparency = 0.4,
    Text = "",
    AutoButtonColor = false,
    ZIndex = 20,
    Parent = Card,
})
corner(CloseBtn, 8)

local CloseX = new("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "✕",
    TextColor3 = C.textMuted,
    TextSize = 15,
    Font = Enum.Font.GothamBold,
    ZIndex = 21,
    Parent = CloseBtn,
})

CloseBtn.MouseEnter:Connect(function()
    tween(CloseBtn, { BackgroundTransparency = 0, BackgroundColor3 = C.errorBg }, 0.15)
    tween(CloseX, { TextColor3 = C.error }, 0.15)
end)
CloseBtn.MouseLeave:Connect(function()
    tween(CloseBtn, { BackgroundTransparency = 0.4, BackgroundColor3 = C.surface }, 0.2)
    tween(CloseX, { TextColor3 = C.textMuted }, 0.2)
end)
CloseBtn.MouseButton1Click:Connect(function()
    tween(Card, { Size = UDim2.new(0, cardWidth, 0, 0), BackgroundTransparency = 1 }, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    tween(cardStroke, { Transparency = 1 }, 0.25)
    tween(Backdrop, { BackgroundTransparency = 1 }, 0.35)
    task.wait(0.4)
    Gui:Destroy()
end)

-- ═══ CONTENT AREA ═══
local Content = new("Frame", {
    Size = UDim2.new(1, -68, 1, -56),
    Position = UDim2.new(0, 34, 0, 28),
    BackgroundTransparency = 1,
    ClipsDescendants = true,
    ZIndex = 4,
    Parent = Card,
})

-- ═══ HELPER: EXECUTE AND CLOSE ═══
local function executeAndClose(scriptData)
    tween(Card, {
        Size = UDim2.new(0, cardWidth, 0, 0),
        BackgroundTransparency = 1,
    }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    tween(cardStroke, { Transparency = 1 }, 0.3)
    tween(Backdrop, { BackgroundTransparency = 1 }, 0.4)
    task.wait(0.5)
    Gui:Destroy()
    pcall(function()
        loadstring(game:HttpGet(scriptData.URL))()
    end)
end

-- ══════════════════════════════════════════
--   DETERMINE WHAT TO SHOW
-- ══════════════════════════════════════════

-- If saved key is valid but no matching game, show "unsupported" page
-- If no saved key, show key page
-- If saved key valid and game matches, we already returned above

local showKeyPage = not isKeyValid(savedKey)

-- ══════════════════════════════════════════
--   PAGE: KEY VERIFICATION
-- ══════════════════════════════════════════
local KeyPage = new("Frame", {
    Name = "KeyPage",
    Size = UDim2.new(1, 0, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundTransparency = 1,
    Visible = showKeyPage,
    ZIndex = 5,
    Parent = Content,
})

-- Header row
local HeaderRow = new("Frame", {
    Size = UDim2.new(1, 0, 0, 44),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundTransparency = 1,
    ZIndex = 5,
    Parent = KeyPage,
})

-- Logo mark with gradient background
local LogoMark = new("Frame", {
    Size = UDim2.new(0, 40, 0, 40),
    Position = UDim2.new(0, 0, 0, 2),
    BackgroundColor3 = C.accentGhost,
    ZIndex = 6,
    Parent = HeaderRow,
})
corner(LogoMark, 12)
stroke(LogoMark, C.accent, 1, 0.7)

new("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "✦",
    TextColor3 = C.accent,
    TextSize = 20,
    Font = Enum.Font.GothamBold,
    ZIndex = 7,
    Parent = LogoMark,
})

-- Brand name
new("TextLabel", {
    Size = UDim2.new(0, 200, 0, 20),
    Position = UDim2.new(0, 52, 0, 3),
    BackgroundTransparency = 1,
    Text = "IBdihP Hub",
    TextColor3 = C.textBright,
    TextSize = 18,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 6,
    Parent = HeaderRow,
})

-- Subtitle
new("TextLabel", {
    Size = UDim2.new(0, 200, 0, 14),
    Position = UDim2.new(0, 52, 0, 25),
    BackgroundTransparency = 1,
    Text = "script loader",
    TextColor3 = C.textSecondary,
    TextSize = 11,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 6,
    Parent = HeaderRow,
})

-- Version badge
local VBadge = new("Frame", {
    Size = UDim2.new(0, 40, 0, 20),
    Position = UDim2.new(0, 158, 0, 5),
    BackgroundColor3 = C.accentGhost,
    ZIndex = 6,
    Parent = HeaderRow,
})
corner(VBadge, 6)
stroke(VBadge, C.accent, 1, 0.7)
new("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "v3.0",
    TextColor3 = C.accent,
    TextSize = 9,
    Font = Enum.Font.GothamBold,
    ZIndex = 7,
    Parent = VBadge,
})

-- Divider
new("Frame", {
    Size = UDim2.new(1, 0, 0, 1),
    Position = UDim2.new(0, 0, 0, 54),
    BackgroundColor3 = C.border,
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0,
    ZIndex = 5,
    Parent = KeyPage,
})

-- Greeting
new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 18),
    Position = UDim2.new(0, 0, 0, 68),
    BackgroundTransparency = 1,
    Text = "Welcome, " .. LocalPlayer.Name .. " 👋",
    TextColor3 = C.text,
    TextSize = 13,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5,
    Parent = KeyPage,
})

-- Game detection info
local gameStatusText = currentGameScript
    and ("✓" .. currentGameScript.Name)
    or "⚠  This game is not currently supported"
local gameStatusColor = currentGameScript and C.success or C.warning

local GameStatusLabel = new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 14),
    Position = UDim2.new(0, 0, 0, 88),
    BackgroundTransparency = 1,
    Text = gameStatusText,
    TextColor3 = gameStatusColor,
    TextSize = 11,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5,
    Parent = KeyPage,
})

-- Auth section label
new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 12),
    Position = UDim2.new(0, 0, 0, 116),
    BackgroundTransparency = 1,
    Text = "ENTER KEY",
    TextColor3 = C.textMuted,
    TextSize = 9,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5,
    Parent = KeyPage,
})

-- Input field
local InputWrap = new("Frame", {
    Size = UDim2.new(1, 0, 0, 44),
    Position = UDim2.new(0, 0, 0, 134),
    BackgroundColor3 = C.inputBg,
    ZIndex = 6,
    Parent = KeyPage,
})
corner(InputWrap, 10)
local inputStroke = stroke(InputWrap, C.border, 1.5, 0)

-- Key icon
new("TextLabel", {
    Size = UDim2.new(0, 34, 1, 0),
    Position = UDim2.new(0, 4, 0, 0),
    BackgroundTransparency = 1,
    Text = "🔑",
    TextSize = 14,
    ZIndex = 7,
    Parent = InputWrap,
})

-- Text input
local KeyInput = new("TextBox", {
    Size = UDim2.new(1, -48, 1, 0),
    Position = UDim2.new(0, 38, 0, 0),
    BackgroundTransparency = 1,
    Text = "",
    PlaceholderText = "enter your key here...",
    PlaceholderColor3 = C.textMuted,
    TextColor3 = C.textBright,
    TextSize = 13,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
    ClearTextOnFocus = false,
    ZIndex = 7,
    Parent = InputWrap,
})

-- Input focus effects
KeyInput.Focused:Connect(function()
    tween(inputStroke, { Color = C.borderFocus }, 0.2)
    tween(InputWrap, { BackgroundColor3 = C.inputBgFocus }, 0.2)
end)
KeyInput.FocusLost:Connect(function()
    tween(inputStroke, { Color = C.border }, 0.25)
    tween(InputWrap, { BackgroundColor3 = C.inputBg }, 0.25)
end)

-- Status message
local StatusMsg = new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 16),
    Position = UDim2.new(0, 0, 0, 186),
    BackgroundTransparency = 1,
    Text = "",
    TextColor3 = C.error,
    TextSize = 11,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTransparency = 0,
    ZIndex = 5,
    Parent = KeyPage,
})

-- Hint text
new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 14),
    Position = UDim2.new(0, 0, 0, 206),
    BackgroundTransparency = 1,
    Text = "free permanent key in our discord — your key saves automatically ♡",
    TextColor3 = C.textMuted,
    TextSize = 10,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Center,
    ZIndex = 5,
    Parent = KeyPage,
})

-- ═══ BUTTON ROW ═══
local BtnRow = new("Frame", {
    Size = UDim2.new(1, 0, 0, 44),
    Position = UDim2.new(0, 0, 1, -44),
    BackgroundTransparency = 1,
    ZIndex = 6,
    Parent = KeyPage,
})

-- Discord button
local DiscordBtn = new("TextButton", {
    Size = UDim2.new(0, 108, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = C.discord,
    Text = "",
    AutoButtonColor = false,
    ZIndex = 7,
    ClipsDescendants = true,
    Parent = BtnRow,
})
corner(DiscordBtn, 10)

new("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "💬  Get Key",
    TextColor3 = C.textOnAccent,
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    ZIndex = 8,
    Parent = DiscordBtn,
})

-- Paste button
local PasteBtn = new("TextButton", {
    Size = UDim2.new(0, 76, 1, 0),
    Position = UDim2.new(0, 116, 0, 0),
    BackgroundColor3 = C.surface,
    Text = "",
    AutoButtonColor = false,
    ZIndex = 7,
    ClipsDescendants = true,
    Parent = BtnRow,
})
corner(PasteBtn, 10)
stroke(PasteBtn, C.border, 1, 0)

new("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "📋 Paste",
    TextColor3 = C.textSecondary,
    TextSize = 11,
    Font = Enum.Font.GothamBold,
    ZIndex = 8,
    Parent = PasteBtn,
})

-- Verify button (fills remaining space)
local VerifyBtn = new("TextButton", {
    Size = UDim2.new(1, -200, 1, 0),
    Position = UDim2.new(0, 200, 0, 0),
    BackgroundColor3 = C.accent,
    Text = "",
    AutoButtonColor = false,
    ZIndex = 7,
    ClipsDescendants = true,
    Parent = BtnRow,
})
corner(VerifyBtn, 10)

local VerifyLabel = new("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "Verify & Launch  →",
    TextColor3 = C.textOnAccent,
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    ZIndex = 8,
    Parent = VerifyBtn,
})

-- Setup button hovers
setupHover(DiscordBtn, C.discord, C.discordHover, C.discordPress)
setupHover(PasteBtn, C.surface, C.surfaceLight, C.card)
setupHover(VerifyBtn, C.accent, C.accentHover, C.accentPress)

-- ══════════════════════════════════════════
--   PAGE: UNSUPPORTED GAME
-- ══════════════════════════════════════════
local UnsupportedPage = new("Frame", {
    Name = "UnsupportedPage",
    Size = UDim2.new(1, 0, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundTransparency = 1,
    Visible = false,
    ZIndex = 5,
    Parent = Content,
})

-- Big icon
new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 50),
    Position = UDim2.new(0, 0, 0, 20),
    BackgroundTransparency = 1,
    Text = "😔",
    TextSize = 42,
    ZIndex = 6,
    Parent = UnsupportedPage,
})

-- Title
new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 24),
    Position = UDim2.new(0, 0, 0, 80),
    BackgroundTransparency = 1,
    Text = "Game Not Supported",
    TextColor3 = C.text,
    TextSize = 18,
    Font = Enum.Font.GothamBold,
    ZIndex = 6,
    Parent = UnsupportedPage,
})

-- Subtitle
new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 18),
    Position = UDim2.new(0, 0, 0, 110),
    BackgroundTransparency = 1,
    Text = "IBdihP Hub doesn't have a script for this game yet.",
    TextColor3 = C.textSecondary,
    TextSize = 12,
    Font = Enum.Font.GothamMedium,
    ZIndex = 6,
    Parent = UnsupportedPage,
})

new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 16),
    Position = UDim2.new(0, 0, 0, 132),
    BackgroundTransparency = 1,
    Text = "Join our Discord to request support for new games!",
    TextColor3 = C.textMuted,
    TextSize = 11,
    Font = Enum.Font.Gotham,
    ZIndex = 6,
    Parent = UnsupportedPage,
})

-- Supported games list
local SupportedLabel = new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 12),
    Position = UDim2.new(0, 0, 0, 166),
    BackgroundTransparency = 1,
    Text = "SUPPORTED GAMES",
    TextColor3 = C.textMuted,
    TextSize = 9,
    Font = Enum.Font.GothamBold,
    ZIndex = 6,
    Parent = UnsupportedPage,
})

local gameNames = {}
for _, s in ipairs(SCRIPTS) do
    table.insert(gameNames, s.Icon .. " " .. s.Name)
end
local gamesText = table.concat(gameNames, "  •  ")

new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 16),
    Position = UDim2.new(0, 0, 0, 184),
    BackgroundTransparency = 1,
    Text = gamesText,
    TextColor3 = C.textSecondary,
    TextSize = 10,
    Font = Enum.Font.GothamMedium,
    TextTruncate = Enum.TextTruncate.AtEnd,
    ZIndex = 6,
    Parent = UnsupportedPage,
})

-- Discord button on unsupported page
local UnsupportedDiscordBtn = new("TextButton", {
    Size = UDim2.new(0, 180, 0, 42),
    Position = UDim2.new(0.5, -90, 1, -50),
    BackgroundColor3 = C.discord,
    Text = "",
    AutoButtonColor = false,
    ZIndex = 7,
    ClipsDescendants = true,
    Parent = UnsupportedPage,
})
corner(UnsupportedDiscordBtn, 10)

new("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "💬  Join Discord",
    TextColor3 = C.textOnAccent,
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    ZIndex = 8,
    Parent = UnsupportedDiscordBtn,
})

setupHover(UnsupportedDiscordBtn, C.discord, C.discordHover, C.discordPress)

UnsupportedDiscordBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then setclipboard(DISCORD_LINK) end
    end)
end)

-- ══════════════════════════════════════════
--   PAGE: LAUNCHING (shown after verify)
-- ══════════════════════════════════════════
local LaunchPage = new("Frame", {
    Name = "LaunchPage",
    Size = UDim2.new(1, 0, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundTransparency = 1,
    Visible = false,
    ZIndex = 5,
    Parent = Content,
})

-- Spinner container
local SpinnerWrap = new("Frame", {
    Size = UDim2.new(0, 50, 0, 50),
    Position = UDim2.new(0.5, -25, 0, 40),
    BackgroundTransparency = 1,
    ZIndex = 6,
    Parent = LaunchPage,
})

-- Animated spinner dots
local spinnerColors = {
    Color3.fromRGB(140, 120, 255),
    Color3.fromRGB(180, 140, 255),
    Color3.fromRGB(100, 180, 255),
}

local spinnerDots = {}
for idx = 1, 3 do
    local dot = new("Frame", {
        Size = UDim2.new(0, 10, 0, 10),
        Position = UDim2.new(0, (idx - 1) * 18 + 2, 0.5, -5),
        BackgroundColor3 = spinnerColors[idx],
        ZIndex = 7,
        Parent = SpinnerWrap,
    })
    corner(dot, 5)
    spinnerDots[idx] = dot
end

-- Animate spinner
task.spawn(function()
    while SpinnerWrap and SpinnerWrap.Parent do
        for idx, dot in ipairs(spinnerDots) do
            task.delay((idx - 1) * 0.15, function()
                if dot and dot.Parent then
                    tween(dot, { Position = dot.Position - UDim2.new(0, 0, 0, 12) }, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    task.wait(0.2)
                    if dot and dot.Parent then
                        tween(dot, { Position = dot.Position + UDim2.new(0, 0, 0, 12) }, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                    end
                end
            end)
        end
        task.wait(0.9)
    end
end)

-- Launch title
local LaunchTitle = new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 22),
    Position = UDim2.new(0, 0, 0, 105),
    BackgroundTransparency = 1,
    Text = "Launching...",
    TextColor3 = C.text,
    TextSize = 17,
    Font = Enum.Font.GothamBold,
    ZIndex = 6,
    Parent = LaunchPage,
})

local LaunchSub = new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 16),
    Position = UDim2.new(0, 0, 0, 132),
    BackgroundTransparency = 1,
    Text = "",
    TextColor3 = C.textSecondary,
    TextSize = 12,
    Font = Enum.Font.GothamMedium,
    ZIndex = 6,
    Parent = LaunchPage,
})

local LaunchHint = new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 14),
    Position = UDim2.new(0, 0, 1, -30),
    BackgroundTransparency = 1,
    Text = "key saved — you won't need to enter it again ✓",
    TextColor3 = C.success,
    TextSize = 10,
    Font = Enum.Font.GothamMedium,
    ZIndex = 6,
    Parent = LaunchPage,
})

-- ══════════════════════════════════════════
--   SHOW CORRECT PAGE FOR SAVED KEY + NO GAME MATCH
-- ══════════════════════════════════════════

if not showKeyPage then
    -- Key is valid but game not supported (we already returned if both valid)
    KeyPage.Visible = false
    UnsupportedPage.Visible = true
end

-- ══════════════════════════════════════════
--   BUTTON CALLBACKS
-- ══════════════════════════════════════════

-- Discord
DiscordBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then setclipboard(DISCORD_LINK) end
    end)
    StatusMsg.Text = "🔗  Discord invite copied to clipboard!"
    StatusMsg.TextColor3 = C.discord
    StatusMsg.TextTransparency = 0
    task.delay(4, function()
        if StatusMsg and StatusMsg.Parent then
            tween(StatusMsg, { TextTransparency = 1 }, 0.3)
            task.wait(0.35)
            if StatusMsg and StatusMsg.Parent then
                StatusMsg.Text = ""
                StatusMsg.TextTransparency = 0
            end
        end
    end)
end)

-- Paste
PasteBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if getclipboard then
            KeyInput.Text = getclipboard()
        end
    end)
end)

-- Shake animation
local function shakeInput()
    local orig = InputWrap.Position
    for _ = 1, 4 do
        tween(InputWrap, { Position = orig + UDim2.new(0, 6, 0, 0) }, 0.035, Enum.EasingStyle.Linear)
        task.wait(0.04)
        tween(InputWrap, { Position = orig - UDim2.new(0, 6, 0, 0) }, 0.035, Enum.EasingStyle.Linear)
        task.wait(0.04)
    end
    tween(InputWrap, { Position = orig }, 0.06)
end

-- Verify & Launch
local verifying = false
local function doVerify()
    if verifying then return end
    local key = KeyInput.Text:gsub("^%s+", ""):gsub("%s+$", "")

    if key == "" then
        StatusMsg.Text = "⚠  please enter a key"
        StatusMsg.TextColor3 = C.warning
        StatusMsg.TextTransparency = 0
        shakeInput()
        return
    end

    verifying = true
    VerifyLabel.Text = "Verifying..."
    tween(VerifyBtn, { BackgroundColor3 = C.accentSoft }, 0.15)

    task.wait(0.6)

    if isKeyValid(key) then
        -- Save key
        saveKey(key)

        -- Success feedback
        StatusMsg.Text = "✓  Key verified & saved!"
        StatusMsg.TextColor3 = C.success
        StatusMsg.TextTransparency = 0
        tween(VerifyBtn, { BackgroundColor3 = C.success }, 0.2)
        VerifyLabel.Text = "✓  Verified!"
        tween(inputStroke, { Color = C.success }, 0.2)

        task.wait(0.7)

        if currentGameScript then
            -- Game is supported — transition to launch page
            LaunchSub.Text = currentGameScript.Icon .. "  " .. currentGameScript.Name
            LaunchTitle.Text = "Launching Script..."

            tween(KeyPage, { Position = UDim2.new(-1.2, 0, 0, 0) }, 0.4)
            task.wait(0.1)
            LaunchPage.Visible = true
            LaunchPage.Position = UDim2.new(1.2, 0, 0, 0)
            tween(LaunchPage, { Position = UDim2.new(0, 0, 0, 0) }, 0.4)

            task.wait(1.5)

            -- Execute
            executeAndClose(currentGameScript)
        else
            -- Game not supported — show unsupported page
            tween(KeyPage, { Position = UDim2.new(-1.2, 0, 0, 0) }, 0.4)
            task.wait(0.1)
            UnsupportedPage.Visible = true
            UnsupportedPage.Position = UDim2.new(1.2, 0, 0, 0)
            tween(UnsupportedPage, { Position = UDim2.new(0, 0, 0, 0) }, 0.4)
        end
    else
        -- Invalid key
        StatusMsg.Text = "✗  Invalid key — join our Discord for a free key"
        StatusMsg.TextColor3 = C.error
        StatusMsg.TextTransparency = 0
        tween(inputStroke, { Color = C.error }, 0.15)
        shakeInput()

        task.delay(3.5, function()
            tween(inputStroke, { Color = C.border }, 0.3)
            if StatusMsg and StatusMsg.Parent then
                tween(StatusMsg, { TextTransparency = 1 }, 0.4)
                task.wait(0.4)
                if StatusMsg and StatusMsg.Parent then
                    StatusMsg.Text = ""
                    StatusMsg.TextTransparency = 0
                end
            end
        end)

        VerifyLabel.Text = "Verify & Launch  →"
        tween(VerifyBtn, { BackgroundColor3 = C.accent }, 0.2)
        verifying = false
    end
end

VerifyBtn.MouseButton1Click:Connect(doVerify)

KeyInput.FocusLost:Connect(function(enter)
    if enter then doVerify() end
end)

-- ══════════════════════════════════════════
--   DRAGGING
-- ══════════════════════════════════════════
local dragging, dragInput, dragStart, startPos

Card.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local relY = input.Position.Y - Card.AbsolutePosition.Y
        if relY > 55 then return end

        dragging = true
        dragStart = input.Position
        startPos = Card.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Card.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Card.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- ═══ LOGO PULSE ANIMATION ═══
task.spawn(function()
    while LogoMark and LogoMark.Parent do
        tween(LogoMark, { BackgroundColor3 = C.accentSoft }, 1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(1.8)
        tween(LogoMark, { BackgroundColor3 = C.accentGhost }, 1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(1.8)
    end
end)
