-- Переменные
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local TeachersFolder = workspace:FindFirstChild("Teachers")
local AlicesFolder = workspace:FindFirstChild("Alices")
local StudentsFolder = workspace:FindFirstChild("Students")
local RunService = game:GetService("RunService")
local Camera = game.Workspace.Camera

-- Переменные для ESP
local espTeachersEnabled = true
local espAlicesEnabled = true
local espStudentsEnabled = true

-- Таблицы для хранения Drawing объектов и Highlight
local teacherDrawings = {}
local aliceDrawings = {}
local studentDrawings = {}
local highlights = {} -- Таблица для хранения Highlight объектов

-- Функция для создания Drawing объектов
local function createDrawing(type, properties)
    local drawing = Drawing.new(type)
    for property, value in pairs(properties) do
        drawing[property] = value
    end
    return drawing
end

-- Функция для расчета расстояния до объекта
local function getDistanceFromPlayer(targetPosition)
    local playerPosition = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character.HumanoidRootPart.Position
    if playerPosition then
        return math.floor((targetPosition - playerPosition).Magnitude)
    end
    return 0
end

-- Функция для создания Highlight
local function createHighlight(object, color)
    local highlight = Instance.new("Highlight")
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.Parent = object
    highlights[object] = highlight
end

-- Функция для обновления ESP
local function updateESP()
    -- Очищаем старые Drawing объекты
    for _, drawings in pairs(teacherDrawings) do
        for _, drawing in pairs(drawings) do
            drawing.Visible = false
            drawing:Remove()
        end
    end
    for _, drawings in pairs(aliceDrawings) do
        for _, drawing in pairs(drawings) do
            drawing.Visible = false
            drawing:Remove()
        end
    end
    for _, drawings in pairs(studentDrawings) do
        for _, drawing in pairs(drawings) do
            drawing.Visible = false
            drawing:Remove()
        end
    end
    teacherDrawings = {}
    aliceDrawings = {}
    studentDrawings = {}

    -- Обрабатываем Teachers
    if espTeachersEnabled and TeachersFolder then
        for _, teacher in pairs(TeachersFolder:GetChildren()) do
            local rootPart = teacher:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local position, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                if onScreen then
                    local drawings = {}

                    -- Квадрат (рамка)
                    local topLeft = Camera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(-2, 3, 0)).Position)
                    local bottomRight = Camera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(2, -3, 0)).Position)
                    local width = bottomRight.X - topLeft.X
                    local height = bottomRight.Y - topLeft.Y

                    local box = createDrawing("Square", {
                        Visible = true,
                        Thickness = 1,
                        Color = Color3.new(1, 0, 0), -- Красный цвет для Teachers
                        Size = Vector2.new(width, height),
                        Position = Vector2.new(topLeft.X, topLeft.Y),
                        Filled = false
                    })
                    table.insert(drawings, box)

                    -- Никнейм (название объекта) и расстояние
                    local distance = getDistanceFromPlayer(rootPart.Position)
                    local name = createDrawing("Text", {
                        Visible = true,
                        Text = teacher.Name .. " (" .. distance .. "m)",
                        Color = Color3.new(1, 1, 1), -- Белый цвет текста
                        Size = 18,
                        Outline = true,
                        Position = Vector2.new(topLeft.X + width / 2, topLeft.Y - 20),
                        Center = true
                    })
                    table.insert(drawings, name)

                    -- Линия от игрока к учителю
                    local line = createDrawing("Line", {
                        Visible = true,
                        Thickness = 1,
                        Color = Color3.new(1, 0, 0), -- Красный цвет линии
                        From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2),
                        To = Vector2.new(position.X, position.Y)
                    })
                    table.insert(drawings, line)

                    teacherDrawings[teacher] = drawings

                    -- Добавляем Highlight
                    if not highlights[teacher] then
                        createHighlight(teacher, Color3.new(1, 0, 0)) -- Красный Highlight для Teachers
                    end
                end
            end
        end
    end

    -- Обрабатываем Alices
    if espAlicesEnabled and AlicesFolder then
        for _, alice in pairs(AlicesFolder:GetChildren()) do
            local rootPart = alice:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local position, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                if onScreen then
                    local drawings = {}

                    -- Квадрат (рамка)
                    local topLeft = Camera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(-2, 3, 0)).Position)
                    local bottomRight = Camera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(2, -3, 0)).Position)
                    local width = bottomRight.X - topLeft.X
                    local height = bottomRight.Y - topLeft.Y

                    local box = createDrawing("Square", {
                        Visible = true,
                        Thickness = 1,
                        Color = Color3.new(0, 0, 1), -- Синий цвет для Alices
                        Size = Vector2.new(width, height),
                        Position = Vector2.new(topLeft.X, topLeft.Y),
                        Filled = false
                    })
                    table.insert(drawings, box)

                    -- Никнейм (название объекта) и расстояние
                    local distance = getDistanceFromPlayer(rootPart.Position)
                    local name = createDrawing("Text", {
                        Visible = true,
                        Text = alice.Name .. " (" .. distance .. "m)",
                        Color = Color3.new(1, 1, 1), -- Белый цвет текста
                        Size = 18,
                        Outline = true,
                        Position = Vector2.new(topLeft.X + width / 2, topLeft.Y - 20),
                        Center = true
                    })
                    table.insert(drawings, name)

                    -- Линия от игрока к Alice
                    local line = createDrawing("Line", {
                        Visible = true,
                        Thickness = 1,
                        Color = Color3.new(0, 0, 1), -- Синий цвет линии
                        From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2),
                        To = Vector2.new(position.X, position.Y)
                    })
                    table.insert(drawings, line)

                    aliceDrawings[alice] = drawings

                    -- Добавляем Highlight
                    if not highlights[alice] then
                        createHighlight(alice, Color3.new(0, 0, 1)) -- Синий Highlight для Alices
                    end
                end
            end
        end
    end

    -- Обрабатываем Students
    if espStudentsEnabled and StudentsFolder then
        for _, student in pairs(StudentsFolder:GetChildren()) do
            local rootPart = student:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local position, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                if onScreen then
                    local drawings = {}

                    -- Квадрат (рамка)
                    local topLeft = Camera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(-2, 3, 0)).Position)
                    local bottomRight = Camera:WorldToViewportPoint((rootPart.CFrame * CFrame.new(2, -3, 0)).Position)
                    local width = bottomRight.X - topLeft.X
                    local height = bottomRight.Y - topLeft.Y

                    local box = createDrawing("Square", {
                        Visible = true,
                        Thickness = 1,
                        Color = Color3.new(0, 1, 0), -- Зеленый цвет для Students
                        Size = Vector2.new(width, height),
                        Position = Vector2.new(topLeft.X, topLeft.Y),
                        Filled = false
                    })
                    table.insert(drawings, box)

                    -- Никнейм (название объекта) и расстояние
                    local distance = getDistanceFromPlayer(rootPart.Position)
                    local name = createDrawing("Text", {
                        Visible = true,
                        Text = student.Name .. " (" .. distance .. "m)",
                        Color = Color3.new(1, 1, 1), -- Белый цвет текста
                        Size = 18,
                        Outline = true,
                        Position = Vector2.new(topLeft.X + width / 2, topLeft.Y - 20),
                        Center = true
                    })
                    table.insert(drawings, name)

                    -- Линия от игрока к Student
                    local line = createDrawing("Line", {
                        Visible = true,
                        Thickness = 1,
                        Color = Color3.new(0, 1, 0), -- Зеленый цвет линии
                        From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2),
                        To = Vector2.new(position.X, position.Y)
                    })
                    table.insert(drawings, line)

                    studentDrawings[student] = drawings

                    -- Добавляем Highlight
                    if not highlights[student] then
                        createHighlight(student, Color3.new(0, 1, 0)) -- Зеленый Highlight для Students
                    end
                end
            end
        end
    end
end

-- Обрабатываем добавление новых объектов в папку Teachers
if TeachersFolder then
    TeachersFolder.ChildAdded:Connect(function(child)
        if espTeachersEnabled then
            updateESP()
        end
    end)

    TeachersFolder.ChildRemoved:Connect(function(child)
        if espTeachersEnabled then
            updateESP()
        end
    end)
end

-- Обрабатываем добавление новых объектов в папку Alices
if AlicesFolder then
    AlicesFolder.ChildAdded:Connect(function(child)
        if espAlicesEnabled then
            updateESP()
        end
    end)

    AlicesFolder.ChildRemoved:Connect(function(child)
        if espAlicesEnabled then
            updateESP()
        end
    end)
end

-- Обрабатываем добавление новых объектов в папку Students
if StudentsFolder then
    StudentsFolder.ChildAdded:Connect(function(child)
        if espStudentsEnabled then
            updateESP()
        end
    end)

    StudentsFolder.ChildRemoved:Connect(function(child)
        if espStudentsEnabled then
            updateESP()
        end
    end)
end

-- Основной цикл для обновления ESP
RunService.RenderStepped:Connect(function()
    if espTeachersEnabled or espAlicesEnabled or espStudentsEnabled then
        updateESP()
    end
end)