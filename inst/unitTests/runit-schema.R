# test for other db schemas then 'public'

library(RPostgreSQL)
library(localoptions)
library(RCurl)
library(digest)

readOptions("~/.R.options")

test.schema<-function() {

	# make sure we have sane db

	PgObjectsInit(dbname=getOption("pgobj.dbname"),
				  passwd=getOption("pgobj.password"))
	destroyPgobjTables()
	PgObjectsClose()

	PgObjectsInit(dbname=getOption("pgobj.dbname"),
				  passwd=getOption("pgobj.password"),
				  schema='pgtest')
	sql("create schema pgtest;")
	createPgobjTables(delete=TRUE)

	test.obj <- data.frame(x=rnorm(10),y=rnorm(10))
	# if tables exists, we don't want to mess with real tables


	# check options
	storeObj("test.obj",test.obj)
	checkTrue(objectExists("test.obj"))
	x<-getObj("test.obj")
	checkEquals(x,test.obj)
	x<-getObjId("test.obj")
	checkTrue(is.numeric(x))
	storeKeyval("test.obj",key="key1",val="val1")
	x <- getKeyval(obj="test.obj",key="key1")
	checkTrue(x=="val1")
	getKeyvalObj(obj="test.obj")
	getKey(key="key1")
	x <- getObjHash("test.obj")
	deleteObj("test.obj")
	x <- objectExists("test.obj")
	checkTrue(!x)

	storeObj("test2.obj",test.obj,isblob=TRUE)
	x <- isBlob("test2.obj")
	checkTrue(x)


	destroyPgobjTables()
	sql("drop schema pgtest CASCADE")
	PgObjectsClose()
}


