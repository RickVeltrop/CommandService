--// Module
local module = { }

local Constructor = { }
Constructor.__call = function(self, Name:string, Type:string)
	local self = setmetatable({ }, module)

	self.Name = Name
	self.Type = Type

	return self
end

export type Argument = typeof(Constructor.__call())

return setmetatable(module, Constructor)
