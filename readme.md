# CommandService

A TextChatCommand wrapper for Roblox. This module allows you to easily define and structure in-game commands with arguments, aliases, and prefixes.

---

## 📦 Installation

1. Download the latest release .rbxmx file
2. Drag your file anywhere into your game. (ServerStorage recommended)
3. Require the module like so:
```lua
local ss = game:GetService('ServerStorage')
local CommandModule = require(ss.CommandBuilder)
```
4. All done! See the API reference for usage examples.

---

## 🧱 API Reference

### `CommandModule.GlobalPrefix : string`

* Default prefix used for commands (e.g. `'/'`).
* Can be overridden per command using `CommandBuilder:WithPrefix`.

### `CommandModule.Arguments`

* Shortcut to the `Argument` module.
* Used for defining and parsing arguments.

### `CommandModule.ArgTypes`

Defines supported argument types:
```lua
{
    string = "string",
    number = "number",
    Player = "player",
    Players = "players"
}
```

`Player` vs `Players`?
`Players` supports strings such as "all", "others", and "me", thus may return a table.
`Player` only supports explicit names.

---

## 🛠️ Creating a Command

Use the builder-style API to construct a command:

```lua
local command = CommandModule.create()
	:WithPrefix('/')
    :WithName("kick")
    :WithAlias("k")
    :WithArgs({
        CommandModule.Arguments("target", CommandModule.ArgTypes.Player),
        CommandModule.Arguments("reason", CommandModule.ArgTypes.string)
    })
	:WithAccessRequirement(2) -- Will make the command using only with access level 2 or up
    :Finalize()
```
It is recommended to store CommandModule.Arguments and CommandModule.ArgTypes in shorthand variables.

### Builder Methods

| Method                                       | Description                                                   | Required? |
| -------------------------------------------- | ------------------------------------------------------------- | --- |
| `:WithPrefix(prefix: string)`                | A custom prefix for this command.                              | ❌ |
| `:WithName(name: string)`                    | The command's name.                                            | ✅ |
| `:WithAlias(alias: string)`                  | Shorthand command                                             | ❌ |
| `:WithArgs(args: { Argument })`              | Provide argument names, types & order.                         | ❌ |
| `:WithAccessRequirement(level: number)` | Minimum required access level to see/use this command.         | ❌ |
| `:Finalize()`                                | Finalizes and returns a `Command` object. Must be called last. | ✅ |

---

## 📥 Defining Commands in Bulk

You can bulk load commands from a ModuleScript:

```lua
local LoadedCommands = CommandModule.loadModule(script.ModuleScript)
```

**ModuleScript format:**

```lua
local ss = game:GetService('ServerStorage')
local CommandModule = require(ss.CommandBuilder)

local Module = { }

module.KickCommand = {
    Name = "kick",
    Alias = "k",
	AccessRequirement = 2,
    Args = {
        CommandModule.Arguments("Target", CommandModule.ArgTypes.Player),
        CommandModule.Arguments("Reason", CommandModule.ArgTypes.string)
    },
    Invoked = function(Player, Args)
    	Args.Target:Kick(`You have been kicked : {Args.Reason}.`)
    end
}

return Module
```

---

## 🧪 Example

```lua
local ss = game:GetService('ServerStorage')

local CommandModule = require(ss.CommandBuilder)
local Arg = CommandModule.Arguments
local Types = CommandModule.ArgTypes

local KickCmd = CommandModule.create()
	:WithName('kick')
	:WithAlias('k')
	:WithArgs({
		Arg('Target', Types.Player),
		Arg('Reason', Types.string)
	})
	:Finalize()

KickCmd.Invoked:Connect(function(Player:Player, Args:{ })
    Args.Target:Kick(`You have been kicked : {Args.Reason}.`)
end)
```

### 💡 Arguments Table Intellisense
What you'll notice in the aforementioned example is a lack of intellisense for the `Args` table.
Unfortunately I haven't been able to find an internal fix, so here's what you can do:

```lua
type KickArgs = {
	Target : Player,
	Reason : string
}

KickCmd.Invoked:Connect(function(Player:Player, Args:KickArgs)
    Args.Target:Kick(`You have been kicked : {Args.Reason}.`)
end)
```


---

## 📝 Notes

* Commands are stored under `TextChatService.Commands`.
* Commands can be invoked dynamically through `Command:Invoke()`   
 Be sure to pass in the required arguments defined in `:WithArgs`
* Player's access levels can be set with `Player:SetAttribute('AccessLevel', NewLevel)`
  To reduce overhead in the module, you'll need to set up storage of access levels yourself.