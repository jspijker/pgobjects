library(RPostgreSQL)
library(localoptions)
readOptions("~/.R.options")

test.tableExist<-function() {

	PgObjectsInit(dbname=getOption("pgobj.dbname"),
				  passwd=getOption("pgobj.password"))



	sql("create table testTableExists (id int);")
    table<-"testTableExists"

# checK without db connection
    checkException(tableExists(1))
    checkException(tableExists(TRUE))

    checkIdentical(tableExists(table),TRUE)
    checkIdentical(tableExists("ThisTableSurelyDoesNotExist"),FALSE)


	sql("drop table testTableExists;")

	dbDisconnect(dbh)
}




