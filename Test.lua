local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Обновление ссылки на персонажа при респауне
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
end)

-- Конфигурация стиля
local Theme = {
    Background = Color3.fromRGB(0, 0, 0),
    Accent = Color3.fromRGB(255, 255, 255),
    Hover = Color3.fromRGB(30, 30, 30),
    Overlay = Color3.fromRGB(0, 0, 0)
}

-- Создание UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GoodGameG_Premium"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Затемнение фона
local Overlay = Instance.new("Frame")
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.BackgroundColor3 = Theme.Overlay
Overlay.BackgroundTransparency = 1
Overlay.BorderSizePixel = 0
Overlay.Parent = ScreenGui

-- Главная панель
local MainPanel = Instance.new("Frame")
MainPanel.Size = UDim2.new(0, 0, 0, 0)
MainPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
MainPanel.AnchorPoint = Vector2.new(0.5, 0.5)
MainPanel.BackgroundColor3 = Theme.Background
MainPanel.BorderSizePixel = 0
MainPanel.ClipsDescendants = true
MainPanel.Parent = Overlay

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainPanel

local Stroke = Instance.new("UIStroke")
Stroke.Color = Theme.Accent
Stroke.Thickness = 1
Stroke.Parent = MainPanel

-- Заголовок
local Header = Instance.new("TextLabel")
Header.Text = "goodgameg"
Header.TextColor3 = Theme.Accent
Header.Font = Enum.Font.GothamBold
Header.TextSize = 18
Header.Size = UDim2.new(0, 0, 0, 40)
Header.Position = UDim2.new(0, 15, 0, 10)
Header.BackgroundTransparency = 1
Header.TextXAlignment = Enum.TextXAlignment.Left
Header.Parent = MainPanel

-- Кнопка закрытия
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Theme.Accent
CloseBtn.TextSize = 24
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Parent = MainPanel

-- Контейнер для элементов
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -60)
Content.Position = UDim2.new(0, 10, 0, 50)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 2
Content.ScrollBarImageColor3 = Theme.Accent
Content.Parent = MainPanel

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 5)
Layout.Parent = Content

-- Функция создания кнопки
local function CreateButton(text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Text = "  " .. text
    Btn.TextColor3 = Theme.Accent
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 14
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.BackgroundColor3 = Theme.Background
    Btn.BackgroundTransparency = 1
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.BorderSizePixel = 0
    Btn.Parent = Content

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Btn

    local ActiveBar = Instance.new("Frame")
    ActiveBar.Size = UDim2.new(0, 3, 1, 0)
    ActiveBar.Position = UDim2.new(0, 0, 0, 0)
    ActiveBar.BackgroundColor3 = Theme.Accent
    ActiveBar.BorderSizePixel = 0
    ActiveBar.Visible = false
    ActiveBar.Parent = Btn

    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Hover}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Background}):Play()
    end)

    Btn.MouseButton1Click:Connect(function()
        ActiveBar.Visible = not ActiveBar.Visible
        callback()
    end)

    return Btn
end

--------------------------------------------------------------------------------
-- ТЕХНИЧЕСКИЙ ФУНКЦИОНАЛ
--------------------------------------------------------------------------------

local noclip = false
local flying = false
local flySpeed = 50
local espEnabled = false
local infJump = false

-- 1. Улучшенный Kill All (Humanoid + Custom Values + Void)
local function KillAll()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Humanoid") and v.Parent.Name ~= LocalPlayer.Name then
            v.Health = 0
        end
        if v:IsA("NumberValue") or v:IsA("IntValue") then
            if v.Name:lower():find("health") or v.Name:lower():find("hp") then
                v.Value = 0
            end
        end
        if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v.Name ~= LocalPlayer.Name then
            pcall(function()
                v.HumanoidRootPart.CFrame = CFrame.new(0, -1000, 0)
            end)
        end
    end
end

-- 2. Стабильный Fly (CFrame)
local function ToggleFly()
    flying = not flying
    task.spawn(function()
        while flying do
            local root = Character:FindFirstChild("HumanoidRootPart")
            if root then
                local moveDir = Vector3.new(0,0,0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + workspace.CurrentCamera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - workspace.CurrentCamera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - workspace.CurrentCamera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + workspace.CurrentCamera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0,1,0) end
                
                root.Velocity = Vector3.new(0,0,0)
                root.CFrame = root.CFrame + (moveDir * (flySpeed/10))
            end
            task.wait()
        end
    end)
end

-- 3. Max Health & God Mode
local function SetMaxHealth()
    if Character:FindFirstChild("Humanoid") then
        Character.Humanoid.MaxHealth = 999999
        Character.Humanoid.Health = 999999
    end
    for _, v in pairs(LocalPlayer:GetDescendants()) do
        if v:IsA("NumberValue") or v:IsA("IntValue") then
            if v.Name:lower():find("health") or v.Name:lower():find("hp") then
                v.Value = 999999
            end
        end
    end
    pcall(function()
        Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end)
end

-- 4. ESP (Подсветка NPC)
local function ToggleESP()
    espEnabled = not espEnabled
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Highlight") and v.Name == "GGE_ESP" then v:Destroy() end
    end
    if espEnabled then
        task.spawn(function()
            while espEnabled do
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Name ~= LocalPlayer.Name then
                        if not v:FindFirstChild("GGE_ESP") then
                            local hl = Instance.new("Highlight")
                            hl.Name = "GGE_ESP"
                            hl.FillColor = Color3.fromRGB(255, 255, 255)
                            hl.OutlineColor = Color3.fromRGB(0, 0, 0)
                            hl.FillTransparency = 0.5
                            hl.Parent = v
                        end
                    end
                end
                task.wait(2)
            end
        end)
    end
end

-- 5. Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if infJump then
        Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Цикл Noclip
RunService.Stepped:Connect(function()
    if noclip then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

--------------------------------------------------------------------------------
-- НАПОЛНЕНИЕ МЕНЮ
--------------------------------------------------------------------------------

CreateButton("Max Health (God)", SetMaxHealth)
CreateButton("Toggle Fly", ToggleFly)
CreateButton("Toggle Noclip", function() noclip = not noclip end)
CreateButton("Kill All NPCs/Bosses", KillAll)
CreateButton("Toggle ESP (Highlights)", ToggleESP)
CreateButton("Infinite Jump", function() infJump = not infJump end)
CreateButton("Speed Boost (x2)", function()
    Character.Humanoid.WalkSpeed = 32
end)
CreateButton("Reset Speed", function()
    Character.Humanoid.WalkSpeed = 16
end)

-- АНИМАЦИЯ ОТКРЫТИЯ
local function OpenMenu()
    Overlay.BackgroundTransparency = 1
    MainPanel.Size = UDim2.new(0, 0, 0, 0)
    MainPanel.BackgroundTransparency = 1
    
    TweenService:Create(Overlay, TweenInfo.new(0.5), {BackgroundTransparency = 0.5}):Play()
    TweenService:Create(MainPanel, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 320, 0, 420),
        BackgroundTransparency = 0
    }):Play()
end

CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(Overlay, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    TweenService:Create(MainPanel, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
end)

OpenMenu()
