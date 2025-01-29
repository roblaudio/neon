local config = require("./builders/config")
local constants = require("./constants")
local generator = require("./generator")
local remotes = require("./builders/remotes")

type CallableTable<Fn, T> = typeof(setmetatable(({} :: any) :: T, {} :: { __call: Fn }))

export type NeonCase = config.Case
export type NeonAsync = config.Async

export type NeonConfiguration = {
	--- The output client file relative to the current working directory
	clientOutput: (path: string) -> NeonConfiguration,
	--- The output server file relative to the current working directory
	serverOutput: (path: string) -> NeonConfiguration,
	--- Toggles generating companion `d.ts` TypeScript definitions
	typescript: (boolean) -> NeonConfiguration,
	--- Casing of the compiled API
	case: (NeonCase) -> NeonConfiguration,
	--- Configures how functions yield. If not using "yielding", provide a
	--- require statement to the async library. If using roblox-ts's Promise,
	--- point to it's RuntimeLib.
	---
	--- ```Luau
	--- Neon.config().async("promise", "require(game:GetService('ReplicatedStorage').rbxts_include.RuntimeLib).Promise")
	--- ```
	async: (("yielding") -> NeonConfiguration) & (("promise" | "future", libPath: string) -> NeonConfiguration),
	--- Toggles checking types at runtime. Useful for development, but has a
	--- performance cost. Consider turning off during production.
	checkTypes: (boolean) -> NeonConfiguration,
	--- The name of the folder made in ReplicatedStorage that Neon will use.
	remoteFolder: (remoteFolderName: string) -> NeonConfiguration,
	--- Toggles formatting of the generated code using Stylua
	fmt: (boolean) -> NeonConfiguration,
}

export type NeonType = { __neonType: never }

export type NeonRemote = {
	args: (...NeonType) -> NeonRemote,
	returns: (...NeonType) -> NeonRemote,
}

export type Neon = {
	read version: string,

	--- Generates new network definition files given a configuration and remotes
	read generate: (config: NeonConfiguration, ...NeonRemote) -> (),
	--- Creates a new configuration
	read config: () -> NeonConfiguration,

	--- Creates a new remote sent from the client
	read fromClient: (remoteName: string) -> NeonRemote,
	--- Creates a new remote sent from the server
	read fromServer: (remoteName: string) -> NeonRemote,

	read dataTypes: {
		-- numeric
		read u8: NeonType,
		read u16: NeonType,
		read u32: NeonType,
		read i8: NeonType,
		read i16: NeonType,
		read i32: NeonType,
		read f32: NeonType,
		read f64: NeonType,
		-- primitives
		read bool: NeonType,
		read buffer: NeonType,
		read cframe: NeonType,
		read color3: NeonType,
		read instance: { read any: NeonType, read class: (class: string) -> NeonType },
		read string: NeonType,
		read unknown: NeonType,
		read vector: NeonType,
		-- advanced
		read optional: (NeonType) -> NeonType,
		read struct: ({ [string]: NeonType }) -> NeonType,
		read map: (key: NeonType, value: NeonType) -> NeonType,
		read array: (NeonType) -> NeonType,
		read tuple: (...NeonType) -> NeonType,
		read enum: (...string) -> NeonType,
	},
}

local Neon: Neon = table.freeze({
	version = tostring(constants.version),

	generate = function(config: config.ConfigurationBuilder, ...: remotes.RemoteBuilder)
		local generatables = {}

		for index = 1, select("#", ...) do
			local obj = select(index, ...) :: remotes.RemoteBuilder
			if obj._remote then
				table.insert(generatables, obj._remote)
			else
				error("unrecognized object")
			end
		end

		generator.generate({
			config = config._config,
			generatables = generatables,
		})
	end,
	config = config,

	fromClient = remotes.fromClient,
	fromServer = remotes.fromServer,

	dataTypes = table.freeze({}),
}) :: any

return Neon
