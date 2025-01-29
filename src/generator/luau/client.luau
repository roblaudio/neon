local LuauOutput = require("./output")
local names = require("../names")
local types = require("../../types")

local function generateClientLuau(config: types.Configuration, generatable: { types.Generatable }): types.Output
	local output = LuauOutput()
	output.pushHeader("Client")

	output.pushLine("")
	output.pushLine("return table.freeze {")

	for _, gen in generatable do
		if gen.type == "remote" then
			output.pushLine(`{gen.name} = table.freeze \{`)

			if gen.kind == "event" then
				if gen.from == "client" then
					output.pushLine(`{names.cased(config.case, "fire")} = function()`)
				else
					output.pushLine(`{names.cased(config.case, "on")} = function()`)
				end
			else
				output.pushLine(`{names.cased(config.case, "invoke")} = function()`)
			end

			output.pushLine("end,")
			output.pushLine("},")
		end
	end

	output.pushLine("}")

	return output
end

return generateClientLuau
