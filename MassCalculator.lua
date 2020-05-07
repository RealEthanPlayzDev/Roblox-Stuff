--[[
	Mass calculator by ItzEthanPlayz_YT, put under Model/Folder/Anything that contains Union/BasePart children/BasePart or Union.
	Open sourced, also used in RbxUtility by ItzEthanPlayz_YT
  Also available as a model that you can take at Roblox:
  https://web.roblox.com/library/4997026712/MassCalculator
--]]

local totalmass = 0
local object = script.Parent
if not object:IsA("BasePart") or not object:IsA("UnionOperation") then
	for i, v in pairs(script.Parent:GetDescendants()) do
		if v:IsA("BasePart") or v:IsA("UnionOperation") then
			totalmass = totalmass + v:GetMass()
		end
	end
else
	totalmass = object:GetMass()
end
print("Total mass: "..totalmass)
