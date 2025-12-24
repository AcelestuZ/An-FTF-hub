-- Beast Tab
local BeastTab = _G.HubWindow:CreateTab("Beast", 4483362458)
local lp = game:GetService("Players").LocalPlayer

BeastTab:CreateToggle({
    Name = "Custom Beast Crawl",
    CurrentValue = false,
    Callback = function(state)
        _G.BeastCrawl = state
        local char = lp.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        if state then 
            if not _G.cTrack then 
                local a = Instance.new("Animation")
                a.AnimationId = "rbxassetid://961932719"
                _G.cTrack = hum:LoadAnimation(a) 
            end 
            hum.HipHeight = -2
            hum.WalkSpeed = 8
            _G.cTrack:Play()
        else 
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
                    local bPowers = char and char:FindFirstChild("BeastPowers")
                    local pEvent = bPowers and bPowers:FindFirstChild("PowersEvent")
                    
                    if pEvent then
                        local oldName = pEvent.Name
                        pEvent.Name = "FakeEvent"
                        repeat task.wait() until not _G.AntiJumpSlow or lp.Character ~= char
                        pEvent.Name = oldName
                    end
                    task.wait(1)
                end
            end)
        end
    end
})
