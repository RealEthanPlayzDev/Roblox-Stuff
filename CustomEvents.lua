--@module
--[[
	File name: CustomEvents.lua
	Author: ItzEthanPlayz_YT
	
	Used to make custom events/call something if something is finished to continue (without using "repeat wait until ...")
	
	https://realethanplayzdev.github.io/Custom%20Events/Custom%20Events/
--]]

local module = {}

local events = {}

function module.newEvent(aName, isHidden, aParent)
	assert(tostring(aName), "Error: 'name' is a required argument!")
	local CustomEventObject = {
		BindableEvent = Instance.new("BindableEvent"),
		name = aName,
		_indexPosition = nil,
		_isHidden = isHidden
	}
	CustomEventObject.Event = CustomEventObject.BindableEvent.Event
	CustomEventObject.BindableEvent.Name = aName
	function CustomEventObject:Destroy()
		if not CustomEventObject._isHidden then
			table.remove(events, CustomEventObject._indexPosition)
			CustomEventObject.BindableEvent:Destroy()
		else
			CustomEventObject.BindableEvent:Destroy()
		end
	end
	if aParent then
		CustomEventObject.BindableEvent.Parent = aParent
	end
	if isHidden then
		return CustomEventObject
	else
		CustomEventObject._indexPosition = #events + 1
		table.insert(events, CustomEventObject._indexPosition, CustomEventObject)
		return CustomEventObject
	end
end

function module.getEvent(eventName)
	assert(tostring(eventName), "Error: event name isn't provided.")
	for _, v in pairs(events) do
		if v.name == eventName then
			return v
		end
	end
end

return module
