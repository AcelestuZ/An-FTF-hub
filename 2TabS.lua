-- Tab Survivors
local STab = _G.HubWindow:CreateTab("Survivors", 4483362458)

STab:CreateToggle({
    Name = "No PC Error",
    CurrentValue = false,
    Callback = function(v)
        _G.NoPCError = v
        if v then
            task.spawn(function()
                local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent")
                while _G.NoPCError do
                    pcall(function()
                        remote:FireServer("SetPlayerMinigameResult", true)
                        remote:FireServer("SetMinigameSuccess", true)
                    end)
                    task.wait()
                end
            end)
        end
    end
})

STab:CreateToggle({
    Name = "Auto-No Seek",
    CurrentValue = false,
    Callback = function(v)
        _G.AutoNoSeek = v
        if v then
            task.spawn(function()
                local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent")
                local hasNotified = false
                
                while _G.AutoNoSeek do
                    local target = nil
                    for _, name in pairs({"HidingCloset", "HiddenCloset", "Locker", "Loker2"}) do
                        local found = workspace:FindFirstChild(name, true)
                        if found then target = found break end
                    end
                    
                    if target then
                        pcall(function()
                            remote:FireServer("SetPlayerHiding", true, target)
                        end)
                        hasNotified = false
                    elseif not hasNotified then
                        _G.Rayfield:Notify({
                            Title = "Errore Nascondiglio",
                            Content = "Non ci sono posti in cui nascondersi in questa mappa!",
                            Duration = 5
                        })
                        hasNotified = true
                    end
                    task.wait(0.5)
                end
                
                local r = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvent")
                if r then r:FireServer("SetPlayerHiding", false) end
            end)
        end
    end
})

STab:CreateButton({
    Name = "Noclip Doors (Once)",
    Callback = function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "SingleDoor" or v.Name == "DoubleDoor" then
                for _, part in pairs(v:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end
})
