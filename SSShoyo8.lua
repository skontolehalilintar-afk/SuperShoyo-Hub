
-- STABLE TOGGLE SYSTEM
-- Mempertahankan pemanggilan addBtn yang sudah ada.

local function addBtn(name, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name:gsub("[^%w]", "") .. "Toggle"
    btn.Size = UDim2.new(1, -10, 0, 38)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = BUTTON
    btn.TextColor3 = MUTED
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 0
    btn.Active = true
    btn.Selectable = true
    btn.AutoButtonColor = true
    btn.ZIndex = 7
    btn.Parent = scroll

    corner(btn, 8)
    outline(btn, BORDER, 1, 0.35)

    local active = false
    local busy = false

    local function render()
        btn.BackgroundColor3 = active and RED or BUTTON
        btn.TextColor3 = active and WHITE or MUTED
        btn.Text = "    " .. name .. (active and "  [ON]" or "  [OFF]")
    end

    local function setState(value)
        active = value == true
        render()

        local ok, err = pcall(callback, active)
        if not ok then
            warn("[SuperShoyo] " .. name .. ": " .. tostring(err))
        end

        print("[SuperShoyo] " .. name .. " = " .. tostring(active))
    end

    btn.Activated:Connect(function()
        if busy then
            return
        end

        busy = true
        setState(not active)
        task.delay(0.15, function()
            busy = false
        end)
    end)

    render()

    return {
        Button = btn,
        GetState = function()
            return active
        end,
        SetState = setState,
    }
end
