local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvent")
local RemoteFunction: RemoteFunction = ReplicatedStorage:WaitForChild("RemoteFunction")

local ClientNetwork = {}

local BindableEvent: BindableEvent = ReplicatedStorage:FindFirstChild("BindableEvent") or Instance.new("BindableEvent", ReplicatedStorage)
BindableEvent.Name = "client"
local bindListeners = {}

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

-- listen to bindable event (client to client)
function ClientNetwork:OnBind(messageName: string, callback)
	bindListeners[messageName] = callback
end

function ClientNetwork:FireBind(messageName: string, data: any)
	BindableEvent:Fire(
	{
		Name = messageName,
		Data = data
	})
end
BindableEvent.Event:Connect(function(payload)
	local name = payload.Name
	local data = payload.Data

	local callback = bindListeners[name]
	if callback then
		callback(data)
	end
end)

function ClientNetwork:Invoke(messageName: string, data: any)
	local packet = {
		Name = messageName,
		Data = data
	}
	RemoteFunction:InvokeServer(packet)
end

function ClientNetwork:OnInvoke(messageName: string, callback)
	RemoteFunction.OnClientInvoke = function(payload)
		if payload.Name == messageName then
			callback(payload.Data)
		end
	end
end

return ClientNetwork
