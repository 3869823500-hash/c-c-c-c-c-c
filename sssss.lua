-- 悬浮球俄亥俄州
local function Ohio()
    if not game:IsLoaded() then game.Loaded:Wait() end
    
    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local lp = Players.LocalPlayer
    
    -- 悬浮球
    local gui = Instance.new("ScreenGui")
    gui.Parent = CoreGui
    gui.ResetOnSpawn = false
    
    local ball = Instance.new("TextButton")
    ball.Size = UDim2.new(0, 50, 0, 50)
    ball.Position = UDim2.new(0, 10, 0.5, -25)
    ball.BackgroundColor3 = Color3.fromRGB(60, 60, 200)
    ball.Text = "O"
    ball.TextColor3 = Color3.fromRGB(255, 255, 255)
    ball.TextSize = 24
    ball.Font = Enum.Font.GothamBold
    ball.Parent = gui
    
    Instance.new("UICorner").CornerRadius = UDim.new(1, 0)
    Instance.new("UICorner", ball)
    
    -- 菜单
    local menu = Instance.new("Frame")
    menu.Size = UDim2.new(0, 180, 0, 200)
    menu.Position = UDim2.new(0, 70, 0, 0)
    menu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    menu.Visible = false
    menu.Parent = ball
    
    Instance.new("UICorner", menu)
    
    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 2)
    list.Parent = menu
    
    local function createBtn(text, cb)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -4, 0, 25)
        btn.Position = UDim2.new(0, 2, 0, 2)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 12
        btn.Font = Enum.Font.Gotham
        btn.Parent = menu
        btn.MouseButton1Click:Connect(cb)
        return btn
    end
    
    local function createToggle(text, def, cb)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -4, 0, 25)
        btn.Position = UDim2.new(0, 2, 0, 2)
        btn.BackgroundColor3 = def and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(80, 80, 80)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 12
        btn.Font = Enum.Font.Gotham
        btn.Parent = menu
        local state = def
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(80, 80, 80)
            cb(state)
        end)
        return btn
    end
    
    -- 配置
    local config = {atm=true, vest=true, health=true, doll=true}
    
    -- 菜单按钮
    createBtn("关闭", function() gui:Destroy() end)
    createToggle("ATM", config.atm, function(s) config.atm = s end)
    createToggle("护甲", config.vest, function(s) config.vest = s end)
    createToggle("回血", config.health, function(s) config.health = s end)
    createToggle("反布娃娃", config.doll, function(s) config.doll = s end)
    
    -- 点击球切换菜单
    local menuOpen = false
    ball.MouseButton1Click:Connect(function()
        menuOpen = not menuOpen
        menu.Visible = menuOpen
        menu.Size = UDim2.new(0, 180, 0, 200)
    end)
    
    -- 拖拽
    local drag, dragInput, dragStart, startPos
    
    ball.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true
            dragStart = input.Position
            startPos = ball.Position
        end
    end)
    
    ball.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and drag then
            local delta = input.Position - dragStart
            ball.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = false
        end
    end)
    
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
        if config.atm then
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
        if config.vest then
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
        if config.health then
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
        if config.doll then
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
end

pcall(Ohio)
