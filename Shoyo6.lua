-- SuperShoyo Hub | Auction Core Only (Auto Bid & Stop NPC Bid Test)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Clean Up Old GUI
if playerGui:FindFirstChild("ShoyoAuctionCore") then
    playerGui.ShoyoAuctionCore:Destroy()
end

-- ScreenGui Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ShoyoAuctionCore"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 99999
screenGui.Parent = playerGui

-- Colors
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

local function outline(obj, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Parent = obj
end

-- Floating Toggle Button
local floatBtn = Instance.new("TextButton")
floatBtn.Name = "FloatButton"
floatBtn.Size = UDim2.new(0, 50, 0, 50)
floatBtn.Position = UDim2.new(0, 20, 0, 200)
floatBtn.BackgroundColor3 = RED
floatBtn.TextColor3 = WHITE
floatBtn.TextSize = 22
floatBtn.Font = Enum.Font.GothamBlack
floatBtn.Text = "BID"
floatBtn.Active = true
floatBtn.ZIndex = 10
floatBtn.Parent = screenGui
corner(floatBtn, 25)
outline(floatBtn, WHITE, 1.5)

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 220)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -110)
mainFrame.BackgroundColor3 = BLACK
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ZIndex = 5
mainFrame.Parent = screenGui
corner(mainFrame, 12)
outline(mainFrame, RED, 1.5)

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundColor3 = RED_DARK
header.Parent = mainFrame
corner(header, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "AUCTION CORE TEST"
title.TextColor3 = WHITE
title.TextSize = 14
title.Font = Enum.Font.GothamBlack
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -32, 0, 10)
closeBtn.BackgroundColor3 = RED
closeBtn.TextColor3 = WHITE
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header
corner(closeBtn, 6)

-- Global State
local Config = { AutoBid = false, StopNPCBid = false }

local function createToggle(name, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = BUTTON
    btn.TextColor3 = MUTED
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.Text = "    " .. name
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = mainFrame
    corner(btn, 8)
    outline(btn, BORDER, 1)

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

createToggle("Auto Bid (Smart Bidding)", 60, function(s) Config.AutoBid = s end)
createToggle("Stop NPC Bid (Counter-Bid)", 110, function(s) Config.StopNPCBid = s end)

-- Menu Drag & Toggle Controls
floatBtn.Activated:Connect(function() mainFrame.Visible = not mainFrame.Visible end)
closeBtn.Activated:Connect(function() mainFrame.Visible = false end)

local dragging, dragStart, startPos
floatBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = floatBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
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
-- LOGIKA LELANG (STATE-BASED LOGIC)
-- =======================================================

local bidBusy = false
local lastBidKey = nil
local lastBidAttempt = 0
local BID_COOLDOWN = 1.2
local lastHighestName = nil
local lastHighestPrice = nil

local function cleanText(str)
    return (str or ""):upper():gsub("%s+", " "):match("^%s*(.-)%s*$")
end

local function getBidButton()
    local gui = player:FindFirstChild("PlayerGui")
    if not gui then return nil end

    for _, v in ipairs(gui:GetDescendants()) do
        if v:IsA("TextButton") and v.Visible and v.Active then
            local txt = cleanText(v.Text)
            if txt == "BID" or txt:find("BID") then
                return v
            end
        end
    end
    return nil
end

local function scanAuctionState()
    local gui = player:FindFirstChild("PlayerGui")
    if not gui then return nil end

    local current, nextBid, highestName, highestPrice

    for _, obj in ipairs(gui:GetDescendants()) do
        if obj:IsA("TextLabel") and obj.Visible then
            local txt = cleanText(obj.Text)
            if txt:find("CURRENT", 1, true) then
                current = txt
            elseif txt:find("NEXT", 1, true) then
                nextBid = txt
            elseif txt == "HIGHEST BID" then
                local parent = obj.Parent
                if parent then
                    for _, child in ipairs(parent:GetDescendants()) do
                        if child:IsA("TextLabel") and child.Visible then
                            local val = cleanText(child.Text)
                            if val ~= "HIGHEST BID" then
                                if val:find("$", 1, true) then
                                    highestPrice = val
                                elseif val ~= "" then
                                    highestName = val
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
        highestPrice = highestPrice
    }
end

local function executeBid(state)
    if bidBusy or not state or not state.nextBid then return end

    local stateKey = table.concat({
        state.current or "",
        state.nextBid or "",
        state.highestName or "",
        state.highestPrice or ""
    }, "|")

    local now = os.clock()
    if stateKey == lastBidKey or (now - lastBidAttempt < BID_COOLDOWN) then return end

    local btn = getBidButton()
    if not btn then return end

    bidBusy = true
    lastBidKey = stateKey
    lastBidAttempt = now

    pcall(function()
        if firesignal then
            firesignal(btn.MouseButton1Click)
            firesignal(btn.Activated)
        end
        btn:Activate()
    end)

    task.delay(BID_COOLDOWN, function()
        bidBusy = false
    end)
end

-- LOOP UTAMA AUCTION ENGINE
task.spawn(function()
    while task.wait(0.25) do
        local ok, state = pcall(scanAuctionState)

        if ok and state then
            local isNewHighest = (state.highestName ~= lastHighestName) or (state.highestPrice ~= lastHighestPrice)
            if isNewHighest then
                lastHighestName = state.highestName
                lastHighestPrice = state.highestPrice
            end

            -- 1. Mode Auto Bid
            if Config.AutoBid then
                pcall(executeBid, state)
            end

            -- 2. Mode Stop NPC Bid (Counter Bid jika direbut NPC)
            if Config.StopNPCBid and isNewHighest then
                if state.highestName and not state.highestName:find(player.Name:upper(), 1, true) then
                    pcall(executeBid, state)
                end
            end
        end
    end
end)

print("[Shoyo Hub] Dedicated Auction Core Loaded!")
