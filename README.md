# Neon

Type-safe Luau API for writing and compiling buffer network IDLs based on Blink
and Zap.

```Luau
local Neon = require("./lune_packages/neon")

Neon.compile(
	Neon.config()
		.clientOutput("src/client/network.luau")
		.serverOutput("src/server/network.luau")
		.typescript(true)
		.case("camel")
		.async("promise" :: "promise", "require(game:GetService('ReplicatedStorage').rbxts_include.RuntimeLib)"),
	Neon.fromClient("CanMigrate").returns(Neon.dataTypes.bool)
)
```

## Installation

Neon requires the Lune runtime.

### pesde

```
pesde add roblaudio/neon
```
