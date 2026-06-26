-- ══════════════════════════════════════════════════════════════
--   IBdihP Hub — Professional Script Loader v2
--   Minimalistic • Aesthetic • Bold
-- ══════════════════════════════════════════════════════════════

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
        URL = "https://raw.githubusercontent.com/hersheyzchoco-cmyk/awcc/refs/heads/main/main.lua",
        GameId = 109715918987082,
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

-- ═══ COLOR SYSTEM ═══
local C = {
    bg            = Color3.fromRGB(12, 12, 16),
    card          = Color3.fromRGB(22, 22, 30),
    cardHover     = Color3.fromRGB(28, 28, 38),
    cardActive    = Color3.fromRGB(32, 30, 48),
    surface       = Color3.fromRGB(26, 26, 34),
    accent        = Color3.fromRGB(130, 110, 255),
    accentHover   = Color3.fromRGB(150, 130, 255),
    accentPress   = Color3.fromRGB(110, 90, 220),
    accentGhost   = Color3.fromRGB(35, 30, 60),
    success       = Color3.fromRGB(60, 200, 110),
    successBg     = Color3.fromRGB(20, 50, 35),
    error         = Color3.fromRGB(240, 75, 75),
    text          = Color3.fromRGB(240, 240, 250),
    textSecondary = Color3.fromRGB(160, 160, 180),
    textMuted     = Color3.fromRGB(80, 80, 100),
    textOnAccent  = Color3.fromRGB(255, 255, 255),
    border        = Color3.fromRGB(38, 38, 50),
    borderHover   = Color3.fromRGB(55, 55, 72),
    borderFocus   = Color3.fromRGB(130, 110, 255),
    inputBg       = Color3.fromRGB(16, 16, 22),
    discord       = Color3.fromRGB(88, 101, 242),
    discordHover  = Color3.fromRGB(105, 118, 255),
    white         = Color3.fromRGB(255, 255, 255),
    black         = Color3.fromRGB(0, 0, 0),
}

-- ═══ CLEANUP ═══
if CoreGui:FindFirstChild("IBdihPLoader") then
    CoreGui:FindFirstChild("IBdihPLoader"):Destroy()
end

-- ═══ INSTANCE FACTORY ═══
local function new(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" and k ~= "Children" then
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

local function pad(parent, t, b, l, r)
    return new("UIPadding", {
        PaddingTop = UDim.new(0, t or 0),
        PaddingBottom = UDim.new(0, b or 0),
        PaddingLeft = UDim.new(0, l or 0),
        PaddingRight = UDim.new(0, r or 0),
        Parent = parent,
    })
end

-- ═══ TWEEN UTILITY ═══
local function tween(obj, props, dur, style, dir)
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
        BackgroundTransparency = 0.85,
        ZIndex = 99,
        Parent = button,
    })
    corner(ripple, 9999)
    local size = maxDist * 2
    tween(ripple, { Size = UDim2.new(0, size, 0, size), BackgroundTransparency = 1 }, 0.6)
    task.delay(0.65, function() if ripple then ripple:Destroy() end end)
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
local Card = new("Frame", {
    Name = "Card",
    Size = UDim2.new(0, 520, 0, 360),
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

-- Accent bar at top
local AccentBar = new("Frame", {
    Size = UDim2.new(1, 0, 0, 2),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = C.accent,
    BorderSizePixel = 0,
    ZIndex = 15,
    Parent = Card,
})

local accentGrad = new("UIGradient", {
    Color = ColorSequence.new(C.accent, Color3.fromRGB(180, 130, 255)),
    Rotation = 0,
    Parent = AccentBar,
})

task.spawn(function()
    local t = 0
    while AccentBar and AccentBar.Parent do
        t = t + 0.015
        accentGrad.Offset = Vector2.new(math.sin(t) * 0.3, 0)
        accentGrad.Rotation = math.sin(t * 0.7) * 20
        RunService.RenderStepped:Wait()
    end
end)

-- Inner glow
local InnerGlow = new("Frame", {
    Size = UDim2.new(1, 0, 0, 80),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = C.accent,
    ZIndex = 3,
    Parent = Card,
})
new("UIGradient", {
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.93),
        NumberSequenceKeypoint.new(1, 1),
    }),
    Rotation = 90,
    Parent = InnerGlow,
})

