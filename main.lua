-- My Custom Script
local Player = game.Players.LocalPlayer
local CoreGui = game:GetService("StarterGui")

-- Send a notification when the script starts
CoreGui:SetCore("SendNotification", {
    Title = "Script Loaded!";
    Text = "Welcome, " .. Player.Name .. ". Press F to toggle speed.";
    Duration = 5;
})

-- Example Feature: WalkSpeed Toggle
local toggled = false
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F then
        toggled = not toggled
        if toggled then
            Player.Character.Humanoid.WalkSpeed = 50
            print("Speed Boost: ON")
        else
            Player.Character.Humanoid.WalkSpeed = 16
            print("Speed Boost: OFF")
        end
    end
end)
