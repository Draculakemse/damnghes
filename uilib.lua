repeat task.wait() until game:IsLoaded() and game:GetService("ReplicatedStorage"):FindFirstChild("ClientModules") and game:GetService("ReplicatedStorage").ClientModules:FindFirstChild("Core") and game:GetService("ReplicatedStorage").ClientModules.Core:FindFirstChild("UIManager") and game:GetService("ReplicatedStorage").ClientModules.Core:FindFirstChild("UIManager").Apps:FindFirstChild("TransitionsApp") and game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("TransitionsApp") and game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("TransitionsApp"):FindFirstChild("Whiteout")

if game:GetService("Players").LocalPlayer.PlayerGui.TransitionsApp:FindFirstChild("Whiteout").Visible then 
    game:GetService("Players").LocalPlayer.PlayerGui.TransitionsApp:FindFirstChild("Whiteout").Visible = false 
end

for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
  v:Disable()
end

for i, v in pairs(debug.getupvalue(require(game.ReplicatedStorage.Fsys).load("RouterClient").init, 7)) do 
    v.Name = i 
end

local RS = game:GetService("ReplicatedStorage")
local Fsys = require(RS:WaitForChild("Fsys")).load
local Main_Menu = require(RS.ClientModules.Core.UIManager.Apps.MainMenuApp)
local Player = game:GetService("Players").LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")

---------------- Warn Control ---------------------------------
local old;old = hookfunction(warn,function(data)
   return
end)
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
