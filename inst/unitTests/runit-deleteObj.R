library(RPostgreSQL)
library(localoptions)
library(RCurl)
library(digest)

readOptions("~/.R.options")

test.deleteObj.exceptions<-function() {
	checkException(deleteObj(1))
}

test.deleteObj<-function() {

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
	checkTrue(!objectExists("test.obj"))
	storeObj("test.obj",test.obj)
	checkTrue(objectExists("test.obj"))
	deleteObj("test.obj")
	checkTrue(!objectExists("test.obj"))

	storeObj("test2.obj",test.obj)
	storeKeyval(obj="test2.obj",key="key1",val="val1")
	did <- getObjId("test2.obj")
	deleteObj("test2.obj")
	d <- sql(paste("select * from rkeyvalue where did=",did,sep=''))
	checkTrue(nrow(d)==0)
	

	destroyPgobjTables()
	dbDisconnect(dbh)
}

