-- Tab Survivors
local SurvTab = _G.HubWindow:CreateTab("Survivors", 4483362458)
local lp = game:GetService("Players").LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local remote = rs:WaitForChild("RemoteEvent")

SurvTab:CreateToggle({
    Name = "No PC Error",
    CurrentValue = false,
    Callback = function(v)
        _G.NoPCError = v
        while _G.NoPCError do
            remote:FireServer("SetPlayerMinigameResult", true)
            task.wait(0.1)
        end
    end
})

SurvTab:CreateButton({
    Name = "Noclip All Doors",
    Callback = function()
        for _, m in pairs(workspace:GetDescendants()) do
            if (m.Name == "Door" or m.Name == "SingleDoor" or m.Name == "DoubleDoor" or m.Name == "DoorL" or m.Name == "DoorR") and m:IsA("Model") then
                for _, p in pairs(m:GetDescendants()) do
                    if p:IsA("BasePart") then
                        p.CanCollide = false
                    end
                end
            end
        end
        local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
        Rayfield:Notify({Title = "Noclip", Content = "All doors are now passable.", Duration = 2})
    end
})
