require '../modules/cpserver.rb'
require '../configure/config.rb'

server = Cpserver.new(getLoginPort, true, getLoginMaxUsers, getSQLhost, getSQLname, getSQLpass, getSQLdb, getSQLtb, 0, 0, getDebug, "")
while true
	server.looper
end