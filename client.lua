local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvent")
local RemoteFunction: RemoteFunction = ReplicatedStorage:WaitForChild("RemoteFunction")

local ClientNetwork = {}

function ClientNetwork:Send(messageName: string, data: any)
	local packet = {
		Name = messageName,
		Data = data
	}

	RemoteEvent:FireServer(packet)
end

function ClientNetwork:On(messageName: string, callback)
	RemoteEvent.OnClientEvent:Connect(function(payload)
		if payload.Name == messageName then
			callback(payload.Data)
		end
	end)
end

function ClientNetwork:Invoke(messageName: string, data: any)
	local packet = {
		Name = messageName,
		Data = data
	}
	return RemoteFunction:InvokeServer(packet)
end

local invokeCallbacks = {}

function ClientNetwork:OnInvoke(messageName: string, callback)
	invokeCallbacks[messageName] = callback
end

RemoteFunction.OnClientInvoke = function(payload)
	local callback = invokeCallbacks[payload.Name]
	if callback then
		return callback(payload.Data)
	end
	return nil
end

return ClientNetwork
