local process = require("@lune/process")

local pathfs = require("@lune_packages/pathfs")
local semver = require("@luau_packages/semver")

local function assertStylua(minimumVersion: semver.SemverImpl?)
	local styluaProcess = process.spawn("stylua", { "-V" })
	if not styluaProcess.ok then
		error("stylua not found")
	end

	if minimumVersion then
		local styluaVersion = semver
			.parse(styluaProcess.stdout:gsub("^stylua", ""):gsub("%s+", ""))
			:expect("failed to parse stylua version") :: semver.SemverImpl

		if styluaVersion < minimumVersion then
			error(`stylua version out of date, expected minimum {minimumVersion}, got {styluaVersion}`)
		end
	end
end

local stylua = {}

function stylua.batchFormat(...: pathfs.Path)
	assertStylua()

	local paths = {}
	for index = 1, select("#", ...) do
		local path: pathfs.Path = select(index, ...)
		table.insert(paths, path:toString())
	end

	local styluaProcess = process.spawn("stylua", paths)
	if not styluaProcess.ok then
		print(styluaProcess.stderr, styluaProcess.stdout)
	end
end

function stylua.formatEach(...: pathfs.Path)
	assertStylua()

	for index = 1, select("#", ...) do
		local path: pathfs.Path = select(index, ...)
		local styluaProcess = process.spawn("stylua", { path:toString() })
		if not styluaProcess.ok then
			print(styluaProcess.stderr, styluaProcess.stdout)
		end
	end
end

function stylua.formatPath(path: pathfs.Path)
	assertStylua()
	local styluaProcess = process.spawn("stylua", { path:toString() })
	if not styluaProcess.ok then
		print(styluaProcess.stderr, styluaProcess.stdout)
	end
end

table.freeze(stylua)
return stylua
