library(RPostgreSQL)
library(localoptions)
readOptions("~/.R.options")

test.createPbobjTables <- function() {


	PgObjectsInit(dbname=getOption("pgobj.dbname"),
				  passwd=getOption("pgobj.password"))

# check options
    checkException(createPgobjTables(1))
    checkException(createPgobjTables("string",delete="a"))

	#assumption: tables do not exist

	# test create
	createPgobjTables()
	res<-sql(paste("select * from public.robjects limit 0"),errors=FALSE)
	stopifnot(!is.na(res))
	#do not re-create tables if delete=FALSE (default)
    checkException(createPgobjTables())


	# test non-existing schema
    checkException(createPgobjTables(schema="nonexistent"))

	# test other schema
	sql("create schema runitPgobj")
	createPgobjTables(schema="runitPgobj")
	res<-sql(paste("select * from runitPgobj.robjects limit 0"),
			 errors=FALSE)
	stopifnot(!is.na(res))
	sql("drop schema runitPgobj cascade")


}





