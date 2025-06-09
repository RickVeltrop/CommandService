local tcs = game:GetService('TextChatService')
local plrs = game:GetService('Players')
local rs = game:GetService('ReplicatedStorage')

local Plr = plrs.LocalPlayer
local Remote = rs.Remote

Remote.OnClientEvent:Connect(function()
	local Access = Plr:GetAttribute('AccessLevel')
	local Commands = tcs.Commands:GetChildren()
	
	for i,v in Commands do
		local MinAccessLevel = v:GetAttribute('MinAccessLevel')
		
		if Access < MinAccessLevel then
			v:Destroy()
		end
	end
end)
