-- XENO ULTIMATE FLY (DISCORD CLIPBOARD EDITION)
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local pgui = Player:WaitForChild("PlayerGui")

-- 1. NOTIFICATION WITH CLIPBOARD
local discordLink = "https://discord.gg/gA4geyTmpm" -- REPLACE THIS WITH YOUR ACTUAL LINK

local bindable = Instance.new("BindableFunction")

bindable.OnInvoke = function(button)
    if button == "Copy Link" then
        if setclipboard then
            setclipboard(discordLink)
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Success!",
                Text = "Link copied to clipboard.",
                Duration = 3
            })
        else
            print("Executor does not support clipboard. Link: " .. discordLink)
        end
    end
end

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Join Our Discord!",
    Text = "Updates and support available on our server.",
    Duration = 15,
    Button1 = "Copy Link",
    Button2 = "Ignore",
    Callback = bindable
})

-- 2. CLEANUP & UI SETUP
if pgui:FindFirstChild("XenoFinalHub") then pgui.XenoFinalHub:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "XenoFinalHub"
sg.IgnoreGuiInset = true
sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.05, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0.9, 0, 0, 40)
toggle.Position = UDim2.new(0.05, 0, 0.1, 0)
toggle.Text = "FLY: OFF"
toggle.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Font = Enum.Font.GothamBold
Instance.new("UICorner", toggle)

local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(1, 0, 0, 30)
speedLabel.Position = UDim2.new(0, 0, 0.6, 0)
speedLabel.Text = "Speed: 100 (Tap)"
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.BackgroundTransparency = 1

-- 3. THE MOVEMENT ENGINE (S-DIRECTION FIX)
local flying = false
local speed = 100
local bv, bg

toggle.MouseButton1Click:Connect(function()
    flying = not flying
    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if flying and root then
        toggle.Text = "FLY: ACTIVE"
        toggle.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        
        bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        
        char.Humanoid.PlatformStand = true
        
        task.spawn(function()
            while flying and char and char:FindFirstChild("Humanoid") do
                local cam = workspace.CurrentCamera.CFrame
                local moveDir = char.Humanoid.MoveDirection
                
                if moveDir.Magnitude > 0 then
                    -- Projecting moveDir onto camera axis
                    -- This ensures 'S' moves you BACKWARDS relative to camera
                    local forward = cam.LookVector
                    local right = cam.RightVector
                    
                    local fVal = moveDir:Dot(forward)
                    local rVal = moveDir:Dot(right)
                    
                    bv.Velocity = (forward * fVal + right * rVal).Unit * speed
                else
                    bv.Velocity = Vector3.new(0, 0, 0)
                end
                
                bg.CFrame = cam
                
                -- Noclip
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
                RunService.RenderStepped:Wait()
            end
        end)
    else
        toggle.Text = "FLY: OFF"
        toggle.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
        end
    end
end)

speedLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        speed = (speed >= 1000) and 100 or speed + 100
        speedLabel.Text = "Speed: " .. speed
    end
end)
