local Neon = require("../src")

Neon.generate(
	Neon.config().clientOutput("client.luau").serverOutput("server.luau").fmt(true).typescript(true).document(true),
	Neon.fromClient("EventFromClient"),
	Neon.fromServer("EventFromServer"),
	Neon.fromServer("FunctionFromServer").returns()
)