-- ═══ INTRO ANIMATION ═══
Card.Size = UDim2.new(0, 520, 0, 0)
task.wait(0.15)
tween(Backdrop, { BackgroundTransparency = 0.55 }, 0.5)
task.wait(0.05)
tween(Card, { Size = UDim2.new(0, 520, 0, 360), BackgroundTransparency = 0 }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
tween(cardStroke, { Transparency = 0 }, 0.35)
task.wait(0.5)

-- ═══ CLOSE BUTTON ═══
local CloseBtn = new("TextButton", {
    Size = UDim2.new(0, 28, 0, 28),
    Position = UDim2.new(1, -38, 0, 10),
    BackgroundColor3 = C.surface,
    BackgroundTransparency = 0.5,
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
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    ZIndex = 21,
    Parent = CloseBtn,
})

CloseBtn.MouseEnter:Connect(function()
    tween(CloseBtn, { BackgroundTransparency = 0 }, 0.15)
    tween(CloseX, { TextColor3 = C.error }, 0.15)
end)
CloseBtn.MouseLeave:Connect(function()
    tween(CloseBtn, { BackgroundTransparency = 0.5 }, 0.2)
    tween(CloseX, { TextColor3 = C.textMuted }, 0.2)
end)
CloseBtn.MouseButton1Click:Connect(function()
    tween(Card, { Size = UDim2.new(0, 520, 0, 0), BackgroundTransparency = 1 }, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    tween(Backdrop, { BackgroundTransparency = 1 }, 0.35)
    task.wait(0.4)
    Gui:Destroy()
end)

-- ═══ CONTENT AREA (clips both pages) ═══
local Content = new("Frame", {
    Size = UDim2.new(1, -68, 1, -60),
    Position = UDim2.new(0, 34, 0, 30),
    BackgroundTransparency = 1,
    ClipsDescendants = true,
    ZIndex = 4,
    Parent = Card,
})

-- ══════════════════════════════════════════
--   PAGE 1: KEY VERIFICATION
-- ══════════════════════════════════════════
local KeyPage = new("Frame", {
    Name = "KeyPage",
    Size = UDim2.new(1, 0, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundTransparency = 1,
    ZIndex = 5,
    Parent = Content,
})

-- Header row (logo + brand)
local HeaderRow = new("Frame", {
    Size = UDim2.new(1, 0, 0, 42),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundTransparency = 1,
    ZIndex = 5,
    Parent = KeyPage,
})

local LogoMark = new("Frame", {
    Size = UDim2.new(0, 38, 0, 38),
    Position = UDim2.new(0, 0, 0, 2),
    BackgroundColor3 = C.accentGhost,
    ZIndex = 6,
    Parent = HeaderRow,
})
corner(LogoMark, 11)

new("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "✦",
    TextColor3 = C.accent,
    TextSize = 19,
    Font = Enum.Font.GothamBold,
    ZIndex = 7,
    Parent = LogoMark,
})

new("TextLabel", {
    Size = UDim2.new(0, 200, 0, 19),
    Position = UDim2.new(0, 50, 0, 3),
    BackgroundTransparency = 1,
    Text = "IBdihP Hub",
    TextColor3 = C.text,
    TextSize = 17,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 6,
    Parent = HeaderRow,
})

new("TextLabel", {
    Size = UDim2.new(0, 200, 0, 14),
    Position = UDim2.new(0, 50, 0, 24),
    BackgroundTransparency = 1,
    Text = "script loader",
    TextColor3 = C.textMuted,
    TextSize = 11,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 6,
    Parent = HeaderRow,
})

-- Version badge
local VBadge = new("Frame", {
    Size = UDim2.new(0, 38, 0, 18),
    Position = UDim2.new(0, 152, 0, 5),
    BackgroundColor3 = C.accentGhost,
    ZIndex = 6,
    Parent = HeaderRow,
})
corner(VBadge, 5)
new("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "v2.0",
    TextColor3 = C.accent,
    TextSize = 9,
    Font = Enum.Font.GothamBold,
    ZIndex = 7,
    Parent = VBadge,
})

-- Divider
new("Frame", {
    Size = UDim2.new(1, 0, 0, 1),
    Position = UDim2.new(0, 0, 0, 52),
    BackgroundColor3 = C.border,
    BackgroundTransparency = 0.4,
    BorderSizePixel = 0,
    ZIndex = 5,
    Parent = KeyPage,
})

-- Greeting
new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 16),
    Position = UDim2.new(0, 0, 0, 66),
    BackgroundTransparency = 1,
    Text = "Welcome back, " .. LocalPlayer.Name,
    TextColor3 = C.textSecondary,
    TextSize = 12,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5,
    Parent = KeyPage,
})

