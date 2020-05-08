-- @module RobloxUtility.lua
--[[
	Made by ItzEthanPlayz_YT
	
	V1.0D
	
	Supports Documentation Reader.
	
	Get it here:
	https://web.roblox.com/library/4964306811/RELEASE-RobloxUtility
	
	module.CreateInstance(InstanceType, Name, Parent, TableProperty)
	To create a instance.
	InstanceType = The instance class to be made (example: "Folder", "Tool") [CASE-SENSITIVE] [REQUIRED]
	Name = The instance name.
	Parent = The instance parent
	TableProperty = A table containing list of the instance property and it's value, if the property is Parent, it will be skipped. (Example: BrickColor = BrickColor.red())
	Returns the instance.
	
	module:DisconnectConnectionSignal(connection)
	To disconnect a RBXScriptConnection.
	connection = The RBXScriptConnection to be disconnected. [REQUIRED]
	Returns nil.
	
	module:GetBasePartMass(part)
	To get a mass of BasePart/UnionOperation, you can actually achieve this using BasePart:GetMass() or UnionOperation:GetMass().
	part, The BasePart/UnionOperation (Note: Part is the same as BasePart). [REQUIRED]
	Returns The mass in number.
	
	module:GetTotalMassOfParts(a)
	The same as :GetBasePartMass(part) except, this accepts more than 1 part, how it works is that it gets the mass of the part and add it to a variable that will be returned one by one.
	a, Accepts anything that contains a BasePart/UnionOperation, accepts a table of array with list of BasePart/UnionOperation (Note if using tables: CANNOT BE PART NAME, MUST BE A PATH TO PART!!). [REQUIRED]
	Returns The mass in number.
	
	module:HexToColor3(Hex)
	Hex to Color3 converter.
	Hex, The Hex code to be converted to Color3. [REQUIRED]
	Returns The Color3 of the Hex.
	
	module:Color3ToHex(C3)
	Color3 to Hex converter.
	C3, The Color3 to be converted to Hex. [REQUIRED]
	Returns The Hex of the Color3.
--]]

local module = {}

--[[**
	To create a instance.
	
	@param [t:class] InstanceType The instance class to be made (example: "Folder", "Tool") [CASE-SENSITIVE] [REQUIRED]
	
	@param [t:string] Name The instance name.
	
	@param [t:instance] Parent The instance parent.
	
	@returns The Instance.
**--]]
module.CreateInstance = function(InstanceType, Name, Parent, TableProperty)
	local sucess, newobj = pcall(function()
		if InstanceType then
			local object = Instance.new(InstanceType)
			
			if Name then
				object.Name = Name
			end
			
			
		-- TableProperty
			for property, PropertyValue in pairs(TableProperty) do
				-- Check if it isn't parent.
				if TableProperty ~= Parent then
					object[property] = PropertyValue
				end
			end
			
			if Parent then
				object.Parent = Parent
			end
			
			return object
		else
			return "InstanceType is undefined."
		end
	end)
	
	if sucess then
		return newobj
	else
		warn("[RobloxUtility.CreateInstance]: Error. ("..newobj..")")
	end
end

--[[**
	To disconnect a RBXScriptConnection.
	
	@param [t:RBXScriptConnection] connection The connection to be disconnected. [REQUIRED]

	@returns nil.
**--]]
function module:DisconnectConnectionSignal(connection)
	if connection then
		connection:Disconnect()
	end
	return nil
end

--[[**
	To get a mass of BasePart/UnionOperation, you can actually achieve this using BasePart:GetMass() or UnionOperation:GetMass().
	
	@param [t:BasePart/UnionOperation] part, The BasePart/UnionOperation (Note: Part is the same as BasePart). [REQUIRED]

	@returns The mass in number.
**--]]
function module:GetBasePartMass(part)
	if part then
		return part:GetMass()
	else
		warn("[RobloxUtility.GetBasePartMass]: Error. No BasePart/UnionOperation was given.")
		return nil
	end
end

--[[**
	The same as :GetBasePartMass(part) except, this accepts more than 1 part, how it works is that it gets the mass of the part and add it to a variable that will be returned one by one.
	
	@param [t:Model/Folder/AnythingContainsBasePartsOrUnionOperation/Table] a, Accepts anything that contains a BasePart/UnionOperation, accepts a table of array with list of BasePart/UnionOperation (Note if using tables: CANNOT BE PART NAME, MUST BE A PATH TO PART!!). [REQUIRED]

	@returns The mass in number.
**--]]
function GetTotalMassOfParts(a)
	local totalmass = 0
	if type(a) == "table" then
		for _, pt in pairs(a) do
			totalmass = totalmass + pt:GetMass()
		end
		return totalmass
	else
		for _, pb in pairs(a:GetDescendants()) do
			if pb:IsA("BasePart") or pb:IsA("UnionOperation") then
				totalmass = totalmass + pb:GetMass()
			end
		end
		return totalmass
	end
end

-- Color conversion stuff.
local floor = math.floor

module.HexCharsList = {
	0,
	1,
	2,
	3,
	4,
	5,
	6,
	7,
	8,
	9,
	"A",
	"B",
	"C",
	"D",
	"E",
	"F"
}

function CharToNum(Char) Char = string.upper(Char)
	for Index, Value in ipairs(module.HexCharsList) do
		if tostring(Value) == Char then
			return Index-1
		end
	end
end

function NumToChar(Num)
	return module.HexCharsList[Num+1]
end

--[[**
	Hex to Color3 converter.
	
	@param [t:string] Hex, The Hex code to be converted to Color3. [REQUIRED]

	@returns The Color3 of the Hex.
**--]]
function module:HexToColor3(Hex)
	Hex = tostring(Hex)
	
	local R, G, B
	
	if (#Hex ~= 6) then
		if (#Hex ~= 7) and string.gsub(Hex, 1, 1) ~= "#" then
			error("Invalid HEX length")
		else
			Hex = string.sub(Hex, 2, #Hex)
		end
	end
	
	for L = 1, 5, 2 do
		local Maj = CharToNum(string.sub(Hex, L, L))
		local Min = CharToNum(string.sub(Hex, L+1, L+1))
		
		local Val = Maj*16+Min
		
		if L == 1 then R = Val end
		if L == 3 then G = Val end
		if L == 5 then B = Val end
	end
	
	return Color3.fromRGB(R, G, B)
end

--[[**
	Color3 to Hex converter.
	
	@param [t:Color3] C3, The Color3 to be converted to Hex. [REQUIRED]

	@returns The Hex of the Color3.
**--]]
function module:Color3ToHex(C3)
	local R = floor(C3.R*255)
	local G = floor(C3.G*255)
	local B = floor(C3.B*255)
	
	local Hex = ""
	
	local function VF(Num)
		Num = floor(Num)
		
		local Div = Num/16
		local Maj = floor(Div)
		local Min = (Div-Maj)*16
		
		Hex = Hex .. NumToChar(Maj) .. NumToChar(Min)
	end
	
	VF(R) VF(G) VF(B)
	
	return Hex
end

return module
