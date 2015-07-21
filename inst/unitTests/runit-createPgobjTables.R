library(RPostgreSQL)
library(localoptions)
readOptions("~/.R.options")

test.createPgobjTables <- function() {


	PgObjectsInit(dbname=getOption("pgobj.dbname"),
				  passwd=getOption("pgobj.password"))

# check options
    checkException(createPgobjTables(1))
    checkException(createPgobjTables("string",delete="a"))
    checkException(destroyPgobjTables(1))

	# if tables exists, we don't want to destroy real tables
	if(tableExists("robjects")) {
		destroyPgobjTables()
	}

	sql("abort")
	# test create
	createPgobjTables()
	checkTrue(tableExists("robjects"))
	#do not re-create tables if delete=FALSE (default)
    checkException(createPgobjTables())

	#this should not give an error
	createPgobjTables(delete=TRUE)

	destroyPgobjTables()

	# test non-existing schema
    checkException(createPgobjTables(schema="nonexistent"))

	# test other schema
	sql("create schema runitPgobj")

	options("pgobject.schema"="runitPgobj")
	createPgobjTables()
	checkTrue(tableExists("robjects"))

	sql("drop schema runitPgobj cascade")
	dbDisconnect(dbh)
	options("pgobject.schema"="public")
}


