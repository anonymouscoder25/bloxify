local Selection = game:GetService("Selection")

local toolbar = plugin:CreateToolbar("Bloxify")
local button = toolbar:CreateButton("Bloxify","Add the default roblox bones/attachments to your custom roblox rigs.","rbxassetid://109464777186243")

local projectFolder = script.Parent

local rig = require(projectFolder.Modules.Rig)
local viewportUtil = require(projectFolder.Modules.ViewportUtil)

local coreGui = game:WaitForChild("CoreGui")
local pluginGui = projectFolder:WaitForChild("MainGui") --//PUT GUI HERE

local confirmButton = pluginGui.Backdrop.ConfirmButton
local viewports = pluginGui.Backdrop.Viewports

--[[how selection should be structured
[1] = origin
[2] = target
]]

local viewportTable = {}

for _,viewport in ipairs(viewports:GetChildren()) do
	if not viewport:IsA("ViewportFrame") then continue end
	table.insert(viewportTable,viewportUtil.new(viewport))
end

local function clearViewports()
	for _,class in ipairs(viewportTable) do
		class:clear()
	end
end

button.Click:Connect(function()
	if pluginGui.Parent == projectFolder then
		pluginGui.Parent = coreGui
	elseif pluginGui.Parent == coreGui then
		pluginGui.Parent = projectFolder
	end
end)

confirmButton.MouseButton1Click:Connect(function()
	local selection = Selection:Get()
	rig(selection[1],selection[2])
	clearViewports()
end)

Selection.SelectionChanged:Connect(function()
	local selected = Selection:Get()
	local selectIndex = #selected
	if #selected > 2 then return end
	if #selected == 0 then
		clearViewports()
		return
	end
	local newSelect = selected[selectIndex]
	if viewportTable[selectIndex] then viewportTable[selectIndex]:update(newSelect) end
end)