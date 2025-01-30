export type Case = "camel" | "pascal" | "snake"
export type NameCasing = { camel: string, pascal: string, snake: string }

local function firstToUpper(str: string): string
	return (str:gsub("^%l", string.upper))
end

--- Returns casing conventions from the components of a name. Components are
--- expected to be lowercase.
local function fromComponents(...: string): NameCasing
	local camel = {}
	local pascal = {}

	for index = 1, select("#", ...) do
		local component = select(index, ...)

		local componentUpper = firstToUpper(component)
		table.insert(pascal, componentUpper)

		if index == 1 then
			table.insert(camel, component)
		else
			table.insert(camel, componentUpper)
		end
	end

	return table.freeze {
		camel = table.concat(camel),
		pascal = table.concat(pascal),
		snake = table.concat({ ... }, "_"),
	} :: any
end

---

local NAMES = table.freeze {
	fire = fromComponents("fire"),
	fireAll = fromComponents("fire", "all"),
	fireExcept = fromComponents("fire", "except"),
	fireList = fromComponents("fire", "list"),
	on = fromComponents("on"),
	invoke = fromComponents("invoke"),
	setCallback = fromComponents("set", "callback"),
	sendEvents = fromComponents("send", "events"),
}

---

local names = { NAMES = NAMES, fromComponents = fromComponents }

function names.cased(case: Case, name: keyof<typeof(NAMES)>)
	return (NAMES :: { [any]: any })[name][case]
end

return names
