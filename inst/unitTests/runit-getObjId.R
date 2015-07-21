library(RPostgreSQL)
library(localoptions)
library(RCurl)

readOptions("~/.R.options")

test.getObjIdExceptions<-function() {
	checkException(getObjId(1))
}

test.getObjId<-function() {

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
	res <- getObjId("test.obj")
	d <- sql("select id from robjects where name='test.obj'")
	id <- d$id[1]

	checkEquals(id,res)

	# check if function returns NA in case of non existing obj
	res <- getObjId("nonexistentobject")
	checkTrue(is.na(res))

	destroyPgobjTables()
	dbDisconnect(dbh)
}

