library(RPostgreSQL)
library(localoptions)
readOptions("~/.R.options")

test.tableExist<-function() {

	PgObjectsInit(dbname=getOption("pgobj.dbname"),
				  passwd=getOption("pgobj.password"))

    table<-"pg_user"

# checK without db connection
    checkException(tableExists(1))
    checkException(tableExists(TRUE))

    checkIdentical(tableExists(table),TRUE)
    checkIdentical(tableExists("ThisTableSurelyDoesNotExist"),FALSE)

	dbDisconnect(dbh)
}




