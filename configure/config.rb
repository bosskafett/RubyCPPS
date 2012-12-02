################################
##      Credits to Damen      ##
##      Rile5.com Forums      ##
##         web.i.r.cx         ##
################################

@login_port 		= 	6112	# Login Server Port
@game_port 			= 	4401	# Game Server Port

@max_game_users 	= 	1500	# Maximum Clients on Game Server
@max_login_users 	= 	2500	# Maximum Clients on Login Server
@max_in_room		=	100		# Maximum Clients in one room
@auto_room			=	100		# Default Room to Join
@command			=	"!"		# The Character that commands start with

@mysql_host			= 	"localhost"			# MySQL Server Host
@mysql_username		=	"username_here"		# MySQL Login Username
@mysql_password		=	"12344567881011"	# MySQL Login Password
@mysql_database		=	"rubycp"			# MySQL Database
@mysql_table		=	"ruby_users"		# MySQL Table

@config_host		=	"127.0.0.1"			# Host
@debug_mode			=	false				# Enable/Disable message tracing

def getHost 
	return @config_host
end
def getGamePort
	return @game_port
end
def getLoginPort
	return @login_port
end
def getGameMaxUsers
	return @max_game_users
end
def getLoginMaxUsers
	return @max_login_users
end
def getSQLhost
	return @mysql_host
end
def getSQLname
	return @mysql_username
end
def getSQLpass
	return @mysql_password
end
def getSQLdb
	return @mysql_database
end
def getSQLtb
	return @mysql_table
end
def getRoom
	return @auto_room
end
def getMaxInRoom
	return @max_in_room
end
def getDebug
	return @debug_mode
end
def getCommand
	return @command
end