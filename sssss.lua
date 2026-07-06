-- 俄亥俄州 - 悬浮球+可移动UI
local function OhioFull()
    if not game:IsLoaded() then game.Loaded:Wait() end
    
    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local lp = Players.LocalPlayer
    
    -- 主GUI
    local gui = Instance.new("ScreenGui")
    gui.Name = "OhioGUI"
    gui.Parent = CoreGui
    gui.ResetOnSpawn = false
    
    -- ====== 悬浮球 ======
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
    
    -- 悬浮球拖拽
    local ballDrag = false
    local ballDragInput
    local ballDragStart
    local ballStartPos
    
    ball.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            ballDrag = true
            ballDragStart = input.Position
            ballStartPos = ball.Position
        end
    end)
    
    ball.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            ballDragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == ballDragInput and ballDrag then
            local delta = input.Position - ballDragStart
            ball.Position = UDim2.new(
                ballStartPos.X.Scale,
                ballStartPos.X.Offset + delta.X,
                ballStartPos.Y.Scale,
                ballStartPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            ballDrag = false
        end
    end)
    
    -- ====== 主UI窗口 ======
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 350, 0, 450)
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.Visible = false
    mainFrame.Parent = gui
    mainFrame.ZIndex = 20
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = mainFrame
    
    -- 标题栏（可拖动）
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    titleBar.Parent = mainFrame
    
    local titleBarCorner = Instance.new("UICorner")
    titleBarCorner.CornerRadius = UDim.new(0, 10)
    titleBarCorner.Parent = titleBar
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -60, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.Text = "俄亥俄州"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = 16
    titleText.Font = Enum.Font.GothamBold
    titleText.BackgroundTransparency = 1
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    -- 关闭按钮
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = titleBar
    closeBtn.ZIndex = 21
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
    end)
    
    -- 主窗口拖拽
    local mainDrag = false
    local mainDragInput
    local mainDragStart
    local mainStartPos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            mainDrag = true
            mainDragStart = input.Position
            mainStartPos = mainFrame.Position
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            mainDragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == mainDragInput and mainDrag then
            local delta = input.Position - mainDragStart
            mainFrame.Position = UDim2.new(
                mainStartPos.X.Scale,
                mainStartPos.X.Offset + delta.X,
                mainStartPos.Y.Scale,
                mainStartPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            mainDrag = false
        end
    end)
    
    -- 点击球显示/隐藏主窗口
    local menuOpen = false
    ball.MouseButton1Click:Connect(function()
        menuOpen = not menuOpen
        mainFrame.Visible = menuOpen
    end)
    
    -- ====== UI内容 ======
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -45)
    scroll.Position = UDim2.new(0, 5, 0, 40)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 5
    scroll.Parent = mainFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.Parent = scroll
    
    -- 开关函数
    local function createToggle(text, def, cb)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 32)
        frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        frame.Parent = scroll
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -8, 1, -4)
        btn.Position = UDim2.new(0, 4, 0, 2)
        btn.BackgroundColor3 = def and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(80, 80, 80)
        btn.Text = text .. (def and " [开]" or " [关]")
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 13
        btn.Font = Enum.Font.Gotham
        btn.Parent = frame
        
        local state = def
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.BackgroundColor3 = state and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(80, 80, 80)
            btn.Text = text .. (state and " [开]" or " [关]")
            cb(state)
        end)
    end
    
    -- 配置
    local config = {
        atm = true,
        bank = false,
        vest = true,
        health = true,
        doll = true,
        kz = false,
        bx = false,
        zbd = false,
        sell = false,
        remove = false,
        use = false,
        xywp = false,
        xybs = false,
        ptbs = false,
        money = false,
        block = false,
        moss = false,
        card = false,
        balloon = false,
        admin = false
    }
    
    -- 创建所有开关
    createToggle("自动ATM", config.atm, function(s) config.atm = s end)
    createToggle("自动银行", config.bank, function(s) config.bank = s end)
    createToggle("自动护甲", config.vest, function(s) config.vest = s end)
    createToggle("自动回血", config.health, function(s) config.health = s end)
    createToggle("反布娃娃", config.doll, function(s) config.doll = s end)
    createToggle("自动口罩", config.kz, function(s) config.kz = s end)
    createToggle("自动开保险", config.bx, function(s) config.bx = s end)
    createToggle("自动珠宝店", config.zbd, function(s) config.zbd = s end)
    createToggle("自动售卖", config.sell, function(s) config.sell = s end)
    createToggle("自动移除垃圾", config.remove, function(s) config.remove = s end)
    createToggle("自动使用消耗品", config.use, function(s) config.use = s end)
    createToggle("稀有物品", config.xywp, function(s) config.xywp = s end)
    createToggle("稀有宝石", config.xybs, function(s) config.xybs = s end)
    createToggle("普通宝石", config.ptbs, function(s) config.ptbs = s end)
    createToggle("印钞机", config.money, function(s) config.money = s end)
    createToggle("幸运方块", config.block, function(s) config.block = s end)
    createToggle("礼物", config.moss, function(s) config.moss = s end)
    createToggle("红卡", config.card, function(s) config.card = s end)
    createToggle("气球", config.balloon, function(s) config.balloon = s end)
    createToggle("反管理员", config.admin, function(s) config.admin = s end)
    
    -- 更新滚动
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
    
    -- ====== 功能实现 ======
    local devv = require(ReplicatedStorage:WaitForChild("devv"))
    local Signal = devv.client.Helpers.remotes.Signal
    local FireServer = Signal.FireServer
    local InvokeServer = Signal.InvokeServer
    local Inventory = devv.load("v3item").inventory
    local items = Inventory.items
    
    local function GetGuid(name)
        for _, v in pairs(items) do
            if v.name == name then return v.guid end
        end
        return nil
    end
    
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
    
    local function Autoitem(name)
        local data = itemMap[name]
        if data then
            pcall(function()
                local char = lp.Character
                if char then
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.CFrame = data.part.CFrame * CFrame.new(0, 2, 0)
                        task.wait(0.1)
                        data.prompt.RequiresLineOfSight = false
                        data.prompt.HoldDuration = 0
                        fireproximityprompt(data.prompt)
                    end
                end
            end)
            return true
        end
        return false
    end
    
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
    
    -- 银行
    local nextThrow = 0
    RunService.Heartbeat:Connect(function()
        if not config.bank then return end
        
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
        else
            local Cash = Robbery:FindFirstChild("BankCash")
            if Cash then
                local Main = Cash:FindFirstChild("Main")
                if Main then
                    local Att = Main:FindFirstChild("Attachment")
                    if Att then
                        local Prompt = Att:FindFirstChild("ProximityPrompt")
                        if Prompt and Prompt.Enabled then
                            root.CFrame = CFrame.new(1110.40369, 2, -325.485962)
                            FireServer("stealBankCash")
                        end
                    end
                end
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
    
    -- 主要功能循环
    RunService.Heartbeat:Connect(function()
        local char = lp.Character
        if not char then return end
        
        -- 护甲
        if config.vest then
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
        end
        
        -- 回血
        if config.health then
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
        end
        
        -- 反布娃娃
        if config.doll then
            if lp:GetAttribute("isRagdoll") then
                FireServer("setRagdoll", false)
                local client = devv.load("ClientReplicator")
                client.Set(lp, "ragdolled", false)
                lp:SetAttribute("isRagdoll", false)
            end
        end
        
        -- 口罩
        if config.kz then
            local Mask = char:FindFirstChild("Black Bandana")
            if not Mask then
                local id = GetGuid('Black Bandana')
                if not id then
                    InvokeServer('attemptPurchase', 'Black Bandana')
                else
                    FireServer("equip", id)
                    FireServer("wearMask", id)
                end
            end
        end
        
        -- 开保险
        if config.bx then
            local id = GetGuid('Lockpick')
            if not id then
                InvokeServer('attemptPurchase', 'Lockpick')
                return
            end
            local chestTypes = {"SmallChest", "LargeChest", "SmallSafe", "MediumSafe", "LargeSafe", "JewelSafe", "GoldJewelSafe"}
            for _, chestType in pairs(chestTypes) do
                local chestFolder = Workspace:FindFirstChild("Game")
                if chestFolder then
                    chestFolder = chestFolder:FindFirstChild("Entities")
                    if chestFolder then
                        chestFolder = chestFolder:FindFirstChild(chestType)
                        if chestFolder then
                            for _, chest in pairs(chestFolder:GetChildren()) do
                                if chest.PrimaryPart then
                                    local prompt = chest:FindFirstChild("ProximityPrompt", true)
                                    if prompt and prompt.Enabled then
                                        local root = char:FindFirstChild("HumanoidRootPart")
                                        if root then
                                            local tween = TweenService:Create(root, TweenInfo.new(0.1), {CFrame = chest.PrimaryPart.CFrame * CFrame.new(0, 3, 0)})
                                            tween:Play()
                                            tween.Completed:Wait()
                                            fireproximityprompt(prompt)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        
        -- 珠宝店
        if config.zbd then
            local cases = Workspace:FindFirstChild("GemRobbery")
            if cases then
                cases = cases:FindFirstChild("JewelryCases")
                if cases then
                    for _, d in pairs(cases:GetDescendants()) do
                        if d:IsA("ProximityPrompt") and d.ActionText == "Steal" and d.Enabled then
                            d.HoldDuration = 0
                            local root = char:FindFirstChild("HumanoidRootPart")
                            if root then
                                root.CFrame = CFrame.new(d.Parent.Position + Vector3.new(0, 0, 0))
                                fireproximityprompt(d)
                            end
                        end
                    end
                end
            end
        end
        
        -- 售卖
        if config.sell then
            for _, v in pairs(items) do
                if (v.type == "Holdable" and v.subtype == "gem" and v.sellPrice < 5000) or 
                   (v.subtype == "valuable") or 
                   (v.type == "Gun" and v.cost < 3999 and v.name ~= "Raygun") then
                    FireServer("equip", v.guid)
                    FireServer("sellItem", v.guid)
                end
            end
        end
        
        -- 移除垃圾
        if config.remove then
            for _, v in pairs(items) do
                if (v.type == "Consumable" and v.subtype == "food" and v.name ~= "Bandage") or
                   (v.type == "Throwable" and v.cost < 500 and v.name ~= "Ninja Star" and v.name ~= "Tomahawk") or
                   (v.type == "Melee" and v.cost > 100) then
                    FireServer("removeItem", v.guid)
                end
            end
        end
        
        -- 使用消耗品
        if config.use then
            for _, v in pairs(items) do
                if v.type == "Consumable" and v.subtype ~= "vest" and v.subtype ~= "food" and v.name ~= "Lockpick" then
                    FireServer("equip", v.guid)
                    FireServer("useConsumable", v.guid)
                    FireServer("removeItem", v.guid)
                end
            end
        end
        
        -- 自动寻找
        if config.xywp then
            Autoitem("Blue Candy Cane")
            Autoitem("Suitcase Nuke")
            Autoitem("Nuke Launcher")
            Autoitem("Easter Basket")
            Autoitem("Gold Cup")
            Autoitem("Gold Crown")
            Autoitem("Treasure Map")
            Autoitem("Spectral Scythe")
        end
        
        if config.xybs then
            Autoitem("Diamond")
            Autoitem("Void Gem")
            Autoitem("Dark Matter Gem")
            Autoitem("Rollie")
            Autoitem("Gold Crown")
            Autoitem("Gold Cup")
            Autoitem("Pearl Necklace")
        end
        
        if config.ptbs then
            Autoitem("Amethyst")
            Autoitem("Sapphire")
            Autoitem("Emerald")
            Autoitem("Topaz")
            Autoitem("Ruby")
        end
        
        if config.money then
            Autoitem("Money Printer")
        end
        
        if config.block then
            Autoitem("Green Lucky Block")
            Autoitem("Orange Lucky Block")
            Autoitem("Purple Lucky Block")
        end
        
        if config.moss then
            Autoitem("Medium Present")
            Autoitem("Large Present")
        end
        
        if config.card then
            local has = false
            for _, v in pairs(items) do
                if v.name == "Military Armory Keycard" then
                    has = true
                    break
                end
            end
            if not has then
                Autoitem("Military Armory Keycard")
            end
        end
        
        if config.balloon then
            for _, v in pairs(ReplicatedStorage.devv.shared.Indicies.v3items.bin.Holdable:GetChildren()) do
                if v:IsA("ModuleScript") then
                    local data = require(v)
                    if data.holdableType == "Balloon" and data.name ~= 'Balloon' then
                        Autoitem(v.Name)
                    end
                end
            end
        end
    end)
    
    -- 反管理员
    RunService.Heartbeat:Connect(function()
        if config.admin then
            for _, p in pairs(Players:GetPlayers()) do
                if p:GetAttribute("clanId") == "6557c057b60ffcc7226f532c" and p ~= lp then
                    lp:Kick('[Anti Admin] Admin: '.. p.Name)
                    break
                end
            end
        end
    end)
    
    print("俄亥俄州已启动！点击O球打开菜单")
end

pcall(OhioFull)
