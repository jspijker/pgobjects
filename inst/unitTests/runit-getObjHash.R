library(RPostgreSQL)
library(localoptions)
library(RCurl)

readOptions("~/.R.options")

test.getObjIdExceptions<-function() {
	checkException(getObjId(1))
}

test.getObjHash<-function() {

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
	res <- getObjHash("test.obj")
	d <- sql("select hash from robjects where name='test.obj'")
	hash <- d$hash[1]

	checkEquals(hash,res)

	# check if NA is retuned when object does not exist
	res <- getObjHash("nonxistentobject")
	checkTrue(is.na(res))

	destroyPgobjTables()
	dbDisconnect(dbh)
}

