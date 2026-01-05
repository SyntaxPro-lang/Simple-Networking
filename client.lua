local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvent")

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

return ClientNetwork
