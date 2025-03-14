getgenv().jump = {
    enabled = false,
    power = 50, 
    control = false,
    friction = 2.0,    
    keybind = Enum.KeyCode.KeypadDivide 
}

local function setJumpPower(player, power)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = power
    end
end

local function enhanceControl(player, reset)
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        if reset then
            rootPart.CustomPhysicalProperties = PhysicalProperties.new()
        else
            rootPart.CustomPhysicalProperties = PhysicalProperties.new(
                0.7, 
                jump.friction,
                0.5,
                1.0, 
                0.5  
            )
        end
    end
end

local function applyJumpBoost(player)
    local character = player.Character or player.CharacterAdded:Wait()

    if jump.enabled then
        setJumpPower(player, jump.power)
        if jump.control then
            enhanceControl(player, false) 
        end
    else
        setJumpPower(player, 50) 
        if jump.control then
            enhanceControl(player, true) 
        end
    end
end

local function toggleJumpBoost()
    jump.enabled = not jump.enabled
    print("Jump boost enabled:", jump.enabled)
    applyJumpBoost(game.Players.LocalPlayer)
end

local player = game.Players.LocalPlayer

if player.Character then
    applyJumpBoost(player)
end

player.CharacterAdded:Connect(function()
    applyJumpBoost(player)
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == jump.keybind then
        toggleJumpBoost()
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if jump.enabled then
        setJumpPower(player, jump.power)
    end
end)
