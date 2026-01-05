local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvent")

local ClientNetwork = {}

local BindableEvent: BindableEvent = ReplicatedStorage:FindFirstChild("BindableEvent") or Instance.new("BindableEvent", ReplicatedStorage)
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
function ServerNetwork:OnBind(messageName: string, callback)
	bindListeners[messageName] = callback
end

function ServerNetwork:FireBind(messageName: string, data: any)
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

return ClientNetwork
