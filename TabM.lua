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
    Name = "Remove Barriers",
    CurrentValue = false,
    Callback = function(v)
        _G.RemoveBarriers = v
        if v then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name == "Barrier" or obj.Parent.Name == "LobbyCollideBox") then
                    obj.CanCollide = false
                    obj.Transparency = 1
                end
            end
        else
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name == "Barrier" or obj.Parent.Name == "LobbyCollideBox") then
                    obj.CanCollide = true
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
        p.CFrame = hrp.CFrame - Vector3.new(0, 3.2, 0)
        p.Parent = workspace
        local e = Instance.new("ParticleEmitter")
        e.LightInfluence, e.Brightness = 0, 2
        e.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.6), NumberSequenceKeypoint.new(0.05, 1.2), NumberSequenceKeypoint.new(1, 0.4)})
        e.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.7, 0), NumberSequenceKeypoint.new(1, 1)})
        e.Lifetime, e.Speed, e.Acceleration, e.SpreadAngle, e.Shape = NumberRange.new(0.3), NumberRange.new(12), Vector3.new(0, 4, 0), Vector2.new(0, 180), Enum.ParticleEmitterShape.Disc
        e.Parent = p
        e:Emit(24)
        game:GetService("Debris"):AddItem(p, 0.5)
    end
end

local hasJumpedOnce = false
local hasDoubleJumped = false

MainTab:CreateButton({
    Name = "Activate Safe Double Jump",
    Callback = function()
        if _G.SafeDJ then _G.SafeDJ:Disconnect() end
        _G.SafeDJ = UIS.JumpRequest:Connect(function()
            local char = lp.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hum and hrp then
                local state = hum:GetState()
                if state == Enum.HumanoidStateType.Freefall and hasJumpedOnce and not hasDoubleJumped then
                    hasDoubleJumped = true
                    hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 36, hrp.AssemblyLinearVelocity.Z)
                    task.spawn(SpawnJumpEffect)
                end
            end
        end)
        task.spawn(function()
            while _G.SafeDJ do
                local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    local s = hum:GetState()
                    if s == Enum.HumanoidStateType.Landed then
                        hasJumpedOnce = false
                        hasDoubleJumped = false
                    elseif s == Enum.HumanoidStateType.Jumping then
                        hasJumpedOnce = true
                    end
                end
                task.wait()
            end
        end)
        _G.Rayfield:Notify({Title = "Hace HUB", Content = "Safe Double Jump Ready", Duration = 2})
    end
})
