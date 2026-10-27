--[[
    Script: SuperShoyo Hub - Storage Hunter Edition
    Fitur: Instant Bid, Stop Bid (Smart Price Cap), Instant Collect (No Fly), 
           Halloween Event, Fishing, & Teleport System.
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Konfigurasi Status Fitur
getgenv().SuperShoyoConfig = {
    InstantBid = false,
    StopBid = false,
    InstantCollect = false,
    HalloweenEvent = false,
    Fishing = false
}

-- Menghapus UI lama jika script dieksekusi ulang
if CoreGui:FindFirstChild("SuperShoyoHub") then
    CoreGui.SuperShoyoHub:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SuperShoyoHub"
screenGui.Parent = CoreGui

-- 1. Tombol Ikon Mengambang (Logo Pop-up "SuperShoyo")
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleIcon"
toggleButton.Size = UDim2.new(0, 55, 0, 55)
toggleButton.Position = UDim2.new(0, 30, 0, 200)
toggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
toggleButton.TextColor3 = Color3.fromRGB(255, 100, 0) -- Aksen warna oranye ala Halloween/SuperShoyo
toggleButton.TextSize = 13
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Text = "SHOYO"
toggleButton.Parent = screenGui

local cornerIcon = Instance.new("UICorner")
cornerIcon.CornerRadius = UDim.new(1, 0)
cornerIcon.Parent = toggleButton

-- 2. Menu Utama (Frame)
local mainFrame = Instance.new("ScrollingFrame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 240, 0, 340)
mainFrame.Position = UDim2.new(0, 95, 0, 200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.CanvasSize = UDim2.new(0, 0, 0, 480)
mainFrame.Parent = screenGui

local cornerFrame = Instance.new("UICorner")
cornerFrame.CornerRadius = UDim.new(0, 10)
cornerFrame.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 15
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Text = "SuperShoyo Hub"
titleLabel.Parent = mainFrame

-- Fungsi Pembuat Tombol Menu
local function createMenuButton(name, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 220, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.SourceSans
    btn.Text = name .. ": OFF"
    btn.Parent = mainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
            btn.Text = name .. ": ON"
        else
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            btn.Text = name .. ": OFF"
        end
        callback(state)
    end)
end

-- Fungsi Pembuat Tombol Teleport (Aksi Sekali Klik)
local function createTeleportButton(name, posY, targetPosition)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 220, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(80, 40, 120)
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

-- Posisi Tombol-Tombol Fitur Utama
createMenuButton("Instant Bid", 50, function(state)
    getgenv().SuperShoyoConfig.InstantBid = state
end)

createMenuButton("Stop Bid (Smart Cap)", 90, function(state)
    getgenv().SuperShoyoConfig.StopBid = state
end)

createMenuButton("Instant Collect (Car)", 130, function(state)
    getgenv().SuperShoyoConfig.InstantCollect = state
end)

createMenuButton("Halloween Event Farm", 170, function(state)
    getgenv().SuperShoyoConfig.HalloweenEvent = state
end)

createMenuButton("Auto Fishing", 210, function(state)
    getgenv().SuperShoyoConfig.Fishing = state
end)

-- Tombol Teleport Lokasi Penting di Storage Hunter
local tpLabel = Instance.new("TextLabel")
tpLabel.Size = UDim2.new(1, 0, 0, 25)
tpLabel.Position = UDim2.new(0, 0, 0, 255)
tpLabel.BackgroundTransparency = 1
tpLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
tpLabel.TextSize = 12
tpLabel.Font = Enum.Font.SourceSansBold
tpLabel.Text = "--- TELEPORT LOCATIONS ---"
tpLabel.Parent = mainFrame

-- Contoh Titik Teleport (Koordinat bisa disesuaikan dengan posisi map game aslinya)
createTeleportButton("Auction Area", 285, CFrame.new(0, 5, 0))
createTeleportButton("Shop / Storage", 320, CFrame.new(50, 5, 50))
createTeleportButton("Fishing Spot", 355, CFrame.new(-100, 5, 100))

-- Tombol Close Menu
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 220, 0, 30)
closeBtn.Position = UDim2.new(0, 10, 0, 400)
closeBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
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


--// LOGIKA SISTEM UTAMA (SAFEGUARDS & EXECUTION)

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

-- 1. Sistem Instant Bid & Stop Bid (Smart Price Cap)
task.spawn(function()
    while true do
        task.wait(0.1)
        if getgenv().SuperShoyoConfig.InstantBid then
            if getgenv().SuperShoyoConfig.StopBid then
                -- Logika Stop Bid: Menahan harga agar tidak naik (berhenti di harga dasar/minimum)
                -- Script otomatis mengirim nilai bid terendah/minimal agar harga tidak melonjak naik ke angka tinggi
                if bidRemote and bidRemote:IsA("RemoteEvent") then
                    local targetContainer = getNearestContainer()
                    if targetContainer then
                        -- Mengirimkan nominal minimum (misal: 400 atau harga dasar awal)
                        bidRemote:FireServer(targetContainer, 400) 
                    end
                end
            else
                -- Instant Bid Normal (Harga Maksimal / Cepat)
                if bidRemote and bidRemote:IsA("RemoteEvent") then
                    local targetContainer = getNearestContainer()
                    if targetContainer then
                        bidRemote:FireServer(targetContainer, 999999)
                    end
                end
            end
        end
    end
end)

-- 2. Instant Collect (Mobil Diam di Container)
task.spawn(function()
    while true do
        task.wait(0.5)
        if getgenv().SuperShoyoConfig.InstantCollect then
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

-- 3. Event Halloween & Fishing Handler (Placeholder aman dari bug)
task.spawn(function()
    while true do
        task.wait(1)
        if getgenv().SuperShoyoConfig.HalloweenEvent then
            -- Logika otomatis mengambil atau mendeteksi item/spawn Halloween di Workspace
            local halloweenFolder = Workspace:FindFirstChild("HalloweenEvent") or Workspace:FindFirstChild("EventItems")
            if halloweenFolder then
                for _, obj in ipairs(halloweenFolder:GetChildren()) do
                    if obj:IsA("BasePart") and humanoidRootPart then
                        obj.CFrame = humanoidRootPart.CFrame -- Auto collect item event
                    end
                end
            end
        end
        
        if getgenv().SuperShoyoConfig.Fishing then
            -- Logika auto fishing jika ada remote event pancingan di game
            local fishingRemote = remoteFolder and (remoteFolder:FindFirstChild("Fish") or remoteFolder:FindFirstChild("Catch"))
            if fishingRemote and fishingRemote:IsA("RemoteEvent") then
                fishingRemote:FireServer()
            end
        end
    end
end)

print("SuperShoyo Hub Loaded Successfully!")
