require '../modules/cpserver.rb'
require '../configure/config.rb'

server = Cpserver.new(getGamePort, false, getGameMaxUsers, getSQLhost, getSQLname, getSQLpass, getSQLdb, getSQLtb, getMaxInRoom, getRoom, getDebug, getCommand)
while true
	server.looper
end