--// Services
local tcs = game:GetService('TextChatService')
local plrs = game:GetService('Players')

--// Modules
local Args = require('./Argument')
local Conversions = require('./TypeConversions')

--// Constants
local QuotesPattern = '^"(.-)"%s*(.*)'
local StdPattern = '^(%S+)%s*(.*)'

--// Functions
local function ParseCommandArgs(TargetArgs:{ Args.Argument }, Source:TextSource, Text:string)
	local Args = { }
	
	local Match = Text:match(StdPattern)
	Text = Text:gsub(`^{Match} `, '')
	
	for i,v in TargetArgs do
		local HasQuotes = Text:match('^"')
		local Pattern = if HasQuotes then QuotesPattern else StdPattern
		local Match = Text:match(Pattern)
		
		local Converted
		local Succ,Err = pcall(function() Converted = Conversions[v.Type](Match) end)
		
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
	Cmd.Parent = tcs.Commands
	
	Cmd.Triggered:Connect(function(Source:TextSource, Text:string)
		local FiredPlr = plrs:GetPlayerByUserId(Source.UserId)
		
		local Parsed = ParseCommandArgs(CmdData.Args, Source, Text)
		Bindable:Fire(FiredPlr, Parsed)
	end)
	
	local self = setmetatable({ }, module)
	
	self.Invoked = Bindable.Event
	self.Invoke = function(self, ...) Bindable:Fire(...) end
	
	return self
end

export type Command = typeof(Static.new())

return Static
