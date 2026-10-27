-- SuperShoyo Hub | Red-White Indonesia Edition
-- UI refresh for Storage Hunter
-- Catatan: ini adalah lapisan UI yang aman. Sambungkan callback hanya ke mekanik
-- yang memang didukung/diizinkan oleh game. Tidak menyertakan remote spam/exploit.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Bersihkan UI lama saat script dijalankan ulang
local old = playerGui:FindFirstChild("SuperShoyoHub")
if old then old:Destroy() end

local Config = {
    AutoBid = false,
    StopNPCBid = false,
    InstantCollect = false,
    AutoUnload = false,
    HalloweenEvent = false,
    Fishing = false,
}
_G.SuperShoyoConfig = Config

local C = {
    bg = Color3.fromRGB(10, 13, 19),
    panel = Color3.fromRGB(17, 22, 31),
    panel2 = Color3.fromRGB(24, 30, 41),
    red = Color3.fromRGB(239, 35, 55),
    redDark = Color3.fromRGB(115, 15, 29),
    white = Color3.fromRGB(247, 249, 252),
    muted = Color3.fromRGB(169, 181, 201),
    border = Color3.fromRGB(59, 69, 86),
    green = Color3.fromRGB(49, 220, 151),
    off = Color3.fromRGB(68, 77, 94),
}

local gui = Instance.new("ScreenGui")
gui.Name = "SuperShoyoHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = playerGui

local function new(className, props, parent)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local function corner(obj, radius)
    new("UICorner", {CornerRadius = UDim.new(0, radius or 10)}, obj)
end

local function stroke(obj, color, thickness, transparency)
    new("UIStroke", {
        Color = color or C.border,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
    }, obj)
end

local function label(parent, text, size, position, font, color)
    return new("TextLabel", {
        BackgroundTransparency = 1,
        Text = text,
        TextSize = size or 14,
        Font = font or Enum.Font.Gotham,
        TextColor3 = color or C.white,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        Position = position or UDim2.new(),
        Size = UDim2.new(1, 0, 0, 24),
    }, parent)
end

local function button(parent, text, size, position, color)
    local b = new("TextButton", {
        Text = text,
        TextSize = 13,
        Font = Enum.Font.GothamSemibold,
        TextColor3 = C.white,
        BackgroundColor3 = color or C.panel2,
        Size = size,
        Position = position,
        AutoButtonColor = false,
        BorderSizePixel = 0,
    }, parent)
    corner(b, 9)
    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12), {
            BackgroundColor3 = color == C.red and Color3.fromRGB(255, 61, 78) or Color3.fromRGB(37, 45, 60)
        }):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12), {
            BackgroundColor3 = color or C.panel2
        }):Play()
    end)
    return b
end

-- Floating button
local float = button(gui, "S", UDim2.fromOffset(58, 58), UDim2.new(0, 24, 0.35, 0), C.red)
float.TextSize = 27
float.Font = Enum.Font.GothamBlack
corner(float, 29)
stroke(float, Color3.fromRGB(255, 255, 255), 1.5, 0.15)
local flag = label(float, "ID", 9, UDim2.new(0, 0, 1, -17), Enum.Font.GothamBold, C.white)
flag.TextXAlignment = Enum.TextXAlignment.Center
flag.Size = UDim2.new(1, 0, 0, 12)

-- Main window, scales on smaller screens
local main = new("Frame", {
    Name = "Main",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(0.88, 0, 0.82, 0),
    BackgroundColor3 = C.bg,
    BorderSizePixel = 0,
    Visible = false,
}, gui)
main.Size = UDim2.new(0, 900, 0, 570)
main.SizeConstraint = Enum.SizeConstraint.RelativeYY
main.ClipsDescendants = true
corner(main, 16)
stroke(main, C.red, 2, 0.05)

local sizeConstraint = new("UISizeConstraint", {
    MinSize = Vector2.new(320, 380),
    MaxSize = Vector2.new(1100, 720),
}, main)

local scale = new("UIScale", {Scale = 1}, main)
local function updateScale()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local vp = cam.ViewportSize
    scale.Scale = math.min(1, vp.X / 940, vp.Y / 620)
end
updateScale()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
end

