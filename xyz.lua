repeat task.wait() until game:IsLoaded() and game:GetService("ReplicatedStorage"):FindFirstChild("ClientModules") and game:GetService("ReplicatedStorage").ClientModules:FindFirstChild("Core") and game:GetService("ReplicatedStorage").ClientModules.Core:FindFirstChild("UIManager") and game:GetService("ReplicatedStorage").ClientModules.Core:FindFirstChild("UIManager").Apps:FindFirstChild("TransitionsApp") and game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("TransitionsApp") and game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("TransitionsApp"):FindFirstChild("Whiteout")

if game:GetService("Players").LocalPlayer.PlayerGui.TransitionsApp:FindFirstChild("Whiteout").Visible then 
    game:GetService("Players").LocalPlayer.PlayerGui.TransitionsApp:FindFirstChild("Whiteout").Visible = false 
end


local RS = game:GetService("ReplicatedStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ClientData = require(RS.ClientModules.Core.ClientData)
local Player = game:GetService("Players").LocalPlayer
local RouterClient = require(RS.ClientModules.Core:WaitForChild("RouterClient"):WaitForChild("RouterClient"))
local Main_Menu = require(RS.ClientModules.Core.UIManager.Apps.MainMenuApp)
local VirtualInputManager = game:GetService("VirtualInputManager")
local LiveOpsMapSwap = require(game:GetService("ReplicatedStorage").SharedModules.Game.LiveOpsMapSwap)

game.Players.LocalPlayer.Idled:Connect(function() 
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame) 
    task.wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame) 
end)

for i, v in pairs(debug.getupvalue(RouterClient.init, 7)) do
    v.Name = i
end

---------------------------------------------------------------

function clickGuiButton(button: Instance, xOffset: number, yOffset: number)
	local xOffset = xOffset or 60
	local yOffset = yOffset or 60
	task.wait()
	VirtualInputManager:SendMouseButtonEvent(button.AbsolutePosition.X + xOffset, button.AbsolutePosition.Y + yOffset, 0, true, game, 1)
	task.wait()
	VirtualInputManager:SendMouseButtonEvent(button.AbsolutePosition.X + xOffset, button.AbsolutePosition.Y + yOffset, 0, false, game, 1)
	task.wait()
end

repeat
    if Player.PlayerGui.NewsApp.EnclosingFrame.MainFrame.Contents.PlayButton.Visible then
        clickGuiButton(Player.PlayerGui.NewsApp.EnclosingFrame.MainFrame.Contents.PlayButton)
    end
    if Player.PlayerGui.DialogApp.Dialog.RoleChooserDialog.Baby.Visible then
        clickGuiButton(Player.PlayerGui.DialogApp.Dialog.RoleChooserDialog.Baby)
    end
    task.wait(1.1)
    -- After Choose Parent
    Player.PlayerGui.DialogApp.Dialog:WaitForChild("RobuxProductDialog")
    if Player.PlayerGui.DialogApp.Dialog.RobuxProductDialog.Visible then 
        for i,v in pairs(Player.PlayerGui.DialogApp.Dialog.RobuxProductDialog.Buttons:GetChildren()) do 
            if v.ClassName == "ImageButton" then 
                clickGuiButton(v)
            end
        end
    end
    Player.PlayerGui:WaitForChild("DailyLoginApp")
    if Player.PlayerGui.DailyLoginApp.Enabled and Player.PlayerGui.DailyLoginApp.Frame.Visible then 
        for i,v in pairs(Player.PlayerGui.DailyLoginApp.Frame.Body.Buttons:GetChildren()) do 
            if v.Name == "ClaimButton" then
                clickGuiButton(v)
            end 
        end
    end
    game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog:WaitForChild("UpdatesDialog")
    if game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog.UpdatesDialog.Visible then 
        for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog.UpdatesDialog.Buttons:GetChildren()) do 
            if v.ClassName == "ImageButton" then 
                clickGuiButton(v)
            end
        end
    end
