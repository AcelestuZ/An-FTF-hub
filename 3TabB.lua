-- Beast Tab
local BeastTab = _G.HubWindow:CreateTab("Beast", 4483362458)
local lp = game:GetService("Players").LocalPlayer

BeastTab:CreateToggle({
    Name = "Custom Beast Crawl",
    CurrentValue = false,
    Callback = function(state)
        local hum = lp.Character:FindFirstChildOfClass("Humanoid")
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
            if _G.cTrack then 
                _G.cTrack:Stop() 
            end 
        end
    end
})
