-- ============================================================================
-- GANIN HUB 👾 | SISTEMA UNIFICADO: CINEMATIC INTRO + BLACKOUT EDITION
-- ============================================================================

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- [ CONFIGURAÇÕES DE SEGURANÇA ] --
local function GetSafeGuiContainer()
    if gethui then return gethui() elseif game:GetService("CoreGui"):FindFirstChild("RobloxGui") then return game:GetService("CoreGui") else return PlayerGui end
end

local TargetGuiParent = GetSafeGuiContainer()

-- [ CORES E CONSTANTES ] --
local MAIN_COLOR = Color3.fromRGB(170, 0, 255)
local GLITCH_COLOR = Color3.fromRGB(255, 0, 200)
local PINK = Color3.fromRGB(255, 70, 200)
local WHITE = Color3.fromRGB(255, 255, 255)
local BLACK = Color3.fromRGB(5, 5, 8)
local INTRO_TIME = 3

-- ============================================================================
-- 1. SISTEMA DE INTRO (CUTE CINEMATIC)
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

    -- [ FOTO/LOGO MAIS PARA CIMA (Mudado para 0.30) ] --
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

    -- [ TÍTULO MANTIDO NA POSIÇÃO ORIGINAL (0.60) ] --
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

    -- [ SUBTÍTULO MANTIDO NA POSIÇÃO ORIGINAL (0.665) ] --
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

    -- [ BARRA DE PROGRESSO MANTIDA NA POSIÇÃO ORIGINAL (0.75) ] --
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

    -- [ PORCENTAGEM MANTIDA NA POSIÇÃO ORIGINAL (0.80) ] --
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

    -- Partículas
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

    -- Animação
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
            if i == 20 then Sub.Text = "✦ LOADING SYSTEM... ✦"
            elseif i == 50 then Sub.Text = "✦ LOADING INTERFACE... ✦"
            elseif i == 75 then Sub.Text = "✦ ALMOST READY... ✦"
            elseif i == 100 then Sub.Text = "✦ READY! ✦" end
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
-- 2. SISTEMA DO PAINEL (HUB DEFINITIVO)
-- ============================================================================

