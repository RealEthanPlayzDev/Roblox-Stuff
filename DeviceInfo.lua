--[[
	File name: DeviceInfo.lua
	Author: ItzEthanPlayz_YT
	
	https://realethanplayzdev.github.io/Device%20Info/Device%20Info/
	
	V1.2
	
	Allows platform, screen size, input type, device type, and device orientation detection.
--]]

local module = {}

--// If not on client, errors (because this module only works on the client)
assert(not game:GetService("RunService"):IsServer(), "[DeviceInfo]: DeviceInfo can only be used to the server.")

--// Important services
local userInputService = game:GetService("UserInputService")
local guiService = game:GetService("GuiService")

--// Variables
local lastInputTypeWas
local lastResolutionWas
local lastOrientationWas
local lastGraphicQualityLevelWas

--// Event creation
local inputChanged = Instance.new("BindableEvent")
local resolutionChanged = Instance.new("BindableEvent")
local orientationChanged = Instance.new("BindableEvent")
local graphicsQualityChanged = Instance.new("BindableEvent")

--// Custom Enum creation
module.Enum = {
	PlatformType = {
		Computer = "PlatformType_Computer",
		Console = "PlatformType_Console",
		Mobile = "PlatformType_Mobile"
	},
	InputType = {
		Touchscreen = "InputType_Touchscreen",
		KeyboardMouse = "InputType_KeyboardMouse",
		Gamepad = "InputType_Gamepad",
		VR = "InputType_VR",
		Keyboard = "InputType_Keyboard",
		Mouse = "InputType_Mouse"
	},
	DeviceType = {
		Computer = "DeviceType_Computer",
		Phone = "DeviceType_Phone",
		Tablet = "DeviceType_Tablet",
		Console = "DeviceType_Console",
		TouchscreenComputer = "DeviceType_TouchscreenComputer"
	},
	DeviceOrientation = {
		Landscape = "DeviceOrientation_Landscape",
		Portrait = "DeviceOrientation_Portrait"
	},
	GraphicsQuality = {
		Automatic = "GraphicsQuality_Automatic",
		Level01 = "GraphicsQuality_Level01",
		Level02 = "GraphicsQuality_Level02",
		Level03 = "GraphicsQuality_Level03",
		Level04 = "GraphicsQuality_Level04",
		Level05 = "GraphicsQuality_Level05",
		Level06 = "GraphicsQuality_Level06",
		Level07 = "GraphicsQuality_Level07",
		Level08 = "GraphicsQuality_Level08",
		Level09 = "GraphicsQuality_Level09",
		Level10 = "GraphicsQuality_Level10",
		--[[
		Level11 = "GraphicsQuality_Level11",
		Level12 = "GraphicsQuality_Level12",
		Level13 = "GraphicsQuality_Level13",
		Level14 = "GraphicsQuality_Level14",
		Level15 = "GraphicsQuality_Level15",
		Level16 = "GraphicsQuality_Level16",
		Level17 = "GraphicsQuality_Level17",
		Level18 = "GraphicsQuality_Level18",
		Level19 = "GraphicsQuality_Level19",
		Level20 = "GraphicsQuality_Level20",
		Level21 = "GraphicsQuality_Level21"
		--]]
	}
}

--// Functions
function module.getDeviceScreenSize()
	lastResolutionWas = Vector2.new(game.Workspace.CurrentCamera.ViewportSize.X, game.Workspace.CurrentCamera.ViewportSize.Y)
	return Vector2.new(game.Workspace.CurrentCamera.ViewportSize.X, game.Workspace.CurrentCamera.ViewportSize.Y)
end

function module.getDevicePlatform()
	if guiService:IsTenFootInterface() and userInputService.GamepadEnabled and not userInputService.KeyboardEnabled and not userInputService.MouseEnabled then
		return module.Enum.PlatformType.Console
	elseif userInputService.TouchEnabled and not userInputService.KeyboardEnabled and not userInputService.MouseEnabled then
		return module.Enum.PlatformType.Mobile
	else
		return module.Enum.PlatformType.Computer
	end
