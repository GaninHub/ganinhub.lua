-- [[ GANIN HUB - BLACKOUT PREMIUM V12.0 - PARTE 1 ]] --
-- [[ REFORMULADO POR DEEPHAT - FOCO EM PERFORMANCE ]] --

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

-- Configurações de Segurança e Interface
local function GetSafeGuiContainer()
    if gethui then return gethui()
    elseif game:GetService("CoreGui"):FindFirstChild("RobloxGui") then return game:GetService("CoreGui")
    else return Player:WaitForChild("PlayerGui") end 
end

local TargetGuiParent = GetSafeGuiContainer()
local MAIN_COLOR = Color3.fromRGB(170, 0, 255)
local BypassAtivo = false

-- Variáveis de Controle
local FlyControl = {f=0, b=0, l=0, r=0, q=0, e=0}
local Flying = false
local FlySpeed = 50
local ESP_Settings = {Enabled=false, Aura=false, Tracers=false, MainColor=MAIN_COLOR}
local TrollSettings = {KillAura=false, AuraRange=25, TargetMode="Mais Próximo", AutoEquip=true}

local function IniciarHub()
    local success, Fluent = pcall(function()
        return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    end)

    if not success or not Fluent then warn("Erro ao carregar a biblioteca Fluent!") return end

    local Window = Fluent:CreateWindow({
        Title = "Ganin hub 👾",
        SubTitle = "Blackout Premium V12.0 | Bypass Edition",
        TabWidth = 140,
        Size = UDim2.fromOffset(500, 380),
        Acrylic = false,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.G
    })

    -- Tabs Principais
    local Tabs = {
        Main = Window:AddTab({Title = "Main", Icon = "home"}),
        Exercit = Window:AddTab({Title = "Exercit Infinito", Icon = "zap"}),
        Troll = Window:AddTab({Title = "Troll", Icon = "flame"}),
        ESP = Window:AddTab({Title = "ESP", Icon = "eye"}),
        Protection = Window:AddTab({Title = "Protection", Icon = "shield-check"}),
        Server = Window:AddTab({Title = "Server", Icon = "activity"})
    }

    -- [[ CATEGORIA: MAIN ]] --
    Tabs.Main:AddSection("Movement")
    Tabs.Main:AddSlider("WalkSpeed", {Title = "WalkSpeed", Default = 16, Min = 16, Max = 500, Rounding = 0, Callback = function(v)
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then Player.Character.Humanoid.WalkSpeed = v end
    end})
    
    Tabs.Main:AddSlider("JumpPower", {Title = "JumpPower", Default = 50, Min = 50, Max = 500, Rounding = 0, Callback = function(v)
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then Player.Character.Humanoid.JumpPower = v end
    end})

    -- [[ CATEGORIA: EXERCIT INFINITO ]] --
    Tabs.Exercit:AddSection("Money Bypass Pro")
    Tabs.Exercit:AddParagraph({Title = "Status", Content = "Sistema de injeção pronto."})

    Tabs.Exercit:AddToggle("MoneyLoop", {Title = "Ativar Auto-Ganho (Loop)", Default = false, Callback = function(v)
        BypassAtivo = v
        if BypassAtivo then
            task.spawn(function()
                while BypassAtivo do
                    pcall(function()
                        local stats = Player:FindFirstChild("leaderstats")
                        if stats then
                            for _, val in pairs(stats:GetChildren()) do
                                if val:IsA("NumberValue") or val:IsA("IntValue") then
                                    val.Value = val.Value + 100000
                                end
                            end
                        end
                        for _, remote in pairs(game:GetDescendants()) do
                            if remote:IsA("RemoteEvent") and (remote.Name:lower():find("money") or remote.Name:lower():find("cash")) then
                                remote:FireServer(500000)
                            end
                        end
                    end)
                    task.wait(0.3)
                end
            end)
        end
    end})
          -- [[ CONTINUAÇÃO: CATEGORIA: TROLL (RECONSTRUÍDA) ]] --
    Tabs.Troll:AddSection("Combat Troll")
    Tabs.Troll:AddToggle("KillAura", {Title = "Ativar Kill Aura", Default = false, Callback = function(v)
        TrollSettings.KillAura = v
        task.spawn(function()
            while TrollSettings.KillAura do
                pcall(function()
                    local char = Player.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if not root then task.wait(1) return end

                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = (root.Position - p.Character.HumanoidRootPart.Position).Magnitude
                            if dist <= TrollSettings.AuraRange then
                                -- Ataque via Tool/Damage Simulation
                                local tool = char:FindFirstChildOfClass("Tool") or (Player.Backpack:FindFirstChildOfClass("Tool") and Player.Backpack:FindFirstChildOfClass("Tool"))
                                if tool then
                                    char.Humanoid:EquipTool(tool)
                                    tool:Activate()
                                end
                                -- Simulação de Hitbox (FireTouchInterest)
                                local targetPart = p.Character:FindFirstChild("HumanoidRootPart")
                                if targetPart and firetouchinterest then
                                    firetouchinterest(root, targetPart, 0)
                                    task.wait(0.05)
                                    firetouchinterest(root, targetPart, 1)
                                end
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end})

    Tabs.Troll:AddSlider("AuraRange", {Title = "Alcance da Aura", Default = 25, Min = 5, Max = 100, Rounding = 0, Callback = function(v)
        TrollSettings.AuraRange = v
    end})

    -- [[ CATEGORIA: ESP ]] --
    Tabs.ESP:AddSection("Visuals")
    Tabs.ESP:AddToggle("EspEnabled", {Title = "Ativar ESP", Default = false, Callback = function(v)
        ESP_Settings.Enabled = v
    end})
    Tabs.ESP:AddColorpicker("EspColor", {Title = "Cor do ESP", Default = MAIN_COLOR, Callback = function(v)
        ESP_Settings.MainColor = v
    end})

    -- [[ CATEGORIA: PROTECTION ]] --
    Tabs.Protection:AddSection("Anti-Detection")
    Tabs.Protection:AddToggle("Noclip", {Title = "Noclip", Default = false, Callback = function(v)
        _G.Noclip = v
        RunService.Stepped:Connect(function()
            if _G.Noclip and Player.Character then
                for _, p in pairs(Player.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
    end})

    Tabs.Protection:AddToggle("AntiAFK", {Title = "Anti-AFK", Default = false, Callback = function(v)
        _G.AntiAFK = v
        if v then
            task.spawn(function()
                local VirtualUser = game:GetService("VirtualUser")
                Player.Idled:Connect(function()
                    if _G.AntiAFK then
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                    end
                end)
            end)
        end
    end})

    -- [[ CATEGORIA: SERVER INFO ]] --
    Tabs.Server:AddParagraph({Title = "Status do Servidor", Content = "Online"})
    Tabs.Server:AddButton({Title = "Rejoin", Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
    end})

    -- [[ FINALIZAÇÃO DO SCRIPT ]] --
    Window:SelectTab(1) -- Abre na aba Main por padrão
    print("Ganin Hub V12.0 carregado com sucesso!")
end

-- Execução Inicial
IniciarHub()
