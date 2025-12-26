-- Tab Main 🏠 
local MainTab = _G.HubWindow:CreateTab("Main", 4483362458)
local lp = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
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
    Name = "Reset Character (Instant)",
    Callback = function()
        local char = lp.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Health = 0
            char:BreakJoints()
        end
    end
})
MainTab:CreateToggle({
    Name = "Remove Barriers",
    CurrentValue = false,
    Callback = function(v)
        _G.RemoveBarriers = v
        local function process(obj)
            if obj:IsA("BasePart") then
                obj.CanCollide = not v
                obj.Transparency = v and 1 or 0
            end
        end
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                if obj.Name == "Barrier" or obj.Name == "LobbyCollideBox" or obj.Name == "Barriers" then
                    process(obj)
                end
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
MainTab:CreateSection("Movement")
MainTab:CreateInput({
   Name = "Walk Speed",
   PlaceholderText = "Default: 16",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      _G.SpeedValue = tonumber(Text) or 16
   end,
})
MainTab:CreateToggle({
   Name = "Enable LoopSpeed",
   CurrentValue = false,
   Callback = function(v)
      _G.LoopSpeedEnabled = v
      if v then
         task.spawn(function()
            local connection
            connection = RunService.Stepped:Connect(function()
               if not _G.LoopSpeedEnabled then connection:Disconnect() return end
               if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
                  lp.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = _G.SpeedValue
               end
            end)
         end)
      end
   end,
})

MainTab:CreateSection("Special Abilities")

local function SpawnJumpEffect()
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local p = Instance.new("Part")
        p.Transparency, p.Size, p.CanCollide, p.Massless, p.Anchored = 1, Vector3.new(0.1, 0.1, 0.1), false, true, true
        p.CFrame = hrp.CFrame - Vector3.new(0, 3, 0)
        p.Parent = workspace
        local e = Instance.new("ParticleEmitter")
        e.LightInfluence, e.Brightness = 0, 2
        e.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.6), NumberSequenceKeypoint.new(0.05, 1.2), NumberSequenceKeypoint.new(1, 0.4)})
        e.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.7, 0), NumberSequenceKeypoint.new(1, 1)})
        e.Lifetime, e.Speed, e.Acceleration, e.SpreadAngle, e.Shape = NumberRange.new(0.3), NumberRange.new(12), Vector3.new(0, 4, 0), Vector2.new(0, 180), Enum.ParticleEmitterShape.Disc
        e.Rate = 0
        e.Parent = p
        e:Emit(20)
        game:GetService("Debris"):AddItem(p, 0.5)
    end
end

local canDoubleJump = false
local hasDoubleJumped = false
local oldPower = 50 

MainTab:CreateButton({
    Name = "Activate Safe Double Jump",
    Callback = function()
        local char = lp.Character or lp.CharacterAdded:Wait()
        local hum = char:WaitForChild("Humanoid")
        
        -- Reset degli stati quando tocchi terra
        hum.StateChanged:Connect(function(_, newState)
            if newState == Enum.HumanoidStateType.Landed then
                canDoubleJump = false
                hasDoubleJumped = false
            elseif newState == Enum.HumanoidStateType.Jumping then
                canDoubleJump = true
            end
        end)

        -- Gestione dell'input per il secondo salto
        UIS.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == Enum.KeyCode.Space then
                local h = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
                local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                
                if h and hrp and canDoubleJump and not hasDoubleJumped then
                    local state = h:GetState()
                    if state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping then
                        hasDoubleJumped = true
                        canDoubleJump = false
                        
                        -- Applica la forza verso l'alto
                        hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 45, hrp.AssemblyLinearVelocity.Z)
                        task.spawn(SpawnJumpEffect)
                    end
                end
            end
        end)
        
        _G.Rayfield:Notify({Title = "Hace HUB", Content = "Double Jump Ottimizzato!", Duration = 2})
    end
})
