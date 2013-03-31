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
	if(tableExists("public.robjects")||
	   tableExists("runitPgobj.robjects")) {
		stop("test tables already exists, clean up database")
	}

	sql("abort")
	# test create
	createPgobjTables()
	checkTrue(tableExists("public.robjects"))
	#do not re-create tables if delete=FALSE (default)
    checkException(createPgobjTables())

	#this should not give an error
	createPgobjTables(delete=TRUE)

	destroyPgobjTables()

	# test non-existing schema
    checkException(createPgobjTables(schema="nonexistent"))

	# test other schema
	sql("create schema runitPgobj")
	createPgobjTables(schema="runitPgobj")
	checkTrue(tableExists("runitPgobj.robjects"))

	sql("drop schema runitPgobj cascade")

}





