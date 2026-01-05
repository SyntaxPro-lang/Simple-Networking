local ServerNetwork = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteEvent: RemoteEvent = ReplicatedStorage:FindFirstChild("RemoteEvent") or Instance.new("RemoteEvent", ReplicatedStorage)
local BindableEvent: BindableEvent = ReplicatedStorage:FindFirstChild("BindableEvent") or Instance.new("BindableEvent", ReplicatedStorage)
BindableEvent.Name = "server"
local RemoteFunction: RemoteFunction = ReplicatedStorage:FindFirstChild("RemoteFunction") or Instance.new("RemoteFunction", ReplicatedStorage)

local remoteListeners = {}
local bindListeners = {}
local remoteFuncListeners = {}

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

function ServerNetwork:OnInvoke(messageName: string, callback)
	remoteFuncListeners[messageName] = callback
end

RemoteFunction.OnServerInvoke = function(player, payload)
	local handler = remoteFuncListeners[payload.Name]
	if handler then
		handler(player, payload.Data)
	end
end

function ServerNetwork:Invoke(target, messageName: string, data: any)
	local packet = {
		Name = messageName,
		Data = data
	}

	if typeof(target) == "Instance" then
		RemoteFunction:InvokeClient(target, packet)
	elseif typeof(target) == "table" then
		for _, player in target do
			RemoteFunction:InvokeClient(player, packet)
		end
	end
end

return ServerNetwork