until game:GetService("Players").LocalPlayer.Character and workspace.Camera.CameraSubject == game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid")

task.spawn(function()
    repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    task.wait(4)
    game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog:WaitForChild("RobuxProductDialog")
    if game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog.RobuxProductDialog.Visible then 
        for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog.RobuxProductDialog.Buttons:GetChildren()) do 
            if v.ClassName == "ImageButton" then 
                clickGuiButton(v)
            end
        end
    end
    wait(0.5)
    game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("DailyLoginApp")
    if game:GetService("Players").LocalPlayer.PlayerGui.DailyLoginApp.Enabled and game:GetService("Players").LocalPlayer.PlayerGui.DailyLoginApp.Frame.Visible then 
        for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.DailyLoginApp.Frame.Body.Buttons:GetChildren()) do 
            if v.Name == "ClaimButton" then
                clickGuiButton(v)
                task.wait(0.5)
                clickGuiButton(v)
            end 
        end
    end
    wait(0.5)
    game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog:WaitForChild("UpdatesDialog")
    if game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog.UpdatesDialog.Visible then 
        for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog.UpdatesDialog.Buttons:GetChildren()) do 
            if v.ClassName == "ImageButton" then 
                clickGuiButton(v)
            end
        end
    end
end)

---------- Extra GUI Control and Buttons and IMAGES blah blah -------------
game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Enabled = false
game:GetService("Players").LocalPlayer.PlayerGui.InteractionsApp.Enabled = false
game:GetService("Players").LocalPlayer.PlayerGui.NavigatorApp.Enabled = false

------- Transition App Disabled (whatever it is) --------
require(game.ReplicatedStorage.ClientModules.Core.UIManager.Apps.TransitionsApp).transition = function() return end 
require(game.ReplicatedStorage.ClientModules.Core.UIManager.Apps.TransitionsApp).sudden_fill = function() return end
if game:GetService("Players").LocalPlayer.PlayerGui.TransitionsApp:FindFirstChild("Whiteout").Visible then 
    game:GetService("Players").LocalPlayer.PlayerGui.TransitionsApp:FindFirstChild("Whiteout").Visible = false 
end


local Player = game:GetService("Players").LocalPlayer
local HRP = Player.Character.HumanoidRootPart
local RS = game.ReplicatedStorage
local getconstants = getconstants or debug.getconstants
local getgc = getgc or get_gc_objects or debug.getgc
local get_thread_identity = get_thread_context or getthreadcontext or getidentity or syn.get_thread_identity
local set_thread_identity = set_thread_context or setthreadcontext or setidentity or syn.set_thread_identity

-- Disable GUIs
Player.PlayerGui.DialogApp.Enabled = false
Player.PlayerGui.InteractionsApp.Enabled = false
Player.PlayerGui.NavigatorApp.Enabled = false

--------  Game Status Check ----------
function GameStatus()
    return workspace.StaticMap["spleef_minigame_minigame_state"].is_game_active.Value
end

function GameLoading()
    return workspace.StaticMap["spleef_minigame_minigame_state"].players_loading.Value
end

local SetLocationTP
for _, v in pairs(getgc()) do
	if type(v) == "function" then
		if getfenv(v).script == game.ReplicatedStorage.ClientModules.Core.InteriorsM.InteriorsM then
			if table.find(getconstants(v), "LocationAPI/SetLocation") then
				SetLocationTP = v
				break
			end
		end
	end
end

SetLocation = function(A, B)
    local O = get_thread_identity()
    set_thread_identity(4)
    --require(game.ReplicatedStorage.ClientModules.Core.InteriorsM.InteriorsM).enter(A, B, {["studs_ahead_of_door"] = 15})
    require(game.ReplicatedStorage.ClientModules.Core.InteriorsM.InteriorsM).enter(A, B, {["spawn_cframe"] = CFrame.new(-15956, 11155, -15888) * CFrame.Angles(0, 0, 0)})
    set_thread_identity(O)
end

