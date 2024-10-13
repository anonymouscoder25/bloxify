
local function clear(object)
	for _,child in ipairs(object:GetChildren()) do
		child:Destroy()
	end
end


local function calculateM6D(originRig,child)
	if child:IsA("Motor6D") then
		child.Part0 = child.Parent
		if child.Name == "Left Hip" then --//May be different due to names.
			child.Part1 = originRig:FindFirstChild("Left Leg")
		elseif child.Name == "Left Shoulder" then
			child.Part1 = originRig:FindFirstChild("Left Arm")
		elseif child.Name == "Neck" then
			child.Part1 = originRig:FindFirstChild("Head")
		elseif child.Name == "Right Hip" then
			child.Part1 = originRig:FindFirstChild("Right Leg")
		elseif child.Name == "Right Shoulder" then
			child.Part1 = originRig:FindFirstChild("Right Arm")
		elseif child.Name == "RootJoint" then
			child.Part1 = originRig:FindFirstChild("Torso")
		end
	end
end

local function createLigament(targetComp,originComp)
	
	--//comp1 = target, comp2 = zombie
	
	clear(originComp) --//destroy any 
	originComp.CFrame = targetComp.CFrame	
	
	for _,child in ipairs(targetComp:GetChildren()) do
		
		--//copy over to origin_rig
		local newComp = child:Clone()
		newComp.Parent = originComp
		
		calculateM6D(originComp.Parent,newComp)
	end

	targetComp:Destroy()
end


return function(originRig,targetRig)

if not originRig:IsA("Model") or not targetRig:IsA("Model") then
    warn("Only select rigs: origin first, target second(github for more info)")
    return
end

if not originRig:FindFirstChild("HumanoidRootPart") then
	local torso = originRig:FindFirstChild("Torso")
	local part = Instance.new("Part")
	part.Name = "HumanoidRootPart"
	part.Size = torso.Size
	part.Transparency = 1
	part.CanCollide = false
    part.Anchored = false
	part.CFrame = torso.CFrame --//the torso might be flipped, make manual adjustments
	part.Parent = originRig
end

originRig.PrimaryPart = originRig:FindFirstChild(targetRig.PrimaryPart.Name)

for _,targetComp in ipairs(targetRig:GetChildren()) do
	if not targetComp:IsA("BasePart") then continue end
	for _,originComp in ipairs(originRig:GetChildren()) do
		if not originComp:IsA("BasePart") then continue end
		if originComp.Name == targetComp.Name then
			createLigament(targetComp,originComp)
		end
	end
end
targetRig:Destroy()

end