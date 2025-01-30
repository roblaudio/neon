local LuauOutput = require("./output")
local base = require("./base")
local names = require("../names")
local types = require("../../types")

local function generateClientLuau(config: types.Configuration, generatable: { types.Generatable }): types.Output
	local function cased(name: keyof<typeof(names.NAMES)>)
		return names.cased(config.case, name)
	end

	local output = LuauOutput()

	local function document(comment: string)
		if config.document then
			output.pushLine("--- " .. comment)
		end
	end

	-- stylua: ignore
	output
		.pushHeader("Client")
		.pushLine(base)
		.pushLine("if not RunService:IsClient() then")
		.pushLine('error("[neon] cannot use client module from the server")')
		.pushLine("end")
		.pushNewLine()
		.pushLine(`local remotes = ReplicatedStorage:WaitForChild("{config.remoteFolderName}")`)
		.pushLine(`local reliable = remotes:WaitForChild("{config.remoteFolderName}_Reliable")`)
		.pushLine(`local unreliable = remotes:WaitForChild("{config.remoteFolderName}_Unreliable")`)
		.pushLine(`assert(reliable:IsA("RemoteEvent"), "[neon] expected {config.remoteFolderName}_Reliable to be a RemoteEvent")`)
		.pushLine(`assert(unreliable:IsA("UnreliableRemoteEvent"), "[neon] expected {config.remoteFolderName}_Unreliable to be an UnreliableRemoteEvent")`)
		.pushNewLine()
		.pushLine("return table.freeze {")

	for _, gen in generatable do
		if gen.type == "remote" then
			output.pushLine(`{gen.name} = table.freeze \{`)

			if gen.kind == "event" then
				if gen.from == "client" then
					document("")
					output.pushLine(`{cased("fire")} = function()`)
				else
					document("")
					output.pushLine(`{cased("on")} = function()`)
				end
			else
				document("Invokes the server")
				output.pushLine(`{cased("invoke")} = function()`)
			end

			output.pushLine("end,")
			output.pushLine("},")
		end
	end

	output.pushLine("}")

	return output
end

return generateClientLuau
