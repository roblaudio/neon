local TypeScriptOutput = require("./output")
local names = require("../names")
local types = require("../../types")

local function generateServerTypeScript(config: types.Configuration, generatable: { types.Generatable }): types.Output
	local output = TypeScriptOutput()
	output.pushHeader("Server")

	output.pushLine("")
	output.pushLine(`export declare const {names.cased(config.case, "sendEvents")}: () => void`)
	output.pushLine("")

	for _, gen in generatable do
		if gen.type == "remote" then
			output.pushLine(`export declare const {gen.name}: \{`)

			if gen.kind == "event" then
				if gen.from == "server" then
					output.pushLine(`{names.cased(config.case, "fire")}: () => void`)
					output.pushLine(`{names.cased(config.case, "fireAll")}: () => void`)
					output.pushLine(`{names.cased(config.case, "fireList")}: () => void`)
					output.pushLine(`{names.cased(config.case, "fireExcept")}: () => void`)
				else
					output.pushLine(`{names.cased(config.case, "on")}: () => void`)
				end
			else
				output.pushLine(`{names.cased(config.case, "setCallback")}: (callback: () => void) => () => void`)
			end

			output.pushLine("};")
			output.pushLine("")
		end
	end

	return output
end

return generateServerTypeScript