-- Auth label
new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 12),
    Position = UDim2.new(0, 0, 0, 98),
    BackgroundTransparency = 1,
    Text = "AUTHENTICATION",
    TextColor3 = C.textMuted,
    TextSize = 9,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5,
    Parent = KeyPage,
})

-- Input field
local InputWrap = new("Frame", {
    Size = UDim2.new(1, 0, 0, 42),
    Position = UDim2.new(0, 0, 0, 118),
    BackgroundColor3 = C.inputBg,
    ZIndex = 6,
    Parent = KeyPage,
})
corner(InputWrap, 10)
local inputStroke = stroke(InputWrap, C.border, 1.5, 0)

new("TextLabel", {
    Size = UDim2.new(0, 32, 1, 0),
    Position = UDim2.new(0, 4, 0, 0),
    BackgroundTransparency = 1,
    Text = "🔑",
    TextSize = 13,
    ZIndex = 7,
    Parent = InputWrap,
})

local KeyInput = new("TextBox", {
    Size = UDim2.new(1, -44, 1, 0),
    Position = UDim2.new(0, 36, 0, 0),
    BackgroundTransparency = 1,
    Text = "",
    PlaceholderText = "enter your key...",
    PlaceholderColor3 = C.textMuted,
    TextColor3 = C.text,
    TextSize = 13,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
    ClearTextOnFocus = false,
    ZIndex = 7,
    Parent = InputWrap,
})

KeyInput.Focused:Connect(function()
    tween(inputStroke, { Color = C.borderFocus }, 0.2)
    tween(InputWrap, { BackgroundColor3 = Color3.fromRGB(20, 18, 30) }, 0.2)
end)
KeyInput.FocusLost:Connect(function()
    tween(inputStroke, { Color = C.border }, 0.25)
    tween(InputWrap, { BackgroundColor3 = C.inputBg }, 0.25)
end)

-- Status label
local StatusMsg = new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 16),
    Position = UDim2.new(0, 0, 0, 168),
    BackgroundTransparency = 1,
    Text = "",
    TextColor3 = C.error,
    TextSize = 11,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5,
    Parent = KeyPage,
})

-- Hint
new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 14),
    Position = UDim2.new(0, 0, 0, 192),
    BackgroundTransparency = 1,
    Text = "free permanent key available in our discord server ♡",
    TextColor3 = C.textMuted,
    TextSize = 10,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Center,
    ZIndex = 5,
    Parent = KeyPage,
})

-- Button row
local BtnRow = new("Frame", {
    Size = UDim2.new(1, 0, 0, 42),
    Position = UDim2.new(0, 0, 1, -42),
    BackgroundTransparency = 1,
    ZIndex = 6,
    Parent = KeyPage,
})

-- Discord button
local DiscordBtn = new("TextButton", {
    Size = UDim2.new(0, 100, 1, 0),
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
    Text = "💬 Get Key",
    TextColor3 = C.textOnAccent,
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    ZIndex = 8,
    Parent = DiscordBtn,
})

-- Paste button
local PasteBtn = new("TextButton", {
    Size = UDim2.new(0, 72, 1, 0),
    Position = UDim2.new(0, 108, 0, 0),
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
    Font = Enum.Font.GothamSemibold,
    ZIndex = 8,
    Parent = PasteBtn,
})

-- Verify button
local VerifyBtn = new("TextButton", {
    Size = UDim2.new(1, -188, 1, 0),
    Position = UDim2.new(0, 188, 0, 0),
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
    Text = "Verify & Continue  →",
    TextColor3 = C.textOnAccent,
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    ZIndex = 8,
    Parent = VerifyBtn,
})

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

setupHover(DiscordBtn, C.discord, C.discordHover, Color3.fromRGB(75, 88, 220))
setupHover(PasteBtn, C.surface, C.cardHover, C.card)
setupHover(VerifyBtn, C.accent, C.accentHover, C.accentPress)

