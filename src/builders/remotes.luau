local types = require("../types")

export type RemoteBuilder = {
	_remote: types.Remote,

	arguments: (...unknown) -> RemoteBuilder,
	returns: (...unknown) -> RemoteBuilder,
}

local function newRemoteBuilder(from: types.RemoteFrom, name: string)
	local remote = { type = "remote", from = from, kind = "event", name = name } :: types.Remote
	local builder = { _remote = remote } :: RemoteBuilder

	function builder.arguments(...: unknown): RemoteBuilder
		-- STUB
		return builder
	end

	function builder.returns(...: unknown): RemoteBuilder
		-- STUB
		remote.kind = "function"
		return builder
	end

	return builder
end

local remotes = {}

function remotes.fromClient(name: string): RemoteBuilder
	return newRemoteBuilder("client", name)
end

function remotes.fromServer(name: string): RemoteBuilder
	return newRemoteBuilder("server", name)
end

table.freeze(remotes)
return remotes
