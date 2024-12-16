-- List of main accounts (receivers)
local MainAccounts = {"XrjnbWFhzxW", "SxrOwLugQAv", "sSVyTcBAwGN", "xpBLEvtcwFF", "zYdxHxMzmcS", "HzDYFdRByVM", "ugNbEbbeyBV", "PZAMvTAJnzC", "ujvvCpuVyRk", "NXVXzjAVtvd"} -- Add usernames of main accounts
local PetNames = {"Ice Cube", "Cold Cube", "Berry Cool Cube"} -- Add pet names here

-- Wait for game to load
repeat
    task.wait(1)
    print("Waiting for game to load...")
until game:IsLoaded() 
    and game:GetService("ReplicatedStorage"):FindFirstChild("ClientModules")
    and game:GetService("ReplicatedStorage").ClientModules:FindFirstChild("Core")
    and game:GetService("ReplicatedStorage").ClientModules.Core:FindFirstChild("UIManager")
    and game:GetService("ReplicatedStorage").ClientModules.Core.UIManager.Apps:FindFirstChild("TransitionsApp")
    and game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("TransitionsApp")
    and game:GetService("Players").LocalPlayer.PlayerGui.TransitionsApp:FindFirstChild("Whiteout")

print("Game loaded successfully!")

local RS = game:GetService("ReplicatedStorage")
local ClientData = require(RS.ClientModules.Core.ClientData)
local RouterClient = require(RS.ClientModules.Core:WaitForChild("RouterClient"):WaitForChild("RouterClient"))
local Player = game:GetService("Players").LocalPlayer

-- Disable idling connections
for i, v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
    v:Disable()
end

for i, v in pairs(debug.getupvalue(RouterClient.init, 7)) do
    v.Name = i
end

-- Helper Functions
function findPetID(petName)
    print("Finding Pet ID for:", petName)
    for _, entry in pairs(require(game:GetService("ReplicatedStorage").ClientDB.Inventory.InventoryDB).pets) do
        if type(entry) == "table" and string.lower(entry.name) == string.lower(petName) then
            return entry.id
        end
    end
    print("Pet ID not found for:", petName)
    return nil
end

function InvContainsPet(petName)
    local petID = findPetID(petName)
    if not petID then return false end
    print("Checking if inventory contains pet:", petName)
    for _, v in pairs(ClientData.get_data()[Player.Name].inventory.pets) do
        if v.id == petID then
            return true
        end
    end
    return false
end

function TradePet(mainAccount, petName)
    print("Attempting to trade pet:", petName, "to:", mainAccount)
    if game.Players:FindFirstChild(mainAccount) and InvContainsPet(petName) then
        repeat
            task.wait(1)
            print("Sending trade request to:", mainAccount)
            RS.API:WaitForChild("TradeAPI/SendTradeRequest"):FireServer(game.Players:WaitForChild(mainAccount))
        until Player.PlayerGui.TradeApp.Frame.Visible

        -- Add pet to trade
        for _, v in pairs(ClientData.get_data()[Player.Name].inventory.pets) do
            if v.id == findPetID(petName) then
                print("Adding pet to trade:", petName)
                RS.API:FindFirstChild("TradeAPI/AddItemToOffer"):FireServer(v.unique)
                break
            end
        end

        -- Accept and confirm trade
        while Player.PlayerGui.TradeApp.Frame.Visible do
            print("Accepting trade...")
            RS.API.TradeAPI.AcceptNegotiation:FireServer()
            task.wait(0.1)
            RS.API.TradeAPI.ConfirmTrade:FireServer()
            task.wait(0.1)
        end
        print("Trade completed for pet:", petName)
    else
        print("Trade conditions not met for pet:", petName, "to:", mainAccount)
    end
end

-- Main Script Logic
local tradedPets = {}

for _, mainAccount in ipairs(MainAccounts) do
    for _, petName in ipairs(PetNames) do
        if not tradedPets[petName] then
            print("Starting trade process for pet:", petName)
            while InvContainsPet(petName) do
                TradePet(mainAccount, petName)
                tradedPets[petName] = true
            end
        end
    end
end

print("All trades completed.")
