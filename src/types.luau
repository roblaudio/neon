local pathfs = require("@lune_packages/pathfs")

export type Case = "camel" | "pascal" | "snake"
export type Async = "yielding" | "promise" | "future"

export type Configuration = {
	clientOutput: string?,
	serverOutput: string?,
	typescript: boolean,
	case: Case,
	async: Async,
	asyncLibPath: string?,
	checkTypes: boolean,
	remoteFolderName: string,
	fmt: boolean,
}

export type RemoteFrom = "client" | "server"
export type RemoteKind = "event" | "function"

export type Remote = {
	type: "remote",

	from: RemoteFrom,
	kind: RemoteKind,
	name: string,
	arguments: {}?,
	returns: {}?,
}

export type Output = {
	pushHeader: (scope: string) -> Output,
	push: (...string) -> Output,
	pushLine: (line: string) -> Output,

	contents: () -> string,
	writeFile: (path: pathfs.Path) -> (),
}

export type Generatable = Remote
export type GeneratorOptions = {
	config: Configuration,
	generatables: { Generatable },
}

return nil