-- Header
local header = new("Frame", {
    Size = UDim2.new(1, 0, 0, 76),
    BackgroundColor3 = Color3.fromRGB(18, 21, 29),
    BorderSizePixel = 0,
}, main)
corner(header, 14)
local title = label(header, "SHOYO HUB", 25, UDim2.new(0, 22, 0, 8), Enum.Font.GothamBlack, C.white)
title.Size = UDim2.new(0.6, 0, 0, 31)
local subtitle = label(header, "STORAGE HUNTER  •  MERAH PUTIH EDITION", 11,
    UDim2.new(0, 23, 0, 40), Enum.Font.GothamMedium, C.muted)
subtitle.Size = UDim2.new(0.7, 0, 0, 20)
local status = label(header, "● SIAP", 12, UDim2.new(1, -170, 0, 20), Enum.Font.GothamBold, C.green)
status.Size = UDim2.fromOffset(95, 28)
local minimize = button(header, "—", UDim2.fromOffset(34, 32), UDim2.new(1, -78, 0, 20), C.panel2)
local close = button(header, "×", UDim2.fromOffset(34, 32), UDim2.new(1, -38, 0, 20), C.red)
minimize.TextSize = 18
close.TextSize = 21

-- Body and sidebar
local body = new("Frame", {
    Position = UDim2.new(0, 0, 0, 84),
    Size = UDim2.new(1, 0, 1, -92),
    BackgroundTransparency = 1,
}, main)

local sidebar = new("Frame", {
    Position = UDim2.new(0, 12, 0, 0),
    Size = UDim2.new(0, 155, 1, 0),
    BackgroundColor3 = C.panel,
    BorderSizePixel = 0,
}, body)
corner(sidebar, 12)
local sideTitle = label(sidebar, "MENU UTAMA", 11, UDim2.new(0, 14, 0, 12), Enum.Font.GothamBold, C.muted)
sideTitle.Size = UDim2.new(1, -20, 0, 22)

local content = new("ScrollingFrame", {
    Position = UDim2.new(0, 178, 0, 0),
    Size = UDim2.new(1, -190, 1, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = C.red,
    CanvasSize = UDim2.new(0, 0, 0, 900),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, body)
new("UIPadding", {
    PaddingLeft = UDim.new(0, 2),
    PaddingRight = UDim.new(0, 6),
    PaddingBottom = UDim.new(0, 10),
}, content)

local sections = {}
local activeTab = "Beranda"
local tabNames = {"Beranda", "Auto Farm", "Teleports", "Event & Lainnya", "Pengaturan"}
local tabButtons = {}

local function setTab(name)
    activeTab = name
    for tab, b in pairs(tabButtons) do
        b.BackgroundColor3 = tab == name and C.red or C.panel2
        b.TextColor3 = C.white
    end
    for tab, section in pairs(sections) do
        section.Visible = (name == "Beranda" or tab == name or tab == "Umum")
    end
end

for i, name in ipairs(tabNames) do
    local b = button(sidebar, name, UDim2.new(1, -16, 0, 38), UDim2.new(0, 8, 0, 44 + (i-1)*45),
        name == "Beranda" and C.red or C.panel2)
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.Text = "   " .. name
    tabButtons[name] = b
    b.MouseButton1Click:Connect(function() setTab(name) end)
end

local function makeSection(name, heading, height)
    local frame = new("Frame", {
        Name = name,
        Size = UDim2.new(1, 0, 0, height),
        BackgroundTransparency = 1,
        Visible = true,
    }, content)
    sections[name] = frame
    label(frame, heading, 17, UDim2.new(0, 4, 0, 0), Enum.Font.GothamBold, C.white)
    return frame
end

local function makeFeatureCard(parent, titleText, description, configKey, x, y, width)
    local card = new("Frame", {
        Position = UDim2.new(0, x, 0, y),
        Size = UDim2.new(0.5, -8, 0, 92),
        BackgroundColor3 = C.panel,
        BorderSizePixel = 0,
    }, parent)
    corner(card, 11)
    stroke(card, C.border, 1, 0.15)
    local accent = new("Frame", {
        Size = UDim2.new(0, 3, 1, -20),
        Position = UDim2.new(0, 0, 0, 10),
        BackgroundColor3 = C.red,
        BorderSizePixel = 0,
    }, card)
    corner(accent, 2)
    label(card, titleText, 14, UDim2.new(0, 14, 0, 12), Enum.Font.GothamBold, C.white).Size = UDim2.new(1, -100, 0, 22)
    local desc = label(card, description, 11, UDim2.new(0, 14, 0, 38), Enum.Font.Gotham, C.muted)
    desc.Size = UDim2.new(1, -100, 0, 42)
    desc.TextWrapped = true
    local toggle = button(card, Config[configKey] and "ON" or "OFF",
        UDim2.fromOffset(58, 29), UDim2.new(1, -70, 0.5, -14),
        Config[configKey] and C.red or C.off)
    toggle.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]
        toggle.Text = Config[configKey] and "ON" or "OFF"
        toggle.BackgroundColor3 = Config[configKey] and C.red or C.off
        status.Text = Config[configKey] and "● AKTIF" or "● SIAP"
        status.TextColor3 = Config[configKey] and C.red or C.green
        -- Hub UI only: sambungkan event ini ke implementasi game yang sah bila tersedia.
        if _G.SuperShoyoOnToggle then
            pcall(_G.SuperShoyoOnToggle, configKey, Config[configKey])
        end
    end)
