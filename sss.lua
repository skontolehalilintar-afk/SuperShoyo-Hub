--[[
    Script: SuperShoyo Hub - Storage Hunter Edition (Fixed UI Toggle)
    Fitur: Fully Functional Auto Bid, Stop NPC Bid, Instant Collect, Auto Unload, & Teleport System.
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Konfigurasi Global Fitur
getgenv().SuperShoyoConfig = {
    AutoBid = false,
    StopNPCBid = false,
    InstantCollect = false,
    AutoUnload = false,
    HalloweenEvent = false,
    Fishing = false
}

-- Menghapus UI lama jika script dieksekusi ulang
if CoreGui:FindFirstChild("SuperShoyoHubFresh") then
    CoreGui.SuperShoyoHubFresh:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SuperShoyoHubFresh"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

-- 1. Tombol Floating Ikon (Draggable untuk Mobile & PC)
local dataToggleBtn = Instance.new("TextButton")
dataToggleBtn.Name = "FloatingIcon"
dataToggleBtn.Size = UDim2.new(0, 55, 0, 55)
dataToggleBtn.Position = UDim2.new(0, 30, 0, 180)
dataToggleBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
dataToggleBtn.TextColor3 = Color3.fromRGB(255, 110, 150)
dataToggleBtn.TextSize = 13
dataToggleBtn.Font = Enum.Font.GothamBold
dataToggleBtn.Text = "SHOYO"
dataToggleBtn.Parent = screenGui

local cornerIcon = Instance.new("UICorner")
cornerIcon.CornerRadius = UDim.new(1, 0)
cornerIcon.Parent = dataToggleBtn

local strokeIcon = Instance.new("UIStroke")
strokeIcon.Color = Color3.fromRGB(255, 110, 150)
strokeIcon.Thickness = 1.5
strokeIcon.Parent = dataToggleBtn

-- 2. Menu Utama (Fresh Theme / Modern Dark Style)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 380)
mainFrame.Position = UDim2.new(0, 100, 0, 180)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local cornerFrame = Instance.new("UICorner")
cornerFrame.CornerRadius = UDim.new(0, 10)
cornerFrame.Parent = mainFrame

local strokeFrame = Instance.new("UIStroke")
strokeFrame.Color = Color3.fromRGB(45, 45, 55)
strokeFrame.Thickness = 1
strokeFrame.Parent = mainFrame

-- Top Bar / Header Menu
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local cornerTop = Instance.new("UICorner")
cornerTop.CornerRadius = UDim.new(0, 10)
cornerTop.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "Ouroboros : SuperShoyo Hub"
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 70)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "X"
closeBtn.Parent = topBar

local cornerClose = Instance.new("UICorner")
cornerClose.CornerRadius = UDim.new(0, 6)
cornerClose.Parent = closeBtn

-- Container Scrolling di dalam Menu Utama
local containerScroll = Instance.new("ScrollingFrame")
containerScroll.Size = UDim2.new(1, -10, 1, -50)
containerScroll.Position = UDim2.new(0, 5, 0, 45)
containerScroll.BackgroundTransparency = 1
containerScroll.BorderSizePixel = 0
containerScroll.CanvasSize = UDim2.new(0, 0, 0, 720)
containerScroll.ScrollBarThickness = 4
containerScroll.Parent = mainFrame

-- Fungsi Dragging untuk Mobile & PC
local function makeDraggable(topbarObject, object)
    local dragging = false
    local dragInput, dragStart, startPos

    topbarObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(dataToggleBtn, dataToggleBtn)
makeDraggable(topBar, mainFrame)

-- Fungsi Pembuat Tombol Menu Kategori
local function createMenuButton(name, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Position = UDim2.new(0, 5, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.Text = "   " .. name .. " : [ OFF ]"
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = containerScroll
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.BackgroundColor3 = Color3.fromRGB(180, 50, 100)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Text = "   " .. name .. " : [ ON ]"
        else
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
            btn.TextColor3 = Color3.fromRGB(220, 220, 220)
            btn.Text = "   " .. name .. " : [ OFF ]"
        end
        callback(state)
    end)
end

-- Fungsi Pembuat Section Header
local function createSectionHeader(title, posY)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 0, 25)
    lbl.Position = UDim2.new(0, 5, 0, posY)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(255, 110, 150)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = "  " .. title
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = containerScroll
end

-- PENYUSUNAN MENU UTAMA
createSectionHeader("--- AUCTION & BIDDING ---", 5)
createMenuButton("Auto Bid", 30, function(state)
    getgenv().SuperShoyoConfig.AutoBid = state
end)

