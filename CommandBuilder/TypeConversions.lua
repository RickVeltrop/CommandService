local plrs = game:GetService('Players')

local module = {}

module.string = tostring
module.number = tonumber

module.player = function(PartialName:string)
	PartialName = PartialName:lower()
	
	for _,v in plrs:GetPlayers() do
		local Name = v.Name:lower()
		if Name:sub(1, #PartialName) == PartialName then
			return v
		end
	end
	
	error(`Unable to match player "{PartialName}"`)
end

return module
