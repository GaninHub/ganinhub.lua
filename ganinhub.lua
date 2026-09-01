--[[
    GANIN HUB ULTRA v12.0
    Criado por: Drakzin & Darkznx
]]

--// SERVIÇOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")

--// VARIÁVEIS GLOBAIS
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")
local Camera = Workspace.CurrentCamera

--// CONFIGURAÇÕES DO SISTEMA
local Settings = {
    WalkSpeed = 16,
    JumpPower = 50,
    Gravity = 196.2,
    InfiniteJump = false,
    Fly = false,
    FlySpeed = 50,
    Noclip = false,
    FlyControl = {f = 0, b = 0, l = 0, r = 0, q = 0, e = 0},
    
    ESP = {
        Enabled = false,
        Boxes = false,
        Names = false,
        Health = false,
        Distance = false,
        Tracers = false,
        Skeleton = false,
        TeamCheck = false,
        MaxDistance = 1000,
        MainColor = Color3.fromRGB(170, 0, 255),
        TeamColor = Color3.fromRGB(0, 255, 0),
        EnemyColor = Color3.fromRGB(255, 0, 0)
    },
    
    KillAura = {
        Enabled = false,
        Range = 25,
        Delay = 0.05,
        Mode = "Mais Próximo",
        Target = nil,
        AutoEquip = true,
        SpinAttack = false,
        SpinSpeed = 50,
        TPToTarget = false,
        SilentAim = false,
        Prediction = false,
        PredictionFactor = 0.1,
        WallCheck = false,
        TeamCheck = true,
        RageMode = false,
        Reach = 10,
        HitboxExpander = false,
        HitboxSize = 10,
        ShowTarget = false
    },
    
    Troll = {
        FlingEnabled = false,
        FlingTarget = nil,
        FlingPower = 500,
        LoopKill = false,
        LoopKillTarget = nil,
        LoopKillDelay = 1,
        AutoClicker = false,
        ClickerDelay = 0.05,
        SpamTool = false,
        FakeLag = false,
        LagInterval = 0.5
    },
    
    Visual = {
        FullBright = false,
        NoFog = false,
        TimeOfDay = 12,
        FOV = 70
    }
}

print("Parte 1 carregada - Configurações")--// FUNÇÕES UTILITÁRIAS
local Utility = {}

function Utility.GetSafeContainer()
    if gethui then
        return gethui()
    elseif syn and syn.protect_gui then
        local gui = Instance.new("ScreenGui")
        syn.protect_gui(gui)
        gui.Parent = game:GetService("CoreGui")
        return gui
    elseif game:GetService("CoreGui"):FindFirstChild("RobloxGui") then
        return game:GetService("CoreGui")
    else
        return Player:WaitForChild("PlayerGui")
    end
end

function Utility.Notify(title, text, duration)
    -- Será sobrescrito após carregar Fluent
end

function Utility.GetPlayerList()
    local list = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player then
            table.insert(list, p.Name)
        end
    end
    return list
end

function Utility.IsAlive(character)
    if not character then return false end
    local hum = character:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

function Utility.IsTeammate(player)
    if not Settings.KillAura.TeamCheck then return false end
    return player.Team == Player.Team
end

function Utility.GetDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

function Utility.GetClosestPlayer(range)
    local closest = nil
    local minDist = range or math.huge
    local myHRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player and Utility.IsAlive(p.Character) then
            if not Utility.IsTeammate(p) then
                local targetHRP = p.Character:FindFirstChild("HumanoidRootPart")
                if targetHRP then
                    local dist = Utility.GetDistance(myHRP.Position, targetHRP.Position)
                    if dist < minDist then
                        minDist = dist
                        closest = p
                    end
                end
            end
        end
    end
    return closest, minDist
end

function Utility.GetWeakestPlayer(range)
    local weakest = nil
    local minHealth = math.huge
    local myHRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player and Utility.IsAlive(p.Character) then
            if not Utility.IsTeammate(p) then
                local targetHRP = p.Character:FindFirstChild("HumanoidRootPart")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if targetHRP and hum then
                    local dist = Utility.GetDistance(myHRP.Position, targetHRP.Position)
                    if dist <= range and hum.Health < minHealth then
                        minHealth = hum.Health
                        weakest = p
                    end
                end
            end
        end
    end
    return weakest
end

function Utility.GetStrongestPlayer(range)
    local strongest = nil
    local maxHealth = 0
    local myHRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player and Utility.IsAlive(p.Character) then
            if not Utility.IsTeammate(p) then
                local targetHRP = p.Character:FindFirstChild("HumanoidRootPart")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if targetHRP and hum then
                    local dist = Utility.GetDistance(myHRP.Position, targetHRP.Position)
                    if dist <= range and hum.Health > maxHealth then
                        maxHealth = hum.Health
                        strongest = p
                    end
                end
            end
        end
    end
    return strongest
end

function Utility.HasLineOfSight(targetChar)
    if Settings.KillAura.WallCheck then return true end
    local myChar = Player.Character
    if not myChar then return false end
    local myHead = myChar:FindFirstChild("Head")
    local targetHead = targetChar:FindFirstChild("Head") or targetChar:FindFirstChild("HumanoidRootPart")
    if not myHead or not targetHead then return false end
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {myChar, targetChar}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local result = Workspace:Raycast(myHead.Position, (targetHead.Position - myHead.Position).Unit * 1000, raycastParams)
    return result == nil
