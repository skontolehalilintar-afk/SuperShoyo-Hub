-- SuperShoyo Hub | Red-White Edition (State-Based Auction System)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("SuperShoyoHubSimple") then
    playerGui.SuperShoyoHubSimple:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SuperShoyoHubSimple"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 99999
screenGui.Parent = playerGui

-- Palet Warna Merah Putih
local RED = Color3.fromRGB(239, 35, 55)
local RED_DARK = Color3.fromRGB(105, 13, 28)
local BLACK = Color3.fromRGB(10, 13, 19)
local PANEL = Color3.fromRGB(18, 23, 32)
local BUTTON = Color3.fromRGB(27, 33, 45)
local WHITE = Color3.fromRGB(255, 255, 255)
local MUTED = Color3.fromRGB(190, 199, 214)
local BORDER = Color3.fromRGB(76, 87, 105)

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
end

local function outline(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = obj
end

-- Floating Button 'S'
local floatBtn = Instance.new("TextButton")
floatBtn.Name = "FloatButton"
floatBtn.Size = UDim2.new(0, 60, 0, 60)
floatBtn.Position = UDim2.new(0, 30, 0, 200)
floatBtn.BackgroundColor3 = RED
floatBtn.TextColor3 = WHITE
floatBtn.TextSize = 25
floatBtn.Font = Enum.Font.GothamBlack
floatBtn.Text = "S"
floatBtn.Active = true
floatBtn.Selectable = true
floatBtn.ZIndex = 10
floatBtn.AutoButtonColor = true
floatBtn.Parent = screenGui
corner(floatBtn, 30)
outline(floatBtn, WHITE, 1.5, 0.12)

-- Main Panel
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 340, 0, 440)
mainFrame.Position = UDim2.new(0.5, -170, 0.5, -220)
mainFrame.BackgroundColor3 = BLACK
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.ZIndex = 5
mainFrame.Parent = screenGui
corner(mainFrame, 14)
outline(mainFrame, RED, 1.7, 0.05)

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 58)
header.BackgroundColor3 = RED_DARK
header.BorderSizePixel = 0
header.ZIndex = 6
header.Parent = mainFrame
corner(header, 14)

local accent = Instance.new("Frame")
accent.Size = UDim2.new(1, 0, 0, 3)
accent.Position = UDim2.new(0, 0, 1, -3)
accent.BackgroundColor3 = RED
accent.BorderSizePixel = 0
accent.ZIndex = 7
accent.Parent = header

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -58, 0, 30)
titleLabel.Position = UDim2.new(0, 15, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = WHITE
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.Text = "SHOYO HUB"
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 8
titleLabel.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -58, 0, 17)
subtitle.Position = UDim2.new(0, 16, 0, 34)
subtitle.BackgroundTransparency = 1
subtitle.TextColor3 = MUTED
subtitle.TextSize = 10
subtitle.Font = Enum.Font.GothamMedium
subtitle.Text = "STORAGE HUNTER  •  MERAH PUTIH"
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.ZIndex = 8
subtitle.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -38, 0, 13)
closeBtn.BackgroundColor3 = RED
closeBtn.TextColor3 = WHITE
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "×"
closeBtn.Active = true
closeBtn.Selectable = true
closeBtn.ZIndex = 9
closeBtn.Parent = header
corner(closeBtn, 8)

-- Scrolling Container
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -16, 1, -72)
scroll.Position = UDim2.new(0, 8, 0, 65)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.CanvasSize = UDim2.new(0, 0, 0, 950)
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = RED
scroll.ZIndex = 6
scroll.Parent = mainFrame

local sectionLabel = Instance.new("TextLabel")
sectionLabel.Size = UDim2.new(1, -10, 0, 20)
sectionLabel.Position = UDim2.new(0, 5, 0, 0)
sectionLabel.BackgroundTransparency = 1
sectionLabel.Text = "FITUR UTAMA"
sectionLabel.TextColor3 = RED
sectionLabel.TextSize = 11
sectionLabel.Font = Enum.Font.GothamBold
sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
sectionLabel.ZIndex = 7
sectionLabel.Parent = scroll