end

function module.getInputType()
	if userInputService.KeyboardEnabled and userInputService.MouseEnabled and not userInputService.GamepadEnabled and not userInputService.TouchEnabled then
		lastInputTypeWas = module.Enum.InputType.KeyboardMouse
		return module.Enum.InputType.KeyboardMouse
	elseif userInputService.KeyboardEnabled and not userInputService.MouseEnabled and not userInputService.GamepadEnabled and not userInputService.TouchEnabled then
		lastInputTypeWas = module.Enum.InputType.Keyboard
		return module.Enum.InputType.Keyboard
	elseif not userInputService.KeyboardEnabled and userInputService.MouseEnabled and not userInputService.GamepadEnabled and not userInputService.TouchEnabled then
		lastInputTypeWas = module.Enum.InputType.Mouse
		return module.Enum.InputType.Mouse
	elseif not userInputService.KeyboardEnabled and not userInputService.MouseEnabled and userInputService.GamepadEnabled and not userInputService.TouchEnabled then
		lastInputTypeWas = module.Enum.InputType.Gamepad
		return module.Enum.InputType.Gamepad
	elseif userInputService.VREnabled then
		lastInputTypeWas = module.Enum.InputType.VR
		return module.Enum.InputType.VR
	else
		lastInputTypeWas = module.Enum.InputType.Touchscreen
		return module.Enum.InputType.Touchscreen
	end
end

function module.getDeviceOrientation()
	if module.getDevicePlatform() ~= module.Enum.PlatformType.Mobile then return end
	local isPortrait = game.Workspace.Camera.ViewportSize.X < game.Workspace.Camera.ViewportSize.Y
	if isPortrait then
		return module.Enum.DeviceOrientation.Portrait
	else
		return module.Enum.DeviceOrientation.Landscape
	end
end

function module.getDeviceType()
	if guiService:IsTenFootInterface() and userInputService.GamepadEnabled and not userInputService.KeyboardEnabled and not userInputService.MouseEnabled then
		return module.Enum.DeviceType.Console
	elseif not guiService:IsTenFootInterface() and userInputService.TouchEnabled and not userInputService.KeyboardEnabled and not userInputService.MouseEnabled then
		local deviceOrientation = module.getDeviceOrientation()
		if deviceOrientation == module.Enum.DeviceOrientation.Landscape then
			if game.Workspace.CurrentCamera.ViewportSize.Y < 600 then
				return module.Enum.DeviceType.Phone
			else
				return module.Enum.DeviceType.Tablet
			end
		elseif deviceOrientation ==  module.Enum.DeviceOrientation.Portrait then
			if game.Workspace.CurrentCamera.ViewportSize.X < 600 then
				return module.Enum.DeviceType.Phone
			else
				return module.Enum.DeviceType.Tablet
			end
		end
	elseif userInputService.TouchEnabled and userInputService.KeyboardEnabled and userInputService.MouseEnabled then
		return module.Enum.DeviceType.TouchscreenComputer
	else
		return module.Enum.DeviceType.Computer
	end
end

