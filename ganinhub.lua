-- ============================================================================
-- GANIN HUB 👾 | SCRIPT COMPLETO E CORRIGIDO
-- ============================================================================

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local function GetSafeGuiContainer()
    if gethui then return gethui() elseif game:GetService("CoreGui"):FindFirstChild("RobloxGui") then return game:GetService("CoreGui") else return PlayerGui end
end

local TargetGuiParent = GetSafeGuiContainer()

local MAIN_COLOR = Color3.fromRGB(170, 0, 255)
local PINK = Color3.fromRGB(255, 70, 200)
local WHITE = Color3.fromRGB(255, 255, 255)
local BLACK = Color3.fromRGB(5, 5, 8)

-- ============================================================================
-- 1. INTRO CINEMÁTICA
-- ============================================================================

local function StartCinematicIntro(Callback)
    local IntroGui = Instance.new("ScreenGui")
    IntroGui.Name = "GaninCuteIntro"
    IntroGui.IgnoreGuiInset = true
    IntroGui.ResetOnSpawn = false
    IntroGui.Parent = TargetGuiParent

    local Background = Instance.new("Frame")
    Background.Size = UDim2.fromScale(1, 1)
    Background.BackgroundColor3 = BLACK
    Background.BorderSizePixel = 0
    Background.Parent = IntroGui

    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 5, 10)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 5, 45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 10))
    })
    Gradient.Rotation = 45
    Gradient.Parent = Background

    local Flash = Instance.new("Frame")
    Flash.Size = UDim2.fromScale(1, 1)
    Flash.BackgroundColor3 = WHITE
    Flash.BackgroundTransparency = 1
    Flash.ZIndex = 20
    Flash.Parent = IntroGui

    local Blur = Instance.new("BlurEffect")
    Blur.Size = 0
    Blur.Parent = Lighting

    local LogoHolder = Instance.new("Frame")
    LogoHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    LogoHolder.Position = UDim2.fromScale(0.5, 0.30)
    LogoHolder.Size = UDim2.fromOffset(160, 160)
    LogoHolder.BackgroundTransparency = 1
    LogoHolder.ZIndex = 5
    LogoHolder.Parent = Background

    local LogoScale = Instance.new("UIScale")
    LogoScale.Scale = 0
    LogoScale.Parent = LogoHolder

    local LogoBg = Instance.new("Frame")
    LogoBg.Size = UDim2.fromScale(1, 1)
    LogoBg.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
    LogoBg.BackgroundTransparency = 0.2
    LogoBg.Parent = LogoHolder
    Instance.new("UICorner", LogoBg).CornerRadius = UDim.new(1, 0)
    
    local LogoStroke = Instance.new("UIStroke")
    LogoStroke.Color = MAIN_COLOR
    LogoStroke.Thickness = 4
    LogoStroke.Parent = LogoBg

    local LogoImage = Instance.new("ImageLabel")
    LogoImage.Size = UDim2.new(1, -10, 1, -10)
    LogoImage.AnchorPoint = Vector2.new(0.5, 0.5)
    LogoImage.Position = UDim2.fromScale(0.5, 0.5)
    LogoImage.BackgroundTransparency = 1
    LogoImage.Image = "rbxassetid://111763894098712"
    LogoImage.Parent = LogoHolder
    Instance.new("UICorner", LogoImage).CornerRadius = UDim.new(1, 0)

    local Title = Instance.new("TextLabel")
    Title.AnchorPoint = Vector2.new(0.5, 0.5)
    Title.Position = UDim2.fromScale(0.5, 0.60)
    Title.Size = UDim2.fromOffset(600, 70)
    Title.BackgroundTransparency = 1
    Title.Text = "GANIN HUB 👾"
    Title.TextColor3 = MAIN_COLOR
    Title.TextSize = 42
    Title.Font = Enum.Font.FredokaOne
    Title.TextTransparency = 1
    Title.Parent = Background

    local Sub = Instance.new("TextLabel")
    Sub.AnchorPoint = Vector2.new(0.5, 0.5)
    Sub.Position = UDim2.fromScale(0.5, 0.665)
    Sub.Size = UDim2.fromOffset(500, 40)
    Sub.BackgroundTransparency = 1
    Sub.Text = "✦ INITIALIZING EXPERIENCE ✦"
    Sub.TextColor3 = WHITE
    Sub.TextSize = 15
    Sub.Font = Enum.Font.GothamBold
    Sub.TextTransparency = 1
    Sub.Parent = Background

    local BarBG = Instance.new("Frame")
    BarBG.AnchorPoint = Vector2.new(0.5, 0.5)
    BarBG.Position = UDim2.fromScale(0.5, 0.75)
    BarBG.Size = UDim2.fromOffset(330, 12)
    BarBG.BackgroundColor3 = Color3.fromRGB(25, 20, 35)
    BarBG.Parent = Background
    Instance.new("UICorner", BarBG).CornerRadius = UDim.new(1, 0)

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.fromScale(0, 1)
    Bar.BackgroundColor3 = MAIN_COLOR
    Bar.Parent = BarBG
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

    local Percent = Instance.new("TextLabel")
    Percent.AnchorPoint = Vector2.new(0.5, 0.5)
    Percent.Position = UDim2.fromScale(0.5, 0.80)
    Percent.Size = UDim2.fromOffset(200, 30)
    Percent.BackgroundTransparency = 1
    Percent.Text = "0%"
    Percent.TextColor3 = WHITE
    Percent.TextSize = 16
    Percent.Font = Enum.Font.GothamBold
    Percent.TextTransparency = 1
    Percent.Parent = Background

    for i = 1, 35 do
        local Particle = Instance.new("Frame")
        local size = math.random(3, 8)
        Particle.Size = UDim2.fromOffset(size, size)
        Particle.Position = UDim2.fromScale(math.random(), math.random())
        Particle.BackgroundColor3 = math.random(1, 2) == 1 and MAIN_COLOR or PINK
        Particle.BackgroundTransparency = math.random(30, 70) / 100
        Particle.BorderSizePixel = 0
        Particle.Parent = Background
        Instance.new("UICorner", Particle).CornerRadius = UDim.new(1, 0)
        task.spawn(function()
            while Particle.Parent do
                local newPos = UDim2.fromScale(math.random(), math.random())
                local tween = TweenService:Create(Particle, TweenInfo.new(math.random(3, 7), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    Position = newPos,
                    BackgroundTransparency = math.random(20, 75) / 100
                })
                tween:Play()
                tween.Completed:Wait()
            end
        end)
    end

    task.spawn(function()
        Flash.BackgroundTransparency = 0
        TweenService:Create(Flash, TweenInfo.new(0.7), {BackgroundTransparency = 1}):Play()
        TweenService:Create(Blur, TweenInfo.new(1), {Size = 20}):Play()
        task.wait(0.3)

        TweenService:Create(LogoScale, TweenInfo.new(1, Enum.EasingStyle.Back), {Scale = 1}):Play()
        task.wait(0.4)

        TweenService:Create(Title, TweenInfo.new(0.6), {TextTransparency = 0}):Play()
        TweenService:Create(Sub, TweenInfo.new(0.7), {TextTransparency = 0}):Play()
        TweenService:Create(Percent, TweenInfo.new(0.5), {TextTransparency = 0}):Play()

        for i = 0, 100 do
            Percent.Text = i .. "%"
            Bar.Size = UDim2.fromScale(i / 100, 1)
            task.wait(0.025)
        end

        task.wait(0.7)
        Flash.BackgroundTransparency = 1
        TweenService:Create(Flash, TweenInfo.new(0.35), {BackgroundTransparency = 0}):Play()
        task.wait(0.25)

        TweenService:Create(LogoScale, TweenInfo.new(0.5), {Scale = 1.4}):Play()
        TweenService:Create(Background, TweenInfo.new(0.7), {BackgroundTransparency = 1}):Play()
        TweenService:Create(Blur, TweenInfo.new(0.7), {Size = 0}):Play()
        
        task.wait(0.8)
        Blur:Destroy()
        IntroGui:Destroy()
        
        if Callback then Callback() end
    end)