local function addBtn(name, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 38)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = BUTTON
    btn.TextColor3 = MUTED
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamMedium
    btn.Text = "    " .. name
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Active = true
    btn.Selectable = true
    btn.ZIndex = 7
    btn.BorderSizePixel = 0
    btn.Parent = scroll
    corner(btn, 8)
    outline(btn, BORDER, 1, 0.35)

    local active = false
    btn.Activated:Connect(function()
        active = not active
        if active then
            btn.BackgroundColor3 = RED
            btn.TextColor3 = WHITE
            btn.Text = "    " .. name .. "  [ON]"
        else
            btn.BackgroundColor3 = BUTTON
            btn.TextColor3 = MUTED
            btn.Text = "    " .. name
        end
        callback(active)
    end)
end

-- Global Config
local Config = { AutoBid = false, StopNPCBid = false, InstantCollect = false, AutoUnload = false }

addBtn("Auto Bid (Smart Bidding)", 30, function(state) Config.AutoBid = state end)
addBtn("Stop NPC Bid (Counter-Bid)", 75, function(state) Config.StopNPCBid = state end)
addBtn("Instant Collect Items", 120, function(state) Config.InstantCollect = state end)
addBtn("Auto Unload Truck", 165, function(state) Config.AutoUnload = state end)

local tpHeader = Instance.new("TextLabel")
tpHeader.Size = UDim2.new(1, -10, 0, 20)
tpHeader.Position = UDim2.new(0, 5, 0, 210)
tpHeader.BackgroundTransparency = 1
tpHeader.Text = "LOKASI TELEPORT"
tpHeader.TextColor3 = RED
tpHeader.TextSize = 11
tpHeader.Font = Enum.Font.GothamBold
tpHeader.TextXAlignment = Enum.TextXAlignment.Left
tpHeader.ZIndex = 7
tpHeader.Parent = scroll

local tps = {
    "My Plot", "Grading", "Cleaning", "Junk Yard", "Back Alley",
    "Power Plant", "Farmyard", "Shipyard", "Lucky Beach", "Business Bay",
    "Cargo Ship", "Shopping Mall", "The Mines", "Train Container"
}

local function normalizeName(name)
    return string.lower(name):gsub("[^%w]", "")
end

local function findLocation(name)
    local target = normalizeName(name)
    local matches = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("Folder") or obj:IsA("BasePart") then
            local objectName = normalizeName(obj.Name)
            if objectName == target or objectName:find(target) then
                table.insert(matches, obj)
            end
        end
    end
    return matches
end

for i, loc in ipairs(tps) do
    local y = 240 + ((i - 1) * 43)
    local tpBtn = Instance.new("TextButton")
    tpBtn.Size = UDim2.new(1, -10, 0, 38)
    tpBtn.Position = UDim2.new(0, 5, 0, y)
    tpBtn.BackgroundColor3 = PANEL
    tpBtn.TextColor3 = WHITE
    tpBtn.TextSize = 13
    tpBtn.Font = Enum.Font.GothamMedium
    tpBtn.Text = "    ↗  TP: " .. loc
    tpBtn.TextXAlignment = Enum.TextXAlignment.Left
    tpBtn.Active = true
    tpBtn.Selectable = true
    tpBtn.ZIndex = 7
    tpBtn.BorderSizePixel = 0
    tpBtn.Parent = scroll
    corner(tpBtn, 8)
    outline(tpBtn, RED_DARK, 1, 0.15)

    tpBtn.Activated:Connect(function()
        pcall(function()
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return end

            if loc == "My Plot" then
                local foundPlot = false
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") or obj:IsA("Folder") then
                        local n = obj.Name:lower()
                        if n:find("plot") or n:find("base") or n:find("storage") then
                            if n:find(player.Name:lower()) or (obj:FindFirstChild("Owner") and obj.Owner.Value == player) then
                                local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)
                                if part then
                                    root.CFrame = part.CFrame + Vector3.new(0, 4, 0)
                                    foundPlot = true
                                    break
                                end
                            end
                        end
                    end
                end
                if not foundPlot then
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj.Name == "Plots" or obj.Name == "PlayerPlots" then
                            for _, pPlot in ipairs(obj:GetChildren()) do
                                local part = pPlot:FindFirstChildWhichIsA("BasePart", true)
                                if part then
                                    root.CFrame = part.CFrame + Vector3.new(0, 4, 0)
                                    return
                                end
                            end
                        end
                    end
                end
                return
            end

            local foundMatches = findLocation(loc)
            for _, obj in ipairs(foundMatches) do
                local part = obj:IsA("BasePart") and obj or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)))
                if part then
                    root.CFrame = part.CFrame + Vector3.new(0, 4, 0)
                    return
                end
            end
        end)
    end)
