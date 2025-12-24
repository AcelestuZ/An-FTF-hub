-- ESP tab
local ESPTab = _G.HubWindow:CreateTab("ESP", 4483362458)
local lp = game:GetService("Players").LocalPlayer

local function GetBeastChance(p)
    local c = "0"
    pcall(function() 
        local s = p:FindFirstChild("SavedPlayerStatsModule") 
        if s and s:FindFirstChild("BeastChance") then 
            c = tostring(s.BeastChance.Value) 
        end 
    end)
    return c
end

local function UpdateESP(obj, col, txt, en, isP, pObj)
    if not obj then return end
    local targetPart = isP and obj:FindFirstChild("Head") or obj:FindFirstChild("Screen", true) or obj:FindFirstChildWhichIsA("BasePart", true)
    if not targetPart then return end

    local sh = _G.ESP_Highlights and en and (pObj ~= lp)
    if sh then
        local h = obj:FindFirstChild("HubH") or Instance.new("Highlight", obj)
        h.Name = "HubH"; h.FillColor = col; h.OutlineColor = Color3.new(1,1,1)
        h.OutlineTransparency = _G.ESP_Outlines and 0 or 1; h.DepthMode = 0; h.FillTransparency = isP and 0.2 or 0.85
    elseif obj:FindFirstChild("HubH") then obj.HubH:Destroy() end
    
    if _G.ESP_Names and en and txt then
        local tag = obj:FindFirstChild("HubT") or Instance.new("BillboardGui", obj)
        tag.Name = "HubT"; tag.Size = UDim2.new(0,200,0,50); tag.AlwaysOnTop = true; tag.Adornee = targetPart
        tag.ExtentsOffset = Vector3.new(0, isP and 1.2 or 0.8, 0)
        
        local l = tag:FindFirstChild("L") or Instance.new("TextLabel", tag)
        l.Name = "L"; l.BackgroundTransparency = 1; l.Size = UDim2.new(1,0,1,0); l.Text = txt; l.TextColor3 = col; l.TextSize = 14; l.Font = 3; l.TextStrokeTransparency = 0
        
        if isP and pObj then
            local cl = tag:FindFirstChild("C") or Instance.new("TextLabel", tag)
            cl.Name = "C"; cl.BackgroundTransparency = 1; cl.Position = UDim2.new(0,0,0.6,0); cl.Size = UDim2.new(1,0,0.4,0); cl.TextColor3 = Color3.new(1,1,1); cl.TextSize = 11
            if _G.Show_BeastChance then 
                cl.Text = "Chance: "..GetBeastChance(pObj).."%"; 
                cl.Visible = true 
            else 
                cl.Visible = false 
            end
        end
    elseif obj:FindFirstChild("HubT") then obj.HubT:Destroy() end
end

ESPTab:CreateSection("Settings")
ESPTab:CreateToggle({Name = "Highlights", CurrentValue = false, Callback = function(v) _G.ESP_Highlights = v end})
ESPTab:CreateToggle({Name = "Names", CurrentValue = false, Callback = function(v) _G.ESP_Names = v end})
ESPTab:CreateToggle({Name = "Outlines", CurrentValue = true, Callback = function(v) _G.ESP_Outlines = v end})
ESPTab:CreateSection("Detection")
ESPTab:CreateToggle({Name = "ESP Computers", CurrentValue = false, Callback = function(v) _G.ESP_PC = v end})
ESPTab:CreateToggle({Name = "ESP Freeze Pods", CurrentValue = false, Callback = function(v) _G.ESP_Pod = v end})
ESPTab:CreateToggle({Name = "ESP Exits", CurrentValue = false, Callback = function(v) _G.ESP_Exit = v end})
ESPTab:CreateToggle({Name = "Show Beast Chance", CurrentValue = false, Callback = function(v) _G.Show_BeastChance = v end})

task.spawn(function()
    while task.wait(0.5) do
        for _,p in pairs(game.Players:GetPlayers()) do
            if p.Character then
                local color = Color3.new(0,1,0)
                local prefix = "[S] "
                local isBeast = p.Character:FindFirstChild("Hammer") or p.Character:FindFirstChild("BeastPowers")
                
                if workspace:FindFirstChild("FTFLobby") and p.Character:IsDescendantOf(workspace.FTFLobby) then
                    color = Color3.new(1,1,1)
                    prefix = "[Lobby] "
                elseif isBeast then
                    color = Color3.new(1,0,0)
                    prefix = "[B] "
                end
                
                UpdateESP(p.Character, color, (p==lp and "[YOU] " or prefix)..p.Name, true, true, p)
            end
        end
        for _,v in pairs(workspace:GetDescendants()) do
            if v.Name=="ComputerTable" then 
                UpdateESP(v, Color3.new(0,1,1), "PC", _G.ESP_PC, false)
            elseif v.Name=="FreezePod" and v:IsA("Model") then 
                UpdateESP(v, Color3.new(1,0,0), "POD", _G.ESP_Pod, false)
            elseif v.Name=="ExitDoor" or v.Name=="ExitArea" then 
                UpdateESP(v, Color3.new(0,1,0), "EXIT", _G.ESP_Exit, false) 
            end
        end
    end
end)
