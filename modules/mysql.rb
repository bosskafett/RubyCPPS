require 'mysql'
class MySQLHandler
	
	def initialize (host, username, password, database, table)
		@host = host 
		@user = username 
		@pass = password 
		@mydb = database
		@tabl = table
    	@@sql = Mysql.new @host, @user, @pass, @mydb
    end 
    def query (query)
    	return @@sql.query(query)
    end
    def escape (string)
    	return @@sql.escape_string(string)
    end
    def getrow (result)
    	if result.num_rows > 1
    		return 0
    	end
    	myrow = []
    	while row = result.fetch_row do
    		myrow = row
    	end
    	return myrow
    end
    def numrows (result)
    	return result.num_rows
    end
end