-- ══════════════════════════════════════════
--   PAGE 2: SCRIPT SELECTION
-- ══════════════════════════════════════════
local ScriptPage = new("Frame", {
    Name = "ScriptPage",
    Size = UDim2.new(1, 0, 1, 0),
    Position = UDim2.new(1.2, 0, 0, 0),
    BackgroundTransparency = 1,
    Visible = false,
    ZIndex = 5,
    Parent = Content,
})

-- Header
new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 20),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundTransparency = 1,
    Text = "✦  Choose Your Script",
    TextColor3 = C.text,
    TextSize = 16,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 6,
    Parent = ScriptPage,
})

new("TextLabel", {
    Size = UDim2.new(0, 300, 0, 14),
    Position = UDim2.new(0, 0, 0, 24),
    BackgroundTransparency = 1,
    Text = "authenticated as " .. LocalPlayer.Name:lower(),
    TextColor3 = C.textMuted,
    TextSize = 10,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 6,
    Parent = ScriptPage,
})

-- Verified badge
local VBadge2 = new("Frame", {
    Size = UDim2.new(0, 68, 0, 20),
    Position = UDim2.new(1, -68, 0, 2),
    BackgroundColor3 = C.successBg,
    ZIndex = 6,
    Parent = ScriptPage,
})
corner(VBadge2, 6)
stroke(VBadge2, C.success, 1, 0.7)
new("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "✓ Verified",
    TextColor3 = C.success,
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    ZIndex = 7,
    Parent = VBadge2,
})

-- Divider
new("Frame", {
    Size = UDim2.new(1, 0, 0, 1),
    Position = UDim2.new(0, 0, 0, 48),
    BackgroundColor3 = C.border,
    BackgroundTransparency = 0.4,
    BorderSizePixel = 0,
    ZIndex = 5,
    Parent = ScriptPage,
})

-- Script list
local ScriptList = new("ScrollingFrame", {
    Size = UDim2.new(1, 0, 1, -60),
    Position = UDim2.new(0, 0, 0, 58),
    BackgroundTransparency = 1,
    ScrollBarThickness = 2,
    ScrollBarImageColor3 = C.accent,
    ScrollBarImageTransparency = 0.5,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ZIndex = 6,
    Parent = ScriptPage,
})

new("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 8),
    Parent = ScriptList,
})

for i, data in ipairs(SCRIPTS) do
    local available = true
    if data.GameId and data.GameId ~= game.PlaceId then
        available = false
    end

    local SCard = new("TextButton", {
        Name = "Script_" .. i,
        Size = UDim2.new(1, 0, 0, 72),
        BackgroundColor3 = C.card,
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = i,
        ZIndex = 7,
        ClipsDescendants = true,
        Parent = ScriptList,
    })
    corner(SCard, 12)
    local sStroke = stroke(SCard, C.border, 1, 0.4)

    -- Icon
    local IconBox = new("Frame", {
        Size = UDim2.new(0, 44, 0, 44),
        Position = UDim2.new(0, 14, 0.5, -22),
        BackgroundColor3 = C.accentGhost,
        ZIndex = 8,
        Parent = SCard,
    })
    corner(IconBox, 12)

    new("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = data.Icon or "⚡",
        TextSize = 20,
        ZIndex = 9,
        Parent = IconBox,
    })

    -- Name
    new("TextLabel", {
        Size = UDim2.new(0.5, 0, 0, 18),
        Position = UDim2.new(0, 70, 0, 16),
        BackgroundTransparency = 1,
        Text = data.Name,
        TextColor3 = available and C.text or C.textMuted,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 8,
        Parent = SCard,
    })

    -- Desc
    new("TextLabel", {
        Size = UDim2.new(0.55, 0, 0, 14),
        Position = UDim2.new(0, 70, 0, 38),
        BackgroundTransparency = 1,
        Text = data.Description,
        TextColor3 = C.textMuted,
        TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 8,
        Parent = SCard,
    })

    -- Execute badge
    local ExecBadge = new("Frame", {
        Size = UDim2.new(0, 72, 0, 30),
        Position = UDim2.new(1, -86, 0.5, -15),
        BackgroundColor3 = available and C.accent or C.surface,
        ZIndex = 8,
        Parent = SCard,
    })
    corner(ExecBadge, 8)

    local ExecLabel = new("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = available and "Execute" or "N/A",
        TextColor3 = available and C.textOnAccent or C.textMuted,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        ZIndex = 9,
        Parent = ExecBadge,
    })

    -- Hover
    SCard.MouseEnter:Connect(function()
        tween(SCard, { BackgroundColor3 = C.cardHover }, 0.15)
        tween(sStroke, { Color = available and C.accent or C.borderHover, Transparency = 0.1 }, 0.15)
        if available then tween(ExecBadge, { BackgroundColor3 = C.accentHover }, 0.15) end
    end)
    SCard.MouseLeave:Connect(function()
        tween(SCard, { BackgroundColor3 = C.card }, 0.2)
        tween(sStroke, { Color = C.border, Transparency = 0.4 }, 0.2)
        if available then tween(ExecBadge, { BackgroundColor3 = C.accent }, 0.2) end
    end)

    if available then
        SCard.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                createRipple(SCard, input.Position.X, input.Position.Y)
            end
        end)

        SCard.MouseButton1Click:Connect(function()
            tween(ExecBadge, { BackgroundColor3 = C.success }, 0.2)
            ExecLabel.Text = "Loading..."

            task.wait(0.6)

            tween(Card, { Size = UDim2.new(0, 520, 0, 0), BackgroundTransparency = 1 }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            tween(cardStroke, { Transparency = 1 }, 0.3)
            tween(Backdrop, { BackgroundTransparency = 1 }, 0.4)

            task.wait(0.5)
            Gui:Destroy()

            pcall(function()
                loadstring(game:HttpGet(data.URL))()
            end)
        end)
    end
end

-- ══════════════════════════════════════════
--   BUTTON CALLBACKS
-- ══════════════════════════════════════════

-- Discord
DiscordBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then setclipboard(DISCORD_LINK) end
    end)
    StatusMsg.Text = "🔗  Discord invite copied — get your free key there!"
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