GoToMainMap = function()
    local stA = tick()
    SetLocation("Winter2024Shop", "MainDoor")
    --if workspace:FindFirstChildWhichIsA("Terrain") then workspace.Terrain:Clear() end
    repeat task.wait(1) until (game.workspace.Interiors:FindFirstChildWhichIsA("Model") and game.workspace.Interiors:FindFirstChild("Winter2024Shop")) or (tick() - stA >= 200)
    CreateTempPart()
    if workspace:FindFirstChildWhichIsA("Terrain") then workspace.Terrain:Clear() end
    return false
end

function CreateTempPart()
    if workspace:FindFirstChild("TempPartA") then 
        workspace.TempPartA:Destroy() 
    end
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then  
        game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = true  
        local a = Instance.new("Part", workspace)
        a.Size = Vector3.new(500,0,500)
        a.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, -2, 0)
        a.CanCollide = true 
        a.Anchored = true 
        a.Transparency = 1 
        a.Name = "TempPartA"
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = a.CFrame + Vector3.new(0, 1, 0)
        Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
    end
end

function GetMainMap()
    return workspace.Interiors:FindFirstChild("Winter2024Shop")
end

function GetLobby()
    repeat task.wait() until workspace.Interiors:FindFirstChild("Winter2024Shop")
    repeat task.wait() until workspace.Interiors["Winter2024Shop"]:FindFirstChild("JoinZones")
    repeat task.wait() until workspace.Interiors["Winter2024Shop"].JoinZones:FindFirstChild("SpleefMinigame")
    repeat task.wait() until workspace.Interiors["Winter2024Shop"].JoinZones.SpleefMinigame:FindFirstChild("Ring")
    local ringPos = workspace.Interiors["Winter2024Shop"].JoinZones.SpleefMinigame.Ring.Position
    if ((ringPos - HRP.Position).Magnitude <= 15) or (ringPos.Y - HRP.Position.Y >= 0.50) then
        return true
    end
    return false
end

function farmGingerbreads()
    for _, v in RS.Resources.IceSkating.GingerbreadMarkers:GetChildren() do
        if v:IsA("BasePart") then
            local a,b = RS.API:FindFirstChild("WinterEventAPI/PickUpGingerbread"):InvokeServer(v.Name)
            task.wait()
        end
    end
    task.wait(1)
    RS.API:FindFirstChild("WinterEventAPI/RedeemPendingGingerbread"):FireServer()
end

-- Optimization
workspace.Pets.ChildAdded:Connect(function(c)
    task.wait(1)
    for i, v in pairs(workspace.Pets:GetChildren()) do
        v.Parent = game.ReplicatedStorage
    end
end)

workspace.PlayerCharacters.ChildAdded:Connect(function(c)
    task.wait(1)
    for i, v in pairs(workspace.PlayerCharacters:GetChildren()) do
        if v.Name ~= game.Players.LocalPlayer.Name then
            v.Parent = game.ReplicatedStorage
        end
    end
end)

workspace.Interiors.ChildAdded:Connect(function(c)
    task.wait(1)
    if workspace.Interiors:FindFirstChild("Winter2024Shop") then
        for i,v in pairs(workspace.Interiors.Winter2024Shop:GetChildren()) do
            if v.Name == "Visual" or v.Name == "Mannequins" or v.Name == "ShopPedestals" then
                if v.Name == "Visual" then
                    for l,o in pairs(workspace.Interiors.Winter2024Shop.Visual:GetChildren()) do
                        if o.Name ~= "Model" then
                            v.Parent = game.ReplicatedStorage
                        end
                    end
                else
                    v.Parent = game.ReplicatedStorage
                end
                task.wait()
            end
        end
    elseif workspace.Interiors:FindFirstChild("SpleefMinigame") then
        for i,v in pairs(workspace.Interiors.SpleefMinigame:GetChildren()) do
            if v.Name == "Visual" then
                v.Parent = game.ReplicatedStorage
                task.wait()
            end
        end
        if workspace:FindFirstChildWhichIsA("Terrain") then workspace.Terrain:Clear() end
    end
end)

