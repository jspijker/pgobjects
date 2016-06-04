library(RPostgreSQL)
library(localoptions)
library(RCurl)

readOptions("~/.R.options")

test.isBlob.exceptions <- function() {
    checkException(isBlob(1))
    checkException(isBlob("nonexistingobject"))

}

test.isBlob <- function() {

	PgObjectsInit(dbname=getOption("pgobj.dbname"),
				  passwd=getOption("pgobj.password"))


	# if tables exists, we don't want to mess with real data
	if(tableExists("robjects")){
		destroyPgobjTables()
	}

	sql("abort")
	# test create
	createPgobjTables()

	test.obj <- data.frame(x=rnorm(10),y=rnorm(10))
	storeObj("test.obj",test.obj,isblob=TRUE)
	checkTrue(isBlob("test.obj"))

	destroyPgobjTables()
	dbDisconnect(dbh)

}

