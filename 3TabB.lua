-- Beast Tab
local BeastTab = _G.HubWindow:CreateTab("Beast", 4483362458)
local lp = game:GetService("Players").LocalPlayer
BeastTab:CreateToggle({
    Name = "Custom Beast Crawl (Vent Bypass)",
    CurrentValue = false,
    Callback = function(state)
        _G.BeastCrawl = state
        local char = lp.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvent")
        if not hum or not remote then return end
        if state then 
            if not _G.cTrack then 
                local a = Instance.new("Animation")
                a.AnimationId = "rbxassetid://961932719"
                _G.cTrack = hum:LoadAnimation(a) 
            end 
            remote:FireServer("Input", "Crawl", true)
            hum.HipHeight = -2
            hum.WalkSpeed = 8
            _G.cTrack:Play(0.1, 1, 0)
            task.spawn(function()
                while _G.BeastCrawl do
                    if char then
                        for _, part in pairs(char:GetChildren()) do
                            if part:IsA("BasePart") and part.CanCollide then
                                part.CanCollide = false
                            end
                        end
                    end
                    if hum.MoveDirection.Magnitude > 0 then
                        _G.cTrack:AdjustSpeed(2)
                    else
                        _G.cTrack:AdjustSpeed(0)
                    end
                    task.wait()
                end
                if char then
                    for _, part in pairs(char:GetChildren()) do
                        if part:IsA("BasePart") then part.CanCollide = true end
                    end
                end
            end)
        else 
            remote:FireServer("Input", "Crawl", false)
            hum.HipHeight = 0
            hum.WalkSpeed = 16
            if _G.cTrack then _G.cTrack:Stop() end 
        end
    end
})
BeastTab:CreateToggle({
    Name = "Anti-Jump Slowdown",
    CurrentValue = false,
    Callback = function(state)
        _G.AntiJumpSlow = state
        if state then
            task.spawn(function()
                while _G.AntiJumpSlow do
                    local char = lp.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    local bPowers = char and char:FindFirstChild("BeastPowers")
                    local pEvent = bPowers and bPowers:FindFirstChild("PowersEvent")
                    if hum and pEvent then
                        if hum:GetState() == Enum.HumanoidStateType.Landed then
                            pEvent:FireServer("Jumped")
                        end
                    end
                    task.wait()
                end
            end)
        end
    end
})
