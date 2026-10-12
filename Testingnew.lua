local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

LocalPlayer.CharacterAdded:Connect(function(char) Character = char end)

-- Конфигурация стиля
local Theme = {
    Background = Color3.fromRGB(0, 0, 0),
    Accent = Color3.fromRGB(255, 255, 255),
    Inactive = Color3.fromRGB(40, 40, 40),
    Hover = Color3.fromRGB(60, 60, 60),
    Overlay = Color3.fromRGB(0, 0, 0)
}

-- Создание UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GoodGameG_V2"
ScreenGui.Parent = game.CoreGui

local Overlay = Instance.new("Frame")
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.BackgroundColor3 = Theme.Overlay
Overlay.BackgroundTransparency = 1
Overlay.BorderSizePixel = 0
Overlay.Parent = ScreenGui

local MainPanel = Instance.new("Frame")
MainPanel.Size = UDim2.new(0, 0, 0, 0)
MainPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
MainPanel.AnchorPoint = Vector2.new(0.5, 0.5)
MainPanel.BackgroundColor3 = Theme.Background
MainPanel.BorderSizePixel = 0
MainPanel.Parent = Overlay

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 15)
Corner.Parent = MainPanel

local Stroke = Instance.new("UIStroke")
Stroke.Color = Theme.Accent
Stroke.Thickness = 1.5
Stroke.Parent = MainPanel

-- Заголовок
local Header = Instance.new("TextLabel")
Header.Text = "goodgameg | Premium"
Header.TextColor3 = Theme.Accent
Header.Font = Enum.Font.GothamBold
Header.TextSize = 16
Header.Size = UDim2.new(0, 0, 0, 40)
Header.Position = UDim2.new(0, 15, 0, 10)
Header.BackgroundTransparency = 1
Header.TextXAlignment = Enum.TextXAlignment.Left
Header.Parent = MainPanel

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Theme.Accent
CloseBtn.TextSize = 24
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Parent = MainPanel

-- Система вкладок (Tabs)
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(0, 100, 1, -60)
TabContainer.Position = UDim2.new(0, 10, 0, 50)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainPanel

local TabLayout = Instance.new("UIListLayout")
TabLayout.Padding = UDim.new(0, 5)
TabLayout.Parent = TabContainer

local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -120, 1, -60)
PageContainer.Position = UDim2.new(0, 120, 0, 50)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = MainPanel

-- Функционал переключения страниц
local Pages = {}
local currentTab = ""

local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = name
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 0
    Page.Visible = false
    Page.Parent = PageContainer
    
    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 5)
    Layout.Parent = Page
    
    Pages[name] = Page
    return Page
end

local function SwitchTab(name)
    currentTab = name
    for pageName, page in pairs(Pages) do
        page.Visible = (pageName == name)
    end
end

local function CreateTabButton(name, pageName)
    local Btn = Instance.new("TextButton")
    Btn.Text = name
    Btn.Size = UDim2.new(1, 0, 0, 30)
    Btn.BackgroundColor3 = Theme.Inactive
    Btn.TextColor3 = Theme.Accent
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 12
    Btn.Parent = TabContainer
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Btn
    
    Btn.MouseButton1Click:Connect(function()
        SwitchTab(pageName)
    end)
end

-- Функция создания кнопки-переключателя (Toggle)
local function CreateToggle(text, page, callback)
    local state = false
    local Btn = Instance.new("TextButton")
    Btn.Text = "  " .. text .. " [OFF]"
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.BackgroundColor3 = Theme.Inactive
    Btn.TextColor3 = Theme.Accent
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 14
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = page

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.Text = "  " .. text .. (state and " [ON]" or " [OFF]")
        Btn.BackgroundColor3 = state and Theme.Accent or Theme.Inactive
        if state then Btn.TextColor3 = Color3.fromRGB(0,0,0) else Btn.TextColor3 = Theme.Accent end
        callback(state)
    end)
end

-- Функция создания обычной кнопки (Action)
local function CreateAction(text, page, callback)
    local Btn = Instance.new("TextButton")
    Btn.Text = "  " .. text
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.BackgroundColor3 = Theme.Inactive
    Btn.TextColor3 = Theme.Accent
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 14
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = page

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Btn

    Btn.MouseButton1Click:Connect(callback)
end