end

function Utility.PredictPosition(character)
    if not Settings.KillAura.Prediction then return nil end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local velocity = hrp.Velocity
    return hrp.Position + (velocity * Settings.KillAura.PredictionFactor)
end

print("Parte 2 carregada - Utilitários")--// SISTEMA DE ESP AVANÇADO
local ESPSystem = {
    Drawings = {}
}

function ESPSystem.CreateDrawing(player)
    local drawings = {
        Box = Drawing.new("Square"),
        BoxOutline = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Health = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        Tracer = Drawing.new("Line")
    }
    
    drawings.Box.Thickness = 1
    drawings.Box.Filled = false
    drawings.BoxOutline.Thickness = 3
    drawings.BoxOutline.Filled = false
    drawings.BoxOutline.Color = Color3.new(0, 0, 0)
    drawings.Name.Size = 14
    drawings.Name.Center = true
    drawings.Name.Outline = true
    drawings.Health.Size = 12
    drawings.Health.Center = true
    drawings.Health.Outline = true
    drawings.Distance.Size = 12
    drawings.Distance.Center = true
    drawings.Distance.Outline = true
    drawings.Tracer.Thickness = 1
    
    ESPSystem.Drawings[player] = drawings
    return drawings
end

function ESPSystem.RemoveDrawing(player)
    if ESPSystem.Drawings[player] then
        for _, drawing in pairs(ESPSystem.Drawings[player]) do
            pcall(function() drawing:Remove() end)
        end
        ESPSystem.Drawings[player] = nil
    end
end

function ESPSystem.Update()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player then
            local character = p.Character
            local drawings = ESPSystem.Drawings[p] or ESPSystem.CreateDrawing(p)
            
            if Settings.ESP.Enabled and character and Utility.IsAlive(character) then
                local hrp = character:FindFirstChild("HumanoidRootPart")
                local head = character:FindFirstChild("Head")
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                
                if hrp and head then
                    local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    local distance = Utility.GetDistance(Camera.CFrame.Position, hrp.Position)
                    
                    if onScreen and distance <= Settings.ESP.MaxDistance then
                        local size = (Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0)).Y - Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 2, 0)).Y)
                        local boxSize = Vector2.new(size * 1.5, size * 2.5)
                        local boxPosition = Vector2.new(pos.X - boxSize.X / 2, pos.Y - boxSize.Y / 2)
                        
                        local color = Utility.IsTeammate(p) and Settings.ESP.TeamColor or Settings.ESP.EnemyColor
                        
                        -- Box
                        if Settings.ESP.Boxes then
                            drawings.Box.Visible = true
                            drawings.Box.Size = boxSize
                            drawings.Box.Position = boxPosition
                            drawings.Box.Color = color
                            drawings.BoxOutline.Visible = true
                            drawings.BoxOutline.Size = boxSize
                            drawings.BoxOutline.Position = boxPosition
                        else
                            drawings.Box.Visible = false
                            drawings.BoxOutline.Visible = false
                        end
                        
                        -- Name
                        if Settings.ESP.Names then
                            drawings.Name.Visible = true
                            drawings.Name.Text = p.Name
                            drawings.Name.Position = Vector2.new(pos.X, boxPosition.Y - 15)
                            drawings.Name.Color = color
                        else
                            drawings.Name.Visible = false
                        end
                        
                        -- Health
                        if Settings.ESP.Health and humanoid then
                            drawings.Health.Visible = true
                            drawings.Health.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                            drawings.Health.Position = Vector2.new(pos.X, boxPosition.Y + boxSize.Y + 2)
                            drawings.Health.Color = Color3.fromRGB(255 - (humanoid.Health/humanoid.MaxHealth) * 255, (humanoid.Health/humanoid.MaxHealth) * 255, 0)
                        else
                            drawings.Health.Visible = false
                        end
                        
                        -- Distance
                        if Settings.ESP.Distance then
                            drawings.Distance.Visible = true
                            drawings.Distance.Text = math.floor(distance) .. "m"
                            drawings.Distance.Position = Vector2.new(pos.X, boxPosition.Y + boxSize.Y + (Settings.ESP.Health and 15 or 2))
                            drawings.Distance.Color = Color3.new(1, 1, 1)
                        else
                            drawings.Distance.Visible = false
                        end
                        
                        -- Tracer
                        if Settings.ESP.Tracers then
                            drawings.Tracer.Visible = true
                            drawings.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                            drawings.Tracer.To = Vector2.new(pos.X, pos.Y)
                            drawings.Tracer.Color = color
                        else
                            drawings.Tracer.Visible = false
                        end
                    else
                        for _, drawing in pairs(drawings) do
                            drawing.Visible = false
                        end
                    end
                end
            else
                for _, drawing in pairs(drawings) do
                    drawing.Visible = false
                end
            end
        end
    end
end

print("Parte 3 carregada - ESP")--// SISTEMA DE KILLAURA ULTRA
local KillAuraSystem = {
    Connection = nil,
    LastAttack = 0,
    CurrentTarget = nil,
    AttackCount = 0
}

function KillAuraSystem.EquipTool()
    if not Settings.KillAura.AutoEquip then return false end
    local character = Player.Character
    if not character then return false end
    
    local tool = character:FindFirstChildOfClass("Tool")
    if tool then return true end
    
    local backpack = Player:FindFirstChild("Backpack")
    if not backpack then return false end
    
    local backpackTool = backpack:FindFirstChildOfClass("Tool")
    if backpackTool then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:EquipTool(backpackTool)
            return true
        end
    end
    return false
