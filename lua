-- Moon-Zen V4

local success, err = pcall(function()

    -- Load Rayfield GUI library
    local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

    local Window = Rayfield:CreateWindow({
        Name = "Moon-Zen V4 - Zombie Attack",
        LoadingTitle = "Moon-Zen V4",
        LoadingSubtitle = "By meowbucks on discord",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "MoonZenV4", -- Save folder for configurations
            FileName = "ZombieAttack"
        }
    })

    -- Function to cycle through rainbow colors
    local function rainbowColor(speed)
        local hue = tick() % speed / speed
        return Color3.fromHSV(hue, 1, 1)
    end

    -- Tabs
    local AimbotTab = Window:CreateTab("Aimbot", 4483362458)
    local ESPTab = Window:CreateTab("ESP", 4483362458)
    local CustomTab = Window:CreateTab("Customization", 4483362458)

    -- Auto Aim/Headshot Toggle
    AimbotTab:CreateToggle({
        Name = "Auto Aim/Headshot",
        CurrentValue = false,
        Flag = "AutoAim",
        Callback = function(Value)
            if Value then
                -- Wrap the auto-aim logic to ensure error handling
                spawn(function()
                    xpcall(function()
                        while Value do
                            local nearestZombie = nil
                            local shortestDistance = math.huge
                            for _, zombie in pairs(workspace.Zombies:GetChildren()) do
                                if zombie:FindFirstChild("HumanoidRootPart") then
                                    local distance = (zombie.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude
                                    if distance < shortestDistance then
                                        shortestDistance = distance
                                        nearestZombie = zombie
                                    end
                                end
                            end
                            if nearestZombie and nearestZombie:FindFirstChild("Head") then
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, nearestZombie.Head.Position)
                            end
                            wait(0.1) -- Small delay to prevent crashing
                        end
                    end, function(e)
                        warn("Error in Auto Aim: " .. tostring(e))
                    end)
                end)
            end
        end,
    })

    -- Wallhack/ESP Toggle
    ESPTab:CreateToggle({
        Name = "Wallhack/ESP",
        CurrentValue = false,
        Flag = "Wallhack",
        Callback = function(Value)
            if Value then
                -- Wrap the ESP logic to ensure error handling
                xpcall(function()
                    for _, zombie in pairs(workspace.Zombies:GetChildren()) do
                        if zombie:FindFirstChild("HumanoidRootPart") then
                            local billboard = Instance.new("BillboardGui")
                            billboard.Name = "ZombieESP"
                            billboard.Adornee = zombie.HumanoidRootPart
                            billboard.Size = UDim2.new(0, 200, 0, 50)
                            billboard.AlwaysOnTop = true

                            local textLabel = Instance.new("TextLabel", billboard)
                            textLabel.Size = UDim2.new(1, 0, 1, 0)
                            textLabel.Text = "Zombie"
                            textLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- Default Red
                            textLabel.BackgroundTransparency = 1

                            billboard.Parent = zombie
                        end
                    end
                end, function(e)
                    warn("Error in ESP: " .. tostring(e))
                end)
            else
                -- Remove all ESP Billboards
                for _, zombie in pairs(workspace.Zombies:GetChildren()) do
                    if zombie:FindFirstChild("ZombieESP") then
                        zombie.ZombieESP:Destroy()
                    end
                end
            end
        end,
    })

    -- ESP Color Customization
    ESPTab:CreateColorPicker({
        Name = "Zombie ESP Color",
        Color = Color3.fromRGB(255, 0, 0), -- Default color: Red
        Flag = "ZombieESPColor",
        Callback = function(Color)
            for _, zombie in pairs(workspace.Zombies:GetChildren()) do
                if zombie:FindFirstChild("ZombieESP") then
                    zombie.ZombieESP.TextLabel.TextColor3 = Color
                end
            end
        end,
    })

    -- Rainbow ESP Toggle
    CustomTab:CreateToggle({
        Name = "Enable Rainbow ESP",
        CurrentValue = false,
        Flag = "RainbowESP",
        Callback = function(Value)
            if Value then
                -- Apply rainbow color cycling
                spawn(function()
                    while Value do
                        for _, zombie in pairs(workspace.Zombies:GetChildren()) do
                            if zombie:FindFirstChild("ZombieESP") then
                                zombie.ZombieESP.TextLabel.TextColor3 = rainbowColor(5) -- Speed can be adjusted
                            end
                        end
                        wait(0.1)
                    end
                end)
            end
        end,
    })

    -- Rainbow Auto-Aim Indicator
    CustomTab:CreateToggle({
        Name = "Enable Rainbow Auto-Aim Indicator",
        CurrentValue = false,
        Flag = "RainbowAimbot",
        Callback = function(Value)
            if Value then
                -- Apply rainbow color cycling to aimbot indicator (example: HUD indicator)
                spawn(function()
                    while Value do
                        -- Assuming there's an indicator to change color
                        local aimbotIndicator = game.Players.LocalPlayer.PlayerGui:FindFirstChild("AimbotIndicator")
                        if aimbotIndicator then
                            aimbotIndicator.TextColor3 = rainbowColor(5)
                        end
                        wait(0.1)
                    end
                end)
            end
        end,
    })

    -- Rainbow GUI Theme Toggle
    CustomTab:CreateToggle({
        Name = "Enable Rainbow GUI Theme",
        CurrentValue = false,
        Flag = "RainbowGUI",
        Callback = function(Value)
            if Value then
                -- Apply rainbow color cycling to the entire GUI theme
                spawn(function()
                    while Value do
                        local hue = tick() % 10 / 10
                        local rainbow = Color3.fromHSV(hue, 1, 1)
                        Rayfield:SetTheme({
                            Background = rainbow,
                            TextColor = Color3.new(1, 1, 1), -- White text
                            Accent = rainbow,
                            TextStroke = Color3.new(0, 0, 0) -- Black text stroke
                        })
                        wait(0.1)
                    end
                end)
            end
        end,
    })

    -- Load Configuration
    Rayfield:LoadConfiguration()

end)

-- Handle errors
if not success then
    warn("An error occurred while running Moon-Zen V4: " .. tostring(err))
end
