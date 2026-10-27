--[[
    Script: SuperShoyo Hub - Storage Hunter Edition (Ouroboros Aligned)
    Fitur: Auto Bid, Stop NPC Bid, Instant Collect, Auto Unload, Draggable UI (Mobile Friendly)
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
    Fishing = false
}

-- Menghapus UI lama jika script dieksekusi ulang
if CoreGui:FindFirstChild("SuperShoyoHub") then
    CoreGui.SuperShoyoHub:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SuperShoyoHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

-- 1. Tombol Ikon Mengambang (Draggable untuk Mobile)
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleIcon"
toggleButton.Size = UDim2.new(0, 55, 0, 55)
toggleButton.Position = UDim2.new(0, 30, 0, 200)
toggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
toggleButton.TextColor3 = Color3.fromRGB(255, 100, 150)
toggleButton.TextSize = 13
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Text = "SHOYO"
toggleButton.Parent = screenGui

local cornerIcon = Instance.new("UICorner")
cornerIcon.CornerRadius = UDim.new(1, 0)
cornerIcon.Parent = toggleButton

-- 2. Menu Utama (Draggable Frame)
local mainFrame = Instance.new("ScrollingFrame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 260, 0, 380)
mainFrame.Position = UDim2.new(0, 100, 0, 200)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.CanvasSize = UDim2.new(0, 0, 0, 520)
mainFrame.Parent = screenGui

local cornerFrame = Instance.new("UICorner")
cornerFrame.CornerRadius = UDim.new(0, 8)
cornerFrame.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleLabel.TextColor3 = Color3.fromRGB(255, 150, 180)
titleLabel.TextSize = 15
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Text = "SuperShoyo Hub (Ouroboros Mode)"
titleLabel.Parent = mainFrame

-- Fungsi Dragging untuk HP/Mobile & PC
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

makeDraggable(toggleButton, toggleButton)
makeDraggable(titleLabel, mainFrame)

-- Fungsi Tombol Menu
local function createMenuButton(name, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 240, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
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
            btn.BackgroundColor3 = Color3.fromRGB(180, 50, 100)
            btn.Text = name .. " : ON"
        else
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            btn.Text = name .. " : OFF"
        end
        callback(state)
    end)
end

-- Tombol Fitur Utama
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

createMenuButton("Halloween Event", 210, function(state)
    getgenv().SuperShoyoConfig.HalloweenEvent = state
end)

createMenuButton("Auto Fishing", 250, function(state)
    getgenv().SuperShoyoConfig.Fishing = state
end)

-- Tombol Close
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 240, 0, 30)
closeBtn.Position = UDim2.new(0, 10, 0, 310)
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


--// PENCARIAN AUTOMATIS REMOTE EVENT (DYNAMIC BINDING)
local function findRemote(name)
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj.Name:lower() == name:lower() and (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
            return obj
        end
    end
    return nil
end

-- Logika Eksekusi Auto Bid & Stop NPC Bid yang Lebih Pintar
task.spawn(function()
    while true do
        task.wait(0.1)
        if getgenv().SuperShoyoConfig.AutoBid then
            local bidEvent = findRemote("Bid") or findRemote("PlaceBid") or findRemote("Auction")
            if bidEvent and bidEvent:IsA("RemoteEvent") then
                local containersFolder = Workspace:FindFirstChild("Containers") or Workspace:FindFirstChild("StorageUnits")
                if containersFolder then
                    for _, container in ipairs(containersFolder:GetChildren()) do
                        local primary = container:IsA("Model") and (container.PrimaryPart or container:FindFirstChildWhichIsA("BasePart"))
                        if primary and (humanoidRootPart.Position - primary.Position).Magnitude < 40 then
                            if getgenv().SuperShoyoConfig.StopNPCBid then
                                bidEvent:FireServer(container, 400) -- Menahan bid di harga dasar
                            else
                                bidEvent:FireServer(container, 999999) -- Auto Bid max
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Logika Instant Collect & Unload
task.spawn(function()
    while true do
        task.wait(0.5)
        if getgenv().SuperShoyoConfig.InstantCollect or getgenv().SuperShoyoConfig.AutoUnload then
            local rewardsFolder = Workspace:FindFirstChild("Rewards") or Workspace:FindFirstChild("SpawnedItems") or Workspace
            for _, item in ipairs(rewardsFolder:GetChildren()) do
                if item:IsA("Model") or item:IsA("BasePart") then
                    if humanoidRootPart then
                        if item:IsA("Model") and item.PrimaryPart then
                            item:SetPrimaryPartCFrame(humanoidRootPart.CFrame + Vector3.new(0, 2, 0))
                        elseif item:IsA("BasePart") then
                            item.CFrame = humanoidRootPart.CFrame + Vector3.new(0, 2, 0)
                        end
                    end
                end
            end
        end
    end
end)

print("SuperShoyo Hub Ouroboros Mode Loaded Successfully!")
