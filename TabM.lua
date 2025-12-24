-- Tab Main 🏠 
local MainTab = _G.HubWindow:CreateTab("Main", 4483362458)
local lp = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")

_G.LoopSpeedEnabled = false
_G.SpeedValue = 16

MainTab:CreateToggle({
    Name = "Full Bright",
    CurrentValue = false,
    Callback = function(v)
        _G.FullBrightEnabled = v
        task.spawn(function()
            while _G.FullBrightEnabled do
                game:GetService("Lighting").Brightness = 2
                game:GetService("Lighting").ClockTime = 14
                task.wait(0.5)
            end
        end)
    end
})

MainTab:CreateToggle({
    Name = "No Fog",
    CurrentValue = false,
    Callback = function(v)
        _G.NoFogEnabled = v
        task.spawn(function()
            while _G.NoFogEnabled do
                game:GetService("Lighting").FogEnd = 100000
                pcall(function() game:GetService("Lighting").Atmosphere:Destroy() end)
                task.wait(0.5)
            end
        end)
    end
})

MainTab:CreateButton({
    Name = "Reset Character",
    Callback = function()
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.Health = 0
            task.wait(0.1)
            lp.Character:BreakJoints()
        end
    end
})

MainTab:CreateToggle({
    Name = "Rimuovi Barriere",
    CurrentValue = false,
    Callback = function(v)
        _G.RemoveBarriers = v
        if v then
            local lobbyBox = workspace:FindFirstChild("LobbyCollideBox", true)
            if lobbyBox then
                for _, part in pairs(lobbyBox:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                        part.Transparency = 1
                    end
                end
            end
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name == "Barrier" then
                    obj.CanCollide = false
                    obj.Transparency = 1
                end
            end
            _G.Rayfield:Notify({Title = "Hace HUB", Content = "Barriere rimosse!", Duration = 3})
        else
            local lobbyBox = workspace:FindFirstChild("LobbyCollideBox", true)
            if lobbyBox then
                for _, part in pairs(lobbyBox:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = true end
                end
            end
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name == "Barrier" then obj.CanCollide = true end
            end
        end
    end
})

MainTab:CreateButton({
    Name = "Unlock Camera",
    Callback = function()
        lp.CameraMaxZoomDistance = 1000
        lp.CameraMinZoomDistance = 0.5
        lp.CameraMode = Enum.CameraMode.Classic
    end
})

MainTab:CreateSection("Movimento")

MainTab:CreateInput({
   Name = "Velocità Camminata",
   PlaceholderText = "Default: 16",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      _G.SpeedValue = tonumber(Text) or 16
   end,
})

MainTab:CreateToggle({
   Name = "Attiva LoopSpeed",
   CurrentValue = false,
   Callback = function(v)
      _G.LoopSpeedEnabled = v
      if v then
         task.spawn(function()
            local connection
            connection = RunService.Stepped:Connect(function()
               if not _G.LoopSpeedEnabled then 
                  connection:Disconnect() 
                  return 
               end
               if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
                  lp.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = _G.SpeedValue
               end
            end)
         end)
      else
         if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
            lp.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
         end
      end
   end,
})
MainTab:CreateSection("Special Abilities")

local function JumpCloudParticle()
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local Part_3 = Instance.new("Part")
        Part_3.Name = "DoubleJumpCloudParticle"
        Part_3.Transparency = 1
        Part_3.Size = Vector3.new(0.1, 0.1, 0.1)
        Part_3.CanCollide = false
        Part_3.Massless = true
        Part_3.Anchored = true
        Part_3.CFrame = hrp.CFrame - Vector3.new(0, 3.2, 0)
        Part_3.Parent = workspace
        
        local ParticleEmitter_3 = Instance.new("ParticleEmitter")
        ParticleEmitter_3.LightInfluence = 0
        ParticleEmitter_3.Brightness = 2
        ParticleEmitter_3.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.6), NumberSequenceKeypoint.new(0.05, 1.2), NumberSequenceKeypoint.new(1, 0.4)})
        ParticleEmitter_3.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.7, 0), NumberSequenceKeypoint.new(1, 1)})
        ParticleEmitter_3.Lifetime = NumberRange.new(0.3)
        ParticleEmitter_3.Speed = NumberRange.new(12)
        ParticleEmitter_3.Acceleration = Vector3.new(0, 4, 0)
        ParticleEmitter_3.SpreadAngle = Vector2.new(0, 180)
        ParticleEmitter_3.Shape = Enum.ParticleEmitterShape.Disc
        ParticleEmitter_3.Parent = Part_3
        ParticleEmitter_3:Emit(24)
        game:GetService("Debris"):AddItem(Part_3, 0.5)
    end
end

MainTab:CreateToggle({
    Name = "Always Double Jump",
    CurrentValue = false,
    Callback = function(v)
        _G.AlwaysDoubleJump = v
        if v then
            task.spawn(function()
                while _G.AlwaysDoubleJump do
                    local char = lp.Character
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        
                        -- Logica originale: Check Freefall (riga 590)
                        if hum and hrp and hum:GetState() == Enum.HumanoidStateType.Freefall then
                            -- Applichiamo la forza originale di 36 (riga 590)
                            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 36, hrp.AssemblyLinearVelocity.Z)
                            
                            -- Trigger particelle originali (riga 594)
                            task.spawn(JumpCloudParticle)
                            
                            -- Rimosso il cooldown di 3 secondi (riga 591)
                            task.wait(0.2) 
                        end
                    end
                    task.wait()
                end
            end)
        end
    end
})