function module.getGraphicsQuality()
	local quality = UserSettings().GameSettings.SavedQualityLevel
	if quality == Enum.SavedQualitySetting.Automatic then
		lastGraphicQualityLevelWas = Enum.SavedQualitySetting.Automatic
		return module.Enum.GraphicsQuality.Automatic
	elseif quality == Enum.SavedQualitySetting.QualityLevel1 then
		lastGraphicQualityLevelWas = Enum.SavedQualitySetting.QualityLevel1
		return module.Enum.GraphicsQuality.Level01
	elseif quality == Enum.SavedQualitySetting.QualityLevel2 then
		lastGraphicQualityLevelWas = Enum.SavedQualitySetting.QualityLevel2
		return module.Enum.GraphicsQuality.Level02
	elseif quality == Enum.SavedQualitySetting.QualityLevel3 then
		lastGraphicQualityLevelWas = Enum.SavedQualitySetting.QualityLevel3
		return module.Enum.GraphicsQuality.Level03
	elseif quality == Enum.SavedQualitySetting.QualityLevel4 then
		lastGraphicQualityLevelWas = Enum.SavedQualitySetting.QualityLevel4
		return module.Enum.GraphicsQuality.Level04
	elseif quality == Enum.SavedQualitySetting.QualityLevel5 then
		lastGraphicQualityLevelWas = Enum.SavedQualitySetting.QualityLevel5
		return module.Enum.GraphicsQuality.Level05
	elseif quality == Enum.SavedQualitySetting.QualityLevel6 then
		lastGraphicQualityLevelWas = Enum.SavedQualitySetting.QualityLevel6
		return module.Enum.GraphicsQuality.Level06
	elseif quality == Enum.SavedQualitySetting.QualityLevel7 then
		lastGraphicQualityLevelWas = Enum.SavedQualitySetting.QualityLevel7
		return module.Enum.GraphicsQuality.Level07
	elseif quality == Enum.SavedQualitySetting.QualityLevel8 then
		lastGraphicQualityLevelWas = Enum.SavedQualitySetting.QualityLevel8
		return module.Enum.GraphicsQuality.Level08
	elseif quality == Enum.SavedQualitySetting.QualityLevel9 then
		lastGraphicQualityLevelWas = Enum.SavedQualitySetting.QualityLevel9
		return module.Enum.GraphicsQuality.Level09
	elseif quality == Enum.SavedQualitySetting.QualityLevel10 then
		lastGraphicQualityLevelWas = Enum.SavedQualitySetting.QualityLevel10
		return module.Enum.GraphicsQuality.Level10
	end
end

--// Initialize events
userInputService.LastInputTypeChanged:Connect(function()
	if userInputService.KeyboardEnabled and userInputService.MouseEnabled and not userInputService.GamepadEnabled and not userInputService.TouchEnabled then
		if lastInputTypeWas == module.Enum.InputType.KeyboardMouse then return end
		inputChanged:Fire(module.Enum.InputType.KeyboardMouse)
	elseif userInputService.KeyboardEnabled and not userInputService.MouseEnabled and not userInputService.GamepadEnabled and not userInputService.TouchEnabled then
		if lastInputTypeWas == module.Enum.InputType.Keyboard then return end
		inputChanged:Fire(module.Enum.InputType.Keyboard)
	elseif not userInputService.KeyboardEnabled and userInputService.MouseEnabled and not userInputService.GamepadEnabled and not userInputService.TouchEnabled then
		if lastInputTypeWas == module.Enum.InputType.Mouse then return end
		inputChanged:Fire(module.Enum.InputType.Mouse)
	elseif not userInputService.KeyboardEnabled and not userInputService.MouseEnabled and userInputService.GamepadEnabled and not userInputService.TouchEnabled then
		if lastInputTypeWas == module.Enum.InputType.Gamepad then return end
		inputChanged:Fire(module.Enum.InputType.Gamepad)
	elseif userInputService.VREnabled then
		if lastInputTypeWas == module.Enum.InputType.VR then return end
		inputChanged:Fire(module.Enum.InputType.VR)
	else
		if lastInputTypeWas == module.Enum.InputType.Touchscreen then return end
		inputChanged:Fire(module.Enum.InputType.Touchscreen)
	end
end)

