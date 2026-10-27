--[[
    Script: SuperShoyo Hub - Storage Hunter Edition (Ouroboros Style)
    Fitur: Auto Bid, Stop NPC Bid, Instant Collect / Auto Unload, Draggable UI (Mobile Friendly), Halloween, & Fishing.
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

-- Konfigurasi Status Fitur
getgenv().SuperShoyoConfig = {
    AutoBid = false,
    StopNPCBid = false,
    InstantCollect = false,
    AutoUnload = false,
    HalloweenEvent = false,
    Fishing = false,
    MinBidValue = 0
}

-- Menghapus UI lama jika script dieksekusi ulang
if CoreGui:FindFirstChild("SuperShoyoHub") then
    CoreGui.SuperShoyoHub:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SuperShoyoHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

-- 1. Tombol Ikon Mengambang (Bisa Digeser / Draggable)
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleIcon"
toggleButton.Size = UDim2.new(0, 55, 0, 55)
toggleButton.Position = UDim2.new(0, 30, 0, 200)
toggleButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
toggleButton.TextColor3 = Color3.fromRGB(255, 100, 150) -- Tema ala Ouroboros (Pink/Magenta accent)
toggleButton.TextSize = 13
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Text = "SHOYO"
toggleButton.Parent = screenGui

local cornerIcon = Instance.new("UICorner")
cornerIcon.CornerRadius = UDim.new(1, 0)
cornerIcon.Parent = toggleButton

-- 2. Menu Utama (Frame Utama yang juga Draggable)
local mainFrame = Instance.new("ScrollingFrame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 260, 0, 380)
mainFrame.Position = UDim2.new(0, 100, 0, 200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.CanvasSize = UDim2.new(0, 0, 0, 520)
mainFrame.Parent = screenGui

local cornerFrame = Instance.new("UICorner")
cornerFrame.CornerRadius = UDim.new(0, 8)
cornerFrame.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleLabel.TextColor3 = Color3.fromRGB(255, 150, 180)
titleLabel.TextSize = 15
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Text = "SuperShoyo Hub v2.0"
titleLabel.Parent = mainFrame

-- Fungsi Drag / Geser untuk Mobile & PC (Supaya gampang diatur di HP)
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

-- Terapkan fungsi drag ke Tombol Floating dan Menu Utama
makeDraggable(toggleButton, toggleButton)
makeDraggable(titleLabel, mainFrame)

-- Fungsi Pembuat Tombol Toggle Fitur
local function createMenuButton(name, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 240, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.SourceSans
    btn.Text = name .. " : OFF"
    btn.Parent = mainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.BackgroundColor3 = Color3.fromRGB(180, 50, 100) -- Warna aktif ala tema Ouroboros
            btn.Text = name .. " : ON"
        else
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            btn.Text = name .. " : OFF"
        end
        callback(state)
    end)
end

-- Fungsi Pembuat Tombol Teleport Cepat
local function createTeleportButton(name, posY, targetPosition)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 240, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = "TP to: " .. name
    btn.Parent = mainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        if character and humanoidRootPart then
            humanoidRootPart.CFrame = targetPosition
        end
    end)
end

-- Menyusun Menu Sesuai Permintaan (Mirip Ouroboros)
createMenuButton("Auto Bid", 50, function(state)
    getgenv().SuperShoyoConfig.AutoBid = state
end)

createMenuButton("Stop NPC Bid", 90, function(state)
    getgenv().SuperShoyoConfig.StopNPCBid = state
end)

createMenuButton("Instant Collect", 130, function(state)
    getgenv().SuperShoyoConfig.InstantCollect = state
end)

createMenuButton("Auto Unload Truck", 170, function(state)
    getgenv().SuperShoyoConfig.AutoUnload = state
end)

createMenuButton("Halloween Event Farm", 210, function(state)
    getgenv().SuperShoyoConfig.HalloweenEvent = state
end)

createMenuButton("Auto Fishing", 250, function(state)
    getgenv().SuperShoyoConfig.Fishing = state
end)

-- Bagian Label Teleport
local tpLabel = Instance.new("TextLabel")
tpLabel.Size = UDim2.new(1, 0, 0, 25)
tpLabel.Position = UDim2.new(0, 0, 0, 295)
tpLabel.BackgroundTransparency = 1
tpLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
tpLabel.TextSize = 12
tpLabel.Font = Enum.Font.SourceSansBold
tpLabel.Text = "--- QUICK TELEPORT ---"
tpLabel.Parent = mainFrame

createTeleportButton("Auction Area", 325, CFrame.new(0, 5, 0))
createTeleportButton("Shop / Storage", 360, CFrame.new(50, 5, 50))
createTeleportButton("Fishing Spot", 395, CFrame.new(-100, 5, 100))

-- Tombol Close Menu
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 240, 0, 30)
closeBtn.Position = UDim2.new(0, 10, 0, 440)
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.Text = "Close Menu"
closeBtn.Parent = mainFrame

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)


--// LOGIKA EKSEKUSI FITUR UTAMA
local remoteFolder = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("Events")
local bidRemote = remoteFolder and (remoteFolder:FindFirstChild("Bid") or remoteFolder:FindFirstChild("PlaceBid"))

local function getNearestContainer()
    local nearest = nil
    local shortestDistance = math.huge
    local containersFolder = Workspace:FindFirstChild("Containers") or Workspace:FindFirstChild("StorageUnits")
    
    if containersFolder then
        for _, container in ipairs(containersFolder:GetChildren()) do
            local primaryPart = container:IsA("Model") and (container.PrimaryPart or container:FindFirstChild("Base") or container:FindFirstChildWhichIsA("BasePart"))
            if primaryPart then
                local dist = (humanoidRootPart.Position - primaryPart.Position).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    nearest = container
                end
            end
        end
    end
    return nearest
end

-- 1. Logika Auto Bid & Stop NPC Bid
task.spawn(function()
    while true do
        task.wait(0.1)
        if getgenv().SuperShoyoConfig.AutoBid then
            if bidRemote and bidRemote:IsA("RemoteEvent") then
                local targetContainer = getNearestContainer()
                if targetContainer then
                    if getgenv().SuperShoyoConfig.StopNPCBid then
                        -- Menahan bid NPC dengan nominal minimum/capping (misal 400)
                        bidRemote:FireServer(targetContainer, 400)
                    else
                        -- Auto Bid Maksimal / Normal
                        bidRemote:FireServer(targetContainer, 999999)
                    end
                end
            end
        end
    end
end)

-- 2. Logika Instant Collect & Auto Unload
task.spawn(function()
    while true do
        task.wait(0.5)
        if getgenv().SuperShoyoConfig.InstantCollect or getgenv().SuperShoyoConfig.AutoUnload then
            local targetContainer = getNearestContainer()
            if targetContainer then
                local containerPart = targetContainer.PrimaryPart or targetContainer:FindFirstChildWhichIsA("BasePart")
                if containerPart then
                    local rewardsFolder = Workspace:FindFirstChild("Rewards") or Workspace:FindFirstChild("SpawnedItems") or Workspace
                    for _, item in ipairs(rewardsFolder:GetChildren()) do
                        if item.Name:lower():find("car") or item.Name:lower():find("vehicle") or item:IsA("Model") then
                            for _, part in ipairs(item:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.Velocity = Vector3.new(0, 0, 0)
                                    part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                    part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                                end
                            end
                            if item:IsA("Model") and item.PrimaryPart then
                                item:SetPrimaryPartCFrame(containerPart.CFrame + Vector3.new(0, 2, 0))
                            elseif item:IsA("BasePart") then
                                item.CFrame = containerPart.CFrame + Vector3.new(0, 2, 0)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- 3. Logika Halloween & Auto Fishing
task.spawn(function()
    while true do
        task.wait(1)
        if getgenv().SuperShoyoConfig.HalloweenEvent then
            local halloweenFolder = Workspace:FindFirstChild("HalloweenEvent") or Workspace:FindFirstChild("EventItems")
            if halloweenFolder then
                for _, obj in ipairs(halloweenFolder:GetChildren()) do
                    if obj:IsA("BasePart") and humanoidRootPart then
                        obj.CFrame = humanoidRootPart.CFrame
                    end
                end
            end
        end
        
        if getgenv().SuperShoyoConfig.Fishing then
            local fishingRemote = remoteFolder and (remoteFolder:FindFirstChild("Fish") or remoteFolder:FindFirstChild("Catch"))
            if fishingRemote and fishingRemote:IsA("RemoteEvent") then
                fishingRemote:FireServer()
            end
        end
    end
end)

print("SuperShoyo Hub v2.0 Loaded Successfully with Draggable UI!")