end

local home = makeSection("Umum", "Fitur Utama", 300)
makeFeatureCard(home, "Auto Bid", "Pengaturan status Auto Bid.", "AutoBid", 0, 34)
makeFeatureCard(home, "Stop NPC Bid", "Pengaturan status Stop NPC Bid.", "StopNPCBid", 0, 136)
makeFeatureCard(home, "Instant Collect", "Pengaturan status pengambilan.", "InstantCollect", 0, 238)
-- right column uses relative positioning so cards remain aligned
local function moveCardRight(section, index)
    local cards = {}
    for _, child in ipairs(section:GetChildren()) do
        if child:IsA("Frame") and child:FindFirstChildOfClass("UIStroke") then
            table.insert(cards, child)
        end
    end
    local card = cards[index]
    if card then card.Position = UDim2.new(0.5, 4, 0, ({34,136,238})[index]) end
end
moveCardRight(home, 2)
moveCardRight(home, 4)

local farm = makeSection("Auto Farm", "Auto Farm & Interaksi", 210)
farm.Position = UDim2.new(0, 0, 0, 315)
makeFeatureCard(farm, "Auto Unload", "Pengaturan unload item.", "AutoUnload", 0, 34)
makeFeatureCard(farm, "Halloween Event", "Status event (jika tersedia).", "HalloweenEvent", 0, 136)
makeFeatureCard(farm, "Fishing", "Status fishing (jika tersedia).", "Fishing", 0, 136)
local function positionSecond(section, titleToFind, y)
    for _, child in ipairs(section:GetChildren()) do
        if child:IsA("Frame") then
            local t = child:FindFirstChildOfClass("TextLabel")
            if t and t.Text == titleToFind then child.Position = UDim2.new(0.5, 4, 0, y) end
        end
    end
end
positionSecond(farm, "Fishing", 136)

local tele = makeSection("Teleports", "Pintasan Lokasi", 350)
tele.Position = UDim2.new(0, 0, 0, 540)
local locations = {
    {"My Plot", "Plot milikmu"},
    {"Grading NPC", "NPC penilai"},
    {"Cleaning Tool", "Alat pembersih"},
    {"Junk Yard", "Area barang bekas"},
    {"Back Alley", "Gang belakang"},
    {"Power Plant", "Pembangkit listrik"},
    {"Farmyard", "Area pertanian"},
    {"Shipyard", "Area kapal"},
    {"Lucky Beach", "Pantai"},
    {"Business Bay", "Area bisnis"},
    {"Cargo Ship", "Kapal kargo"},
    {"The Mines", "Area tambang"},
    {"Train Container", "Kontainer kereta"},
}
for i, item in ipairs(locations) do
    local col = (i - 1) % 2
    local row = math.floor((i - 1) / 2)
    local b = button(tele, item[1] .. "  ›", UDim2.new(0.5, -7, 0, 36),
        UDim2.new(col * 0.5, col == 0 and 0 or 7, 0, 34 + row * 43), C.panel)
    stroke(b, C.border, 1, 0.2)
    b.MouseButton1Click:Connect(function()
        status.Text = "● DIPILIH"
        status.TextColor3 = C.red
        if _G.SuperShoyoOnTeleport then
            pcall(_G.SuperShoyoOnTeleport, item[1])
        else
            warn("[SuperShoyo Hub] Lokasi dipilih: " .. item[1] .. ". Callback teleport belum dipasang.")
        end
    end)
