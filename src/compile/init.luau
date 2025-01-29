local pathfs = require("../../lune_packages/pathfs")
local config = require("../config")
local process = require("@lune/process")

local function compileForClient(outputPath: string, config: config.Configuration, ...: unknown)
	local contents = "-- hey"

	pathfs.File.create(outputPath, contents)
end

local function compileForServer(outputPath: string, config: config.Configuration, ...: unknown)
	local contents = "-- hey"

	pathfs.File.create(outputPath, contents)
end

local function compile(configBuilder: config.ConfigurationBuilder, ...: unknown)
	local config: config.Configuration = configBuilder.config

	if config.clientOutput == config.serverOutput then
		error("NeonConfiguration.clientOutput and NeonConfiguration.serverOutput cannot be the same")
	end

	print("CWD PATH", process.cwd)

	if config.clientOutput then
		compileForClient(process.cwd .. pathfs.pathSeparator .. config.clientOutput, config, ...)
	end

	if config.serverOutput then
		compileForServer(process.cwd .. pathfs.pathSeparator .. config.serverOutput, config, ...)
	end
end

return compile
