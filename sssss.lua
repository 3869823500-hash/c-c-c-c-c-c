-- 俄亥俄州 + 脚本加载器 完整UI版本
local Config = {
    scriptsLoadstrings = {
        {
            name = "ESP透视",
            loadstring = "loadstring(game:HttpGet('https://raw.githubusercontent.com/iris-fecokev/esp-rbx-script/refs/heads/main/main.lua'))()"
        },
        {
            name = "Aimbot自瞄",
            loadstring = "loadstring(game:HttpGet('https://raw.githubusercontent.com/iris-fecokev/rbx-aimbot/refs/heads/main/main.lua'))()"
        },
        {
            name = "C00lgu脚本",
            loadstring = "loadstring(game:HttpGet('https://pastebin.com/raw/vuNh0P0V'))()"
        }
    }
}

local function CreateHub()
    -- 基础服务
    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    
    local localPlayer = Players.LocalPlayer
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "OhioHub"
    screenGui.Parent = CoreGui

    -- 主框架
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 550)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -275)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.Parent = screenGui

    local uiCorner = mainFrame:FindFirstChild("UICorner") or Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 12)
    uiCorner.Parent = mainFrame

    -- 标题栏
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 35)
    header.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    header.Parent = mainFrame

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = header

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.Text = "Ohio Hub"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    -- 最小化按钮
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 35, 0, 35)
    toggleButton.Position = UDim2.new(1, -35, 0, 0)
    toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Text = "-"
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextSize = 20
    toggleButton.Parent = header

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggleButton

    -- 标签切换
    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(1, 0, 0, 35)
    tabFrame.Position = UDim2.new(0, 0, 0, 35)
    tabFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabFrame.Parent = mainFrame

    local tabs = {"俄亥俄州", "脚本加载"}
    local tabButtons = {}
    local currentTab = 1

    for i, tabName in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.5, 0, 1, 0)
        btn.Position = UDim2.new((i-1) * 0.5, 0, 0, 0)
        btn.BackgroundColor3 = i == 1 and Color3.fromRGB(60, 60, 200) or Color3.fromRGB(50, 50, 50)
        btn.Text = tabName
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamBold
        btn.Parent = tabFrame
        tabButtons[i] = btn
        
        btn.MouseButton1Click:Connect(function()
            currentTab = i
            for j, b in ipairs(tabButtons) do
                b.BackgroundColor3 = j == i and Color3.fromRGB(60, 60, 200) or Color3.fromRGB(50, 50, 50)
            end
            ohioContainer.Visible = i == 1
            scriptContainer.Visible = i == 2
        end)
    end

    -- 内容区域
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -20, 1, -80)
    contentFrame.Position = UDim2.new(0, 10, 0, 75)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame

    -- 俄亥俄州标签内容
    local ohioContainer = Instance.new("ScrollingFrame")
    ohioContainer.Size = UDim2.new(1, 0, 1, 0)
    ohioContainer.BackgroundTransparency = 1
    ohioContainer.ScrollBarThickness = 6
    ohioContainer.Parent = contentFrame
    
    local ohioLayout = Instance.new("UIListLayout")
    ohioLayout.Padding = UDim.new(0, 5)
    ohioLayout.Parent = ohioContainer

    -- 脚本加载标签内容
    local scriptContainer = Instance.new("ScrollingFrame")
    scriptContainer.Size = UDim2.new(1, 0, 1, 0)
    scriptContainer.BackgroundTransparency = 1
    scriptContainer.ScrollBarThickness = 6
    scriptContainer.Visible = false
    scriptContainer.Parent = contentFrame
    
    local scriptLayout = Instance.new("UIListLayout")
    scriptLayout.Padding = UDim.new(0, 5)
    scriptLayout.Parent = scriptContainer

    -- ====== UI工具函数 ======
    local function createToggle(parent, text, defaultValue, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 35)
        frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        frame.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.Gotham
        label.Parent = frame
        
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 50, 0, 25)
        toggleBtn.Position = UDim2.new(1, -60, 0.5, -12.5)
        toggleBtn.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(150, 150, 150)
        toggleBtn.Text = defaultValue and "开" or "关"
        toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleBtn.TextSize = 12
        toggleBtn.Font = Enum.Font.GothamBold
        toggleBtn.Parent = frame
        
        local state = defaultValue
        toggleBtn.MouseButton1Click:Connect(function()
            state = not state
            toggleBtn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(150, 150, 150)
            toggleBtn.Text = state and "开" or "关"
            if callback then callback(state) end
        end)
        
        return function() return state end
    end

    local function createScriptButton(parent, scriptData)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 45)
        frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        frame.Parent = parent
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 1, -5)
        btn.Position = UDim2.new(0, 5, 0, 2.5)
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 200)
        btn.Text = scriptData.name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamBold
        btn.Parent = frame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        local loadingText = {"正在加载", "正在加载.", "正在加载..", "正在加载..."}
        local loadingIndex = 1
        local loadingConnection
        
        btn.MouseButton1Click:Connect(function()
            if loadingConnection then
                loadingConnection:Disconnect()
                loadingConnection = nil
            end
            
            local originalText = btn.Text
            loadingIndex = 1
            
            loadingConnection = RunService.Heartbeat:Connect(function()
                loadingIndex = loadingIndex + 1
                if loadingIndex > #loadingText then loadingIndex = 1 end
                btn.Text = loadingText[loadingIndex]
            end)
            
            local success, err = pcall(function()
                loadstring(scriptData.loadstring)()
            end)
            
            if loadingConnection then
                loadingConnection:Disconnect()
                loadingConnection = nil
            end
            
            btn.Text = originalText
            
            if not success then
                btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                task.wait(0.5)
                btn.BackgroundColor3 = Color3.fromRGB(60, 60, 200)
            end
        end)
        
        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(80, 80, 220)
        end)
        
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 200)
        end)
    end

    -- ====== 俄亥俄州功能 ======
    local ohioConfig = {
        FromATM = true,
        FromBank = false,
        AutoVest = true,
        AutoHealth = true,
        AutoKZ = false,
        AutoBX = false,
        AutoZBD = false,
        AutoSell = false,
        AutoRemove = false,
        AutoUse = false,
        AutoXYWP = false,
        AutoXYBS = false,
        AutoPTBS = false,
        AutoMoney = false,
        AutoBlock = false,
        AutoMoss = false,
        AutoCard = false,
        AutoBalloon = false,
        AntiDoll = true,
        AntiAdmin = false,
    }

    -- 创建俄亥俄州开关
    createToggle(ohioContainer, "自动摧毁ATM", ohioConfig.FromATM, function(s) ohioConfig.FromATM = s end)
    createToggle(ohioContainer, "自动偷盗银行", ohioConfig.FromBank, function(s) ohioConfig.FromBank = s end)
    createToggle(ohioContainer, "自动护甲", ohioConfig.AutoVest, function(s) ohioConfig.AutoVest = s end)
    createToggle(ohioContainer, "自动回血", ohioConfig.AutoHealth, function(s) ohioConfig.AutoHealth = s end)
    createToggle(ohioContainer, "自动口罩", ohioConfig.AutoKZ, function(s) ohioConfig.AutoKZ = s end)
    createToggle(ohioContainer, "自动开保险", ohioConfig.AutoBX, function(s) ohioConfig.AutoBX = s end)
    createToggle(ohioContainer, "自动珠宝店", ohioConfig.AutoZBD, function(s) ohioConfig.AutoZBD = s end)
    createToggle(ohioContainer, "自动售卖", ohioConfig.AutoSell, function(s) ohioConfig.AutoSell = s end)
    createToggle(ohioContainer, "自动移除垃圾", ohioConfig.AutoRemove, function(s) ohioConfig.AutoRemove = s end)
    createToggle(ohioContainer, "自动使用消耗品", ohioConfig.AutoUse, function(s) ohioConfig.AutoUse = s end)
    createToggle(ohioContainer, "自动寻找稀有物品", ohioConfig.AutoXYWP, function(s) ohioConfig.AutoXYWP = s end)
    createToggle(ohioContainer, "自动寻找稀有宝石", ohioConfig.AutoXYBS, function(s) ohioConfig.AutoXYBS = s end)
    createToggle(ohioContainer, "自动寻找普通宝石", ohioConfig.AutoPTBS, function(s) ohioConfig.AutoPTBS = s end)
    createToggle(ohioContainer, "自动寻找印钞机", ohioConfig.AutoMoney, function(s) ohioConfig.AutoMoney = s end)
    createToggle(ohioContainer, "自动寻找幸运方块", ohioConfig.AutoBlock, function(s) ohioConfig.AutoBlock = s end)
    createToggle(ohioContainer, "自动寻找礼物", ohioConfig.AutoMoss, function(s) ohioConfig.AutoMoss = s end)
    createToggle(ohioContainer, "自动寻找红卡", ohioConfig.AutoCard, function(s) ohioConfig.AutoCard = s end)
    createToggle(ohioContainer, "自动寻找气球", ohioConfig.AutoBalloon, function(s) ohioConfig.AutoBalloon = s end)
    createToggle(ohioContainer, "反布娃娃", ohioConfig.AntiDoll, function(s) ohioConfig.AntiDoll = s end)
    createToggle(ohioContainer, "反管理员", ohioConfig.AntiAdmin, function(s) ohioConfig.AntiAdmin = s end)

    -- 创建脚本按钮
    for _, scriptData in ipairs(Config.scriptsLoadstrings) do
        if scriptData.name ~= "EMPTY" and scriptData.loadstring ~= "EMPTY" then
            createScriptButton(scriptContainer, scriptData)
        end
    end

    -- 更新滚动区域大小
    ohioLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ohioContainer.CanvasSize = UDim2.new(0, 0, 0, ohioLayout.AbsoluteContentSize.Y + 10)
    end)
    
    scriptLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scriptContainer.CanvasSize = UDim2.new(0, 0, 0, scriptLayout.AbsoluteContentSize.Y + 10)
    end)

    -- 窗口拖动
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)

    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
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

    -- 最小化
    local isMinimized = false
    local originalSize = mainFrame.Size
    local minimizedSize = UDim2.new(0, 400, 0, 35)
    
    toggleButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        if isMinimized then
            local tween = TweenService:Create(mainFrame, tweenInfo, {Size = minimizedSize})
            tween:Play()
            toggleButton.Text = "+"
            contentFrame.Visible = false
            tabFrame.Visible = false
        else
            local tween = TweenService:Create(mainFrame, tweenInfo, {Size = originalSize})
            tween:Play()
            toggleButton.Text = "-"
            wait(0.15)
            contentFrame.Visible = true
            tabFrame.Visible = true
        end
    end)

    -- ====== 俄亥俄州核心功能 ======
    local function GetGuid()
        local devv = require(ReplicatedStorage:WaitForChild("devv"))
        local Inventory = devv.load("v3item").inventory
        return function(name)
            for _, v in pairs(Inventory.items) do
                if v.name == name then return v.guid end
            end
            return nil
        end
    end
    
    local getGuid = GetGuid()
    
    -- 物品缓存
    local itemMap = {}
    local function updateItemCache()
        local itemPickup = Workspace:FindFirstChild("Game")
        if itemPickup then
            itemPickup = itemPickup:FindFirstChild("Entities")
            if itemPickup then
                itemPickup = itemPickup:FindFirstChild("ItemPickup")
                if itemPickup then
                    itemMap = {}
                    for _, model in pairs(itemPickup:GetChildren()) do
                        for _, v in pairs(model:GetDescendants()) do
                            if (v:IsA("MeshPart") or v:IsA("Part")) and v:FindFirstChildOfClass("ProximityPrompt") then
                                local prompt = v:FindFirstChildOfClass("ProximityPrompt")
                                if prompt and prompt.ObjectText then
                                    itemMap[prompt.ObjectText] = {
                                        part = v,
                                        prompt = prompt
                                    }
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    updateItemCache()
    
    local function Autoitem(itemName)
        local itemData = itemMap[itemName]
        if itemData then
            pcall(function()
                local char = localPlayer.Character
                if char then
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.CFrame = itemData.part.CFrame * CFrame.new(0, 2, 0)
                        task.wait(0.1)
                        itemData.prompt.RequiresLineOfSight = false
                        itemData.prompt.HoldDuration = 0
                        fireproximityprompt(itemData.prompt)
                    end
                end
            end)
            return true
        end
        return false
    end

    -- 主要循环
    local lastCheck = 0
    RunService.Heartbeat:Connect(function()
        if tick() - lastCheck < 0.1 then return end
        lastCheck = tick()
        
        local char = localPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        -- ATM摧毁
        if ohioConfig.FromATM then
            local atms = Workspace:FindFirstChild("ATMs")
            if atms then
                local nearestATM, shortestDist = nil, math.huge
                for _, v in pairs(atms:GetChildren()) do
                    if v:IsA("Model") and (v:GetAttribute("health") or 0) > 0 then
                        local d = (root.Position - v:GetPivot().Position).Magnitude
                        if d < shortestDist then
                            shortestDist = d
                            nearestATM = v
                        end
                    end
                end
                if nearestATM then
                    root.CFrame = (nearestATM:GetPivot() + Vector3.new(0, -3, 0)) * CFrame.Angles(1.57, 0, 0)
                    task.wait(0.2)
                    nearestATM:SetAttribute("health", 0)
                    nearestATM:SetAttribute("isDestroyed", true)
                end
            end
        end
        
        -- 自动拾取现金
        local cashBundles = Workspace:FindFirstChild("Game")
        if cashBundles then
            cashBundles = cashBundles:FindFirstChild("Entities")
            if cashBundles then
                cashBundles = cashBundles:FindFirstChild("CashBundle")
                if cashBundles then
                    for _, descendant in pairs(cashBundles:GetDescendants()) do
                        if descendant:IsA("ClickDetector") and descendant.Parent then
                            local dist = (root.Position - descendant.Parent:GetPivot().Position).Magnitude
                            if dist <= 20 then
                                fireclickdetector(descendant)
                            end
                        end
                    end
                end
            end
        end
        
        -- 自动护甲
        if ohioConfig.AutoVest then
            local devv = require(ReplicatedStorage:WaitForChild("devv"))
            local Inventory = devv.load("v3item").inventory
            local Signal = devv.client.Helpers.remotes.Signal
            local armor = localPlayer:GetAttribute('armor')
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
        
        -- 自动回血
        if ohioConfig.AutoHealth then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 and humanoid.Health < humanoid.MaxHealth then
                local devv = require(ReplicatedStorage:WaitForChild("devv"))
                local Inventory = devv.load("v3item").inventory
                local Signal = devv.client.Helpers.remotes.Signal
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
        
        -- 自动寻找物品
        if ohioConfig.AutoXYWP then
            Autoitem("Blue Candy Cane")
            Autoitem("Suitcase Nuke")
            Autoitem("Nuke Launcher")
            Autoitem("Easter Basket")
            Autoitem("Gold Cup")
            Autoitem("Gold Crown")
            Autoitem("Treasure Map")
            Autoitem("Spectral Scythe")
        end
        
        if ohioConfig.AutoXYBS then
            Autoitem("Diamond")
            Autoitem("Void Gem")
            Autoitem("Dark Matter Gem")
            Autoitem("Rollie")
            Autoitem("Pearl Necklace")
        end
        
        if ohioConfig.AutoPTBS then
            Autoitem("Amethyst")
            Autoitem("Sapphire")
            Autoitem("Emerald")
            Autoitem("Topaz")
            Autoitem("Ruby")
        end
        
        if ohioConfig.AutoMoney then
            Autoitem("Money Printer")
        end
        
        if ohioConfig.AutoBlock then
            Autoitem("Green Lucky Block")
            Autoitem("Orange Lucky Block")
            Autoitem("Purple Lucky Block")
        end
        
        if ohioConfig.AutoMoss then
            Autoitem("Medium Present")
            Autoitem("Large Present")
        end
        
        -- 反布娃娃
        if ohioConfig.AntiDoll then
            local isRagdolled = localPlayer:GetAttribute("isRagdoll")
            if isRagdolled then
                local devv = require(ReplicatedStorage:WaitForChild("devv"))
                local Signal = devv.client.Helpers.remotes.Signal
                Signal.FireServer("setRagdoll", false)
                local client = devv.load("ClientReplicator")
                client.Set(localPlayer, "ragdolled", false)
                localPlayer:SetAttribute("isRagdoll", false)
            end
        end
    end)

    print("Ohio Hub 已加载")
end

-- 执行
pcall(CreateHub)
