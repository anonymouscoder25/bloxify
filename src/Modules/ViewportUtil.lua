local main = {}

main.__index = main

function main.new(viewport)
    local self = setmetatable({},main)
    self.viewport = viewport
    self.camera = Instance.new("Camera")
    self.camera.Parent = viewport
    viewport.CurrentCamera =  self.camera
    return self
end

function main:update(targetObject)
    if targetObject:IsA("Model") and targetObject:FindFirstChild("Head") then
        self:clear()
        local newObject = targetObject:Clone()
        newObject.Parent = self.viewport
        local pivot = newObject:GetPivot() :: CFrame
        local pos = pivot.Position
        self.camera.CFrame = CFrame.lookAt(pos + Vector3.new(0,5,8),newObject:FindFirstChild("Head").Position)
    end
end

function main:clear() --//clears the viewport
    for _,comp in ipairs(self.viewport:GetChildren()) do
        if not comp:IsA("Camera") then
            comp:Destroy()
        end
    end
end

return main