local types = require("../types")

export type ConfigurationBuilder = {
	_config: types.Configuration,

	clientOutput: (path: string) -> ConfigurationBuilder,
	serverOutput: (path: string) -> ConfigurationBuilder,
	typescript: (boolean) -> ConfigurationBuilder,
	case: (types.Case) -> ConfigurationBuilder,
	async: (("yielding") -> ConfigurationBuilder) & (("promise" | "future", libPath: string) -> ConfigurationBuilder),
	checkTypes: (boolean) -> ConfigurationBuilder,
	remoteFolder: (remoteFolderName: string) -> ConfigurationBuilder,
	fmt: (boolean) -> ConfigurationBuilder,
	document: (boolean) -> ConfigurationBuilder,
}

-- FIXME: Luau is broken
local DEFAULT_CONFIGURATION: types.Configuration = table.freeze({
	typescript = false,
	case = "camel",
	async = "yielding",
	checkTypes = false,
	remoteFolderName = "Neon",
	-- TODO: make this based on if the user has stylua enabled
	fmt = true,
	document = true,
} :: { [any]: any })

local function config(): ConfigurationBuilder
	local config = table.clone(DEFAULT_CONFIGURATION)
	local builder = { _config = config } :: ConfigurationBuilder

	function builder.clientOutput(path: string)
		config.clientOutput = path
		return builder
	end

	function builder.serverOutput(path: string)
		config.serverOutput = path
		return builder
	end

	function builder.typescript(typescript: boolean)
		config.typescript = typescript
		return builder
	end

	function builder.case(case: types.Case)
		config.case = case
		return builder
	end

	function builder.async(async: types.Async, libPath: string?)
		config.async = async

		if async ~= "yielding" then
			if not libPath then
				error("message")
			end
			config.asyncLibPath = libPath
		else
			config.asyncLibPath = nil
		end

		return builder
	end

	function builder.checkTypes(checkTypes: boolean)
		config.checkTypes = checkTypes
		return builder
	end

	function builder.remoteFolder(remoteFolderName: string)
		config.remoteFolderName = remoteFolderName
		return builder
	end

	function builder.fmt(fmt: boolean)
		config.fmt = fmt
		return builder
	end

	function builder.document(document: boolean)
		config.document = document
		return builder
	end

	table.freeze(builder)
	return builder :: ConfigurationBuilder
end

return config
