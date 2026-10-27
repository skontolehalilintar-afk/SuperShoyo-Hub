-- SuperShoyo Hub | Red-White Indonesia Edition (Fixed UI Opening)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
        Active = true,
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

-- Floating button (Dibuat agar sangat mudah diklik di HP)
local float = new("TextButton", {
    Name = "FloatingBtn",
    Text = "S",
    TextSize = 27,
    Font = Enum.Font.GothamBlack,
    TextColor3 = C.white,
    BackgroundColor3 = C.red,
    Size = UDim2.fromOffset(58, 58),
    Position = UDim2.new(0, 24, 0.35, 0),
    AutoButtonColor = false,
    BorderSizePixel = 0,
    Active = true,
    Parent = gui,
})
corner(float, 29)
stroke(float, Color3.fromRGB(255, 255, 255), 1.5, 0.15)
local flag = label(float, "ID", 9, UDim2.new(0, 0, 1, -17), Enum.Font.GothamBold, C.white)
flag.TextXAlignment = Enum.TextXAlignment.Center
flag.Size = UDim2.new(1, 0, 0, 12)

-- Main window (Diperbaiki agar tidak terpotong atau tersembunyi di layar kecil/HP)
local main = new("Frame", {
    Name = "Main",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(0, 480, 0, 360),
    BackgroundColor3 = C.bg,
    BorderSizePixel = 0,
    Visible = false,
    Active = true,
    Parent = gui,
})
corner(main, 16)
stroke(main, C.red, 2, 0.05)

-- Header
local header = new("Frame", {
    Size = UDim2.new(1, 0, 0, 50),
    BackgroundColor3 = Color3.fromRGB(18, 21, 29),
    BorderSizePixel = 0,
    Active = true,
}, main)
corner(header, 14)
local title = label(header, "SHOYO HUB", 18, UDim2.new(0, 16, 0, 6), Enum.Font.GothamBlack, C.white)
title.Size = UDim2.new(0.6, 0, 0, 22)
local subtitle = label(header, "STORAGE HUNTER • MERAH PUTIH EDITION", 10,
    UDim2.new(0, 16, 0, 26), Enum.Font.GothamMedium, C.muted)
subtitle.Size = UDim2.new(0.7, 0, 0, 16)
local status = label(header, "● SIAP", 11, UDim2.new(1, -145, 0, 12), Enum.Font.GothamBold, C.green)
status.Size = UDim2.fromOffset(85, 24)

local minimize = button(header, "—", UDim2.fromOffset(30, 28), UDim2.new(1, -72, 0, 11), C.panel2)
local close = button(header, "×", UDim2.fromOffset(30, 28), UDim2.new(1, -36, 0, 11), C.red)
minimize.TextSize = 16
close.TextSize = 18

-- Body and sidebar
local body = new("Frame", {
    Position = UDim2.new(0, 0, 0, 55),
    Size = UDim2.new(1, 0, 1, -55),
    BackgroundTransparency = 1,
}, main)

local sidebar = new("Frame", {
    Position = UDim2.new(0, 10, 0, 0),
    Size = UDim2.new(0, 130, 1, -10),
    BackgroundColor3 = C.panel,
    BorderSizePixel = 0,
}, body)
corner(sidebar, 12)
local sideTitle = label(sidebar, "MENU UTAMA", 11, UDim2.new(0, 10, 0, 8), Enum.Font.GothamBold, C.muted)
sideTitle.Size = UDim2.new(1, -10, 0, 20)

