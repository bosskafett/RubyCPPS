class Client

	require '../configure/config.rb'

	@parent = nil
	@rndk = ""
	@ip = ""
	@id = 0
	@username = ""
	@loginkey = ""
	@moderator = 0
	@rank = 0
	@connection = nil
	
	@color = 0
	@head = 0
	@face = 0
	@body = 0
	@feet = 0
	@neck = 0
	@hand = 0
	@flag = 0
	@photo = 0
	@coins = 0
	@inventory = ""
	
	@x = 0
	@y = 0
	@frame = 1
	@room = 0
	@mood = "Welcome to RubyCP"
	
	
	def initialize(ip, parent)
		@parent = parent
		@ip = ip
		@rndk = ""
	end
	def getId
		return @id
	end
	def getName
		return @username
	end
	def getIp
		return @ip
	end
	def getModerator
		return @moderator
	end
	def getHead
		return @head
	end
	def getRank
		return @rank
	end
	def getColor
		return @color
	end
	def getFace
		return @face
	end
	def getBody
		return @body
	end
	def getFeet
		return @feet
	end
	def getNeck
		return @neck
	end
	def getHand
		return @hand
	end
	def getFlag
		return @flag
	end
	def getPhoto
		return @photo
	end
	def getCoins
		return @coins
	end
	def getKey
		return @rndk
	end
	def getAge
		return @age
	end
	def getStamps
		return @stamps
	end
	def getInventory
		return @inventory
	end
	def getBuddies
		return @buddies
	end
	def getIgnored
		return @ignored
	end
	def getRoom
		return @room
	end
	def setId(id)
		@id = id
	end 
	def setX(x)
		@x = x
	end
	def setY(y)
		@y = y
	end
	def setKey (key)
		@rndk = key
	end
	def setConnection (connection)
		@connection = connection
	end
	def send (pack)
		pack = pack.concat(0)
		@connection.write(pack)
	end
	def update (field, value)
		@parent.updateUserField(@id, field, value)
	end
	def catField (field, index, value)
		current_field = @parent.getUserField(@id, field, index)
		new_field = current_field + value
		@parent.updateUserField(@id, field, new_field)
		return new_field
	end
	def addItem (id)
		inventory = catField("inventory", 19, "%" + id)
		send("%xt%ai%-1%#{id}%#{@coins}%")
		@inventory = inventory
	end
	def addCoins (coins)
		@coins += coins.to_i
		update("coins", @coins.to_s)
		send("%xt%zo%-1%#{@coins.to_s}%_%_%_%_%")
	end
	def joinRoom(id, x, y)
		id = id.to_i
		if @parent.isDebug() == true
			puts "Joining room #{id}"
		end
		if(id < 899)
			if @parent.getClients(id).count > @parent.getMaxRoomUsers
				send("%xt%e%-1%210%")
			else
				clients = @parent.getClients(id)
				if clients != nil
					@parent.sendGlobal("%xt%rp%-1%#{getId}%")
					@x = x 
					@y = y 
					@room = id 
					jr = "%xt%jr%-1%#{id}%#{getUserString}%"
					clients.each_with_index do |value, key| 
						if clients[key].getRoom == id
							jr = jr + clients[key].getUserString + "%"
						end
					end
					clients.push(self)
					send(jr)
					@parent.setClients(id, clients)
					@parent.sendRoom(id, "%xt%ap%-1%#{getUserString}%")
				end
			end
		else
			send("%xt%e%-1%220%")
		end
	end
	def setup (arr)
		@id = arr[0]
		@username = arr[1]
		@loginkey = arr[4]
		@moderator = arr[5]
		@rank = arr[6]
		@color = arr[7]
		@head = arr[8]
		@face = arr[9]
		@body = arr[10]
		@feet = arr[11]
		@neck = arr[12]
		@hand = arr[13]
		@flag = arr[14]
		@photo = arr[15]
		@coins = arr[16]
		@age = 0
		@stamps = arr[18]
		@inventory = arr[19]
		@buddies = arr[20]
		@ignored = arr[21]
	end
	def getUserString
		str = @id.to_s
		str = str + "|" + @username.to_s
		str = str + "|" + "1"
		str = str + "|" + @color.to_s
		str = str + "|" + @head.to_s
		str = str + "|" + @face.to_s
		str = str + "|" + @neck.to_s
		str = str + "|" + @body.to_s
		str = str + "|" + @hands.to_s
		str = str + "|" + @feet.to_s
		str = str + "|" + @pin.to_s
		str = str + "|" + @photo.to_s
		str = str + "|" + @x.to_s
		str = str + "|" + @y.to_s
		str = str + "|" + @frame.to_s
		str = str + "|" + "1"
		str = str + "|" + @moderator.to_s
		str = str + "|" + "1"
		str = str + "|" + "0"
		str = str + "|" + @mood.to_s
		return str
	end
end