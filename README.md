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
