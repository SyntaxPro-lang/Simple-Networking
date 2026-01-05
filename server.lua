local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvent") or Instance.new('RemoteEvent', ReplicatedStorage)

local ServerNetwork = {}

local listeners = {}

function ServerNetwork:On(messageName: string, callback)
	listeners[messageName] = callback
end

RemoteEvent.OnServerEvent:Connect(function(player, payload)
	local handler = listeners[payload.Name]
	if handler then
		handler(player, payload.Data)
	end
end)

function ServerNetwork:Send(target, messageName: string, data: any)
	local packet = {
		Name = messageName,
		Data = data
	}

	if typeof(target) == "Instance" then
		RemoteEvent:FireClient(target, packet)
	elseif typeof(target) == "table" then
		for _, p in target do
			RemoteEvent:FireClient(p, packet)
		end
	else
		RemoteEvent:FireAllClients(packet)
	end
end

return ServerNetwork
