-- 俄亥俄州 - WinUI风格
local function OhioWinUI()
    repeat task.wait() until game:IsLoaded()
    
    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local UserInputService = game:GetService("UserInputService")
    local lp = Players.LocalPlayer
    
    print("开始加载俄亥俄州 WinUI...")
    
    -- 获取模块
    local devv = require(ReplicatedStorage:WaitForChild("devv"))
    local Signal = devv.client.Helpers.remotes.Signal
    local FireServer = Signal.FireServer
    local InvokeServer = Signal.InvokeServer
    local Inventory = devv.load("v3item").inventory
    local items = Inventory.items
    
    print("模块加载完成")
    
    -- 配置
    local cfg = {
        atm = true,
        vest = true,
        health = true,
        doll = true,
        bank = false,
        kz = false,
        bx = false,
        zbd = false
    }
    
    -- 创建GUI
    local gui = Instance.new("ScreenGui")
    gui.Name = "OhioWinUI"
    gui.Parent = CoreGui
    gui.ResetOnSpawn = false
    
    -- ====== WinUI风格窗口 ======
    local window = Instance.new("Frame")
    window.Size = UDim2.new(0, 350, 0, 450)
    window.Position = UDim2.new(0.5, -175, 0.5, -225)
    window.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    window.Parent = gui
    window.ZIndex = 10
    window.BorderSizePixel = 1
    window.BorderColor3 = Color3.fromRGB(180, 180, 180)
    
    -- 窗口阴影
    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.3
    shadow.ZIndex = 0
    shadow.Parent = window
    
    -- 标题栏
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 32)
    titleBar.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
    titleBar.Parent = window
    titleBar.ZIndex = 11
    
    -- 标题
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -80, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.Text = "俄亥俄州"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = 14
    titleText.Font = Enum.Font.GothamBold
    titleText.BackgroundTransparency = 1
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    titleText.ZIndex = 12
    
    -- 关闭按钮
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -30, 0.5, -15)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = titleBar
    closeBtn.ZIndex = 12
    closeBtn.BorderSizePixel = 0
    closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)
    
    -- 最小化按钮
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 30, 0, 30)
    minBtn.Position = UDim2.new(1, -60, 0.5, -15)
    minBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
    minBtn.Text = "─"
    minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minBtn.TextSize = 16
    minBtn.Font = Enum.Font.GothamBold
    minBtn.Parent = titleBar
    minBtn.ZIndex = 12
    minBtn.BorderSizePixel = 0
    
    local minimized = false
    local origSize = window.Size
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            window.Size = UDim2.new(0, 350, 0, 32)
        else
            window.Size = UDim2.new(0, 350, 0, 450)
        end
    end)
    
    -- 内容区域
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -10, 1, -42)
    content.Position = UDim2.new(0, 5, 0, 37)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 6
    content.Parent = window
    content.ZIndex = 10
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.Parent = content
    
    -- ====== WinUI风格开关 ======
    local function WinToggle(text, def, cb)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 36)
        frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        frame.Parent = content
        frame.ZIndex = 10
        frame.BorderSizePixel = 1
        frame.BorderColor3 = Color3.fromRGB(220, 220, 220)
        
        -- 标签
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.Text = text
        label.TextColor3 = Color3.fromRGB(50, 50, 50)
        label.TextSize = 13
        label.Font = Enum.Font.Gotham
        label.BackgroundTransparency = 1
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        label.ZIndex = 11
        
        -- WinUI风格滑块开关
        local toggleBg = Instance.new("Frame")
        toggleBg.Size = UDim2.new(0, 44, 0, 22)
        toggleBg.Position = UDim2.new(1, -54, 0.5, -11)
        toggleBg.BackgroundColor3 = def and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 180, 180)
        toggleBg.Parent = frame
        toggleBg.ZIndex = 11
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(1, 0)
        toggleCorner.Parent = toggleBg
        
        -- 滑块圆点
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 18, 0, 18)
        dot.Position = def and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        dot.Parent = toggleBg
        dot.ZIndex = 12
        
        local dotCorner = Instance.new("UICorner")
        dotCorner.CornerRadius = UDim.new(1, 0)
        dotCorner.Parent = dot
        
        -- 点击切换
        local state = def
        toggleBg.MouseButton1Click:Connect(function()
            state = not state
            toggleBg.BackgroundColor3 = state and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 180, 180)
            dot.Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
            cb(state)
        end)
    end
    
    -- ====== 创建分组 ======
    local function Group(title)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 30)
        frame.BackgroundTransparency = 1
        frame.Parent = content
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = title
        label.TextColor3 = Color3.fromRGB(80, 80, 80)
        label.TextSize = 12
        label.Font = Enum.Font.GothamBold
        label.BackgroundTransparency = 1
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
    end
    
    -- 战斗分组
    Group("战斗")
    WinToggle("自动护甲", cfg.vest, function(s) cfg.vest = s end)
    WinToggle("自动回血", cfg.health, function(s) cfg.health = s end)
    WinToggle("反布娃娃", cfg.doll, function(s) cfg.doll = s end)
    WinToggle("自动口罩", cfg.kz, function(s) cfg.kz = s end)
    
    -- 抢劫分组
    Group("抢劫")
    WinToggle("自动摧毁ATM", cfg.atm, function(s) cfg.atm = s end)
    WinToggle("自动偷盗银行", cfg.bank, function(s) cfg.bank = s end)
    WinToggle("自动珠宝店", cfg.zbd, function(s) cfg.zbd = s end)
    WinToggle("自动开保险", cfg.bx, function(s) cfg.bx = s end)
    
    -- 更新滚动
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
    
    -- 窗口拖拽
    local drag, dragStart, startPos
    
    titleBar.MouseButton1Down:Connect(function()
        drag = true
        dragStart = UserInputService:GetMouseLocation()
        startPos = window.Position
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and drag then
            local delta = input.Position - dragStart
            window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = false
        end
    end)
    
    print("WinUI加载完成！")
    
    -- ====== 功能 ======
    local function GetGuid(name)
        for _, v in pairs(items) do
            if v.name == name then return v.guid end
        end
        return nil
    end
    
    -- ATM
    RunService.Heartbeat:Connect(function()
        if not cfg.atm then return end
        
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
        if not cfg.vest then return end
        
        local armor = lp:GetAttribute('armor')
        if not armor or armor <= 0 then
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
        if not cfg.health then return end
        
        local char = lp.Character
        if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        if hum and hum.Health > 0 and hum.Health < hum.MaxHealth then
            for _, v in pairs(items) do
                if v.name == "Bandage" then
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
        if not cfg.doll then return end
        
        if lp:GetAttribute("isRagdoll") then
            FireServer("setRagdoll", false)
            lp:SetAttribute("isRagdoll", false)
        end
    end)
    
    -- 银行
    local nextThrow = 0
    RunService.Heartbeat:Connect(function()
        if not cfg.bank then return end
        
        local Robbery = Workspace:FindFirstChild("BankRobbery")
        if not Robbery then return end
        
        local char = lp.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local Vault = Robbery:FindFirstChild("VaultDoor")
        if not Vault then return end
        
        local VPos = Vault:IsA("Model") and Vault:GetPivot().Position or Vault.Position
        local vaultTarget = Vector3.new(1123.70703125, 13.76093578338623, -353.52301025390625)
        
        if (VPos - vaultTarget).Magnitude < 0.5 then
            if tick() < nextThrow then return end
            nextThrow = tick() + 5
            
            root.CFrame = CFrame.new(1123.54749, 8.31286526, -364.052216)
            
            local TNTGuid = GetGuid('TNT')
            if not TNTGuid then
                InvokeServer("attemptPurchase", "TNT")
                return
            end
            
            local vaultPos = Vector3.new(1123.70703125, 13.76093578338623, -353.52301025390625)
            local direction = (vaultPos - root.Position).Unit
            
            FireServer("equip", TNTGuid)
            FireServer("throwItem", TNTGuid, direction, Vector3.new(1124.0853271484, 5.3128666877747, -357.68710327148))
            FireServer("removeItem", TNTGuid)
        end
    end)
    
    -- 捡钱
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
    
    print("俄亥俄州 WinUI 启动完成！")
end

pcall(OhioWinUI)
