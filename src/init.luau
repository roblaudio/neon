--!strict

type CallableTable<Fn, T> = typeof(setmetatable(({} :: any) :: T, {} :: { __call: Fn }))

export type NeonConfiguration = {
	clientOutput: (path: string) -> NeonConfiguration,
	serverOutput: (path: string) -> NeonConfiguration,
	typescript: (boolean) -> NeonConfiguration,
	case: ("camel" | "pascal" | "snake") -> NeonConfiguration,
	async: (("yielding") -> NeonConfiguration) & (("promise" | "future", libPath: string) -> NeonConfiguration),
}

export type NeonType = { __neonType: never }

export type NeonRemote = {
	args: (...NeonType) -> NeonRemote,
	returns: (...NeonType) -> NeonRemote,
}

export type Neon = {
	read compile: (config: NeonConfiguration, ...NeonRemote) -> (),
	read config: () -> NeonConfiguration,

	read fromServer: (remoteName: string) -> NeonRemote,
	read fromClient: (remoteName: string) -> NeonRemote,

	read types: {
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

local Neon: Neon = table.freeze({}) :: any

return Neon
