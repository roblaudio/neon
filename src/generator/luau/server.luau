local LuauOutput = require("./output")
local base = require("./base")
local names = require("../names")
local types = require("../../types")

local function generateServerLuau(config: types.Configuration, generatable: { types.Generatable }): types.Output
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
		.pushHeader("Server")
		.pushLine(base)
		.pushLine("if not RunService:IsServer() then")
		.pushLine('error("[neon] cannot use server module from the client")')
		.pushLine("end")
		.pushNewLine()
        .pushLine(`local remotes = ReplicatedStorage:FindFirstChild("{config.remoteFolderName}")`)
  		.pushLine("if remotes == nil then")
  		.pushLine('remotes = Instance.new("Folder")')
  		.pushLine(`remotes.Name = "{config.remoteFolderName}"`)
  		.pushLine("remotes.Parent = ReplicatedStorage")
  		.pushLine("end")
        .pushNewLine()
        .pushLine(`local reliable = remotes:FindFirstChild("{config.remoteFolderName}_Reliable")`)
        .pushLine("if reliable == nil then")
        .pushLine('reliable = Instance.new("RemoteEvent")')
   	    .pushLine(`reliable.Name = "{config.remoteFolderName}_Reliable"`)
   	    .pushLine("reliable.Parent = remotes")
   	    .pushLine("end")
        .pushNewLine()
        .pushLine(`local unreliable = remotes:FindFirstChild("{config.remoteFolderName}_Unreliable")`)
        .pushLine(`if unreliable == nil then`)
        .pushLine('unreliable = Instance.new("UnreliableRemoteEvent")')
        .pushLine(`unreliable.Name = "{config.remoteFolderName}_Unreliable"`)
        .pushLine("unreliable.Parent = remotes")
        .pushLine("end")
        .pushNewLine()
		.pushLine("return table.freeze {")

	for _, gen in generatable do
		if gen.type == "remote" then
			output.pushLine(`{gen.name} = table.freeze \{`)

			if gen.kind == "event" then
				if gen.from == "server" then
					document("")
					output.pushLine(`{cased("fire")} = function()`)
					output.pushLine("end,")

					document("")
					output.pushLine(`{cased("fireAll")} = function()`)
					output.pushLine("end,")

					document("")
					output.pushLine(`{cased("fireExcept")} = function()`)
					output.pushLine("end,")

					document("")
					output.pushLine(`{cased("fireList")} = function()`)
					output.pushLine("end,")
				else
					document("")
					output.pushLine(`{cased("on")} = function()`)
					output.pushLine("end,")
				end
			else
				document("")
				output.pushLine(`{cased("setCallback")} = function()`)
				output.pushLine("end,")
			end

			output.pushLine("},")
		end
	end

	output.pushLine("}")
	return output
end

return generateServerLuau