-- Shake
local function shakeInput()
    local orig = InputWrap.Position
    for _ = 1, 4 do
        tween(InputWrap, { Position = orig + UDim2.new(0, 5, 0, 0) }, 0.035, Enum.EasingStyle.Linear)
        task.wait(0.04)
        tween(InputWrap, { Position = orig - UDim2.new(0, 5, 0, 0) }, 0.035, Enum.EasingStyle.Linear)
        task.wait(0.04)
    end
    tween(InputWrap, { Position = orig }, 0.05)
end

-- Verify
local verifying = false
local function doVerify()
    if verifying then return end
    local key = KeyInput.Text:gsub("^%s+", ""):gsub("%s+$", "")

    if key == "" then
        StatusMsg.Text = "please enter a key"
        StatusMsg.TextColor3 = C.error
        StatusMsg.TextTransparency = 0
        shakeInput()
        return
    end

    verifying = true
    VerifyLabel.Text = "Verifying..."

    task.wait(0.5)

    local valid = false
    for _, k in ipairs(VALID_KEYS) do
        if key == k then valid = true break end
    end

    if valid then
        StatusMsg.Text = "✓  key verified successfully"
        StatusMsg.TextColor3 = C.success
        StatusMsg.TextTransparency = 0
        tween(VerifyBtn, { BackgroundColor3 = C.success }, 0.2)
        VerifyLabel.Text = "✓  Verified"
        tween(inputStroke, { Color = C.success }, 0.2)

        task.wait(0.6)

        tween(KeyPage, { Position = UDim2.new(-1.2, 0, 0, 0) }, 0.4)
        task.wait(0.1)
        ScriptPage.Visible = true
        ScriptPage.Position = UDim2.new(1.2, 0, 0, 0)
        tween(ScriptPage, { Position = UDim2.new(0, 0, 0, 0) }, 0.4)
    else
        StatusMsg.Text = "✗  invalid key — join discord for a free key"
        StatusMsg.TextColor3 = C.error
        StatusMsg.TextTransparency = 0
        tween(inputStroke, { Color = C.error }, 0.15)
        shakeInput()

        task.delay(3, function()
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

        VerifyLabel.Text = "Verify & Continue  →"
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
        -- Only drag from top 55px
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

-- ═══ LOGO PULSE ═══
task.spawn(function()
    while LogoMark and LogoMark.Parent do
        tween(LogoMark, { BackgroundColor3 = Color3.fromRGB(45, 38, 75) }, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(1.5)
        tween(LogoMark, { BackgroundColor3 = C.accentGhost }, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(1.5)
    end
end)
