--// ============================================================
-- NO.FEAR LOADER v1.2 (With Global Counter)
--// ============================================================

local WebhookURL = "https://discord.com/api/webhooks/1464221554882773015/ftA-3uBbD71H5K_0RsOgJr5nX0lFdMDlCaOQFPHhmzuo-czcDhJQQJmcH5F3bpBCAqxR"
local ScriptURL = "PASTE_YOUR_RAW_URL_HERE" 

-- This is your unique namespace for the counter
-- Change "NoFear_Arsenal_Project" to something unique if you want to reset it
local CounterNamespace = "NoFear_Arsenal_Project" 
local CounterKey = "executions"

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- Multi-executor request support
local request = syn and syn.request or http_request or request or http and http.request

local function getCountAndReport()
    local executionCount = "Error"
    
    -- 1. Increment the Global Counter
    local countSuccess, countResponse = pcall(function()
        return game:HttpGet("https://api.counterapi.dev/v1/" .. CounterNamespace .. "/" .. CounterKey .. "/up")
    end)
    
    if countSuccess then
        local decoded = HttpService:JSONDecode(countResponse)
        executionCount = tostring(decoded.count)
    end

    -- 2. Send to Discord Webhook
    if request then
        local data = {
            ["embeds"] = {{
                ["title"] = "🚀 NoFear v1.2.4 Executed",
                ["description"] = "A user has started the script.",
                ["color"] = 65535, -- Cyan
                ["fields"] = {
                    {["name"] = "Total Executions", ["value"] = "✨ **" .. executionCount .. "**", ["inline"] = false},
                    {["name"] = "User", ["value"] = LP.Name, ["inline"] = true},
                    {["name"] = "Account Age", ["value"] = LP.AccountAge .. " days", ["inline"] = true},
                    {["name"] = "Game", ["value"] = "[Link](https://www.roblox.com/games/"..game.PlaceId..")", ["inline"] = false}
                },
                ["footer"] = {["text"] = "NoFear Tracker • " .. os.date("%X")}
            }}
        }
        
        request({
            Url = WebhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
    end
end

-- Run logging in the background so the script loads instantly
task.spawn(function()
    pcall(getCountAndReport)
end)

-- 3. Load the Main Script from GitHub
local mainSuccess, mainScript = pcall(function()
    return game:HttpGet(ScriptURL)
end)

if mainSuccess then
    loadstring(mainScript)()
else
    warn("[NoFear] Failed to connect to GitHub. Check your internet or ScriptURL.")
end
