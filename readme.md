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
    Player = "player"
}
```

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
    :Finalize()
```
It is recommended to store CommandModule.Arguments and CommandModule.ArgTypes in shorthand variables.

### Builder Methods

| Method                          | Description                                                  | Required? |
| ------------------------------- | -------------------------------------------------------------  | --- |
| `:WithPrefix(prefix: string)`   | A custom prefix for this command                               | ❌ |
| `:WithName(name: string)`       | The command's name                                             | ✅ |
| `:WithAlias(alias: string)`     | Shorthand command                                              | ❌ |
| `:WithArgs(args: { Argument })` | Provide argument names, types & order.                         | ❌ |
| `:Finalize()`                   | Finalizes and returns a `Command` object. Must be called last. | ✅ |

---

## 📥 Defining Commands in Bulk

You can bulk load commands from a ModuleScript:

```lua
local Loaded = CommandModule.loadModule(script.ModuleScript)
```

**ModuleScript format:**

```lua
local Module = { }

module.KickCommand = {
     Name = "kick",
     Alias = "k",
    Args = {
        CommandModule.Arguments("target", CommandModule.ArgTypes.Player),
        CommandModule.Arguments("reason", CommandModule.ArgTypes.string)
    },
    Invoked = function(player, args)
        -- handle command
    end
}

return Module
```

---

## 🧪 Example

```lua
local KickCommand = CommandModule.create()
    :WithName("kick")
    :WithArgs({
        CommandModule.Arguments.new("player", CommandModule.ArgTypes.Player)
    })
    :Finalize()

kickCommand.Invoked:Connect(function(player, args)
    local target = args.player
    target:Kick("You have been kicked.")
end)
```

---

## 📝 Notes

* Commands are stored under `TextChatService.Commands`.
* Commands can be invoked dynamically through `Command:Invoke()`
 Be sure to pass in the required arguments defined in `:WithArgs`