local content = new("ScrollingFrame", {
    Position = UDim2.new(0, 145, 0, 0),
    Size = UDim2.new(1, -155, 1, -10),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = C.red,
    CanvasSize = UDim2.new(0, 0, 0, 800),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, body)

local sections = {}
local activeTab = "Beranda"
local tabNames = {"Beranda", "Auto Farm", "Teleports", "Pengaturan"}
local tabButtons = {}

local function setTab(name)
    activeTab = name
    for tab, b in pairs(tabButtons) do
        b.BackgroundColor3 = tab == name and C.red or C.panel2
    end
    for tab, section in pairs(sections) do
        section.Visible = (name == "Beranda" or tab == name or tab == "Umum")
    end
end

for i, name in ipairs(tabNames) do
    local b = button(sidebar, name, UDim2.new(1, -12, 0, 32), UDim2.new(0, 6, 0, 32 + (i-1)*38),
        name == "Beranda" and C.red or C.panel2)
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.Text = "  " .. name
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
    label(frame, heading, 15, UDim2.new(0, 4, 0, 0), Enum.Font.GothamBold, C.white)
    return frame
end

local function makeFeatureCard(parent, titleText, description, configKey, x, y)
    local card = new("Frame", {
        Position = UDim2.new(0, x, 0, y),
        Size = UDim2.new(1, -10, 0, 75),
        BackgroundColor3 = C.panel,
        BorderSizePixel = 0,
    }, parent)
    corner(card, 10)
    stroke(card, C.border, 1, 0.15)
    
    local accent = new("Frame", {
        Size = UDim2.new(0, 3, 1, -16),
        Position = UDim2.new(0, 0, 0, 8),
        BackgroundColor3 = C.red,
        BorderSizePixel = 0,
    }, card)
    corner(accent, 2)
    
    label(card, titleText, 13, UDim2.new(0, 12, 0, 10), Enum.Font.GothamBold, C.white)
    local desc = label(card, description, 11, UDim2.new(0, 12, 0, 32), Enum.Font.Gotham, C.muted)
    desc.Size = UDim2.new(1, -80, 0, 35)
    desc.TextWrapped = true
    
    local toggle = button(card, Config[configKey] and "ON" or "OFF",
        UDim2.fromOffset(50, 26), UDim2.new(1, -60, 0.5, -13),
        Config[configKey] and C.red or C.off)
        
    toggle.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]
        toggle.Text = Config[configKey] and "ON" or "OFF"
        toggle.BackgroundColor3 = Config[configKey] and C.red or C.off
        status.Text = Config[configKey] and "● AKTIF" or "● SIAP"
        status.TextColor3 = Config[configKey] and C.red or C.green
    end)
end

-- Section Beranda (Fitur Utama)
local home = makeSection("Umum", "Fitur Utama", 340)
makeFeatureCard(home, "Auto Bid", "Otomatis menawar kontainer lelang.", "AutoBid", 0, 30)
makeFeatureCard(home, "Stop NPC Bid", "Menahan harga agar NPC berhenti menawar.", "StopNPCBid", 0, 115)
makeFeatureCard(home, "Instant Collect", "Mengambil item/reward instan di sekitar.", "InstantCollect", 0, 200)

-- Section Auto Farm
local farm = makeSection("Auto Farm", "Auto Farm & Interaksi", 200)
farm.Position = UDim2.new(0, 0, 0, 350)
makeFeatureCard(farm, "Auto Unload", "Otomatis membongkar muatan truk.", "AutoUnload", 0, 30)

-- Section Teleports (Termasuk My Plot, Grading NPC, Cleaning Tool)
local tele = makeSection("Teleports", "Pintasan Lokasi", 450)
tele.Position = UDim2.new(0, 0, 0, 560)

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
    local yPos = 30 + (i - 1) * 38
    local b = button(tele, item[1] .. " ›", UDim2.new(1, -10, 0, 32),
        UDim2.new(0, 0, 0, yPos), C.panel)
    stroke(b, C.border, 1, 0.2)
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.Text = "  " .. item[1]
    
    b.MouseButton1Click:Connect(function()
        status.Text = "● TP: " .. item[1]
        status.TextColor3 = C.red
        
        -- Eksekusi Teleport Aman ke Lokasi Game
        pcall(function()
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            
            if item[1] == "My Plot" then
                local plots = Workspace:FindFirstChild("Plots") or Workspace:FindFirstChild("PlayerPlots") or Workspace
                for _, plot in ipairs(plots:GetChildren()) do
                    if plot.Name:find(player.Name) or (plot:FindFirstChild("Owner") and plot.Owner.Value == player) then
                        local part = plot:FindFirstChildWhichIsA("BasePart", true)
                        if part then root.CFrame = part.CFrame + Vector3.new(0, 5, 0) return end
                    end
                end
            elseif item[1] == "Grading NPC" then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") and (obj.Name:lower():find("grade") or obj.Name:lower():find("grading")) then
                        local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                        if part then root.CFrame = part.CFrame + Vector3.new(0, 3, 5) return end
                    end
                end
            elseif item[1] == "Cleaning Tool" then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") and (obj.Name:lower():find("clean") or obj.Name:lower():find("wash") or obj.Name:lower():find("tool")) then
                        local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                        if part then root.CFrame = part.CFrame + Vector3.new(0, 3, 5) return end
                    end
                end
            else
                -- Teleport universal berdasarkan nama area
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if (obj:IsA("Model") or obj:IsA("Folder")) and obj.Name:lower():find(item[1]:lower():gsub(" ", "")) then
                        local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)
                        if part then root.CFrame = part.CFrame + Vector3.new(0, 4, 0) return end
                    end
                end
            end
        end)
    end)