end

-- Toggle Menu Buka/Tutup
floatBtn.Activated:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

closeBtn.Activated:Connect(function()
    mainFrame.Visible = false
end)

-- Sistem Dragging Floating 'S'
local dragging, dragStart, startPos
floatBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = floatBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        floatBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- =======================================================
-- LOGIKA BARU: STATE-BASED AUTO BID & COUNTER-BID SYSTEM
-- =======================================================

local bidBusy = false
local lastBidKey = nil
local lastBidAttempt = 0
local BID_COOLDOWN = 1.2

local lastHighestBidText = nil
local lastCurrentBidText = nil

local function normalizeText(text)
    return (text or ""):upper():gsub("%s+", " "):match("^%s*(.-)%s*$")
end

local function findBidButton()
    local gui = player:FindFirstChild("PlayerGui")
    if not gui then return nil end

    for _, obj in ipairs(gui:GetDescendants()) do
        if obj:IsA("TextButton") and obj.Visible and obj.Active then
            local txt = normalizeText(obj.Text)
            if txt == "BID" or txt:find("BID") then
                return obj
            end
        end
    end

    return nil
end

local function readAuctionState()
    local gui = player:FindFirstChild("PlayerGui")
    if not gui then return nil end

    local current, nextBid, highestName, highestPrice

    for _, obj in ipairs(gui:GetDescendants()) do
        if obj:IsA("TextLabel") and obj.Visible then
            local text = normalizeText(obj.Text)

            if text:find("CURRENT", 1, true) then
                current = text
            elseif text:find("NEXT", 1, true) then
                nextBid = text
            elseif text == "HIGHEST BID" then
                local parent = obj.Parent
                if parent then
                    for _, child in ipairs(parent:GetDescendants()) do
                        if child:IsA("TextLabel") and child.Visible then
                            local value = normalizeText(child.Text)
                            if value ~= "HIGHEST BID" then
                                if value:find("$", 1, true) then
                                    highestPrice = value
                                elseif value ~= "" then
                                    highestName = value
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return {
        current = current,
        nextBid = nextBid,
        highestName = highestName,
        highestPrice = highestPrice,
    }
end

local function attemptBid(state)
    if bidBusy then return end
    if not state or not state.nextBid then return end

    local key = table.concat({
        state.current or "",
        state.nextBid or "",
        state.highestName or "",
        state.highestPrice or ""
    }, "|")

    local now = os.clock()

    if key == lastBidKey then return end
    if now - lastBidAttempt < BID_COOLDOWN then return end

    local button = findBidButton()
    if not button then return end

    bidBusy = true
    lastBidKey = key
    lastBidAttempt = now

    pcall(function()
        if firesignal then
            firesignal(button.MouseButton1Click)
            firesignal(button.Activated)
        end
        button:Activate()
    end)

    task.delay(BID_COOLDOWN, function()
        bidBusy = false
    end)
end

-- LOOP UTAMA PENGAWAS LELANG
task.spawn(function()
    while task.wait(0.25) do
        local ok, state = pcall(readAuctionState)

        if ok and state then
            local highestChanged =
                state.highestName ~= lastHighestBidText
                or state.highestPrice ~= lastCurrentBidText

            if highestChanged then
                lastHighestBidText = state.highestName
                lastCurrentBidText = state.highestPrice
            end

            -- 1. Auto Bid: Menawar jika ada pembaruan harga
            if Config.AutoBid then
                pcall(attemptBid, state)
            end

            -- 2. Stop NPC Bid (Counter Bid): Respon langsung jika penawar tertinggi berubah ke NPC
            if Config.StopNPCBid and highestChanged then
                if state.highestName and not state.highestName:find(player.Name:upper(), 1, true) then
                    pcall(attemptBid, state)
                end
            end
        end

        -- Instant Collect & Unload
        if Config.InstantCollect or Config.AutoUnload then
            pcall(function()
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
            end)
        end
    end
end)

print("[SuperShoyo] State-Based Auction System Loaded Successfully!")