--------------------------------------------------------------------------------
-- ЛОГИКА ЧИТОВ
--------------------------------------------------------------------------------

local noclip = false
local flying = false
local flySpeed = 50
local infJump = false

-- 1. Kill All (Zombie + Humanoid + Model Search)
local function KillAll()
    for _, v in pairs(workspace:GetDescendants()) do
        -- Поиск по именам "Zombie", "NPC", "Enemy"
        local isZombie = v.Name:lower():find("zombie") or v.Name:lower():find("npc") or v.Name:lower():find("boss")
        
        if v:IsA("Humanoid") then
            v.Health = 0
        end
        
        if isZombie and v:IsA("Model") then
            -- Попытка убить через Humanoid внутри модели
            local hum = v:FindFirstChildOfClass("Humanoid")
            if hum then hum.Health = 0 end
            
            -- Попытка физического удаления (если есть сетевой доступ)
            pcall(function()
                local root = v:FindFirstChild("HumanoidRootPart")
                if root then root.CFrame = CFrame.new(0, -1000, 0) end
            end)
        end
        
        if v:IsA("NumberValue") or v:IsA("IntValue") then
            if v.Name:lower():find("health") or v.Name:lower():find("hp") then
                v.Value = 0
            end
        end
    end
end

-- 2. Fly (BodyVelocity + Gyro)
local bv, bg
local function ToggleFly(state)
    flying = state
    if flying then
        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        bv.Velocity = Vector3.new(0,0,0)
        bv.Parent = Character.HumanoidRootPart
        
        bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
        bg.CFrame = Character.HumanoidRootPart.CFrame
        bg.Parent = Character.HumanoidRootPart
        
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
                    
                    bv.Velocity = moveDir * flySpeed
                    bg.CFrame = workspace.CurrentCamera.CFrame
                end
                task.wait()
            end
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end)
    end
end

-- 3. God Mode / Max Health
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
end

-- 4. Noclip Loop
RunService.Stepped:Connect(function()
    if noclip then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- 5. Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if infJump then
        Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

--------------------------------------------------------------------------------
-- СОЗДАНИЕ СТРУКТУРЫ МЕНЮ
--------------------------------------------------------------------------------

local PlayerPage = CreatePage("Player")
local CombatPage = CreatePage("Combat")
local VisualPage = CreatePage("Visuals")

CreateTabButton("Игрок", "Player")
CreateTabButton("Бой", "Combat")
CreateTabButton("Визуал", "Visuals")

-- Наполнение: Игрок
CreateToggle("Полет (Fly)", PlayerPage, ToggleFly)
CreateToggle("Ноуклип (Noclip)", PlayerPage, function(s) noclip = s end)
CreateToggle("Бесконечный прыжок", PlayerPage, function(s) infJump = s end)
CreateAction("Макс Здоровье", PlayerPage, SetMaxHealth)
CreateAction("Скорость x2", PlayerPage, function() Character.Humanoid.WalkSpeed = 32 end)
CreateAction("Сброс скорости", PlayerPage, function() Character.Humanoid.WalkSpeed = 16 end)

-- Наполнение: Бой
CreateAction("УБИТЬ ВСЕХ (Zombies/NPC)", CombatPage, KillAll)

-- Наполнение: Визуал
CreateToggle("ESP (Подсветка)", VisualPage, function(state)
    if state then
        task.spawn(function()
            while state do
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Name ~= LocalPlayer.Name then
                        if not v:FindFirstChild("GGE_ESP") then
                            local hl = Instance.new("Highlight", v)
                            hl.Name = "GGE_ESP"
                            hl.FillColor = Color3.fromRGB(255,255,255)
                        end
                    end
                end
                task.wait(2)
            end
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name == "GGE_ESP" then v:Destroy() end
            end
        end)
    end
end)

-- Анимация открытия
local function OpenMenu()
    Overlay.BackgroundTransparency = 1
    MainPanel.Size = UDim2.new(0, 0, 0, 0)
    MainPanel.BackgroundTransparency = 1
    
    TweenService:Create(Overlay, TweenInfo.new(0.5), {BackgroundTransparency = 0.5}):Play()
    TweenService:Create(MainPanel, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 400, 0, 350),
        BackgroundTransparency = 0
    }):Play()
    SwitchTab("Player")
end

CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(Overlay, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    TweenService:Create(MainPanel, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
end)

OpenMenu()
