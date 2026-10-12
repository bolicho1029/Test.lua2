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
    Inactive = Color3.fromRGB(30, 30, 30),
    Hover = Color3.fromRGB(50, 50, 50),
    Overlay = Color3.fromRGB(0, 0, 0)
}

-- Создание UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GoodGameG_Nuclear"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Overlay = Instance.new("Frame")
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.BackgroundColor3 = Theme.Overlay
Overlay.BackgroundTransparency = 1
Overlay.BorderSizePixel = 0
Overlay.Parent = ScreenGui

local MainPanel = Instance.new("Frame")
MainPanel.Size = UDim2.new(0, 400, 0, 350)
MainPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
MainPanel.AnchorPoint = Vector2.new(0.5, 0.5)
MainPanel.BackgroundColor3 = Theme.Background
MainPanel.BorderSizePixel = 0
MainPanel.Visible = false
MainPanel.Parent = Overlay

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 15)
Corner.Parent = MainPanel

local Stroke = Instance.new("UIStroke")
Stroke.Color = Theme.Accent
Stroke.Thickness = 1.5
Stroke.Parent = MainPanel

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 40, 0, 40)
OpenBtn.Position = UDim2.new(0, 20, 1, -60)
OpenBtn.BackgroundColor3 = Theme.Accent
OpenBtn.Text = ""
OpenBtn.Visible = false
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 8)

local Header = Instance.new("TextLabel")
Header.Text = "goodgameg | NUCLEAR EDITION"
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

local Pages = {}
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
    for pageName, page in pairs(Pages) do page.Visible = (pageName == name) end
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
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn.MouseButton1Click:Connect(function() SwitchTab(pageName) end)
end

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
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.Text = "  " .. text .. (state and " [ON]" or " [OFF]")
        Btn.BackgroundColor3 = state and Theme.Accent or Theme.Inactive
        Btn.TextColor3 = state and Color3.fromRGB(0,0,0) or Theme.Accent
        callback(state)
    end)
end

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
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn.MouseButton1Click:Connect(callback)
end

--------------------------------------------------------------------------------
-- ЯДЕРНАЯ ЛОГИКА (NUCLEAR)
--------------------------------------------------------------------------------

local noclip = false
local flying = false
local flySpeed = 70
local infJump = false

-- 1. NUCLEAR KILL ALL
local function NuclearKill()
    local remotes = {}
    -- Собираем вообще все RemoteEvents в игре
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then table.insert(remotes, v) end
    end

    for _, v in pairs(workspace:GetDescendants()) do
        if v == Character or v:IsDescendantOf(Character) then continue end
        
        local isEnemy = v.Name:lower():find("zombie") or v.Name:lower():find("npc") or v.Name:lower():find("boss")
        
        if isEnemy and v:IsA("Model") then
            local hum = v:FindFirstChildOfClass("Humanoid")
            local root = v:FindFirstChild("HumanoidRootPart")

            -- А) Попытка через Remote Storm (перебор всех ивентов)
            for _, remote in pairs(remotes) do
                pcall(function()
                    remote:FireServer(hum, 999999)
                    remote:FireServer(v, 999999)
                    remote:FireServer("Damage", hum, 999999)
                end)
            end

            -- Б) Попытка Touch-Kill (мгновенный телепорт к NPC и обратно)
            if root then
                pcall(function()
                    local oldPos = Character.HumanoidRootPart.CFrame
                    Character.HumanoidRootPart.CFrame = root.CFrame
                    task.wait(0.05)
                    Character.HumanoidRootPart.CFrame = oldPos
                end)
            end

            -- В) Удаление хедера (на всякий случай)
            for _, child in pairs(v:GetChildren()) do
                if child.Name:lower():find("header") or child.Name:lower():find("head") then
                    pcall(function() child:Destroy() end)
                end
            end
        end
    end
end

-- 2. CFrame Fly
local function ToggleFly(state)
    flying = state
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
                root.CFrame = root.CFrame + (moveDir * (flySpeed/20))
            end
            RunService.Heartbeat:Wait()
        end
    end)
end

-- 3. Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if infJump then
        local hum = Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- 4. Noclip
RunService.Stepped:Connect(function()
    if noclip then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- 5. Remote Scanner (Выводит всё в консоль F9)
local function ScanRemotes()
    print("--- GGE REMOTE SCAN START ---")
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            print("RemoteEvent found: " .. v.Name .. " | Path: " .. v:GetFullName())
        end
    end
    print("--- GGE REMOTE SCAN END ---")
end

--------------------------------------------------------------------------------
-- СБОРКА МЕНЮ
--------------------------------------------------------------------------------

local PlayerPage = CreatePage("Player")
local CombatPage = CreatePage("Combat")
local VisualPage = CreatePage("Visuals")

CreateTabButton("Игрок", "Player")
CreateTabButton("Бой", "Combat")
CreateTabButton("Визуал", "Visuals")

CreateToggle("Полет (CFrame Fly)", PlayerPage, ToggleFly)
CreateToggle("Ноуклип (Noclip)", PlayerPage, function(s) noclip = s end)
CreateToggle("Бесконечный прыжок", PlayerPage, function(s) infJump = s end)
CreateAction("Макс Здоровье", PlayerPage, function()
    if Character:FindFirstChild("Humanoid") then
        Character.Humanoid.MaxHealth = 999999
        Character.Humanoid.Health = 999999
    end
end)
CreateAction("Скорость x2", PlayerPage, function() Character.Humanoid.WalkSpeed = 32 end)
CreateAction("Сброс скорости", PlayerPage, function() Character.Humanoid.WalkSpeed = 16 end)

CreateAction("ЯДЕРНЫЙ KILL ALL", CombatPage, NuclearKill)
CreateAction("Сканировать Remote (F9)", CombatPage, ScanRemotes)

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
            for _, v in pairs(workspace:GetDescendants()) do if v.Name == "GGE_ESP" then v:Destroy() end end
        end)
    end
end)

local function OpenMenu()
    Overlay.BackgroundTransparency = 0.5
    MainPanel.Visible = true
    OpenBtn.Visible = false
    SwitchTab("Player")
    TweenService:Create(MainPanel, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 400, 0, 350)}):Play()
end

local function CloseMenu()
    TweenService:Create(Overlay, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    TweenService:Create(MainPanel, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.3)
    MainPanel.Visible = false
    OpenBtn.Visible = true
end

CloseBtn.MouseButton1Click:Connect(CloseMenu)
OpenBtn.MouseButton1Click:Connect(OpenMenu)

OpenMenu()
