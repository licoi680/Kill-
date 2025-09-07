-- Main.lua
-- GUI Hack: Fly + Auto Kill

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humrp = char:WaitForChild("HumanoidRootPart")

-- GUI chính
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 280, 0, 300)
Frame.Position = UDim2.new(0.05, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
Frame.Active = true
Frame.Draggable = true

-- ========== Fly ==========
local flyOn = false
local flySpeed = 50
local bv, bg

local flyBtn = Instance.new("TextButton", Frame)
flyBtn.Size = UDim2.new(1,-20,0,30)
flyBtn.Position = UDim2.new(0,10,0,10)
flyBtn.Text = "Fly: OFF"
flyBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
flyBtn.TextColor3 = Color3.new(1,1,1)

local upBtn = Instance.new("TextButton", Frame)
upBtn.Size = UDim2.new(0.45,0,0,25)
upBtn.Position = UDim2.new(0.05,0,0,50)
upBtn.Text = "UP"
upBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
upBtn.TextColor3 = Color3.new(1,1,1)

local downBtn = Instance.new("TextButton", Frame)
downBtn.Size = UDim2.new(0.45,0,0,25)
downBtn.Position = UDim2.new(0.5,0,0,50)
downBtn.Text = "DOWN"
downBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
downBtn.TextColor3 = Color3.new(1,1,1)

local plusBtn = Instance.new("TextButton", Frame)
plusBtn.Size = UDim2.new(0.45,0,0,25)
plusBtn.Position = UDim2.new(0.05,0,0,80)
plusBtn.Text = "Speed +"
plusBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
plusBtn.TextColor3 = Color3.new(1,1,1)

local minusBtn = Instance.new("TextButton", Frame)
minusBtn.Size = UDim2.new(0.45,0,0,25)
minusBtn.Position = UDim2.new(0.5,0,0,80)
minusBtn.Text = "Speed -"
minusBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
minusBtn.TextColor3 = Color3.new(1,1,1)

local speedLabel = Instance.new("TextLabel", Frame)
speedLabel.Size = UDim2.new(1,-20,0,20)
speedLabel.Position = UDim2.new(0,10,0,110)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.Text = "Fly Speed: "..flySpeed

flyBtn.MouseButton1Click:Connect(function()
    flyOn = not flyOn
    flyBtn.Text = flyOn and "Fly: ON" or "Fly: OFF"

    if flyOn then
        bv = Instance.new("BodyVelocity", humrp)
        bv.MaxForce = Vector3.new(9e9,9e9,9e9)
        bv.Velocity = Vector3.zero
        bg = Instance.new("BodyGyro", humrp)
        bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
        bg.CFrame = humrp.CFrame
    else
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end)

upBtn.MouseButton1Click:Connect(function()
    if flyOn and bv then
        bv.Velocity = Vector3.new(0, flySpeed, 0)
    end
end)

downBtn.MouseButton1Click:Connect(function()
    if flyOn and bv then
        bv.Velocity = Vector3.new(0, -flySpeed, 0)
    end
end)

plusBtn.MouseButton1Click:Connect(function()
    flySpeed = flySpeed + 10
    speedLabel.Text = "Fly Speed: "..flySpeed
end)

minusBtn.MouseButton1Click:Connect(function()
    flySpeed = math.max(10, flySpeed - 10)
    speedLabel.Text = "Fly Speed: "..flySpeed
end)

-- ========== Kill Aura ==========
local auraOn = false
local auraRange = 15
local auraDelay = 0.5
local auraMaxTargets = 3
local targetMode = "All" -- NPC, Player, All

local auraBtn = Instance.new("TextButton", Frame)
auraBtn.Size = UDim2.new(1,-20,0,30)
auraBtn.Position = UDim2.new(0,10,0,140)
auraBtn.Text = "Aura: OFF"
auraBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
auraBtn.TextColor3 = Color3.new(1,1,1)

local rangeLabel = Instance.new("TextLabel", Frame)
rangeLabel.Size = UDim2.new(1,-20,0,20)
rangeLabel.Position = UDim2.new(0,10,0,175)
rangeLabel.BackgroundTransparency = 1
rangeLabel.TextColor3 = Color3.new(1,1,1)
rangeLabel.Text = "Range: "..auraRange

local delayLabel = Instance.new("TextLabel", Frame)
delayLabel.Size = UDim2.new(1,-20,0,20)
delayLabel.Position = UDim2.new(0,10,0,195)
delayLabel.BackgroundTransparency = 1
delayLabel.TextColor3 = Color3.new(1,1,1)
delayLabel.Text = "Delay: "..auraDelay.."s"

local targetLabel = Instance.new("TextLabel", Frame)
targetLabel.Size = UDim2.new(1,-20,0,20)
targetLabel.Position = UDim2.new(0,10,0,215)
targetLabel.BackgroundTransparency = 1
targetLabel.TextColor3 = Color3.new(1,1,1)
targetLabel.Text = "Target: "..targetMode

-- nút bật tắt Aura
auraBtn.MouseButton1Click:Connect(function()
    auraOn = not auraOn
    auraBtn.Text = auraOn and "Aura: ON" or "Aura: OFF"

    if auraOn then
        spawn(function()
            while auraOn do
                task.wait(auraDelay)
                local count = 0
                for _,v in pairs(workspace:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                        if v ~= char then
                            local dist = (v.HumanoidRootPart.Position - humrp.Position).magnitude
                            if dist <= auraRange then
                                if targetMode == "Player" and Players:FindFirstChild(v.Name) then
                                    v.Humanoid.Health = 0
                                    count = count + 1
                                elseif targetMode == "NPC" and not Players:FindFirstChild(v.Name) then
                                    v.Humanoid.Health = 0
                                    count = count + 1
                                elseif targetMode == "All" then
                                    v.Humanoid.Health = 0
                                    count = count + 1
                                end
                            end
                        end
                    end
                    if count >= auraMaxTargets then break end
                end
            end
        end)
    end
end)
