local pathfs = require("@lune_packages/pathfs")

local generateClientLuau = require("./luau/client")
local generateServerLuau = require("./luau/server")
local stylua = require("./stylua")
local types = require("../types")

local generator = {}

function generator.generate(options: types.GeneratorOptions)
	local fmt = {}

	local clientOutputPath = options.config.clientOutput
	if clientOutputPath then
		local clientLuau = generateClientLuau(options.config, options.generatables)
		local writeTo = pathfs.absolute(options.config.clientOutput :: string)
		table.insert(fmt, writeTo)
		clientLuau.writeFile(writeTo)
	end

	local serverOutputPath = options.config.serverOutput
	if serverOutputPath then
		local serverLuau = generateServerLuau(options.config, options.generatables)
		local writeTo = pathfs.absolute(options.config.serverOutput :: string)
		table.insert(fmt, writeTo)
		serverLuau.writeFile(writeTo)
	end

	if options.config.typescript then
		-- STUB
	end

	stylua.formatEach(table.unpack(fmt))
end

table.freeze(generator)
return generator
