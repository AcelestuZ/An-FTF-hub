-- Tab Survivors
local STab = _G.HubWindow:CreateTab("Survivors", 4483362458)
local lp = game:GetService("Players").LocalPlayer

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
    Name = "Auto-No Seer",
    CurrentValue = false,
    Callback = function(v)
        _G.AutoNoSeer = v
        if v then
            task.spawn(function()
                local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent")
                local hasNotified = false
                while _G.AutoNoSeer do
                    local target = nil
                    for _, mod in pairs(workspace:GetDescendants()) do
                        if mod:IsA("Model") and mod.Name == "Model" then
                            local isLocker = false
                            if mod:FindFirstChild("Union", true) then
                                isLocker = true
                            elseif mod:FindFirstChildWhichIsA("Part", true) and mod:FindFirstChildWhichIsA("Part", true):FindFirstChildWhichIsA("Decal") then
                                isLocker = true
                            end
                            
                            if isLocker then
                                target = mod
                                break
                            end
                        end
                    end
                    if not target then
                        local altNames = {"HidingCloset", "HiddenCloset", "Locker", "Loker2", "Locker2", "Locker 2"}
                        for _, n in pairs(altNames) do
                            local f = workspace:FindFirstChild(n, true)
                            if f then target = f break end
                        end
                    end
                    if target then
                        pcall(function() remote:FireServer("SetPlayerHiding", true, target) end)
                        hasNotified = false
                    elseif not hasNotified then
                        _G.Rayfield:Notify({Title = "Hace HUB", Content = "Nessun locker trovato!", Duration = 5})
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
