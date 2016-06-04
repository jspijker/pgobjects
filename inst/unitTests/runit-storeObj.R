library(RPostgreSQL)
library(localoptions)
library(RCurl)
library(digest)

readOptions("~/.R.options")

# test.storeObjExceptions<-function() {
#check options
#     test.obj <- data.frame(x=rnorm(10),y=rnorm(10))
#     checkException(storeObj(1))
#     checkException(storeObj(1,test.obj))
#     checkException(storeObj("test.obj"))
#     checkException(storeObj("test.obj",test.obj,verbose="a"))
#     checkException(storeObj("test.obj",test.obj,persistent="a"))
#     checkException(storeObj("test.obj",test.obj,whendelete=1))
#     checkException(storeObj("test.obj",test.obj,overwrite="a"))
# }

test.storeObj<-function() {

	PgObjectsInit(dbname=getOption("pgobj.dbname"),
				  passwd=getOption("pgobj.password"))

	test.obj <- data.frame(x=rnorm(10),y=rnorm(10))
	# if tables exists, we don't want to mess with real tables

	sql("abort")
		
	destroyPgobjTables()
	createPgobjTables()

	# check options
	checkException(storeObj(1))
	checkException(storeObj(1,test.obj))
	checkException(storeObj("test.obj"))
	checkException(storeObj("test.obj",test.obj,verbose="a"))
	checkException(storeObj("test.obj",test.obj,verbose=1))
	checkException(storeObj("test.obj",test.obj,persistent="a"))
	checkException(storeObj("test.obj",test.obj,persistent=1))
	checkException(storeObj("test.obj",test.obj,whendelete=1))
	checkException(storeObj("test.obj",test.obj,overwrite="a"))
	checkException(storeObj("test.obj",test.obj,isBlob="a"))

	# check if record exists
	storeObj("test.obj",test.obj)
	res<-sql("select * from robjects where name='test.obj'")
	checkTrue(nrow(res)==1)
	checkIdentical(res$persistent[1],FALSE)
	checkIdentical(res$isblob[1],FALSE)

	# check exception when not to overwrite
	checkException(storeObj("test.obj",test.obj,overwrite=FALSE))

	# check persistent flag (implicit overwrite)
	storeObj("test2.obj",test.obj,persistent=TRUE)
	res<-sql("select * from robjects where name='test2.obj'")
	checkIdentical(res$persistent[1],TRUE)

	destroyPgobjTables()
	dbDisconnect(dbh)
}