end

function KillAuraSystem.ExtendTool(tool)
    if Settings.KillAura.Reach <= 10 then return end
    local handle = tool:FindFirstChild("Handle")
    if handle then
        handle.Size = Vector3.new(Settings.KillAura.Reach, Settings.KillAura.Reach, Settings.KillAura.Reach)
        handle.Massless = true
    end
end

function KillAuraSystem.HitboxExpand(character, expand)
    if not Settings.KillAura.HitboxExpander then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")
    
    if expand then
        if hrp then
            hrp.Size = Vector3.new(Settings.KillAura.HitboxSize, Settings.KillAura.HitboxSize, Settings.KillAura.HitboxSize)
            hrp.Transparency = 0.9
            hrp.CanCollide = false
        end
        if head then
            head.Size = Vector3.new(Settings.KillAura.HitboxSize/2, Settings.KillAura.HitboxSize/2, Settings.KillAura.HitboxSize/2)
            head.Transparency = 0.9
        end
    else
        if hrp then
            hrp.Size = Vector3.new(2, 2, 1)
            hrp.Transparency = 1
        end
        if head then
            head.Size = Vector3.new(1, 1, 1)
            head.Transparency = 0
        end
    end
end

function KillAuraSystem.Attack(targetChar)
    if not targetChar then return end
    local myChar = Player.Character
    if not myChar then return end
    
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("Head")
    if not myHRP or not targetHRP then return end
    
    local distance = Utility.GetDistance(myHRP.Position, targetHRP.Position)
    if distance > Settings.KillAura.Range then return end
    
    local targetPlayer = Players:GetPlayerFromCharacter(targetChar)
    if targetPlayer and Utility.IsTeammate(targetPlayer) then return end
    
    if not Utility.HasLineOfSight(targetChar) then return end
    
    local predictedPos = Utility.PredictPosition(targetChar) or targetHRP.Position
    
    if Settings.KillAura.SpinAttack then
        local angle = tick() * Settings.KillAura.SpinSpeed
        local radius = 5
        local offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
        myHRP.CFrame = CFrame.new(predictedPos + offset, predictedPos)
    elseif Settings.KillAura.TPToTarget then
        myHRP.CFrame = CFrame.new(predictedPos + Vector3.new(0, 0, 3), predictedPos)
    end
    
    if KillAuraSystem.EquipTool() then
        local tool = myChar:FindFirstChildOfClass("Tool")
        if tool then
            KillAuraSystem.ExtendTool(tool)
            
            if Settings.KillAura.SilentAim then
                local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildOfClass("BasePart")
                if handle and firetouchinterest then
                    firetouchinterest(handle, targetHRP, 0)
                    task.wait(0.01)
                    firetouchinterest(handle, targetHRP, 1)
                else
                    tool:Activate()
                end
            else
                tool:Activate()
            end
            
            KillAuraSystem.AttackCount = KillAuraSystem.AttackCount + 1
        end
    end
end

function KillAuraSystem.GetTargets()
    local targets = {}
    local myChar = Player.Character
    if not myChar then return targets end
    
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return targets end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player and Utility.IsAlive(p.Character) then
            if not Utility.IsTeammate(p) then
                local targetHRP = p.Character:FindFirstChild("HumanoidRootPart")
                if targetHRP then
                    local dist = Utility.GetDistance(myHRP.Position, targetHRP.Position)
                    if dist <= Settings.KillAura.Range then
                        if Settings.KillAura.WallCheck or Utility.HasLineOfSight(p.Character) then
                            local hum = p.Character:FindFirstChildOfClass("Humanoid")
                            table.insert(targets, {
                                Character = p.Character,
                                Player = p,
                                Distance = dist,
                                Health = hum and hum.Health or 100,
                                MaxHealth = hum and hum.MaxHealth or 100
                            })
                        end
                    end
                end
            end
        end
    end
    
    return targets
end

function KillAuraSystem.Start()
    if KillAuraSystem.Connection then return end
    
    KillAuraSystem.Connection = RunService.Heartbeat:Connect(function()
        if not Settings.KillAura.Enabled then return end
        if tick() - KillAuraSystem.LastAttack < Settings.KillAura.Delay then return end
        
        local targets = KillAuraSystem.GetTargets()
        if #targets == 0 then return end
        
        KillAuraSystem.LastAttack = tick()
        
        if Settings.KillAura.HitboxExpander then
            for _, t in pairs(targets) do
                KillAuraSystem.HitboxExpand(t.Character, true)
            end
        end
        
        local target = nil
        
        if Settings.KillAura.Mode == "Mais Próximo" then
            table.sort(targets, function(a, b) return a.Distance < b.Distance end)
            target = targets[1]
        elseif Settings.KillAura.Mode == "Mais Fraco" then
            table.sort(targets, function(a, b) return a.Health < b.Health end)
            target = targets[1]
        elseif Settings.KillAura.Mode == "Mais Forte" then
            table.sort(targets, function(a, b) return a.Health > b.Health end)
            target = targets[1]
        elseif Settings.KillAura.Mode == "Distância" then
            table.sort(targets, function(a, b) return a.Distance > b.Distance end)
            target = targets[1]
        elseif Settings.KillAura.Mode == "Específico" and Settings.KillAura.Target then
            for _, t in pairs(targets) do
                if t.Player.Name == Settings.KillAura.Target then
                    target = t
                    break
                end
            end
        elseif Settings.KillAura.Mode == "Todos" then
            if Settings.KillAura.RageMode then
                for _, t in pairs(targets) do
                    task.spawn(function()
                        KillAuraSystem.Attack(t.Character)
                    end)
                end
            else
                for _, t in pairs(targets) do
                    KillAuraSystem.Attack(t.Character)
                    task.wait(Settings.KillAura.Delay / 2)
                end
            end
            return
        end
        
        if target then
            KillAuraSystem.Attack(target.Character)
        end
    end)
