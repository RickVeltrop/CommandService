--// Services
local tcs = game:GetService('TextChatService')
local rs = game:GetService('ReplicatedStorage')
local plrs = game:GetService('Players')

--// Modules
local Args = require('./Argument')
local Conversions = require('./TypeConversions')

--// Constants
local Remote = script.Parent.Obj.Remote
print('Remote: ', Remote)

local QuotesPattern = '^"(.-)"%s*(.*)'
local StdPattern = '^(%S+)%s*(.*)'

--// Functions
local function ParseCommandArgs(TargetArgs:{ Args.Argument }, Caller:Player, Text:string)
	local Args = { }
	
	local Match = Text:match(StdPattern)
	Text = Text:gsub(`^{Match} `, '')
	
	for i,v in TargetArgs do
		local HasQuotes = Text:match('^"')
		local Pattern = if HasQuotes then QuotesPattern else StdPattern
		local Match = Text:match(Pattern)
		
		local Converted
		local Succ,Err = pcall(function() Converted = Conversions[v.Type](Match, Caller) end)
		
		assert(Match, `Pattern match failed for argument {i}`)
		assert(Succ, `Type conversion string->{v.Type} failed for argument #{i}`)
		
		Args[v.Name] = Converted
		
		local MatchStr = if HasQuotes then `^"{Match}" ` else `^{Match} `
		Text = Text:gsub(MatchStr, '')
	end
	
	return Args
end

--// Module
local module = { }
local Static = { }

Static.new = function(CmdData)
	local Bindable = Instance.new('BindableEvent')
	
	local Cmd = Instance.new('TextChatCommand')
	Cmd.Name = CmdData.Name
	Cmd.PrimaryAlias = CmdData.Prefix .. CmdData.Name
	Cmd.SecondaryAlias = CmdData.Prefix .. CmdData.Alias
	Cmd:SetAttribute('MinAccessLevel', CmdData.MinAccessLevel)
	Cmd.Parent = tcs.Commands
	
	Cmd.Triggered:Connect(function(Source:TextSource, Text:string)
		local Caller = plrs:GetPlayerByUserId(Source.UserId)
		local Access = Caller:GetAttribute('AccessLevel')
		
		assert(Access >= CmdData.MinAccessLevel, `{Caller.Name} does not have sufficient access for {Cmd.Name}`)
		
		local Parsed = ParseCommandArgs(CmdData.Args, Caller, Text)
		Bindable:Fire(Caller, Parsed)
	end)
	
	Remote:FireAllClients()
	
	local self = setmetatable({ }, module)
	
	self.Invoked = Bindable.Event
	self.Invoke = function(self, ...) Bindable:Fire(...) end
	
	return self
end

export type Command = typeof(Static.new())

return Static