local function IniciarHub()
    local success, Fluent = pcall(function()
        return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    end)

    if not success or not Fluent then
        warn("Erro ao carregar Fluent Library!")
        return
    end

    local Window = Fluent:CreateWindow({
        Title = "Ganin hub 👾",
        SubTitle = "Blackout Premium V11.9",
        TabWidth = 140,
        Size = UDim2.fromOffset(500, 380),
        Acrylic = false, 
        Theme = "Dark", 
        MinimizeKey = Enum.KeyCode.G 
    })

    -- [ BOTÃO DE MINIMIZAR (AVATAR) ] --
    local MainGui = Instance.new("ScreenGui", TargetGuiParent)
    local MainBtn = Instance.new("ImageButton", MainGui)
    MainBtn.Size = UDim2.new(0, 60, 0, 60)
    MainBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
    MainBtn.BackgroundColor3 = Color3.new(0,0,0)
    MainBtn.Image = "rbxassetid://111763894098712" 
    MainBtn.Draggable = true
    Instance.new("UICorner", MainBtn).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", MainBtn).Color = Color3.fromRGB(170, 0, 255)
    MainBtn.MouseButton1Click:Connect(function() Window:Minimize() end)

    -- [ CONFIGURAÇÕES DO SISTEMA ] --
    local Flying = false
    local FlySpeed = 50
    local FlyControl = {f = 0, b = 0, l = 0, r = 0, q = 0, e = 0}
    local ESP_Settings = { Enabled = false, Names = false, Aura = false, Tracers = false, MainColor = Color3.fromRGB(170, 0, 255) }
    local TrollSettings = { KillAura = false, AuraRange = 25, TargetMode = "Mais Próximo", AutoEquipTool = true, TPToTarget = false }
    local SelectedAuraTarget = nil

    local Tabs = {
        Discord = Window:AddTab({ Title = "Discord", Icon = "message-circle" }),
        Credits = Window:AddTab({ Title = "Credits", Icon = "heart" }),
        Main = Window:AddTab({ Title = "Main", Icon = "home" }),
        ESP = Window:AddTab({ Title = "ESP", Icon = "eye" }),
        Troll = Window:AddTab({ Title = "Troll", Icon = "flame" }),
        Protection = Window:AddTab({ Title = "Protection", Icon = "shield-check" }),
        Server = Window:AddTab({ Title = "Server Info", Icon = "activity" }),
        Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
    }

    -- [ CONTEÚDO DAS ABAS ] --
    Tabs.Discord:AddParagraph({Title = "Ganin hub 👾", Content = "Admin: @Drakzin\nAdmin: @Darkznx"})
    Tabs.Discord:AddButton({Title = "Copiar Convite", Callback = function() pcall(function() setclipboard("https://discord.gg/W5Ep6bzxq") end) end})
    Tabs.Credits:AddParagraph({Title = "👑 Credits", Content = "Script Created by: Drakzin & Darkznx\nBlackout Edition V11.9"})

    -- TAB MAIN
    Tabs.Main:AddSlider("WalkSpeed", {Title = "WalkSpeed", Default = 16, Min = 16, Max = 500, Rounding = 0, Callback = function(v) if Player.Character then Player.Character.Humanoid.WalkSpeed = v end end})
    Tabs.Main:AddSlider("JumpPower", {Title = "JumpPower", Default = 50, Min = 50, Max = 500, Rounding = 0, Callback = function(v) if Player.Character then Player.Character.Humanoid.JumpPower = v end end})
    Tabs.Main:AddSlider("Gravity", {Title = "Gravity", Default = 196, Min = 0, Max = 500, Rounding = 0, Callback = function(v) workspace.Gravity = v end})
    Tabs.Main:AddToggle("InfJump", {Title = "Infinite Jump", Default = false, Callback = function(v) _G.InfJump = v end})
    
    -- [ FLY & SPECTATE ] --
    Tabs.Main:AddSection("Fly & Spectate")
    Tabs.Main:AddSlider("FlySpeed", {Title = "Fly Speed", Default = 50, Min = 10, Max = 300, Rounding = 0, Callback = function(v) FlySpeed = v end})
    Tabs.Main:AddToggle("FlyTog", {Title = "Fly", Default = false, Callback = function(v)
        Flying = v 
        local char = Player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")
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

    -- [ ABA ESP ] --
    Tabs.ESP:AddToggle("EspM", {Title = "Ativar Visão", Default = false, Callback = function(v) ESP_Settings.Enabled = v end})
    Tabs.ESP:AddToggle("EspA", {Title = "Aura", Default = false, Callback = function(v) ESP_Settings.Aura = v end})
    Tabs.ESP:AddToggle("EspT", {Title = "Tracers", Default = false, Callback = function(v) ESP_Settings.Tracers = v end})
    Tabs.ESP:AddColorpicker("EspC", {Title = "Cor", Default = Color3.fromRGB(170, 0, 255), Callback = function(v) ESP_Settings.MainColor = v end})

    -- [ ABA TROLL ] --
    Tabs.Troll:AddSection("Kill Aura (Troll)")
    Tabs.Troll:AddToggle("KillAuraTog", {Title = "Ativar Kill Aura", Default = false, Callback = function(v) TrollSettings.KillAura = v end})
    Tabs.Troll:AddDropdown("AuraMode", {Title = "Modo de Seleção", Values = {"Mais Próximo", "Todos os Jogadores", "Alvo Específico"}, Default = 1, Callback = function(v) TrollSettings.TargetMode = v end})
    local AuraTargetDropdown = Tabs.Troll:AddDropdown("AuraTarget", {Title = "Alvo Específico", Values = {}, Callback = function(Name) SelectedAuraTarget = Name end})
    Tabs.Troll:AddSlider("AuraRangeSld", {Title = "Alcance (Studs)", Default = 25, Min = 5, Max = 150, Rounding = 0, Callback = function(v) TrollSettings.AuraRange = v end})
    Tabs.Troll:AddToggle("AutoEquipTool", {Title = "Auto Equipar Arma", Default = true, Callback = function(v) TrollSettings.AutoEquipTool = v end})
    Tabs.Troll:AddToggle("TPToTarget", {Title = "Teletransportar pro Alvo", Default = false, Callback = function(v) TrollSettings.TPToTarget = v end})

    -- [ ABA PROTECTION ] --
    Tabs.Protection:AddToggle("Noclip", {Title = "Noclip", Default = false, Callback = function(v) _G.Noclip = v end})
    Tabs.Protection:AddToggle("AntiSit", {Title = "Anti sit", Default = false, Callback = function(v) _G.AntiSit = v end})
    Tabs.Protection:AddToggle("AntiVoid", {Title = "Anti void", Default = false, Callback = function(v) _G.AntiVoid = v end})
    Tabs.Protection:AddToggle("AntiFling", {Title = "Anti fling", Default = false, Callback = function(v) _G.AFling = v end})
    Tabs.Protection:AddButton({Title = "Anti lag", Callback = function()
        for _, v in pairs(game:GetDescendants()) do if v:IsA("Part") or v:IsA("MeshPart") then v.Material = Enum.Material.SmoothPlastic elseif v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end end
    end})

    -- [ ABA SERVER ] --
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

    -- [ SISTEMA DE LOOP E ATIVAÇÃO FINAL ] --
    task.spawn(function()
        while true do
            task.wait(0.1)
            pcall(function()
                local pList = {}
                for _, p in pairs(Players:GetPlayers()) do if p ~= Player then table.insert(pList, p.Name) end end
                SpecDropdown:SetValues(pList)
                AuraTargetDropdown:SetValues(pList)
                
                if _G.Noclip and Player.Character then
                    for _, p in pairs(Player.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
                end
            end)
        end
    end)

    Window:SelectTab(3)
    print("🚀 GANIN HUB: Ativado!")
end

-- ================= INICIO DA CENA =================
StartCinematicIntro(function()
    IniciarHub()
end)
