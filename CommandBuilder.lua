--// Services
local tcs = game:GetService('TextChatService')
local plrs = game:GetService('Players')

--// Modules
local Command = require('@self/Command')
local Arg = require('@self/Argument')

--// Constants
local Remote = script.Obj.Remote
local Client = script.Obj.CommandClient

local CmdsFolder = Instance.new('Folder')
CmdsFolder.Name = 'Commands'
CmdsFolder.Parent = tcs

--// Setup
Client.Parent = game.StarterPlayer.StarterPlayerScripts
Remote.Parent = game.ReplicatedStorage

for i,v in plrs:GetPlayers() do
	if not v:GetAttribute('AccessLevel') then v:SetAttribute('AccessLevel', 1) end
end
Remote:FireAllClients()

--// Events
plrs.PlayerAdded:Connect(function(Plr:Player)
	if not Plr:GetAttribute('AccessLevel') then Plr:SetAttribute('AccessLevel', 1) end
	Remote:FireClient(Plr)
end)

--// Module
local module = { }
module.__index = module

local Static = { }

Static.GlobalPrefix = '/'
Static.Arguments = Arg

Static.ArgTypes = {
	string = 'string',
	number = 'number',
	Player = 'player',
	Players = 'players'
}

Static.create = function()
	local self = setmetatable({ }, module)
	
	self.Prefix = nil
	self.Name = nil
	self.Alias = nil
	self.MinAccessLevel = 1
	
	return self
end

Static.loadModule = function(Module:ModuleScript)
	local Commands = { }
	Module = require(Module)
	
	for i,v in Module do
		local Command = Static.create()
			:WithName(v.Name)
			:WithAlias(v.Alias)
			:WithArgs(v.Args)
			:Finalize()
		
		Command.Invoked:Connect(v.Invoked)
		Commands[i] = Command
	end
	
	return Command
end

function module:WithPrefix(Prefix:string) : typeof(module)
	self.Prefix = Prefix

	return self
end

function module:WithName(Name:string) : typeof(module)
	self.Name = Name
	
	return self
end

function module:WithAlias(Alias:string) : typeof(module)
	self.Alias = Alias

	return self
end

function module:WithArgs(Args:{ Args.Argument }) : typeof(module)
	self.Args = Args

	return self
end

function module:WithAccessRequirement(MinAccessLevel:number) : typeof(module)
	self.MinAccessLevel = MinAccessLevel

	return self
end

function module:Finalize() : Command.Command
	assert(Static.GlobalPrefix or self.Prefix, 'Command creation failed : No prefix set.')
	assert(self.Name, 'Command creation failed : No name set.')
	
	self.Prefix = self.Prefix or Static.GlobalPrefix
	return Command.new(self)
end

return Static