end

-- Section Pengaturan
local settings = makeSection("Pengaturan", "Pengaturan Tampilan", 120)
settings.Position = UDim2.new(0, 0, 0, 1030)
local reset = button(settings, "Reset Status Fitur", UDim2.new(1, -10, 0, 36), UDim2.new(0, 0, 0, 30), C.red)
reset.MouseButton1Click:Connect(function()
    for k in pairs(Config) do Config[k] = false end
    status.Text = "● SIAP"
    status.TextColor3 = C.green
end)

-- Routing Tab Menu
tabButtons["Beranda"].MouseButton1Click:Connect(function()
    home.Visible = true; farm.Visible = false; tele.Visible = false; settings.Visible = false
end)
tabButtons["Auto Farm"].MouseButton1Click:Connect(function()
    home.Visible = false; farm.Visible = true; tele.Visible = false; settings.Visible = false
end)
tabButtons["Teleports"].MouseButton1Click:Connect(function()
    home.Visible = false; farm.Visible = false; tele.Visible = true; settings.Visible = false
end)
tabButtons["Pengaturan"].MouseButton1Click:Connect(function()
    home.Visible = false; farm.Visible = false; tele.Visible = false; settings.Visible = true
end)

home.Visible = true; farm.Visible = false; tele.Visible = false; settings.Visible = false

-- Sistem Dragging yang Stabil untuk Menu Utama & Tombol Floating
local function makeDraggable(topbarObject, object)
    local dragging, dragStart, startPos
    topbarObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

makeDraggable(header, main)
makeDraggable(float, float)

-- Handler Buka / Tutup / Minimize Menu
float.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

close.MouseButton1Click:Connect(function()
    main.Visible = false
end)

minimize.MouseButton1Click:Connect(function()
    body.Visible = not body.Visible
    main.Size = body.Visible and UDim2.new(0, 480, 0, 360) or UDim2.new(0, 480, 0, 50)
end)

-- Logika Utama Fitur (Auto Bid, Stop NPC Bid & Instant Collect)
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if Config.AutoBid or Config.StopNPCBid then
                local playerGui = player:FindFirstChild("PlayerGui")
                if playerGui then
                    for _, gui in ipairs(playerGui:GetDescendants()) do
                        if gui:IsA("TextButton") and (gui.Text:upper():find("BID") or gui.Name:upper():find("BID")) then
                            if Config.AutoBid or Config.StopNPCBid then
                                firesignal(gui.MouseButton1Click)
                            end
                        end
                    end
                end
            end

            if Config.InstantCollect or Config.AutoUnload then
                for _, prompt in ipairs(Workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then
                        local char = player.Character
                        local root = char and char:FindFirstChild("HumanoidRootPart")
                        if root and prompt.Parent and prompt.Parent:IsA("BasePart") then
                            if (root.Position - prompt.Parent.Position).Magnitude < 25 then
                                fireproximityprompt(prompt)
                            end
                        end
                    end
                end
            end
        end)
    end
end)

print("[SuperShoyo Hub] Red-White Indonesia Edition loaded successfully.")