spawn(function()
    while task.wait(5) do
        pcall(function()
            if not GameStatus() and Player.PlayerGui.MinigameInGameApp.Body.Left.Container.ValueLabel.Text == "00:00" and Player.PlayerGui.MinigameInGameApp.Enabled then
                task.wait(15)
                if not GameStatus() and Player.PlayerGui.MinigameInGameApp.Body.Left.Container.ValueLabel.Text == "00:00" and Player.PlayerGui.MinigameInGameApp.Enabled then
                    --game:Shutdown()
                    print("===== ACC STUCKK ====")
                end
            end
        end)

        if (ClientData.get_data()[game.Players.LocalPlayer.Name]["spleef_minigame_cycle_timestamp"]["timestamp"] - os.time() > 120) and (not GameLoading() and not GameStatus()) then
            print("== Starting Farming Gingerbread ==")
            farmGingerbreads()
            print("== Ended Farming Gingerbread ==")
            task.wait(300)
        end
    end
end)


print("== Starting Auto Winter 2024 Event ==")
while task.wait(0.5) do
    if GetMainMap() then
        pcall(function()
            if GetLobby() then
                if GameLoading() then
                    RS.API:FindFirstChild("MinigameAPI/AttemptJoin"):FireServer("spleef_minigame", true)
                    task.wait(10)
                else
                    pcall(function()
                        HRP.CFrame = CFrame.new(-15956, 11155, -15888) * CFrame.Angles(0, 0, 0)
                        CreateTempPart()
                    end)
                end
            else
                print("TPing to Join Zone")
                pcall(function()
                    HRP.Anchored = true
                    HRP.CFrame = CFrame.new(-15956, 11155, -15888) * CFrame.Angles(0, 0, 0)
                    CreateTempPart()
                    HRP.Anchored = false
                end)
                RS.API:FindFirstChild("MinigameAPI/AttemptJoin"):FireServer("spleef_minigame", true)
            end
        end)
    elseif GameStatus() and workspace.Interiors:FindFirstChild("SpleefMinigame") then
        print("Waiting for Minigame to load..")
        repeat task.wait(0.50) until workspace.Interiors:FindFirstChild("SpleefMinigame") and workspace.Interiors.SpleefMinigame:FindFirstChild("Minigame") 
        print("Starting Minigame..")
        HRP.Anchored = true
        task.wait(1)

        HRP.CFrame = CFrame.new(15766.4307, 7769.59521, 16022.4043) * CFrame.Angles(0, 0, 0)
        CreateTempPart()

        task.wait(1)
        print("Completing minigame..")
        local startTimeForMinigameOverCheck = os.time()
        repeat task.wait()
            -- Minigame Code
            if (Vector3.new(15766.4307, 7769.59521, 16022.4043) - HRP.Position).Magnitude > 15 then
                HRP.Anchored = true
                HRP.CFrame = CFrame.new(15766.4307, 7769.59521, 16022.4043) * CFrame.Angles(0, 0, 0)
                CreateTempPart()
                --HRP.Anchored = false
            end
            local st = tick()
            while tick() - st <= 60 do
                task.wait(1)
                if not (game.Workspace.Interiors:FindFirstChild("SpleefMinigame") and GameStatus() and Player.PlayerGui.MinigameInGameApp.Enabled) then
                    startTimeForMinigameOverCheck = startTimeForMinigameOverCheck - 150
                    break
                end
            end
        until not (game.Workspace.Interiors:FindFirstChild("SpleefMinigame") and GameStatus() and Player.PlayerGui.MinigameInGameApp.Enabled) or (os.time() - startTimeForMinigameOverCheck >= 150)
        print("Minigame Ended!")
        HRP.Anchored = true
        for i = 1, 10 do
            task.wait(1)
            pcall(function()
                HRP.CFrame = CFrame.new(-15956, 11155, -15888) * CFrame.Angles(0, 0, 0)
                CreateTempPart()
            end)
        end
    else
        print("Going to Main Map..")
        GoToMainMap()
        print("Arrived at Map..")
    end
end
