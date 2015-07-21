library(RPostgreSQL)
library(localoptions)
library(RCurl)

readOptions("~/.R.options")

test.getObjExceptions<-function() {
	checkException(getObj(1))
}

test.getObj<-function() {

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
	storeObj("test.obj",test.obj)
	res <- getObj("test.obj")
	checkEquals(test.obj,res)

	destroyPgobjTables()
	dbDisconnect(dbh)
}