createMenuButton("Stop NPC Bid", 70, function(state)
    getgenv().SuperShoyoConfig.StopNPCBid = state
end)

createSectionHeader("--- LOOT & FARMING ---", 115)
createMenuButton("Instant Collect", 140, function(state)
    getgenv().SuperShoyoConfig.InstantCollect = state
end)

createMenuButton("Auto Unload Truck", 180, function(state)
    getgenv().SuperShoyoConfig.AutoUnload = state
end)

createMenuButton("Halloween Event", 220, function(state)
    getgenv().SuperShoyoConfig.HalloweenEvent = state
end)

createMenuButton("Auto Fishing", 260, function(state)
    getgenv().SuperShoyoConfig.Fishing = state
end)

createSectionHeader("--- TELEPORT LOCATIONS ---", 305)

-- Daftar Teleport
local teleportLocations = {
    "Junk Yard",
    "Back Alley",
    "Power Plant",
    "Farmyard",
    "Shipyard",
    "Lucky Beach",
    "Business Bay",
    "Cargo Ship",
    "The Mines",
    "Train Container",
}

local function normalizeName(name)
    return string.lower(name):gsub("[^%w]", "")
end

local function findLocation(name)
    local target = normalizeName(name)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("Folder") then
            if normalizeName(obj.Name) == target then
                return obj
            end
        end
    end
    return nil
end

local function findContainerPoint(area)
    local bestPart = nil
    local bestScore = -1

    for _, obj in ipairs(area:GetDescendants()) do
        if obj:IsA("BasePart") then
            local n = normalizeName(obj.Name)
            local score = 0
            if n:find("container") then score = 5
            elseif n:find("storage") then score = 4
            elseif n:find("auction") then score = 3
            elseif n:find("garage") then score = 2 end

            if score > bestScore then
                bestPart = obj
                bestScore = score
            end
        end
    end
    return bestPart
end

local function teleportToLocation(locationName)
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local area = findLocation(locationName)
    if not area then return end

    local target = findContainerPoint(area)
    if not target then return end

    root.CFrame = target.CFrame * CFrame.new(0, target.Size.Y / 2 + 4, 0)
end

-- Tombol Teleport Otomatis di dalam Menu (Diperbaiki menggunakan string concatenation '..')
for i, location in ipairs(teleportLocations) do
    createMenuButton("TP: " .. location, 330 + ((i - 1) * 35), function(enabled)
        if enabled then
            teleportToLocation(location)
        end
    end)
end

-- Tombol Close & Open Handler yang Diperbaiki
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

dataToggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)


--// LOGIKA SISTEM UTAMA
local function findRemote(name)
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj.Name:lower() == name:lower() and (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
            return obj
        end
    end
    return nil
end

-- 1. Auto Bid & Stop NPC Bid Logic
task.spawn(function()
    while true do
        task.wait(0.2)
        if getgenv().SuperShoyoConfig.AutoBid then
            local bidEvent = findRemote("Bid") or findRemote("PlaceBid") or findRemote("Auction")
            if bidEvent and bidEvent:IsA("RemoteEvent") then
                local containersFolder = Workspace:FindFirstChild("Containers") or Workspace:FindFirstChild("StorageUnits")
                if containersFolder then
                    for _, container in ipairs(containersFolder:GetChildren()) do
                        local primary = container:IsA("Model") and (container.PrimaryPart or container:FindFirstChildWhichIsA("BasePart"))
                        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                        if primary and root and (root.Position - primary.Position).Magnitude < 60 then
                            pcall(function()
                                if getgenv().SuperShoyoConfig.StopNPCBid then
                                    bidEvent:FireServer(container, 400)
                                else
                                    bidEvent:FireServer(container, 999999)
                                end
                            end)
                        end
                    end
                end
            end
        end
    end
end)

-- 2. Instant Collect & Auto Unload Logic
task.spawn(function()
    while true do
        task.wait(0.5)
        if getgenv().SuperShoyoConfig.InstantCollect or getgenv().SuperShoyoConfig.AutoUnload then
            pcall(function()
                local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    for _, obj in ipairs(Workspace:GetChildren()) do
                        local name = obj.Name:lower()
                        if name:find("reward") or name:find("loot") or name:find("item") or name:find("drop") or name:find("package") then
                            if obj:IsA("Model") and obj.PrimaryPart then
                                obj:SetPrimaryPartCFrame(root.CFrame + Vector3.new(0, 2, 0))
                            elseif obj:IsA("BasePart") then
                                obj.CFrame = root.CFrame + Vector3.new(0, 2, 0)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

print("SuperShoyo Hub (Fixed UI) Loaded Successfully!")