end
tele.Size = UDim2.new(1, 0, 0, 34 + math.ceil(#locations / 2) * 43)

local misc = makeSection("Event & Lainnya", "Informasi & Status", 160)
misc.Position = UDim2.new(0, 0, 0, 900)
local info = new("Frame", {
    Position = UDim2.new(0, 0, 0, 34),
    Size = UDim2.new(1, 0, 0, 100),
    BackgroundColor3 = C.panel,
    BorderSizePixel = 0,
}, misc)
corner(info, 11)
stroke(info, C.border, 1, 0.2)
label(info, "SHOYO HUB  •  Storage Hunter", 14, UDim2.new(0, 14, 0, 10), Enum.Font.GothamBold, C.white)
local infoDesc = label(info, "Tema merah putih • UI responsif • Status fitur tersimpan selama sesi.", 12,
    UDim2.new(0, 14, 0, 38), Enum.Font.Gotham, C.muted)
infoDesc.Size = UDim2.new(1, -28, 0, 48)
infoDesc.TextWrapped = true

local settings = makeSection("Pengaturan", "Pengaturan Tampilan", 150)
settings.Position = UDim2.new(0, 0, 0, 1080)
local reset = button(settings, "Reset Status Fitur", UDim2.new(1, -4, 0, 40), UDim2.new(0, 0, 0, 38), C.red)
reset.MouseButton1Click:Connect(function()
    for k in pairs(Config) do Config[k] = false end
    -- Refresh visual toggle states by rebuilding the UI is avoided; click handlers use Config as source.
    status.Text = "● SIAP"
    status.TextColor3 = C.green
    for _, section in pairs(sections) do
        for _, card in ipairs(section:GetChildren()) do
            if card:IsA("Frame") then
                local titleLabel = card:FindFirstChildOfClass("TextLabel")
                local toggle = card:FindFirstChildOfClass("TextButton")
                if titleLabel and toggle then
                    local map = {
                        ["Auto Bid"]="AutoBid", ["Stop NPC Bid"]="StopNPCBid",
                        ["Instant Collect"]="InstantCollect", ["Auto Unload"]="AutoUnload",
                        ["Halloween Event"]="HalloweenEvent", ["Fishing"]="Fishing",
                    }
                    local key = map[titleLabel.Text]
                    if key then toggle.Text = "OFF"; toggle.BackgroundColor3 = C.off end
                end
            end
        end
    end
end)

-- Tab click routing: home shows general features; other tabs show their own sections.
tabButtons["Beranda"].MouseButton1Click:Connect(function()
    home.Visible = true
    farm.Visible = false
    tele.Visible = false
    misc.Visible = false
    settings.Visible = false
end)
tabButtons["Auto Farm"].MouseButton1Click:Connect(function()
    home.Visible = false
    farm.Visible = true
    tele.Visible = false
    misc.Visible = false
    settings.Visible = false
end)
tabButtons["Teleports"].MouseButton1Click:Connect(function()
    home.Visible = false
    farm.Visible = false
    tele.Visible = true
    misc.Visible = false
    settings.Visible = false
end)
tabButtons["Event & Lainnya"].MouseButton1Click:Connect(function()
    home.Visible = false
    farm.Visible = false
    tele.Visible = false
    misc.Visible = true
    settings.Visible = false
end)
tabButtons["Pengaturan"].MouseButton1Click:Connect(function()
    home.Visible = false
    farm.Visible = false
    tele.Visible = false
    misc.Visible = false
    settings.Visible = true
end)

local function showHome()
    home.Visible = true
    farm.Visible = false
    tele.Visible = false
    misc.Visible = false
    settings.Visible = false
end
showHome()

-- Drag window using header (mouse + touch)
do
    local dragging, dragStart, startPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- Drag floating icon
do
    local dragging, dragStart, startPos
    float.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = float.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            float.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

float.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)
close.MouseButton1Click:Connect(function()
    main.Visible = false
end)
minimize.MouseButton1Click:Connect(function()
    body.Visible = not body.Visible
    main.Size = body.Visible and UDim2.new(0, 900, 0, 570) or UDim2.new(0, 900, 0, 76)
end)

print("[SuperShoyo Hub] Red-White UI loaded.")
