local semver = require("@luau_packages/semver")

return table.freeze({
	version = semver.parse(_G.NEON_VERSION :: string? or "0.0.0"):expect("unable to parse neon version") :: semver.SemverImpl,
})
