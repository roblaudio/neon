local pathfs = require("@lune_packages/pathfs")

local generateClientLuau = require("./luau/client")
local generateClientTypeScript = require("./typescript/client")
local generateServerLuau = require("./luau/server")
local generateServerTypeScript = require("./typescript/server")
local stylua = require("./stylua")
local types = require("../types")

local generator = {}

function generator.generate(options: types.GeneratorOptions)
	local fmt = {}

	local clientOutputPath = options.config.clientOutput
	if clientOutputPath then
		local clientLuau = generateClientLuau(options.config, options.generatables)

		local writeTo: pathfs.Path = pathfs.absolute(options.config.clientOutput :: string)
		table.insert(fmt, writeTo)
		clientLuau.writeFile(writeTo)

		if options.config.typescript then
			local clientTypeScript = generateClientTypeScript(options.config, options.generatables)

			-- ???
			-- fyi none of the Path apis work even including :setExtension???
			local typescriptWriteTo =
				pathfs.absolute(((options.config.clientOutput :: string):gsub("%.luau$", ".d.ts")))
			print(typescriptWriteTo)
			clientTypeScript.writeFile(typescriptWriteTo)
		end
	end

	local serverOutputPath = options.config.serverOutput
	if serverOutputPath then
		local serverLuau = generateServerLuau(options.config, options.generatables)

		local writeTo: pathfs.Path = pathfs.absolute(options.config.serverOutput :: string)
		table.insert(fmt, writeTo)
		serverLuau.writeFile(writeTo)

		if options.config.typescript then
			local serverTypeScript = generateServerTypeScript(options.config, options.generatables)

			-- ???
			-- fyi none of the Path apis work even including :setExtension???
			local typescriptWriteTo =
				pathfs.absolute(((options.config.serverOutput :: string):gsub("%.luau$", ".d.ts")))
			serverTypeScript.writeFile(typescriptWriteTo)
		end
	end

	if options.config.fmt then
		stylua.formatEach(table.unpack(fmt))
	end
end

table.freeze(generator)
return generator
