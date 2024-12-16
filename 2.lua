-- List of main accounts (receivers)
local MainAccounts = {"XrjnbWFhzxW", "SxrOwLugQAv", "sSVyTcBAwGN", "xpBLEvtcwFF", "zYdxHxMzmcS", "HzDYFdRByVM", "ugNbEbbeyBV", "PZAMvTAJnzC", "ujvvCpuVyRk", "NXVXzjAVtvd"} -- Add usernames of main accounts
local PetNames = {"", "Golden Dragon", "Phoenix"} -- Add pet names here

repeat task.wait(1) until game:IsLoaded() and game:GetService("ReplicatedStorage"):FindFirstChild("ClientModules") and game:GetService("ReplicatedStorage").ClientModules:FindFirstChild("Core") and game:GetService("ReplicatedStorage").ClientModules.Core:FindFirstChild("UIManager") and game:GetService("ReplicatedStorage").ClientModules.Core.UIManager.Apps:FindFirstChild("TransitionsApp") and game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("TransitionsApp") and game:GetService("Players").LocalPlayer.PlayerGui.TransitionsApp:FindFirstChild("Whiteout")

local RS = game:GetService("ReplicatedStorage")
local ReplicatedStorage = RS
local ClientData = require(RS.ClientModules.Core.ClientData)
local RouterClient = require(RS.ClientModules.Core:WaitForChild("RouterClient"):WaitForChild("RouterClient"))
local Player = game:GetService("Players").LocalPlayer

for i, v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do v:Disable() end
for i, v in pairs(debug.getupvalue(RouterClient.init, 7)) do v.Name = i end

-- Helper Functions
function findPetID(petName)
    for _, entry in pairs(require(game:GetService("ReplicatedStorage").ClientDB.Inventory.InventoryDB).pets) do
        if type(entry) == "table" and string.lower(entry.name) == string.lower(petName) then
            return entry.id
        end
    end
    return nil
end

function InvContainsPet(petName)
    for _, v in pairs(ClientData.get_data()[Player.Name].inventory.pets) do
        if v.id == findPetID(petName) then
            return true
        end
    end
    return false
end

function TradePet(mainAccount, petName)
    if game.Players:FindFirstChild(mainAccount) and InvContainsPet(petName) then
        repeat task.wait(1)
            RS.API:WaitForChild("TradeAPI/SendTradeRequest"):FireServer(game.Players:WaitForChild(mainAccount))
        until Player.PlayerGui.TradeApp.Frame.Visible

        -- Add pet to trade
        for _, v in pairs(ClientData.get_data()[Player.Name].inventory.pets) do
            if v.id == findPetID(petName) then
                RS.API:FindFirstChild("TradeAPI/AddItemToOffer"):FireServer(v.unique)
                break
            end
        end

        -- Accept and confirm trade
        while Player.PlayerGui.TradeApp.Frame.Visible do
            RS.API.TradeAPI.AcceptNegotiation:FireServer()
            task.wait(0.1)
            RS.API.TradeAPI.ConfirmTrade:FireServer()
            task.wait(0.1)
        end
    end
end

-- Main Script Logic
local tradedPets = {}

for _, mainAccount in ipairs(MainAccounts) do
    for _, petName in ipairs(PetNames) do
        if not tradedPets[petName] then
            while InvContainsPet(petName) do
                TradePet(mainAccount, petName)
                tradedPets[petName] = true
            end
        end -- Closing the 'if' statement
    end
end

print("All trades completed.")
