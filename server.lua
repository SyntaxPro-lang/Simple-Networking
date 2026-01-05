local ServerNetwork = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteEvent = ReplicatedStorage:FindFirstChild("RemoteEvent") or Instance.new("RemoteEvent", ReplicatedStorage)
local BindableEvent: BindableEvent = ReplicatedStorage:FindFirstChild("BindableEvent") or Instance.new("BindableEvent", ReplicatedStorage)

local remoteListeners = {}
local bindListeners = {}

function ServerNetwork:On(messageName: string, callback)
	remoteListeners[messageName] = callback
end

RemoteEvent.OnServerEvent:Connect(function(player, payload)
	local handler = remoteListeners[payload.Name]
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
		for _, player in target do
			RemoteEvent:FireClient(player, packet)
		end
	end
end

-- listen to bindable event (server to server)
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

return ServerNetwork
