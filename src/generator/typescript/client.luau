local TypeScriptOutput = require("./output")
local names = require("../names")
local types = require("../../types")

local function generateClientTypeScript(config: types.Configuration, generatable: { types.Generatable }): types.Output
	local output = TypeScriptOutput()
	output.pushHeader("Client")

	output.pushLine("")
	output.pushLine(`export declare const {names.cased(config.case, "stepReplication")}: () => void`)
	output.pushLine("")

	for _, gen in generatable do
		if gen.type == "remote" then
			output.pushLine(`export declare const {gen.name}: \{`)

			if gen.kind == "event" then
				if gen.from == "client" then
					output.pushLine(`{names.cased(config.case, "fire")}: () => void`)
				else
					output.pushLine(`{names.cased(config.case, "on")}: () => void`)
				end
			else
				output.pushLine(`{names.cased(config.case, "invoke")}: () => void`)
			end

			output.pushLine("}")
			output.pushLine("")
		end
	end

	return output
end

return generateClientTypeScript
