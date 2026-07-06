-- 俄亥俄州 - 基础可用版
local function OhioBase()
    if not game:IsLoaded() then game.Loaded:Wait() end
    
    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local UserInputService = game:GetService("UserInputService")
    local lp = Players.LocalPlayer
    
    print("开始加载俄亥俄州...")
    
    -- 检查必要模块
    local devv
    local success, err = pcall(function()
        devv = require(ReplicatedStorage:WaitForChild("devv"))
    end)
    
    if not success then
        print("❌ 找不到 devv 模块: " .. err)
        return
    end
    
    print("✅ 找到 devv 模块")
    
    -- 获取必要函数
    local Signal = devv.client.Helpers.remotes.Signal
    local FireServer = Signal.FireServer
    local InvokeServer = Signal.InvokeServer
    local Inventory = devv.load("v3item").inventory
    local items = Inventory.items
    
    print("✅ 核心函数加载完成")
    
    -- 配置
    local config = {
        atm = true,
        vest = true,
        health = true,
        doll = true
    }
    
    -- 创建GUI
    local gui = Instance.new("ScreenGui")
    gui.Name = "OhioBase"
    gui.Parent = CoreGui
    gui.ResetOnSpawn = false
    
    -- 悬浮球
    local ball = Instance.new("TextButton")
    ball.Size = UDim2.new(0, 50, 0, 50)
    ball.Position = UDim2.new(0, 10, 0.5, -25)
    ball.BackgroundColor3 = Color3.fromRGB(60, 60, 200)
    ball.Text = "O"
    ball.TextColor3 = Color3.fromRGB(255, 255, 255)
    ball.TextSize = 24
    ball.Font = Enum.Font.GothamBold
    ball.Parent = gui
    ball.ZIndex = 10
    
    local ballCorner = Instance.new("UICorner")
    ballCorner.CornerRadius = UDim.new(1, 0)
    ballCorner.Parent = ball
    
    -- 主窗口
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 200, 0, 250)
    mainFrame.Position = UDim2.new(0.5, -100, 0.5, -125)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.Visible = false
    mainFrame.Parent = gui
    mainFrame.ZIndex = 20
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 8)
    mainCorner.Parent = mainFrame
    
    -- 标题
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    title.Text = "俄亥俄州"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    -- 关闭按钮
    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 25, 0, 25)
    close.Position = UDim2.new(1, -30, 0.5, -12.5)
    close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    close.Text = "X"
    close.TextColor3 = Color3.fromRGB(255, 255, 255)
    close.TextSize = 14
    close.Font = Enum.Font.GothamBold
    close.Parent = title
    
    close.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
    end)
    
    -- 内容区域
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -10, 1, -40)
    content.Position = UDim2.new(0, 5, 0, 35)
    content.BackgroundTransparency = 1
    content.Parent = mainFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 3)
    layout.Parent = content
    
    -- 创建开关
    local function makeToggle(text, def, cb)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 28)
        btn.BackgroundColor3 = def and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(80, 80, 80)
        btn.Text = text .. (def and " [开]" or " [关]")
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 13
        btn.Font = Enum.Font.Gotham
        btn.Parent = content
        
        local state = def
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.BackgroundColor3 = state and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(80, 80, 80)
            btn.Text = text .. (state and " [开]" or " [关]")
            cb(state)
        end)
    end
    
    makeToggle("ATM", config.atm, function(s) config.atm = s end)
    makeToggle("护甲", config.vest, function(s) config.vest = s end)
    makeToggle("回血", config.health, function(s) config.health = s end)
    makeToggle("反布娃娃", config.doll, function(s) config.doll = s end)
    
    -- 点击球切换菜单
    ball.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
    end)
    
    -- 拖拽球
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    ball.MouseButton1Down:Connect(function()
        dragging = true
        dragStart = UserInputService:GetMouseLocation()
        startPos = ball.Position
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
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
            dragging = false
        end
    end)
    
    -- 拖拽窗口
    local dragWin = false
    local dragWinStart = nil
    local winStartPos = nil
    
    title.MouseButton1Down:Connect(function()
        dragWin = true
        dragWinStart = UserInputService:GetMouseLocation()
        winStartPos = mainFrame.Position
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragWin then
            local delta = input.Position - dragWinStart
            mainFrame.Position = UDim2.new(
                winStartPos.X.Scale,
                winStartPos.X.Offset + delta.X,
                winStartPos.Y.Scale,
                winStartPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragWin = false
        end
    end)
    
    -- 更新滚动
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.Size = UDim2.new(1, -10, 0, layout.AbsoluteContentSize.Y + 10)
        mainFrame.Size = UDim2.new(0, 200, 0, layout.AbsoluteContentSize.Y + 55)
    end)
    
    print("✅ UI加载完成")
    
    -- ====== 功能 ======
    local function GetGuid(name)
        for _, v in pairs(items) do
            if v.name == name then return v.guid end
        end
        return nil
    end
    
    print("✅ 功能系统准备就绪")
    
    -- ATM
    RunService.Heartbeat:Connect(function()
        if not config.atm then return end
        
        local atms = Workspace:FindFirstChild("ATMs")
        if not atms then return end
        
        local char = lp.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        for _, v in pairs(atms:GetChildren()) do
            if v:IsA("Model") and (v:GetAttribute("health") or 0) > 0 then
                root.CFrame = (v:GetPivot() + Vector3.new(0, -3, 0)) * CFrame.Angles(1.57, 0, 0)
                task.wait(0.2)
                v:SetAttribute("health", 0)
                v:SetAttribute("isDestroyed", true)
                break
            end
        end
    end)
    
    -- 护甲
    RunService.Heartbeat:Connect(function()
        if not config.vest then return end
        
        local armor = lp:GetAttribute('armor')
        if armor == nil or armor <= 0 then
            for _, v in pairs(items) do
                if v.subtype == "vest" then
                    FireServer("equip", v.guid)
                    FireServer("useConsumable", v.guid)
                    FireServer("removeItem", v.guid)
                    break
                end
            end
        end
    end)
    
    -- 回血
    RunService.Heartbeat:Connect(function()
        if not config.health then return end
        
        local char = lp.Character
        if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        if hum and hum.Health > 0 and hum.Health < hum.MaxHealth then
            for _, v in pairs(items) do
                if v.name == 'Bandage' then
                    FireServer("equip", v.guid)
                    FireServer("useConsumable", v.guid)
                    FireServer("removeItem", v.guid)
                    break
                end
            end
        end
    end)
    
    -- 反布娃娃
    RunService.Heartbeat:Connect(function()
        if not config.doll then return end
        
        if lp:GetAttribute("isRagdoll") then
            FireServer("setRagdoll", false)
            local client = devv.load("ClientReplicator")
            client.Set(lp, "ragdolled", false)
            lp:SetAttribute("isRagdoll", false)
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
    
    print("✅ 俄亥俄州已启动！点击 O 球打开菜单")
    print("功能: ATM自动摧毁 | 自动护甲 | 自动回血 | 反布娃娃")
end

pcall(OhioBase)
