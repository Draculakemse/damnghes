MainAccUsername = "turf5me" -- Roblox Username of Main Account (Receiver)
PetName = "Headless Horse" -- Pet Name (spelling and capitals matter)

repeat task.wait(1) until game:IsLoaded() and game:GetService("ReplicatedStorage"):FindFirstChild("ClientModules") and game:GetService("ReplicatedStorage").ClientModules:FindFirstChild("Core") and game:GetService("ReplicatedStorage").ClientModules.Core:FindFirstChild("UIManager") and game:GetService("ReplicatedStorage").ClientModules.Core:FindFirstChild("UIManager").Apps:FindFirstChild("TransitionsApp") and game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("TransitionsApp") and game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("TransitionsApp"):FindFirstChild("Whiteout")
local RS = game:GetService("ReplicatedStorage")
local ReplicatedStorage = RS
local ClientData = require(RS.ClientModules.Core.ClientData)
local RouterClient = require(RS.ClientModules.Core:WaitForChild("RouterClient"):WaitForChild("RouterClient"))
local Main_Menu = require(RS.ClientModules.Core.UIManager.Apps.MainMenuApp)
local Player = game:GetService("Players").LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")

for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do v:Disable() end
for i, v in pairs(debug.getupvalue(RouterClient.init, 7)) do v.Name = i end

function findPetID(petName)
    for _, entry in pairs(require(game:GetService("ReplicatedStorage").ClientDB.Inventory.InventoryDB).pets) do
        if type(entry) == "table" and string.lower(entry.name) == string.lower(petName) then
            return entry.id
        end
    end
    return nil
end

function CheckPetRarity(PetName)
    for _, entry in pairs(require(game:GetService("ReplicatedStorage").ClientDB.Inventory.InventoryDB).pets) do
        if type(entry) == "table" and string.lower(entry.name) == string.lower(PetName) then
            if entry.rarity == "common" then
                return "Common"
            elseif entry.rarity == "uncommon" then 
                return "Uncommon"
            elseif entry.rarity == "rare" then 
                return "Rare"
            elseif entry.rarity == "ultra_rare" then 
                return "Ultra Rare"
            elseif entry.rarity == "legendary" then 
                return "Legendary"
            end
        end
    end
end

function InvEmpty()
    for i,v in pairs(require(game.ReplicatedStorage.ClientModules.Core.ClientData).get_data()[game.Players.LocalPlayer.Name].inventory.pets) do
        if v.id == findPetID(PetName) then 
            return false
        end
    end
    return true
end

repeat
    if game.Players:FindFirstChild(MainAccUsername) and (not InvEmpty()) then
        repeat task.wait(1)
            RS.API:WaitForChild("TradeAPI/SendTradeRequest"):FireServer(game:GetService("Players"):WaitForChild(MainAccUsername))
        until game:GetService("Players").LocalPlayer.PlayerGui.TradeApp.Frame.Visible

        -- Add Pets
        count = 0
        for i,v in pairs(require(game.ReplicatedStorage.ClientModules.Core.ClientData).get_data()[game.Players.LocalPlayer.Name].inventory.pets) do
            if v.id == findPetID(PetName) then        
                RS.API:FindFirstChild("TradeAPI/AddItemToOffer"):FireServer(v.unique)
                count += 1
                if count >= 18 then break end
            end
        end

        -- Accept/Confirm
        while game:GetService("Players").LocalPlayer.PlayerGui.TradeApp.Frame.Visible do
            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TradeAPI/AcceptNegotiation"):FireServer()
            wait(0.1)
            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TradeAPI/ConfirmTrade"):FireServer()
            wait(0.1)
        end
    end
    task.wait(1.5)
    print("Waiting for acc")
until InvEmpty()

print("Account Completed.")
