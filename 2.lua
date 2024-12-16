-- List of main accounts (receivers)
local MainAccounts = {"XrjnbWFhzxW", "SxrOwLugQAv", "sSVyTcBAwGN", "xpBLEvtcwFF", "zYdxHxMzmcS", "HzDYFdRByVM", "ugNbEbbeyBV", "PZAMvTAJnzC", "ujvvCpuVyRk", "NXVXzjAVtvd"} -- Add usernames
local PetNames = {"Ice Cube", "Cold Cube", "Berry Cool Cube"} -- Add pet names

-- Ensure game and player are fully loaded
repeat task.wait(1) until game:IsLoaded() and game.Players.LocalPlayer and game.Players.LocalPlayer.Character

local RS = game:GetService("ReplicatedStorage")
local ClientData = require(RS.ClientModules.Core.ClientData)
local Player = game.Players.LocalPlayer

-- Prevent AFK kick
for _, v in pairs(getconnections(Player.Idled)) do v:Disable() end

-- Helper Functions
function findPetID(petName)
    for _, entry in pairs(require(RS.ClientDB.Inventory.InventoryDB).pets) do
        if type(entry) == "table" and string.lower(entry.name) == string.lower(petName) then
            return entry.id
        end
    end
    return nil
end

function InvContainsPet(petName)
    local data = ClientData.get_data()
    for _, v in pairs(data[Player.Name].inventory.pets) do
        if v.id == findPetID(petName) then
            return true
        end
    end
    return false
end

function TradePet(mainAccount, petName)
    local petID = findPetID(petName)
    if not petID then
        warn("Pet not found: " .. petName)
        return false
    end

    local tradeTimeout = 30 -- Max time to attempt a trade
    local startTime = os.time()

    while os.time() - startTime < tradeTimeout do
        if not game.Players:FindFirstChild(mainAccount) then
            warn("Main account not found: " .. mainAccount)
            return false
        end

        -- Send trade request
        RS.API:WaitForChild("TradeAPI/SendTradeRequest"):FireServer(game.Players[mainAccount])
        task.wait(2) -- Give time for trade UI to open

        -- Check if Trade UI is visible
        if Player.PlayerGui:FindFirstChild("TradeApp") and Player.PlayerGui.TradeApp.Frame.Visible then
            -- Add pet to trade
            for _, pet in pairs(ClientData.get_data()[Player.Name].inventory.pets) do
                if pet.id == petID then
                    RS.API.TradeAPI.AddItemToOffer:FireServer(pet.unique)
                    task.wait(0.5)
                    break
                end
            end

            -- Accept trade
            RS.API.TradeAPI.AcceptNegotiation:FireServer()
            task.wait(1)
            RS.API.TradeAPI.ConfirmTrade:FireServer()
            task.wait(1)

            print("Trade completed for pet:", petName)
            return true -- Trade successful
        end
        task.wait(1) -- Retry after waiting
    end
    warn("Trade failed for pet: " .. petName)
    return false
end

-- Main Logic
local tradedPets = {}

for _, mainAccount in ipairs(MainAccounts) do
    for _, petName in ipairs(PetNames) do
        while InvContainsPet(petName) do
            print("Attempting to trade", petName, "to", mainAccount)
            local success = TradePet(mainAccount, petName)
            if success then
                tradedPets[petName] = true
            else
                warn("Failed to trade " .. petName .. " to " .. mainAccount)
                break
            end
        end
    end
end

print("All trades completed.")
