local LuauOutput = require("./output")
local types = require("../../types")

local function generateServerLuau(config: types.Configuration, generatable: { types.Generatable }): types.Output
	local output = LuauOutput()
	output.pushHeader("Server")

	return output
end

return generateServerLuau
