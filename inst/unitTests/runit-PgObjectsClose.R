# test

library(RPostgreSQL)
library(localoptions)
readOptions("~/.R.options")

test.PgObjectsClose<-function() {



	PgObjectsInit(dbname=getOption("pgobj.dbname"),
				  passwd=getOption("pgobj.password"))

	#test connection
	tab <- dbListTables(dbh)
	checkTrue(is.character(tab))
	PgObjectsClose()
	checkException(dbListTables(dbh))
	
}
