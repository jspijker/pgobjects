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
	x<-getObj("test.obj")
	x<-getObjId("test.obj")
	storeKeyval("test.obj",key="key1",val="val1")

	destroyPgobjTables()
	sql("drop schema pgtest CASCADE")
	PgObjectsClose()
}


