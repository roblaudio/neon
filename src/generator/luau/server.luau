local LuauOutput = require("./output")
local base = require("./base")
local names = require("../names")
local types = require("../../types")

local function generateServerLuau(config: types.Configuration, generatable: { types.Generatable }): types.Output
	local function cased(name: keyof<typeof(names.NAMES)>)
		return names.cased(config.case, name)
	end

	local output = LuauOutput()

	local function document(comment: string)
		if config.document then
			output.pushLine("--- " .. comment)
		end
	end

	-- stylua: ignore
	output
		.pushHeader("Server")
		.pushLine(base)
		.pushLine("if not RunService:IsServer() then")
		.pushLine('error("[neon] cannot use server module from the client")')
		.pushLine("end")
		.pushNewLine()
		-- Remote creation
        .pushLine(`local remotes = ReplicatedStorage:FindFirstChild("{config.remoteFolderName}")`)
  		.pushLine("if remotes == nil then")
  		.pushLine('remotes = Instance.new("Folder")')
  		.pushLine(`remotes.Name = "{config.remoteFolderName}"`)
  		.pushLine("remotes.Parent = ReplicatedStorage")
  		.pushLine("end")
        .pushNewLine()
        .pushLine(`local reliable = remotes:FindFirstChild("{config.remoteFolderName}_Reliable")`)
        .pushLine("if reliable == nil then")
        .pushLine('reliable = Instance.new("RemoteEvent")')
   	    .pushLine(`reliable.Name = "{config.remoteFolderName}_Reliable"`)
   	    .pushLine("reliable.Parent = remotes")
   	    .pushLine("end")
        .pushNewLine()
        .pushLine(`local unreliable = remotes:FindFirstChild("{config.remoteFolderName}_Unreliable")`)
        .pushLine(`if unreliable == nil then`)
        .pushLine('unreliable = Instance.new("UnreliableRemoteEvent")')
        .pushLine(`unreliable.Name = "{config.remoteFolderName}_Unreliable"`)
        .pushLine("unreliable.Parent = remotes")
        .pushLine("end")
        .pushNewLine()
        -- Players
        .pushLine('local Players = game:GetService("Players")')
        .pushNewLine()
        .pushLine("local players = {}")
        .pushLine("local function loadPlayer(player: Player)")
        .pushLine("if players[player] then")
        .pushLine("load(players[player])")
        .pushLine("else")
        .pushLine("loadEmpty()")
        .pushLine("end")
        .pushLine("end")
        .pushNewLine()
        .pushLine("Players.PlayerRemoving:Connect(function(player)")
        .pushLine("players[player] = nil")
        .pushLine("end)")
        .pushNewLine()
        -- Event handler
        .pushLine(`local events = table.create({#generatable})`)
        .pushLine(`local function {cased("sendEvents")}()`)
        .pushLine("     for player, outgoing in players do")
        .pushLine("          if outgoing.used > 0 then")
        .pushLine("                local buff = buffer.create(outgoing.used)")
		.pushLine("                buffer.copy(buff, 0, outgoing.buff, 0, outgoing.used)")
		.pushLine("                reliable:FireClient(player, buff, outgoing.inst)")
		.pushLine("                outgoing.buff = buffer.create(64)")
		.pushLine("                outgoing.used = 0")
		.pushLine("                outgoing.size = 64")
		.pushLine("                table.clear(outgoing.inst)")
        .pushLine("          end")
        .pushLine("     end")
        .pushLine("end")
        .pushLine("")
        .pushLine(`RunService.PreSimulation:Connect({cased("sendEvents")})`)
        .pushLine([[
            reliable.OnServerEvent:Connect(function(player, buff, inst)
               	incomingBuff = buff
               	incomingInst = inst
               	incomingRead = 0
               	incomingIpos = 0
               	local len = buffer.len(buff)
               	while incoming_read < len do
              		local id = buffer.readu8(buff, read(1))
              		if id == 1 then
             			local call_id = buffer.readu8(buff, read(1))
             			local value
             			if events[1] then
            				task.spawn(function(player2, callId2, value1)
           					local rets = events[1](player2, value1)
           					loadPlayer(player2)
           					alloc(1)
           					buffer.writeu8(outgoingBuff, outgoingApos, 1)
           					alloc(1)
           					buffer.writeu8(outgoingBuff, outgoingApos, callId2)
           					alloc(1)
           					buffer.writeu8(outgoingBuff, outgoingApos, rets and 1 or 0)
           					players[player2] = save()
            				end, player, callId, value)
             			end
              		else
             			error("[neon] unknown event id")
              		end
               	end
            end)
        ]])
        .pushNewLine()
		.pushLine("return table.freeze {")
		.pushLine(`{cased("sendEvents")} = {cased("sendEvents")},`)

	for _, gen in generatable do
		if gen.type == "remote" then
			output.pushLine(`{gen.name} = table.freeze \{`)

			if gen.kind == "event" then
				if gen.from == "server" then
					document("")
					output.pushLine(`{cased("fire")} = function()`)
					output.pushLine("end,")

					document("")
					output.pushLine(`{cased("fireAll")} = function()`)
					output.pushLine("end,")

					document("")
					output.pushLine(`{cased("fireExcept")} = function()`)
					output.pushLine("end,")

					document("")
					output.pushLine(`{cased("fireList")} = function()`)
					output.pushLine("end,")
				else
					document("")
					output.pushLine(`{cased("on")} = function()`)
					output.pushLine("end,")
				end
			else
				document("")
				output.pushLine(`{cased("setCallback")} = function()`)
				output.pushLine("end,")
			end

			output.pushLine("},")
		end
	end

	output.pushLine("}")
	return output
end

return generateServerLuau
