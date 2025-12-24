-- main
_G.Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = _G.Rayfield:CreateWindow({
   Name = "Hace HUB | FtF 🏃🏢",
   LoadingTitle = "Caricamento Hace HUB...",
   LoadingSubtitle = "By AcelestuZ",
   ConfigurationSaving = { Enabled = true, FolderName = "HaceHub_FTF" },
   KeySystem = false
})

_G.HubWindow = Window

_G.ESP_Highlights, _G.ESP_Names, _G.ESP_Outlines = false, false, true
_G.NoPCError, _G.FullBrightEnabled, _G.NoFogEnabled = false, false, false
_G.ESP_PC, _G.ESP_Exit, _G.ESP_Pod = false, false, false
_G.Show_BadgeIcons, _G.Show_BeastChance = false, false

local baseUrl = "https://raw.githubusercontent.com/AcelestuZ/An-FTF-hub/main/"

local function loadTab(file)
    local url = baseUrl .. file
    local success, content = pcall(function() return game:HttpGet(url) end)
    if success then
        local func, err = loadstring(content)
        if func then
            pcall(func)
        else
            warn("Errore di sintassi in " .. file .. ": " .. tostring(err))
        end
    else
        warn("Impossibile scaricare " .. file)
    end
end

loadTab("TabM.lua")
loadTab("2TabS.lua")
loadTab("3TabB.lua")
loadTab("4TabESP.lua")
loadTab("5TabTP.lua")

_G.Rayfield:Notify({Title = "Hace HUB", Content = "Script caricato con successo!", Duration = 3})
