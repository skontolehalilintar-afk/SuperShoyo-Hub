-- SuperShoyo Hub | Ultra Simple & Mobile Friendly (Fixed Touch & Drag)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Bersihkan UI lama
if playerGui:FindFirstChild("SuperShoyoHubSimple") then
    playerGui.SuperShoyoHubSimple:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SuperShoyoHubSimple"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 99999
screenGui.Parent = playerGui

-- 1. Tombol Floating 'S' (Dibuat responsif dengan sistem drag manual yang stabil)
local floatBtn = Instance.new("TextButton")
floatBtn.Name = "FloatButton"
floatBtn.Size = UDim2.new(0, 60, 0, 60)
floatBtn.Position = UDim2.new(0, 30, 0, 200)
floatBtn.BackgroundColor3 = Color3.fromRGB(239, 35, 55)
floatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
floatBtn.TextSize = 24
floatBtn.Font = Enum.Font.GothamBlack
floatBtn.Text = "S"
floatBtn.Active = true
floatBtn.Selectable = true
floatBtn.ZIndex = 10
floatBtn.Parent = screenGui

local cornerFloat = Instance.new("UICorner")
cornerFloat.CornerRadius = UDim.new(1, 0)
cornerFloat.Parent = floatBtn

-- 2. Menu Utama (Simple Dark Panel)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 420)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.ZIndex = 5
mainFrame.Parent = screenGui

local cornerMain = Instance.new("UICorner")
cornerMain.CornerRadius = UDim.new(0, 12)
cornerMain.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 0, 45)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "SHOYO HUB : STORAGE HUNTER"
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 6
titleLabel.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 70)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "X"
closeBtn.Active = true
closeBtn.Selectable = true
closeBtn.ZIndex = 6
closeBtn.Parent = mainFrame

local cornerClose = Instance.new("UICorner")
cornerClose.CornerRadius = UDim.new(0, 6)
cornerClose.Parent = closeBtn

-- Scrolling Container untuk Fitur & Teleport
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -55)
scroll.Position = UDim2.new(0, 5, 0, 50)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 800)
scroll.ScrollBarThickness = 4
scroll.ZIndex = 6
scroll.Parent = mainFrame

-- Fungsi Pembuat Tombol Fitur / Teleport
local function addBtn(name, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 38)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamMedium
    btn.Text = "  " .. name
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Active = true
    btn.Selectable = true
    btn.ZIndex = 7
    btn.Parent = scroll
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local active = false
    btn.Activated:Connect(function()
        active = not active
        if active then
            btn.BackgroundColor3 = Color3.fromRGB(239, 35, 55)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Text = "  " .. name .. " [ON]"
        else
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            btn.TextColor3 = Color3.fromRGB(230, 230, 230)
            btn.Text = "  " .. name
        end
        callback(active)
    end)
end

-- Status Fitur Global
local Config = { AutoBid = false, StopNPCBid = false, InstantCollect = false, AutoUnload = false }

addBtn("Auto Bid / Stop NPC Bid", 10, function(state) Config.AutoBid = state; Config.StopNPCBid = state end)
addBtn("Instant Collect Items", 55, function(state) Config.InstantCollect = state end)
addBtn("Auto Unload Truck", 100, function(state) Config.AutoUnload = state end)

-- Tombol Teleport
local tps = {"My Plot", "Grading NPC", "Cleaning Tool", "Junk Yard", "Back Alley", "Power Plant", "Farmyard", "Shipyard", "Lucky Beach", "Business Bay", "Cargo Ship", "The Mines", "Train Container"}
for i, loc in ipairs(tps) do
    local y = 150 + ((i - 1) * 43)
    local tpBtn = Instance.new("TextButton")
    tpBtn.Size = UDim2.new(1, -10, 0, 38)
    tpBtn.Position = UDim2.new(0, 5, 0, y)
    tpBtn.BackgroundColor3 = Color3.fromRGB(35, 40, 55)
    tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tpBtn.TextSize = 13
    tpBtn.Font = Enum.Font.GothamMedium
    tpBtn.Text = "  TP: " .. loc
    tpBtn.TextXAlignment = Enum.TextXAlignment.Left
    tpBtn.Active = true
    tpBtn.Selectable = true
    tpBtn.ZIndex = 7
    tpBtn.Parent = scroll
    
    local cornerTp = Instance.new("UICorner")
    cornerTp.CornerRadius = UDim.new(0, 6)
    cornerTp.Parent = tpBtn
    
    tpBtn.Activated:Connect(function()
        pcall(function()
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            
            if loc == "My Plot" then
                local plots = Workspace:FindFirstChild("Plots") or Workspace:FindFirstChild("PlayerPlots") or Workspace
                for _, plot in ipairs(plots:GetChildren()) do
                    if plot.Name:find(player.Name) or (plot:FindFirstChild("Owner") and plot.Owner.Value == player) then
                        local part = plot:FindFirstChildWhichIsA("BasePart", true)
                        if part then root.CFrame = part.CFrame + Vector3.new(0, 5, 0) return end
                    end
                end
            elseif loc == "Grading NPC" then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") and (obj.Name:lower():find("grade") or obj.Name:lower():find("grading")) then
                        local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                        if part then root.CFrame = part.CFrame + Vector3.new(0, 3, 5) return end
                    end
                end
            elseif loc == "Cleaning Tool" then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") and (obj.Name:lower():find("clean") or obj.Name:lower():find("wash") or obj.Name:lower():find("tool")) then
                        val = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                        if val then root.CFrame = val.CFrame + Vector3.new(0, 3, 5) return end
                    end
                end
            else
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if (obj:IsA("Model") or obj:IsA("Folder")) and obj.Name:lower():find(loc:lower():gsub(" ", "")) then
                        local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)
                        if part then root.CFrame = part.CFrame + Vector3.new(0, 4, 0) return end
                    end
                end
            end
        end)
    end)
end

-- Sistem Buka Tutup Menu Utama (FIX Menggunakan .Activated yang Konsisten)
local function toggleMenu()
    mainFrame.Visible = not mainFrame.Visible
end

floatBtn.Activated:Connect(function()
    toggleMenu()
end)

closeBtn.Activated:Connect(function()
    mainFrame.Visible = false
end)

-- Sistem Dragging Manual yang Aman untuk Tombol Floating di HP (Tidak memblokir klik)
local dragging, dragInput, dragStart, startPos
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

-- Background Loop Fitur (Auto Bid & Collect)
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if Config.AutoBid or Config.StopNPCBid then
                local playerGui = player:FindFirstChild("PlayerGui")
                if playerGui then
                    for _, gui in ipairs(playerGui:GetDescendants()) do
                        if gui:IsA("TextButton") and (gui.Text:upper():find("BID") or gui.Name:upper():find("BID")) then
                            firesignal(gui.MouseButton1Click)
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

print("[SuperShoyo] Clean & Responsive UI Loaded Successfully!")
