-- 精简俄亥俄州UI
local function Ohio()
    -- 基础
    if not game:IsLoaded() then game.Loaded:Wait() end
    
    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local lp = Players.LocalPlayer
    
    -- UI
    local gui = Instance.new("ScreenGui")
    gui.Parent = CoreGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 400)
    frame.Position = UDim2.new(0.5, -150, 0.5, -200)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui
    
    Instance.new("UICorner").Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    title.Text = "Ohio"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 30, 0, 30)
    close.Position = UDim2.new(1, -30, 0, 0)
    close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    close.Text = "X"
    close.TextColor3 = Color3.fromRGB(255, 255, 255)
    close.TextSize = 16
    close.Font = Enum.Font.GothamBold
    close.Parent = frame
    close.MouseButton1Click:Connect(function() gui:Destroy() end)
    
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -40)
    scroll.Position = UDim2.new(0, 5, 0, 35)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 5
    scroll.Parent = frame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 3)
    layout.Parent = scroll
    
    -- 开关创建
    local function toggle(text, def, cb)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.BackgroundColor3 = def and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(80, 80, 80)
        btn.Text = text .. (def and " [开]" or " [关]")
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 13
        btn.Font = Enum.Font.Gotham
        btn.Parent = scroll
        local state = def
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.BackgroundColor3 = state and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(80, 80, 80)
            btn.Text = text .. (state and " [开]" or " [关]")
            cb(state)
        end)
        return function() return state end
    end
    
    -- 配置
    local config = {ATM=true, Bank=false, Vest=true, Health=true, Doll=true}
    
    -- 开关
    toggle("自动ATM", config.ATM, function(s) config.ATM = s end)
    toggle("自动银行", config.Bank, function(s) config.Bank = s end)
    toggle("自动护甲", config.Vest, function(s) config.Vest = s end)
    toggle("自动回血", config.Health, function(s) config.Health = s end)
    toggle("反布娃娃", config.Doll, function(s) config.Doll = s end)
    
    -- 功能
    local devv = require(ReplicatedStorage:WaitForChild("devv"))
    local Signal = devv.client.Helpers.remotes.Signal
    local Inventory = devv.load("v3item").inventory
    
    local function getGuid(name)
        for _, v in pairs(Inventory.items) do
            if v.name == name then return v.guid end
        end
        return nil
    end
    
    RunService.Heartbeat:Connect(function()
        local char = lp.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        -- ATM
        if config.ATM then
            local atms = Workspace:FindFirstChild("ATMs")
            if atms then
                for _, v in pairs(atms:GetChildren()) do
                    if v:IsA("Model") and (v:GetAttribute("health") or 0) > 0 then
                        root.CFrame = (v:GetPivot() + Vector3.new(0, -3, 0)) * CFrame.Angles(1.57, 0, 0)
                        task.wait(0.2)
                        v:SetAttribute("health", 0)
                        v:SetAttribute("isDestroyed", true)
                        break
                    end
                end
            end
        end
        
        -- 护甲
        if config.Vest then
            local armor = lp:GetAttribute('armor')
            if armor == nil or armor <= 0 then
                for _, v in pairs(Inventory.items) do
                    if v.subtype == "vest" then
                        Signal.FireServer("equip", v.guid)
                        Signal.FireServer("useConsumable", v.guid)
                        Signal.FireServer("removeItem", v.guid)
                        break
                    end
                end
            end
        end
        
        -- 回血
        if config.Health then
            local hum = char:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 and hum.Health < hum.MaxHealth then
                for _, v in pairs(Inventory.items) do
                    if v.name == 'Bandage' then
                        Signal.FireServer("equip", v.guid)
                        Signal.FireServer("useConsumable", v.guid)
                        Signal.FireServer("removeItem", v.guid)
                        break
                    end
                end
            end
        end
        
        -- 反布娃娃
        if config.Doll then
            if lp:GetAttribute("isRagdoll") then
                Signal.FireServer("setRagdoll", false)
                lp:SetAttribute("isRagdoll", false)
            end
        end
    end)
    
    -- 自动拾取现金
    RunService.Heartbeat:Connect(function()
        local char = lp.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local cash = Workspace:FindFirstChild("Game")
        if cash then
            cash = cash:FindFirstChild("Entities")
            if cash then
                cash = cash:FindFirstChild("CashBundle")
                if cash then
                    for _, d in pairs(cash:GetDescendants()) do
                        if d:IsA("ClickDetector") and d.Parent then
                            if (root.Position - d.Parent:GetPivot().Position).Magnitude <= 20 then
                                fireclickdetector(d)
                            end
                        end
                    end
                end
            end
        end
    end)
    
    -- 更新滚动
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
end

pcall(Ohio)
