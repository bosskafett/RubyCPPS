class Cpserver
	
	require 'socket'
	require 'securerandom'
	require '../modules/client.rb'
	require '../configure/config.rb'
	require 'digest/md5'
	require '../modules/mysql.rb'
	require '../modules/rooms.rb'
	require '../modules/commands.rb'

	def initialize (port, login, max, sqlhost, sqluser, sqlpass, sqldb, sqltable, roommax, autoroom, debug, cmd_char)
		if login == true 
			game = false 
		else
			game = true
		end
		
		@@mysql 		= MySQLHandler.new(sqlhost, sqluser, sqlpass, sqldb, sqltable)
		@sock 			= TCPServer.open(port)
		@clients 		= []
		@login 			= login
		@port 			= port
		@table 			= sqltable
		@debug 			= debug
		@roommax 		= roommax
		@autoroom 		= autoroom
		@cprooms 		= CpRooms.new()
		@command_char	= cmd_char
		@rooms 			= @cprooms.getFullRoomList()
		@commands		= Commands.new(self)
		
		puts "[START]: CP server running, on port #{port}."
		puts "[LOGIN]: #{login}."
		puts "[ GAME]: #{game}."
		puts "[  MAX]: #{max}."
		puts "[MYSQL]: Connected to MySQL server. Selected database #{sqldb}."
		puts "[ SERV]: Server running and ready."
		puts "#############################"
		puts "##   Developed by Damen    ##"
		puts "## on the Rile5.com Forums ##"
		puts "##       web.i.r.cx        ##"
		puts "##          and...         ##"
		puts "##   Welcome to RubyCP :)  ##"
		puts "#############################"
	end
	def swrite(connection, pack)
		pack = pack.concat(0)
		connection.write(pack)
	end
	def md5(str)
		return Digest::MD5.hexdigest(str)
	end
	def spotlight (str, left, right)
		s1 = str.split(left)
		s2 = s1[1]
		s3 = s2.split(right)
		s4 = s3[0]
		return s4
	end
	def spotset (str, left, right, value)
		s1 = str.split(left)
		s2 = s1[1]
		s3 = s2.split(right)
		s4 = s3[0]
		s4 = value
		c1 = s1[0]
		c2 = s3[1]
		c3 = c1 + left + s4 + right + c2
		return c3
	end
	def flipHash (str)
		return str[16, 16] + str[0, 16]
	end
	def encryptPass (pass, key)
		pass = pass.to_s
		key = key.to_s
		return flipHash(md5(flipHash(pass) + key + 'Y(02.>\'H}t":E1'))
	end
	def encryptLkey (login_key, client)
		return flipHash(md5(login_key + client.getKey)) + login_key;
	end
	def sendGlobal (pack)
		@clients.each_with_index do |value, key| 
			@clients[key].send(pack)
		end
	end
	def sendRoom (room, pack)
		@rooms[0][room]["clients"].each_with_index do |value, key| 
			@rooms[0][room]["clients"][key].send(pack)
		end
	end
	def getRoomList
		return @rooms
	end
	def getClients(id)
		id = id.to_i
		return @rooms[0][id]["clients"]
	end
	def setClients(id, clients)
		@rooms[0][id]["clients"] = clients
	end
	def getMaxRoomUsers
		return @roommax
	end
	def getRoom 
		return @autoroom
	end
	def isDebug
		return @debug
	end
	def updateUserField (id, field, value)
		@@mysql.query("UPDATE ruby_users SET #{@@mysql.escape(field)} = '#{@@mysql.escape(value)}' WHERE id = '#{@@mysql.escape(id)}'");
	end
	def getUserField (id, field, index)
		q = @@mysql.query("SELECT * FROM ruby_users WHERE id = '#{@@mysql.escape(id)}'")
		row = @@mysql.getrow(q)
		return row[index]
	end
	def handleCommand (client, cmd, args)
		return @commands.handleCommand(client, cmd, args)
	end
	def sendToClient (id, name, pack)
		if id == 0
			@clients.each_with_index do |value, key| 
				if @clients[key].getName.upcase == name.upcase 
					@clients[key].send(pack)
					return 1
				end
			end
		else
			@clients.each_with_index do |value, key| 
				if @clients[key].getId == id 
					@clients[key].send(pack)
					return 1
				end
			end
		end
		return 0
	end
	def getId (name)
		q = @@mysql.query("SELECT * FROM ruby_users WHERE username = '#{@@mysql.escape(name)}'")
		row = @@mysql.getrow(q)
		return row[0]
	end

	def looper
		Thread.new(@sock.accept) do |connection|
		puts "Accepting connections from #{connection.peeraddr[2]}"
		if(@clients.count > @max)
			if @debug == true
				puts "[WARNG]: Server has reached the maximum limit of online clients."
			end
			connection.close
		end
		client = Client.new(connection.peeraddr[2],self)
		client.setConnection(connection)
		@clients << client
		begin
			while connection
			incomingData = connection.gets("\0")
			if incomingData != nil
				incomingData = incomingData.chomp
			end
			if @debug == true
				puts "[RECV]: " + incomingData
			end
			if incomingData.include?("policy-file-request")
				swrite(connection, "<cross-domain-policy><allow-access-from domain='*' to-ports='*' /></cross-domain-policy>")
			end
			if incomingData.include?("<body action='verChk'")
          		swrite(connection, "<msg t='sys'><body action='apiOK' r='0'></body></msg>")
          	end
          	if incomingData.include?("<body action='rndK'")
        		rndk = SecureRandom.hex(12)
        		client.setKey(rndk)
        		swrite(connection, "<msg t='sys'><body action='rndK' r='-1'><k>" + rndk + "</k></body></msg>")
        	end
        	if incomingData.include?("<body action='login'")
        		msg = incomingData
        		username = spotlight(msg, "<nick><![CDATA[", "]]></nick>")
        		password = spotlight(msg, "<pword><![CDATA[", "]]></pword>")
        		q = @@mysql.query("SELECT * FROM ruby_users WHERE username = '#{@@mysql.escape(username)}'")
        		num = @@mysql.numrows(q)
        		if num < 1
        			swrite(connection, "%xt%e%-1%100%") # Unknown User
        		else
        			row = @@mysql.getrow(q) # row[2] is the password field. 
        									# If you use a different table structure, modify to the correct key for your password field. 
        									# Commonly iCP's accs key would be 2
        									# Commonly OpenCP's users key would be 3.
        			if row[22] == 0
        				swrite(connection, "%xt%e%-1%603%")	# De-activated / Banned
        				return
        			end
        			client.setup(row)
        			if @login == true
        				hash = encryptPass(row[2].upcase, client.getKey)
        			else
        				login_key = row[4]
        				hash = encryptLkey(login_key, client)
        			end
        			if hash != password
        				swrite(connection, "%xt%e%-1%101%")	# Incorrect Password
        			else
        				# Correct Password
        				swrite(connection, "%xt%l%-1%#{client.getId}%#{md5(client.getKey.reverse)}%0%") # Tell Flash to show the world selection.
        				swrite(connection, "%xt%gs%-1%#{getHost}:#{getGamePort}:Test:3% 3;") # Tell Flash the worlds.
        				if @login == true
        					@@mysql.query("UPDATE ruby_users SET loginkey = '#{@@mysql.escape(md5(client.getKey.reverse))}' WHERE id = '#{@@mysql.escape(client.getId)}'")
        				end
        			end
        		end
        	end
        	if incomingData.include?("%xt%")
        		cmds = incomingData.split("%")
        		cmd = cmds[3]
        		if cmd == "j#js"
        			swrite(connection, "%xt%js%-1%0%1%#{client.getModerator}%0%")
        		end
        		if cmd == "j#jr"
        			if cmds[5].to_i != nil 
        				client.joinRoom(cmds[5].to_i, cmds[6].to_i, cmds[7].to_i)
        			end
        		end
        		if cmd == "i#gi"
        			swrite(connection, "%xt%gps%-1%#{client.getId}%#{client.getStamps}%")
        			swrite(connection, "%xt%glr%-1%3555%")
        			swrite(connection, "%xt%lp%-1%#{client.getUserString.to_s}%#{client.getCoins.to_s}%0%1440%%#{client.getAge.to_s}%4%%%7%")
        			swrite(connection, "%xt%gi%-1%#{client.getInventory}%");
        			client.joinRoom(100, 330, 330)
        		end
        		if cmd == "b#gb"
        			swrite(connection, "%xt%gb%-1%#{client.getBuddies}%");
        		end
        		if cmd == "n#gn"
        			swrite(connection, "%xt%gn%-1%")
        		end
        		if cmd == "l#mst"
        			swrite(connection, "%xt%mst%-1%0%1")
        		end
        		if cmd == "l#mg"
        			swrite(connection, "%xt%mg%-1%")
        		end
        		if cmd == "u#gp"
        			swrite(connection, "%xt%gp%-1%#{client.getUserString}%")
        		end
        		if cmd == "u#sp"
        			client.setX(cmds[5])
        			client.setY(cmds[6])
        			sendRoom(client.getRoom, "%xt%sp%-1%#{client.getId}%#{cmds[5]}%#{cmds[6]}%") 
        		end
        		if cmd == "m#sm"
        			msg = cmds[6];
        			if(msg[0, 1] == @command_char)
        				cmd_char = msg.split(@command_char)
        				cmd_msg = cmd_char[1]
        				cmd_args = cmd_msg.split(" ")
        				show = handleCommand(client, cmd_args[0].upcase, cmd_args)
        			end
        			sendRoom(client.getRoom, "%xt%sm%-1%#{client.getId}%#{cmds[6]}%")
        		end
        		if cmd == "u#se"
        			sendRoom(client.getRoom, "%xt%se%-1%#{client.getId}%#{cmds[5]}%")
        		end
        		if cmd == "u#sj"
        			sendRoom(client.getRoom, "%xt%sj%-1%#{client.getId}%#{cmds[5]}%")
        		end
        		if cmd == "u#sa"
        			sendRoom(client.getRoom, "%xt%sa%-1%#{client.getId}%#{cmds[5]}%")
        		end
        		if cmd == "u#sf"
        			sendRoom(client.getRoom, "%xt%sf%-1%#{client.getId}%#{cmds[5]}%")
        		end
        		if cmd == "u#ss"
        			sendRoom(client.getRoom, "%xt%ss%-1%#{client.getId}%#{cmds[5]}%")
        		end
        		if cmd == "u#sl"
        			sendRoom(client.getRoom, "%xt%sl%-1%#{client.getId}%#{cmds[5]}%")
        		end
        		if cmd == "u#sg"
        			sendRoom(client.getRoom, "%xt%sg%-1%#{client.getId}%#{cmds[5]}%")
        		end
        		if cmd == "u#sma"
        			sendRoom(client.getRoom, "%xt%sma%-1%#{client.getId}%#{cmds[5]}%")
        		end
        		if cmd == "u#h"
        			sendRoom(client.getRoom, "%xt%h%#{cmds[4]}%")
        		end
        		if cmd == "u#se"
        			sendRoom(client.getRoom, "%xt%se%-1%#{client.getId}%#{cmds[5]}%")
        		end
        		if cmd == "s#uph"
        			client.update("head", cmds[5])
        			sendRoom(client.getRoom, "%xt%uph%-1%#{client.getId}%#{cmds[5]}%")
        		end
        		if cmd == "s#upf"
        			client.update("face", cmds[5])
        			sendRoom(client.getRoom, "%xt%upf%-1%#{client.getId}%#{cmds[5]}%")
        		end
        		if cmd == "s#upc"
        			client.update("color", cmds[5])
        			sendRoom(client.getRoom, "%xt%upc%-1%#{client.getId}%#{cmds[5]}%")
        		end
        		if cmd == "s#upn"
        			client.update("neck", cmds[5])
        			sendRoom(client.getRoom, "%xt%upn%-1%#{client.getId}%#{cmds[5]}%")
        		end
        		if cmd == "s#upb"
        			client.update("body", cmds[5])
        			sendRoom(client.getRoom, "%xt%upb%-1%#{client.getId}%#{cmds[5]}%")
        		end
        		if cmd == "s#upa"
        			client.update("hands", cmds[5])
        			sendRoom(client.getRoom, "%xt%upa%-1%#{client.getId}%#{cmds[5]}%")
        		end
        		if cmd == "s#upe"
        			client.update("feet", cmds[5])
        			sendRoom(client.getRoom, "%xt%upe%-1%#{client.getId}%#{cmds[5]}%")
        		end
        		if cmd == "s#upp"
        			client.update("photo", cmds[5])
        			sendRoom(client.getRoom, "%xt%upp%-1%#{client.getId}%#{cmds[5]}%")
        		end
        		if cmd == "s#upl"
        			client.update("flag", cmds[5])
        			sendRoom(client.getRoom, "%xt%upl%-1%#{client.getId}%#{cmds[5]}%")
        		end
        	end
        end
        rescue Exception => e
        	# Displays Error Message
        	puts "#{ e } (#{ e.class })"
        	ensure
        		sendGlobal("%xt%rp%-1%#{client.getId}%")
        		connection.close
        		if @debug == true
        			puts "[CLOSE]: A client has disconnected from the server."
        		end
        	end
        end
    end
end