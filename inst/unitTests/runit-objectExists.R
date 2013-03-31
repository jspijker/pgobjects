library(RPostgreSQL)
library(localoptions)
library(RCurl)

readOptions("~/.R.options")

test.objectExists.exceptions<-function() {
	checkException(objectExists(1))
}

test.objectExists<-function() {

	PgObjectsInit(dbname=getOption("pgobj.dbname"),
				  passwd=getOption("pgobj.password"))


	# if tables exists, we don't want to mess with real data
	if(tableExists("public.robjects")){
		destroyPgobjTables()
	}

	sql("abort")
	# test create
	createPgobjTables()

	test.obj <- data.frame(x=rnorm(10),y=rnorm(10))
	checkTrue(!objectExists("test.obj"))
	storeObj("test.obj",test.obj)
	checkTrue(objectExists("test.obj"))

	destroyPgobjTables()
	dbDisconnect(dbh)
}

