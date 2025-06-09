local plrs = game:GetService('Players')

local module = {}

module.string = function(Str:string) return tostring(Str) end
module.number = function(Str:string) return tonumber(Str) end

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

module.players = function(PartialName:string, Caller:Player)
	PartialName = PartialName:lower()
	
	if PartialName == 'me' then
		return Caller
	elseif PartialName == 'all' then
		return plrs:GetPlayers()
	elseif PartialName == 'others' then
		local Players = plrs:GetPlayers()
		Players = table.remove(Players, table.find(Players, Caller))
		return Players
	end

	for _,v in plrs:GetPlayers() do
		local Name = v.Name:lower()
		if Name:sub(1, #PartialName) == PartialName then
			return v
		end
	end

	error(`Unable to match player "{PartialName}" or generic`)
end

return module