end

function KillAuraSystem.Stop()
    if KillAuraSystem.Connection then
        KillAuraSystem.Connection:Disconnect()
        KillAuraSystem.Connection = nil
    end
    if Settings.KillAura.HitboxExpander then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                KillAuraSystem.HitboxExpand(p.Character, false)
            end
        end
    end
end

print("Parte 4 carregada - KillAura")--// SISTEMA DE FLY
local FlySystem = {
    Connection = nil,
    BodyGyro = nil,
    BodyVelocity = nil
}

function FlySystem.Start()
    local character = Player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then return end
    
    humanoid.PlatformStand = true
    
    FlySystem.BodyGyro = Instance.new("BodyGyro")
    FlySystem.BodyGyro.P = 9e4
    FlySystem.BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    FlySystem.BodyGyro.Parent = root
    
    FlySystem.BodyVelocity = Instance.new("BodyVelocity")
    FlySystem.BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
    FlySystem.BodyVelocity.Parent = root
    
    FlySystem.Connection = RunService.RenderStepped:Connect(function()
        if not Settings.Fly then return end
        local cam = Workspace.CurrentCamera
        local moveDir = humanoid.MoveDirection
        local lookVec = cam.CFrame.LookVector
        
        local velocity = (moveDir * Settings.FlySpeed) + 
                        (lookVec * (Settings.FlyControl.f + Settings.FlyControl.b) * Settings.FlySpeed) +
                        (Vector3.new(0, 1, 0) * (Settings.FlyControl.e + Settings.FlyControl.q) * Settings.FlySpeed)
        
        FlySystem.BodyVelocity.velocity = velocity
        FlySystem.BodyGyro.cframe = cam.CFrame
    end)
end

function FlySystem.Stop()
    if FlySystem.Connection then
        FlySystem.Connection:Disconnect()
        FlySystem.Connection = nil
    end
    if FlySystem.BodyGyro then
        FlySystem.BodyGyro:Destroy()
        FlySystem.BodyGyro = nil
    end
    if FlySystem.BodyVelocity then
        FlySystem.BodyVelocity:Destroy()
        FlySystem.BodyVelocity = nil
    end
    local character = Player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
end

--// SISTEMA DE TROLL
local TrollSystem = {
    LoopKillConnection = nil,
    AutoClickerConnection = nil,
    SpamToolConnection = nil
}

function TrollSystem.Fling(targetName)
    if not targetName then return end
    local target = Players:FindFirstChild(targetName)
    if not target or not target.Character then return end
    
    local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end
    
    local flingVelocity = Vector3.new(
        math.random(-Settings.Troll.FlingPower, Settings.Troll.FlingPower),
        Settings.Troll.FlingPower,
        math.random(-Settings.Troll.FlingPower, Settings.Troll.FlingPower)
    )
    
    targetHRP.Velocity = flingVelocity
    targetHRP.RotVelocity = Vector3.new(
        math.random(-50, 50),
        math.random(-50, 50),
        math.random(-50, 50)
    )
end

function TrollSystem.StartLoopKill()
    if TrollSystem.LoopKillConnection then return end
    TrollSystem.LoopKillConnection = task.spawn(function()
        while Settings.Troll.LoopKill do
            if Settings.Troll.LoopKillTarget then
                local target = Players:FindFirstChild(Settings.Troll.LoopKillTarget)
                if target and Utility.IsAlive(target.Character) then
                    KillAuraSystem.Attack(target.Character)
                end
            end
            task.wait(Settings.Troll.LoopKillDelay)
        end
    end)
end

function TrollSystem.StopLoopKill()
    Settings.Troll.LoopKill = false
    TrollSystem.LoopKillConnection = nil
end

function TrollSystem.StartAutoClicker()
    if TrollSystem.AutoClickerConnection then return end
    TrollSystem.AutoClickerConnection = task.spawn(function()
        while Settings.Troll.AutoClicker do
            local myChar = Player.Character
            if myChar then
                local tool = myChar:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                elseif Settings.KillAura.AutoEquip then
                    KillAuraSystem.EquipTool()
                end
            end
            task.wait(Settings.Troll.ClickerDelay)
        end
    end)
end

function TrollSystem.StopAutoClicker()
    Settings.Troll.AutoClicker = false
    TrollSystem.AutoClickerConnection = nil
end

