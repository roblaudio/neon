local Neon = require("../src")

Neon.generate( --
	Neon.config().clientOutput("client/net.luau").serverOutput("server/net.luau").fmt(true),
	Neon.fromClient("HelloWorld"),
	Neon.fromServer("CanMigrate").returns()
)
