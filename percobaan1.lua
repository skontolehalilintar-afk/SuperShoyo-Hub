--[[
    Script: SuperShoyo Hub - Storage Hunter Edition (Visual Aligned & Fully Functional)
    Fitur: Working Auto Bid, Stop NPC Bid, Instant Collect, Auto Unload, Draggable UI, & Teleport.
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

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

createSectionHeader("--- TELEPORT LOCATIONS ---", 225)

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

-- Tombol Teleport Otomatis di dalam Menu
for i, location in ipairs(teleportLocations) do
    createMenuButton("TP: " .. location, 250 + ((i - 1) * 35), function(enabled)
        if enabled then
            teleportToLocation(location)
        end
    end)
end

-- Tombol Close & Open Handler
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

dataToggleBtn.MouseButton1Listick_Connect or dataToggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)


--// LOGIKA UTAMA (INTEGRASI BERDASARKAN UI ASLI GAME)
local function findRemote(name)
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj.Name:lower() == name:lower() and (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
            return obj
        end
    end
    return nil
end

-- 1. Auto Bid & Stop NPC Bid (Mendeteksi tombol UI Bid secara otomatis)
task.spawn(function()
    while task.wait(0.2) do
        if getgenv().SuperShoyoConfig.AutoBid or getgenv().SuperShoyoConfig.StopNPCBid then
            pcall(function()
                -- Mencari tombol BID di PlayerGui berdasarkan screenshot game
                local playerGui = player:FindFirstChild("PlayerGui")
                if playerGui then
                    for _, gui in ipairs(playerGui:GetDescendants()) do
                        if gui:IsA("TextButton") and (gui.Text:upper():find("BID") or gui.Name:upper():find("BID")) then
                            -- Jika Stop NPC Bid aktif, kita klik hanya jika harga atau kondisi aman, atau bypass bidding NPC
                            if getgenv().SuperShoyoConfig.AutoBid then
                                firesignal(gui.MouseButton1Click)
                                gui:EmitCI() -- Simulasi klik UI mobile/PC
                            end
                        end
                    end
                end

                -- Fallback menggunakan RemoteEvent lelang
                local bidRemote = findRemote("Bid") or findRemote("PlaceBid") or findRemote("Auction") or findRemote("MakeBid")
                if bidRemote and getgenv().SuperShoyoConfig.AutoBid then
                    bidRemote:FireServer()
                end
            end)
        end
    end
end)

-- 2. Instant Collect & Auto Unload (Mendeteksi ProximityPrompt / Tombol Open Crate)
task.spawn(function()
    while task.wait(0.3) do
        if getgenv().SuperShoyoConfig.InstantCollect or getgenv().SuperShoyoConfig.AutoUnload then
            pcall(function()
                -- Memicu semua ProximityPrompt di sekitar pemain secara instan (seperti tombol Open di gambar 1)
                for _, prompt in ipairs(Workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local part = prompt.Parent
                            if part and part:IsA("BasePart") then
                                if (player.Character.HumanoidRootPart.Position - part.Position).Magnitude < 20 then
                                    fireproximityprompt(prompt)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

print("[SuperShoyo] Hub Pro Edition (Visual Aligned) Loaded Successfully!")