function TrollSystem.StartSpamTool()
    if TrollSystem.SpamToolConnection then return end
    TrollSystem.SpamToolConnection = task.spawn(function()
        while Settings.Troll.SpamTool do
            local myChar = Player.Character
            if myChar then
                local humanoid = myChar:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    local tool = myChar:FindFirstChildOfClass("Tool")
                    if tool then
                        humanoid:UnequipTools()
                    else
                        local backpack = Player:FindFirstChild("Backpack")
                        if backpack then
                            local bpTool = backpack:FindFirstChildOfClass("Tool")
                            if bpTool then
                                humanoid:EquipTool(bpTool)
                            end
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end

function TrollSystem.StopSpamTool()
    Settings.Troll.SpamTool = false
    TrollSystem.SpamToolConnection = nil
end

function TrollSystem.BringAll()
    local myChar = Player.Character
    if not myChar then return end
    
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            p.Character.HumanoidRootPart.CFrame = myHRP.CFrame * CFrame.new(math.random(-10, 10), 0, math.random(-10, 10))
        end
    end
end

function TrollSystem.KillAll()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player and Utility.IsAlive(p.Character) then
            task.spawn(function()
                KillAuraSystem.Attack(p.Character)
            end)
        end
    end
end

print("Parte 5 carregada - Fly e Troll")--// SISTEMA VISUAL
local VisualSystem = {
    OriginalSettings = {}
}

function VisualSystem.SetFullBright(enabled)
    if enabled then
        VisualSystem.OriginalSettings.Brightness = Lighting.Brightness
        VisualSystem.OriginalSettings.GlobalShadows = Lighting.GlobalShadows
        VisualSystem.OriginalSettings.OutdoorAmbient = Lighting.OutdoorAmbient
        VisualSystem.OriginalSettings.Ambient = Lighting.Ambient
        
        Lighting.Brightness = 10
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.Ambient = Color3.new(1, 1, 1)
    else
        Lighting.Brightness = VisualSystem.OriginalSettings.Brightness or 1
        Lighting.GlobalShadows = VisualSystem.OriginalSettings.GlobalShadows or true
        Lighting.OutdoorAmbient = VisualSystem.OriginalSettings.OutdoorAmbient or Color3.new(0.5, 0.5, 0.5)
        Lighting.Ambient = VisualSystem.OriginalSettings.Ambient or Color3.new(0.5, 0.5, 0.5)
    end
end

function VisualSystem.SetNoFog(enabled)
    if enabled then
        VisualSystem.OriginalSettings.FogStart = Lighting.FogStart
        VisualSystem.OriginalSettings.FogEnd = Lighting.FogEnd
        VisualSystem.OriginalSettings.FogColor = Lighting.FogColor
        
        Lighting.FogStart = 0
        Lighting.FogEnd = 100000
        Lighting.FogColor = Color3.new(1, 1, 1)
    else
        Lighting.FogStart = VisualSystem.OriginalSettings.FogStart or 0
        Lighting.FogEnd = VisualSystem.OriginalSettings.FogEnd or 1000
        Lighting.FogColor = VisualSystem.OriginalSettings.FogColor or Color3.new(0.75, 0.75, 0.75)
    end
end

--// CARREGAR UI
local function CreateUI()
    local success, Fluent = pcall(function()
        return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    end)
    
    if not success or not Fluent then
        warn("Falha ao carregar Fluent UI")
        return
    end
    
    Utility.Notify = function(title, text, duration)
        Fluent:Notify({
            Title = title,
            Content = text,
            Duration = duration or 3
        })
    end
    
    local Window = Fluent:CreateWindow({
        Title = "Ganin Hub Ultra 👾",
        SubTitle = "Premium Edition v12.0",
        TabWidth = 160,
        Size = UDim2.fromOffset(600, 450),
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl
    })
    
    local Tabs = {
        Main = Window:AddTab({Title = "Main", Icon = "home"}),
        Movement = Window:AddTab({Title = "Movement", Icon = "move"}),
        ESP = Window:AddTab({Title = "ESP", Icon = "eye"}),
        KillAura = Window:AddTab({Title = "KillAura", Icon = "sword"}),
        Troll = Window:AddTab({Title = "Troll", Icon = "flame"}),
        Teleport = Window:AddTab({Title = "Teleport", Icon = "locate"}),
        Visual = Window:AddTab({Title = "Visual", Icon = "image"}),
        Server = Window:AddTab({Title = "Server", Icon = "server"}),
        Settings = Window:AddTab({Title = "Settings", Icon = "settings"})
    }
    
    --// MAIN TAB
    Tabs.Main:AddSection("Character Mods")
    
    Tabs.Main:AddSlider("WalkSpeed", {
        Title = "Walk Speed",
        Default = 16,
        Min = 16,
        Max = 500,
        Rounding = 0,
        Callback = function(v)
            Settings.WalkSpeed = v
            if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
                Player.Character.Humanoid.WalkSpeed = v
            end
        end
    })
    
    Tabs.Main:AddSlider("JumpPower", {
        Title = "Jump Power",
        Default = 50,
        Min = 50,
        Max = 500,
        Rounding = 0,
        Callback = function(v)
            Settings.JumpPower = v
            if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
                Player.Character.Humanoid.JumpPower = v
            end
        end
    })
    
    Tabs.Main:AddSlider("Gravity", {
        Title = "Gravity",
        Default = 196,
        Min = 0,
        Max = 500,
        Rounding = 0,
        Callback = function(v)
            Settings.Gravity = v
            Workspace.Gravity = v
        end
    })
    
    Tabs.Main:AddToggle("InfJump", {
        Title = "Infinite Jump",
        Default = false,
        Callback = function(v)
            Settings.InfiniteJump = v
        end
    })
    
    UserInputService.JumpRequest:Connect(function()
        if Settings.InfiniteJump and Player.Character then
            local hum = Player.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState("Jumping")
            end
        end
    end)

print("Parte 6 carregada - Visual e UI (Main)")--// MOVEMENT TAB
    Tabs.Movement:AddSection("Fly System")
    
    Tabs.Movement:AddToggle("Fly", {
        Title = "Enable Fly",
        Default = false,
        Callback = function(v)
            Settings.Fly = v
            if v then
                FlySystem.Start()
            else
                FlySystem.Stop()
            end
        end
    })
    
    Tabs.Movement:AddSlider("FlySpeed", {
        Title = "Fly Speed",
        Default = 50,
        Min = 10,
        Max = 500,
        Rounding = 0,
        Callback = function(v)
            Settings.FlySpeed = v
        end
    })
    
    Tabs.Movement:AddSection("Other Movement")
    
    Tabs.Movement:AddToggle("Noclip", {
        Title = "Noclip",
        Default = false,
        Callback = function(v)
            Settings.Noclip = v
        end
    })
    
    RunService.Stepped:Connect(function()
        if Settings.Noclip and Player.Character then
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
    
    --// ESP TAB
    Tabs.ESP:AddSection("ESP Settings")
    
    Tabs.ESP:AddToggle("ESPEnabled", {
        Title = "Enable ESP",
        Default = false,
        Callback = function(v)
            Settings.ESP.Enabled = v
        end
    })
    
    Tabs.ESP:AddToggle("ESPBoxes", {
        Title = "Boxes",
        Default = false,
        Callback = function(v)
            Settings.ESP.Boxes = v
        end
    })
    
    Tabs.ESP:AddToggle("ESPNames", {
        Title = "Names",
        Default = false,
        Callback = function(v)
            Settings.ESP.Names = v
        end
    })
    
    Tabs.ESP:AddToggle("ESPHealth", {
        Title = "Health",
        Default = false,
        Callback = function(v)
            Settings.ESP.Health = v
        end
    })
    
    Tabs.ESP:AddToggle("ESPDistance", {
        Title = "Distance",
        Default = false,
        Callback = function(v)
            Settings.ESP.Distance = v
        end
    })
    
    Tabs.ESP:AddToggle("ESPTracers", {
        Title = "Tracers",
        Default = false,
        Callback = function(v)
            Settings.ESP.Tracers = v
        end
    })
    
    Tabs.ESP:AddToggle("ESPTeamCheck", {
        Title = "Team Check",
        Default = false,
        Callback = function(v)
            Settings.ESP.TeamCheck = v
        end
    })
    
    Tabs.ESP:AddSlider("ESPMaxDistance", {
        Title = "Max Distance",
        Default = 1000,
        Min = 100,
        Max = 5000,
        Rounding = 0,
        Callback = function(v)
            Settings.ESP.MaxDistance = v
        end
    })
    
    Tabs.ESP:AddColorpicker("ESPMainColor", {
        Title = "Enemy Color",
        Default = Settings.ESP.EnemyColor,
        Callback = function(v)
            Settings.ESP.EnemyColor = v
        end
    })
    
    Tabs.ESP:AddColorpicker("ESPTeamColor", {
        Title = "Team Color",
        Default = Settings.ESP.TeamColor,
        Callback = function(v)
            Settings.ESP.TeamColor = v
        end
    })
    
    RunService.RenderStepped:Connect(ESPSystem.Update)
    
    --// KILLAURA TAB
    Tabs.KillAura:AddSection("Main Settings")
    
    Tabs.KillAura:AddToggle("KAEnabled", {
        Title = "Enable KillAura",
        Default = false,
        Callback = function(v)
            Settings.KillAura.Enabled = v
            if v then
                KillAuraSystem.Start()
                Utility.Notify("KillAura", "Sistema ativado!", 3)
            else
                KillAuraSystem.Stop()
            end
        end
    })
    
    Tabs.KillAura:AddDropdown("KAMode", {
        Title = "Target Mode",
        Values = {"Mais Próximo", "Mais Fraco", "Mais Forte", "Distância", "Todos", "Específico"},
        Default = 1,
        Callback = function(v)
            Settings.KillAura.Mode = v
        end
    })
    
    local KATargetDropdown = Tabs.KillAura:AddDropdown("KATarget", {
        Title = "Specific Target",
        Values = {},
        Callback = function(v)
            Settings.KillAura.Target = v
        end
    })
    
    Tabs.KillAura:AddSlider("KARange", {
        Title = "Attack Range",
        Default = 25,
        Min = 5,
        Max = 500,
        Rounding = 0,
        Callback = function(v)
            Settings.KillAura.Range = v
        end
    })
    
    Tabs.KillAura:AddSlider("KADelay", {
        Title = "Attack Delay (ms)",
        Default = 50,
        Min = 0,
        Max = 1000,
        Rounding = 0,
        Callback = function(v)
            Settings.KillAura.Delay = v / 1000
        end
    })

print("Parte 7 carregada - UI Movement, ESP, KillAura")Tabs.KillAura:AddSection("Advanced Features")
    
    Tabs.KillAura:AddToggle("KASilentAim", {
        Title = "Silent Aim",
        Default = false,
        Callback = function(v)
            Settings.KillAura.SilentAim = v
        end
    })
    
    Tabs.KillAura:AddToggle("KAPrediction", {
        Title = "Movement Prediction",
        Default = false,
        Callback = function(v)
            Settings.KillAura.Prediction = v
        end
    })
    
    Tabs.KillAura:AddSlider("KAPredictionFactor", {
        Title = "Prediction Factor",
        Default = 0.1,
        Min = 0.01,
        Max = 1,
        Rounding = 2,
        Callback = function(v)
            Settings.KillAura.PredictionFactor = v
        end
    })
    
    Tabs.KillAura:AddToggle("KARageMode", {
        Title = "Rage Mode (Multi)",
        Default = false,
        Callback = function(v)
            Settings.KillAura.RageMode = v
        end
    })
    
    Tabs.KillAura:AddToggle("KASpin", {
        Title = "Spin Attack",
        Default = false,
        Callback = function(v)
            Settings.KillAura.SpinAttack = v
        end
    })
    
    Tabs.KillAura:AddSlider("KASpinSpeed", {
        Title = "Spin Speed",
        Default = 50,
        Min = 10,
        Max = 200,
        Rounding = 0,
        Callback = function(v)
            Settings.KillAura.SpinSpeed = v
        end
    })
    
    Tabs.KillAura:AddToggle("KATP", {
        Title = "TP to Target",
        Default = false,
        Callback = function(v)
            Settings.KillAura.TPToTarget = v
        end
    })
    
    Tabs.KillAura:AddSection("Filters & Mods")
    
    Tabs.KillAura:AddToggle("KATeamCheck", {
        Title = "Team Check",
        Default = true,
        Callback = function(v)
            Settings.KillAura.TeamCheck = v
        end
    })
    
    Tabs.KillAura:AddToggle("KAWallCheck", {
        Title = "Attack Through Walls",
        Default = false,
        Callback = function(v)
            Settings.KillAura.WallCheck = v
        end
    })
    
    Tabs.KillAura:AddToggle("KAAutoEquip", {
        Title = "Auto Equip Tool",
        Default = true,
        Callback = function(v)
            Settings.KillAura.AutoEquip = v
        end
    })
    
    Tabs.KillAura:AddSlider("KAReach", {
        Title = "Reach Distance",
        Default = 10,
        Min = 1,
        Max = 50,
        Rounding = 0,
        Callback = function(v)
            Settings.KillAura.Reach = v
        end
    })
    
    Tabs.KillAura:AddToggle("KAHitbox", {
        Title = "Hitbox Expander",
        Default = false,
        Callback = function(v)
            Settings.KillAura.HitboxExpander = v
        end
    })
    
    Tabs.KillAura:AddSlider("KAHitboxSize", {
        Title = "Hitbox Size",
        Default = 10,
        Min = 2,
        Max = 50,
        Rounding = 0,
        Callback = function(v)
            Settings.KillAura.HitboxSize = v
        end
    })
    
    --// TROLL TAB
    Tabs.Troll:AddSection("Player Control")
    
    Tabs.Troll:AddToggle("FlingEnabled", {
        Title = "Fling Player",
        Default = false,
        Callback = function(v)
            Settings.Troll.FlingEnabled = v
            if v and Settings.Troll.FlingTarget then
                task.spawn(function()
                    while Settings.Troll.FlingEnabled do
                        TrollSystem.Fling(Settings.Troll.FlingTarget)
                        task.wait(0.1)
                    end
                end)
            end
        end
    })
    
    local FlingDropdown = Tabs.Troll:AddDropdown("FlingTarget", {
        Title = "Fling Target",
        Values = {},
        Callback = function(v)
            Settings.Troll.FlingTarget = v
        end
    })
    
    Tabs.Troll:AddSlider("FlingPower", {
        Title = "Fling Power",
        Default = 500,
        Min = 100,
        Max = 5000,
        Rounding = 0,
        Callback = function(v)
            Settings.Troll.FlingPower = v
        end
    })
    
    Tabs.Troll:AddSection("Loop Attacks")
    
    Tabs.Troll:AddToggle("LoopKill", {
        Title = "Loop Kill Target",
        Default = false,
        Callback = function(v)
            Settings.Troll.LoopKill = v
            if v then
                TrollSystem.StartLoopKill()
            else
                TrollSystem.StopLoopKill()
            end
        end
    })
    
    Tabs.Troll:AddDropdown("LoopKillTarget", {
        Title = "Loop Kill Target",
        Values = {},
        Callback = function(v)
            Settings.Troll.LoopKillTarget = v
        end
    })
    
    Tabs.Troll:AddSlider("LoopKillDelay", {
        Title = "Loop Delay",
        Default = 1,
        Min = 0.1,
        Max = 5,
        Rounding = 1,
        Callback = function(v)
            Settings.Troll.LoopKillDelay = v
        end
    })
    
    Tabs.Troll:AddSection("Mass Actions")
    
    Tabs.Troll:AddButton("Kill All", function()
        TrollSystem.KillAll()
        Utility.Notify("Troll", "Kill All executado!", 3)
    end)
    
    Tabs.Troll:AddButton("Bring All", function()
        TrollSystem.BringAll()
        Utility.Notify("Troll", "Bring All executado!", 3)
    end)
    
    Tabs.Troll:AddSection("Automation")
    
    Tabs.Troll:AddToggle("AutoClicker", {
        Title = "Auto Clicker",
        Default = false,
        Callback = function(v)
            Settings.Troll.AutoClicker = v
            if v then
                TrollSystem.StartAutoClicker()
            else
                TrollSystem.StopAutoClicker()
            end
        end
    })
    
    Tabs.Troll:AddSlider("ClickerDelay", {
        Title = "Click Delay (ms)",
        Default = 50,
        Min = 10,
        Max = 500,
        Rounding = 0,
        Callback = function(v)
            Settings.Troll.ClickerDelay = v / 1000
        end
    })
    
    Tabs.Troll:AddToggle("SpamTool", {
        Title = "Spam Equip/Unequip",
        Default = false,
        Callback = function(v)
            Settings.Troll.SpamTool = v
            if v then
                TrollSystem.StartSpamTool()
            else
                TrollSystem.StopSpamTool()
            end
        end
    })

print("Parte 8 carregada - UI KillAura Avançado e Troll")--// TELEPORT TAB
    Tabs.Teleport:AddSection("Player Teleport")
    
    local TPDropdown = Tabs.Teleport:AddDropdown("TPPlayer", {
        Title = "TP to Player",
        Values = {},
        Callback = function(v)
            local target = Players:FindFirstChild(v)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local myHRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                if myHRP then
                    myHRP.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    Utility.Notify("Teleport", "Teletransportado para " .. v, 3)
                end
            end
        end
    })
    
    Tabs.Teleport:AddSection("Location")
    
    Tabs.Teleport:AddButton("TP to Spawn", function()
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local spawnLoc = Workspace:FindFirstChild("SpawnLocation") or Workspace:FindFirstChild("Spawn")
            if spawnLoc then
                Player.Character.HumanoidRootPart.CFrame = spawnLoc.CFrame
            else
                Player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
            end
        end
    end)
    
    --// VISUAL TAB
    Tabs.Visual:AddSection("Lighting")
    
    Tabs.Visual:AddToggle("FullBright", {
        Title = "Full Bright",
        Default = false,
        Callback = function(v)
            Settings.Visual.FullBright = v
            VisualSystem.SetFullBright(v)
        end
    })
    
    Tabs.Visual:AddToggle("NoFog", {
        Title = "No Fog",
        Default = false,
        Callback = function(v)
            Settings.Visual.NoFog = v
            VisualSystem.SetNoFog(v)
        end
    })
    
    Tabs.Visual:AddSlider("TimeOfDay", {
        Title = "Time of Day",
        Default = 12,
        Min = 0,
        Max = 24,
        Rounding = 1,
        Callback = function(v)
            Settings.Visual.TimeOfDay = v
            Lighting.TimeOfDay = v .. ":00:00"
        end
    })
    
    Tabs.Visual:AddSlider("FOV", {
        Title = "Field of View",
        Default = 70,
        Min = 30,
        Max = 120,
        Rounding = 0,
        Callback = function(v)
            Settings.Visual.FOV = v
            Camera.FieldOfView = v
        end
    })
    
    --// SERVER TAB
    Tabs.Server:AddSection("Server Info")
    
    local FPSLabel = Tabs.Server:AddParagraph({Title = "FPS: Calculando...", Content = ""})
    local PingLabel = Tabs.Server:AddParagraph({Title = "Ping: Calculando...", Content = ""})
    
    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                FPSLabel:SetTitle("FPS: " .. math.floor(Workspace:GetRealPhysicsFPS()))
                PingLabel:SetTitle("Ping: " .. math.floor(Player:GetNetworkPing() * 1000) .. "ms")
            end)
        end
    end)
    
    Tabs.Server:AddSection("Actions")
    
    Tabs.Server:AddButton("Anti-AFK", function()
        Player.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
        Utility.Notify("Server", "Anti-AFK ativado!", 3)
    end)
    
    Tabs.Server:AddButton("Rejoin Server", function()
        TeleportService:Teleport(game.PlaceId, Player)
    end)
    
    Tabs.Server:AddButton("Server Hop", function()
        local Http = game:GetService("HttpService")
        local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local Data = Http:JSONDecode(game:HttpGet(Api))
        
        for _, v in pairs(Data.data) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, Player)
                break
            end
        end
    end)
    
    Tabs.Server:AddButton("FPS Boost", function()
        settings().Rendering.QualityLevel = 1
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            end
        end
        Utility.Notify("Server", "FPS Boost aplicado!", 3)
    end)
    
    --// SETTINGS TAB
    Tabs.Settings:AddSection("UI Settings")
    
    Tabs.Settings:AddButton("Destroy UI", function()
        KillAuraSystem.Stop()
        FlySystem.Stop()
        Window:Destroy()
    end)
    
    Tabs.Settings:AddButton("Rejoin Game", function()
        TeleportService:Teleport(game.PlaceId, Player)
    end)
    
    -- Atualizar Dropdowns
    task.spawn(function()
        while task.wait(3) do
            local players = Utility.GetPlayerList()
            KATargetDropdown:SetValues(players)
            FlingDropdown:SetValues(players)
            TPDropdown:SetValues(players)
        end
    end)
    
    Window:SelectTab(4)
    Utility.Notify("Ganin Hub", "Sistema carregado com sucesso!", 5)
end

-- Iniciar
CreateUI()

-- Manter character atualizado
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HRP = char:WaitForChild("HumanoidRootPart")
end)

print("Parte 9 carregada - Finalização e Inicialização")
print("Ganin Hub Ultra v12.0 carregado com sucesso!")        Title = "Ganin hub 👾",
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
