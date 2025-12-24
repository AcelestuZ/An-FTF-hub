-- ESP tab
local ESPTab = _G.HubWindow:CreateTab("ESP", 4483362458)
local lp = game:GetService("Players").LocalPlayer

local BadgeIcons = {
    ["CON"] = "rbxassetid://18940005647",
    ["DEV"] = "rbxassetid://18940006678",
    ["LEAD"] = "rbxassetid://18937953345",
    ["MAN"] = "rbxassetid://131476591459702",
    ["MOD"] = "rbxassetid://105155010224102",
    ["QA"] = "rbxassetid://18940008283",
    ["VIP"] = "rbxassetid://1188562340"
}

local function GetPlayerBadgeKey(p)
    pcall(function()
        local s = p:FindFirstChild("SavedPlayerStatsModule")
        if s and s:FindFirstChild("VIP") and s.VIP.Value == true then return "VIP" end
    end)
    local k = nil
    pcall(function()
        local g = p:FindFirstChild("PlayerGui")
        local f = g.ScreenGui.PlayerNamesFrame:FindFirstChild(p.Name.."PlayerFrame")
        if f and f:FindFirstChild("IconLabel") then
            local i = f.IconLabel.Image
            if string.find(i,"18940005647") then k="CON" elseif string.find(i,"18940006678") then k="DEV"
            elseif string.find(i,"18937953345") then k="LEAD" elseif string.find(i,"131476591459702") then k="MAN"
            elseif string.find(i,"105155010224102") then k="MOD" elseif string.find(i,"18940008283") then k="QA" end
        end
    end)
    return k
end

local function GetBeastChance(p)
    local c = "0"
    pcall(function() local s = p:FindFirstChild("SavedPlayerStatsModule") if s and s:FindFirstChild("BeastChance") then c = tostring(s.BeastChance.Value) end end)
    return c
end

local function UpdateESP(obj, col, txt, en, isP, pObj)
    if not obj then return end
    local sh = _G.ESP_Highlights and en and (pObj ~= lp)
    if sh then
        local h = obj:FindFirstChild("HubH") or Instance.new("Highlight", obj)
        h.Name = "HubH"; h.FillColor = col; h.OutlineColor = Color3.new(1,1,1)
        h.OutlineTransparency = _G.ESP_Outlines and 0 or 1; h.DepthMode = 0; h.FillTransparency = isP and 0.2 or 0.85
    else if obj:FindFirstChild("HubH") then obj.HubH:Destroy() end end
    
    if _G.ESP_Names and en and txt then
        local tag = obj:FindFirstChild("HubT") or Instance.new("BillboardGui", obj)
        tag.Name = "HubT"; tag.Size = UDim2.new(0,200,0,50); tag.AlwaysOnTop = true
        tag.ExtentsOffset = Vector3.new(0, isP and 1.5 or 0.5, 0)
        local l = tag:FindFirstChild("L") or Instance.new("TextLabel", tag)
        l.Name = "L"; l.BackgroundTransparency = 1; l.Size = UDim2.new(1,0,0.5,0); l.Text = txt; l.TextColor3 = col; l.TextSize = 14; l.Font = 3; l.TextStrokeTransparency = 0
        if isP and pObj then
            local bk = GetPlayerBadgeKey(pObj)
            local img = tag:FindFirstChild("I") or Instance.new("ImageLabel", tag)
            img.Name = "I"; img.BackgroundTransparency = 1; img.Size = UDim2.new(0,18,0,18); img.Position = UDim2.new(0.8,0,0,0)
            if _G.Show_BadgeIcons and bk and BadgeIcons[bk] then img.Image = BadgeIcons[bk]; img.Visible = true else img.Visible = false end
            local cl = tag:FindFirstChild("C") or Instance.new("TextLabel", tag)
            cl.Name = "C"; cl.BackgroundTransparency = 1; cl.Position = UDim2.new(0,0,0.5,0); cl.Size = UDim2.new(1,0,0.4,0); cl.TextColor3 = Color3.new(1,1,1); cl.TextSize = 11
            if _G.Show_BeastChance then cl.Text = "Chance: "..GetBeastChance(pObj).."%"; cl.Visible = true else cl.Visible = false end
        end
    else if obj:FindFirstChild("HubT") then obj.HubT:Destroy() end end
end

ESPTab:CreateSection("Settings")
ESPTab:CreateToggle({Name = "Highlights", CurrentValue = false, Callback = function(v) _G.ESP_Highlights = v end})
ESPTab:CreateToggle({Name = "Names", CurrentValue = false, Callback = function(v) _G.ESP_Names = v end})
ESPTab:CreateToggle({Name = "Outlines", CurrentValue = true, Callback = function(v) _G.ESP_Outlines = v end})
ESPTab:CreateSection("Detection")
ESPTab:CreateToggle({Name = "ESP Computers", CurrentValue = false, Callback = function(v) _G.ESP_PC = v end})
ESPTab:CreateToggle({Name = "ESP Freeze Pods", CurrentValue = false, Callback = function(v) _G.ESP_Pod = v end})
ESPTab:CreateToggle({Name = "ESP Exits", CurrentValue = false, Callback = function(v) _G.ESP_Exit = v end})
ESPTab:CreateToggle({Name = "Show Badges", CurrentValue = false, Callback = function(v) _G.Show_BadgeIcons = v end})
ESPTab:CreateToggle({Name = "Show Beast Chance", CurrentValue = false, Callback = function(v) _G.Show_BeastChance = v end})

task.spawn(function()
    while task.wait(0.5) do
        for _,p in pairs(game.Players:GetPlayers()) do if p.Character then local isB = p.Character:FindFirstChild("Hammer") or p.Character:FindFirstChild("BeastPowers") UpdateESP(p.Character, isB and Color3.new(1,0,0) or Color3.new(0,1,0), (p==lp and "[YOU] " or (isB and "[B] " or "[S] "))..p.Name, true, true, p) end end
        for _,v in pairs(workspace:GetDescendants()) do
            if v.Name=="ComputerTable" then UpdateESP(v, Color3.new(0,1,1), "PC", _G.ESP_PC, false)
            elseif v.Name=="FreezePod" and v:IsA("Model") then UpdateESP(v, Color3.new(1,0,0), "POD", _G.ESP_Pod, false)
            elseif v.Name=="ExitDoor" or v.Name=="ExitArea" then UpdateESP(v, Color3.new(0,1,0), "EXIT", _G.ESP_Exit, false) end
        end
    end
end)
