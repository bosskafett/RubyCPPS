class Commands
	def initialize (parent)
		@parent = parent
	end
	def handleCommand (client, cmd, args)
		if cmd == "AI"
			client.addItem(args[1])
		end
		if cmd == "JR"
			clients = @parent.getClients(args[1])
			if (clients)
				client.joinRoom(args[1], 330, 310)
			end
		end
		if cmd == "AC" # Broken, script can't convert numbers to strings and strings to numbers for some reason.
			#client.addCoins(args[1])
		end
		if cmd == "KICK" # Needs fixing, nothings seems to happen.
			if client.getModerator == true
				@parent.sendToClient(0, args[1], "%xt%e%-1%610%You have been kicked by #{client.getName}.%")
			end
		end
		if cmd == "BAN" # Needs fixing, nothing seems to happen.
			if client.getModerator == true
				id = @parent.getId(args[1])
				@parent.sendToClient(0, args[1], "%xt%e%-1%610%You have been banned by #{client.getName}.%")
				@parent.updateUserField(id, "activated", "0")
			end
		end
		
		return true
	end
end