game.Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
	--// Size changed
	coroutine.resume(coroutine.create(function()
		if game.Workspace.CurrentCamera.ViewportSize.X == lastResolutionWas.X and game.Workspace.CurrentCamera.ViewportSize.X == lastResolutionWas.Y then return end
		lastResolutionWas = Vector2.new(game.Workspace.CurrentCamera.ViewportSize.X, game.Workspace.CurrentCamera.ViewportSize.Y)
		resolutionChanged:Fire(Vector2.new(game.Workspace.CurrentCamera.ViewportSize.X, game.Workspace.CurrentCamera.ViewportSize.Y))
	end))
	
	--// Orientation changed
	coroutine.resume(coroutine.create(function()
		local newOrientation = module.getDeviceOrientation()
		if newOrientation == lastOrientationWas then return end
		if newOrientation == module.Enum.DeviceOrientation.Portrait then
			orientationChanged:Fire(module.Enum.DeviceOrientation.Portrait)
		elseif newOrientation == module.Enum.DeviceOrientation.Landscape then
			orientationChanged:Fire(module.Enum.DeviceOrientation.Landscape)
		end
	end))
end)

UserSettings().GameSettings.Changed:Connect(function()
	local quality = UserSettings().GameSettings.SavedQualityLevel
	if quality == lastGraphicQualityLevelWas then return end
	if quality == Enum.SavedQualitySetting.Automatic then
		lastGraphicQualityLevelWas = Enum.SavedQualitySetting.Automatic
		graphicsQualityChanged:Fire(module.Enum.GraphicsQuality.Automatic)
	elseif quality == Enum.SavedQualitySetting.QualityLevel1 then
		lastGraphicQualityLevelWas = Enum.SavedQualitySetting.QualityLevel1
		graphicsQualityChanged:Fire(module.Enum.GraphicsQuality.Level01)
	elseif quality == Enum.SavedQualitySetting.QualityLevel2 then
		lastGraphicQualityLevelWas = Enum.SavedQualitySetting.QualityLevel2
		graphicsQualityChanged:Fire(module.Enum.GraphicsQuality.Level02)
	elseif quality == Enum.SavedQualitySetting.QualityLevel3 then
		lastGraphicQualityLevelWas = Enum.SavedQualitySetting.QualityLevel3
		graphicsQualityChanged:Fire(module.Enum.GraphicsQuality.Level03)
	elseif quality == Enum.SavedQualitySetting.QualityLevel4 then
		lastGraphicQualityLevelWas = Enum.SavedQualitySetting.QualityLevel4
		graphicsQualityChanged:Fire(module.Enum.GraphicsQuality.Level04)
	elseif quality == Enum.SavedQualitySetting.QualityLevel5 then
		lastGraphicQualityLevelWas = Enum.SavedQualitySetting.QualityLevel5
		graphicsQualityChanged:Fire(module.Enum.GraphicsQuality.Level05)
	elseif quality == Enum.SavedQualitySetting.QualityLevel6 then
		lastGraphicQualityLevelWas = Enum.SavedQualitySetting.QualityLevel6
		graphicsQualityChanged:Fire(module.Enum.GraphicsQuality.Level06)
	elseif quality == Enum.SavedQualitySetting.QualityLevel7 then
		lastGraphicQualityLevelWas = Enum.SavedQualitySetting.QualityLevel7
		graphicsQualityChanged:Fire(module.Enum.GraphicsQuality.Level07)
	elseif quality == Enum.SavedQualitySetting.QualityLevel8 then
		lastGraphicQualityLevelWas = Enum.SavedQualitySetting.QualityLevel8
		graphicsQualityChanged:Fire(module.Enum.GraphicsQuality.Level08)
	elseif quality == Enum.SavedQualitySetting.QualityLevel9 then
		lastGraphicQualityLevelWas = Enum.SavedQualitySetting.QualityLevel9
		graphicsQualityChanged:Fire(module.Enum.GraphicsQuality.Level09)
	elseif quality == Enum.SavedQualitySetting.QualityLevel10 then
		lastGraphicQualityLevelWas = Enum.SavedQualitySetting.QualityLevel10
		graphicsQualityChanged:Fire(module.Enum.GraphicsQuality.Level10)
	end
end)

--// Direct events
module.inputTypeChanged = inputChanged.Event
module.screenSizeChanged = resolutionChanged.Event
module.screenOrientationChanged = orientationChanged.Event
module.graphicsQualityChanged = graphicsQualityChanged.Event

return module
