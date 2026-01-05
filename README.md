## Introduction
this module was made by my friend @[YMA](https://x.com/YmaisMe) it's a pretty useful module for me and I had to make some changes to it because there were previous issues with compression but since my games are quite simple I don't need compression.

if you'd like to hire me for your project dm me on discord
swiftlyxdev

## HOW TO USE

### Client
```lua
local Networking = require(ReplicatedStorage.Networking.client)

Networking:On("Test", function(data: Template)
	-- initial data
	print("message from server to client")
end)
```

### Server
```lua
local Networking = require(ReplicatedStorage.Networking.server)

Networking:On("Test", function(player: Player, data: Template)
  print("message from client to server")
end)
```
