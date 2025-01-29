export type Case = "camel" | "pascal" | "snake"
export type Async = "yielding" | "promise" | "future"

export type Configuration = {
	clientOutput: string?,
	serverOutput: string?,
	typescript: boolean,
	case: Case,
	async: Async,
	asyncLibPath: string?,
}

export type ConfigurationBuilder = {
	config: Configuration,

	clientOutput: (path: string) -> ConfigurationBuilder,
	serverOutput: (path: string) -> ConfigurationBuilder,
	typescript: (boolean) -> ConfigurationBuilder,
	case: (Case) -> ConfigurationBuilder,
	async: (("yielding") -> ConfigurationBuilder) & (("promise" | "future", libPath: string) -> ConfigurationBuilder),
}

-- FIXME: Luau is broken
local DEFAULT_CONFIGURATION: Configuration = table.freeze({
	typescript = false,
	case = "camel",
	async = "yielding",
} :: { [any]: any })

local function config(): ConfigurationBuilder
	local config = table.clone(DEFAULT_CONFIGURATION)
	local builder = { config = config } :: ConfigurationBuilder

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

	function builder.case(case: Case)
		config.case = case
		return builder
	end

	function builder.async(async: Async, libPath: string?)
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

	table.freeze(builder)
	return builder :: ConfigurationBuilder
end

return config