end

-- ============================================================================
-- 2. PAINEL PRINCIPAL
-- ============================================================================

local function IniciarHub()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
    end)

    local success, Fluent = pcall(function()
        return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    end)

    if not success or not Fluent then return end

    local Window = Fluent:CreateWindow({
        Title = "Ganin hub 👾",
        SubTitle = "Blackout V11.9",
        TabWidth = 140,
        Size = UDim2.fromOffset(500, 380),
        Theme = "Dark", 
        MinimizeKey = Enum.KeyCode.G 
    })

    local MainGui = Instance.new("ScreenGui", TargetGuiParent)
    local MainBtn = Instance.new("ImageButton", MainGui)
    MainBtn.Size = UDim2.new(0, 60, 0, 60)
    MainBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
    MainBtn.BackgroundColor3 = Color3.new(0,0,0)
    MainBtn.Image = "rbxassetid://111763894098712" 
    MainBtn.Draggable = true
    Instance.new("UICorner", MainBtn).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", MainBtn).Color = MAIN_COLOR
    MainBtn.MouseButton1Click:Connect(function() Window:Minimize() end)

    local Flying, FlySpeed = false, 50
    local FlyControl = {f = 0, b = 0, l = 0, r = 0, q = 0, e = 0}
    local ESP_Settings = { Enabled = false, Boxes = false, Names = false, Health = false, Tracers = false, MainColor = MAIN_COLOR }
    local TrollSettings = { KillAura = false, AuraRange = 25, TargetMode = "Mais Próximo", AutoEquipTool = true, TPToTarget = false }
    local SelectedTPTarget, SelectedAuraTarget = nil, nil

    -- Criação das Abas
    local Tabs = {
        Discord = Window:AddTab({ Title = "Discord", Icon = "message-circle" }),
        Credits = Window:AddTab({ Title = "Credits", Icon = "heart" }),
        Main = Window:AddTab({ Title = "Main", Icon = "home" }),
        ESP = Window:AddTab({ Title = "ESP", Icon = "eye" }),
        Troll = Window:AddTab({ Title = "Troll", Icon = "flame" }),
        Protection = Window:AddTab({ Title = "Protection", Icon = "shield-check" }),
        Server = Window:AddTab({ Title = "Server Info", Icon = "activity" })
    }

    -- 1. Discord
    Tabs.Discord:AddParagraph({Title = "Ganin hub 👾", Content = "Admin: @Drakzin\nAdmin: @Darkznx"})
    Tabs.Discord:AddButton({Title = "Copiar Convite", Callback = function() pcall(function() setclipboard("https://discord.gg/W5Ep6bzxq") end) end})

    -- 2. Credits
    Tabs.Credits:AddParagraph({Title = "👑 Credits", Content = "Created by: Drakzin \u0026 Darkznx"})

    -- 3. Main
    Tabs.Main:AddSlider("WalkSpeed", {Title = "WalkSpeed", Default = 16, Min = 16, Max = 500, Callback = function(v) if Player.Character then Player.Character.Humanoid.WalkSpeed = v end end})
    Tabs.Main:AddSlider("JumpPower", {Title = "JumpPower", Default = 50, Min = 50, Max = 500, Callback = function(v) if Player.Character then Player.Character.Humanoid.JumpPower = v end end})
    Tabs.Main:AddSlider("Gravity", {Title = "Gravity", Default = 196, Min = 0, Max = 500, Callback = function(v) workspace.Gravity = v end})
    Tabs.Main:AddToggle("InfJump", {Title = "Infinite Jump", Default = false, Callback = function(v) ESP_Settings.Enabled = v end})
    
    Tabs.Main:AddSection("Fly \u0026 Spectate")
    Tabs.Main:AddSlider("FlySpeed", {Title = "Fly Speed", Default = 50, Min = 10, Max = 300, Callback = function(v) FlySpeed = v end})
    Tabs.Main:AddToggle("FlyTog", {Title = "Fly", Default = false, Callback = function(v)
        Flying = v 
        local char = Player.Character
        if char then
            local hum, root = char:FindFirstChildOfClass("Humanoid"), char:FindFirstChild("HumanoidRootPart")
            if Flying and hum and root then
                hum.PlatformStand = true
                local bg = Instance.new("BodyGyro", root) bg.P = 9e4 bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                local bv = Instance.new("BodyVelocity", root) bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
                task.spawn(function()
                    while Flying and root do
                        local cam = workspace.CurrentCamera
                        bv.velocity = (hum.MoveDirection * FlySpeed) + (cam.CFrame.LookVector * (FlyControl.f + FlyControl.b) * FlySpeed) + (Vector3.new(0, 1, 0) * (FlyControl.e + FlyControl.q) * FlySpeed)
                        bg.cframe = cam.CFrame task.wait()
                    end
                    bg:Destroy() bv:Destroy() hum.PlatformStand = false
                end)
            else if hum then hum.PlatformStand = false end end
        end
    end})

    local SpecDropdown = Tabs.Main:AddDropdown("Spec", {Title = "Spectate Player", Values = {}, Callback = function(Name)
        local target = Players:FindFirstChild(Name)
        if target and target.Character and target.Character:FindFirstChild("Humanoid") then workspace.CurrentCamera.CameraSubject = target.Character.Humanoid end
    end})
    Tabs.Main:AddButton({Title = "Reset View", Callback = function() if Player.Character and Player.Character:FindFirstChild("Humanoid") then workspace.CurrentCamera.CameraSubject = Player.Character.Humanoid end end})

    Tabs.Main:AddSection("Teleport System")
    local TPPlayerDropdown = Tabs.Main:AddDropdown("TPPlayerTarget", {Title = "Teletransportar para Jogador", Values = {}, Callback = function(Name) SelectedTPTarget = Name end})
    Tabs.Main:AddButton({Title = "Ir até o Jogador", Callback = function()
        if SelectedTPTarget then
            local targetPlayer = Players:FindFirstChild(SelectedTPTarget)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                Player.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end})

    -- 4. ESP
    Tabs.ESP:AddToggle("EspM", {Title = "Ativar ESP Geral", Default = false, Callback = function(v) ESP_Settings.Enabled = v end})
    Tabs.ESP:AddToggle("EspB", {Title = "Box 2D", Default = false, Callback = function(v) ESP_Settings.Boxes = v end})
    Tabs.ESP:AddToggle("EspN", {Title = "Nomes \u0026 Distância", Default = false, Callback = function(v) ESP_Settings.Names = v end})
    Tabs.ESP:AddToggle("EspH", {Title = "Barra de Vida", Default = false, Callback = function(v) ESP_Settings.Health = v end})
    Tabs.ESP:AddToggle("EspT", {Title = "Tracers", Default = false, Callback = function(v) ESP_Settings.Tracers = v end})
    Tabs.ESP:AddColorpicker("EspC", {Title = "Cor do ESP", Default = MAIN_COLOR, Callback = function(v) ESP_Settings.MainColor = v end})

    -- 5. Troll
    Tabs.Troll:AddSection("Kill Aura (Troll)")
    Tabs.Troll:AddToggle("KillAuraTog", {Title = "Ativar Kill Aura", Default = false, Callback = function(v) TrollSettings.KillAura = v end})
    Tabs.Troll:AddSlider("AuraRange", {Title = "Alcance da Aura", Default = 25, Min = 5, Max = 100, Rounding = 0, Callback = function(v) TrollSettings.AuraRange = v end})
    Tabs.Troll:AddToggle("AutoEquipTool", {Title = "Auto Equipar Arma", Default = true, Callback = function(v) TrollSettings.AutoEquipTool = v end})
    Tabs.Troll:AddToggle("TPToTarget", {Title = "Teletransportar pro Alvo", Default = false, Callback = function(v) TrollSettings.TPToTarget = v end})

    -- 6. Protection
    Tabs.Protection:AddSection("Anti-Detection")
    Tabs.Protection:AddToggle("Noclip", {Title = "Noclip", Default = false, Callback = function(v) _G.Noclip = v end})
    Tabs.Protection:AddToggle("AntiAFK", {Title = "Anti-AFK", Default = false, Callback = function(v) _G.AntiAFK = v end})
    Tabs.Protection:AddButton({Title = "Clean Cache (Anti-Lag)", Callback = function()
        for _, v in pairs(game:GetDescendants()) do 
            if v:IsA("Part") or v:IsA("MeshPart") then v.Material = Enum.Material.SmoothPlastic 
            elseif v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end 
        end
    end})

    -- 7. Server Info
    local fpsL = Tabs.Server:AddParagraph({Title = "FPS: 0", Content = ""})
    local pingL = Tabs.Server:AddParagraph({Title = "Ping: 0ms", Content = ""})
    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                fpsL:SetTitle("FPS: " .. math.floor(workspace:GetRealPhysicsFPS()))
                pingL:SetTitle("Ping: " .. math.floor(Player:GetNetworkPing() * 1000) .. "ms")
            end)
        end
    end)
    Tabs.Server:AddButton({Title = "Anti-AFK", Callback = function() Player.Idled:Connect(function() game:GetService("VirtualUser"):CaptureController() game:GetService("VirtualUser"):ClickButton2(Vector2.new()) end) end})
    Tabs.Server:AddButton({Title = "Rejoin", Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, Player) end})

    -- Loops em Segundo Plano (ESP, Dropdowns e Noclip)
    local ESPCache = {}
    RunService.RenderStepped:Connect(function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= Player then
                if not ESPCache[p] then
                    ESPCache[p] = {
                        Box = Drawing.new("Square"),
                        Name = Drawing.new("Text"),
                        HealthBar = Drawing.new("Line"),
                        HealthBarBg = Drawing.new("Line"),
                        Tracer = Drawing.new("Line")
                    }
                    ESPCache[p].Box.Filled = false
                    ESPCache[p].Name.Size, ESPCache[p].Name.Center, ESPCache[p].Name.Outline = 14, true, true
                end
                
                local cache, char = ESPCache[p], p.Character
                local root, hum = char and char:FindFirstChild("HumanoidRootPart"), char and char:FindFirstChildOfClass("Humanoid")
                
                local function HideAll()
                    for _, obj in pairs(cache) do obj.Visible = false end
                end

                if ESP_Settings.Enabled and char and root and hum and hum.Health > 0 then
                    local vector, onScreen = Camera:WorldToViewportPoint(root.Position)
                    if onScreen then
                        local dist = (Camera.CFrame.Position - root.Position).Magnitude
                        local w, h = math.clamp(2000 / dist, 15, 300), math.clamp(3500 / dist, 25, 500)
                        local x, y = vector.X - w / 2, vector.Y - h / 2

                        cache.Box.Visible = ESP_Settings.Boxes
                        if ESP_Settings.Boxes then
                            cache.Box.Size = Vector2.new(w, h)
                            cache.Box.Position = Vector2.new(x, y)
                            cache.Box.Color = ESP_Settings.MainColor
                        end

                        local head = char:FindFirstChild("Head")
                        cache.Name.Visible = ESP_Settings.Names and (head ~= nil)
                        if ESP_Settings.Names and head then
                            local headVec = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                            cache.Name.Text = p.Name .. " [" .. math.floor(dist) .. "m]"
                            cache.Name.Position = Vector2.new(headVec.X, headVec.Y - 20)
                            cache.Name.Color = ESP_Settings.MainColor
                        end

                        cache.HealthBar.Visible = ESP_Settings.Health
                        cache.HealthBarBg.Visible = ESP_Settings.Health
                        if ESP_Settings.Health then
                            local hpPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                            cache.HealthBarBg.From, cache.HealthBarBg.To = Vector2.new(x - 6, y + h), Vector2.new(x - 6, y)
                            cache.HealthBar.From, cache.HealthBar.To = Vector2.new(x - 6, y + h), Vector2.new(x - 6, y + (h - (h * hpPct)))
                            cache.HealthBar.Color = Color3.fromRGB(0, 255, 0):Lerp(Color3.fromRGB(255, 0, 0), 1 - hpPct)
                        end

                        cache.Tracer.Visible = ESP_Settings.Tracers
                        if ESP_Settings.Tracers then
                            cache.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                            cache.Tracer.To = Vector2.new(vector.X, vector.Y + (h / 2))
                            cache.Tracer.Color = ESP_Settings.MainColor
                        end
                    else HideAll() end
                else HideAll() end
            end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(0.1)
            pcall(function()
                local pList = {}
                for _, p in pairs(Players:GetPlayers()) do if p ~= Player then table.insert(pList, p.Name) end end
                SpecDropdown:SetValues(pList)
                AuraTargetDropdown:SetValues(pList)
                TPPlayerDropdown:SetValues(pList)
                
                if _G.Noclip and Player.Character then
                    for _, p in pairs(Player.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
                end
            end)
        end
    end)

    Window:SelectTab(3)
    print("🚀 GANIN HUB: Ativado com sucesso!")
end

StartCinematicIntro(function()
    IniciarHub()
end)
