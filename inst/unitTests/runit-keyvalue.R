library(RPostgreSQL)
library(localoptions)
readOptions("~/.R.options")

test.storeKeyval<-function() {

	PgObjectsInit(dbname=getOption("pgobj.dbname"),
				  passwd=getOption("pgobj.password"))


	# if tables exists, we don't want to mess with real data
	if(!tableExists("robjects")){
		createPgobjTables()
	}
	test.obj <- data.frame(x=rnorm(10),y=rnorm(10))
	storeObj("test",test.obj)
	objid <- getObjId("test")

	# check exceptions

    checkException(storeKeyval(1))
    checkException(storeKeyval("test"))
    checkException(storeKeyval("test","key1"))
    checkException(storeKeyval("test","key1",1))
    checkException(storeKeyval("test",1,"val1"))
    checkException(storeKeyval("test",key="key1",val="val1",overwrite="FALSE"))

	# test overwrite
	storeKeyval("test",key="key1",val="val1")
	checkException(storeKeyval("test",key="key1",val="val2"))
	storeKeyval("test",key="key1",val="val1",overwrite=TRUE)

	# check data
	qry <- paste("select * from rkeyvalue where did=",objid,
				 " and key='key1';",sep='')
	d <- sql(qry)
	checkIdentical(d$val[1],"val1")
	
	storeKeyval("test",key="key2",val="val2",overwrite=FALSE)
	storeKeyval("test",key="key1",val="val3",overwrite=TRUE)
	# check data
	qry <- paste("select * from rkeyvalue where did=",objid,
				 " and key='key1';",sep='')
	d <- sql(qry)
	checkIdentical(d$val[1],"val3")
	qry <- paste("select * from rkeyvalue where did=",objid,
				 " and key='key2';",sep='')
	d <- sql(qry)
	checkIdentical(d$val[1],"val2")
	destroyPgobjTables()
	#close db 
	dbDisconnect(dbh)
}




test.getKeyvalObj <- function() {

	PgObjectsInit(dbname=getOption("pgobj.dbname"),
				  passwd=getOption("pgobj.password"))


	# if tables exists, we don't want to mess with real data
	if(!tableExists("robjects")){
		createPgobjTables()
	}

	test.obj <- data.frame(x=rnorm(10),y=rnorm(10))
	storeObj("test",test.obj,overwrite=TRUE)
	objid <- getObjId("test")
	storeKeyval("test",key="key1",val="val1")
	# check exceptions

    checkException(getKeyvalObj(1))
    checkException(getKeyvalObj("nonexistent"))

	d <- getKeyvalObj("test")
	checkIdentical(d$key[1],"key1")
	checkIdentical(d$val[1],"val1")


	destroyPgobjTables()
	dbDisconnect(dbh)
}

test.getKeyval <- function() {

	PgObjectsInit(dbname=getOption("pgobj.dbname"),
				  passwd=getOption("pgobj.password"))


	# if tables exists, we don't want to mess with real data
	if(!tableExists("robjects")){
		createPgobjTables()
	}

	test.obj <- data.frame(x=rnorm(10),y=rnorm(10))
	storeObj("test",test.obj,overwrite=TRUE)
	objid <- getObjId("test")
	storeKeyval("test",key="key1",val="val1")
	# check exceptions

    checkException(getKeyval(1))
    checkException(getKeyval(1,1))
    checkException(getKeyval(obj="nonexistent",key="key1"))
    checkException(getKeyval(obj="test",key=1))

	d <- getKeyval("test","key1")
	checkIdentical(d,"val1")

	destroyPgobjTables()
	dbDisconnect(dbh)
}



test.getKey <- function() {

	PgObjectsInit(dbname=getOption("pgobj.dbname"),
				  passwd=getOption("pgobj.password"))


	destroyPgobjTables()
	createPgobjTables()

	test.obj <- data.frame(x=rnorm(10),y=rnorm(10))
	storeObj("test",test.obj,overwrite=TRUE)
	objid <- getObjId("test")
	storeKeyval("test",key="key1",val="val1")
	# check exceptions

    checkException(getKey(1))

	test1 <- test2 <- test3 <- test.obj
	storeObj("test1",test1)
	storeKeyval("test1","key1","val1.1")
	storeObj("test2",test3)
	storeKeyval("test2","key1","val2.1")
	storeObj("test3",test3)
	storeKeyval("test3","key1","val3.1")

	d <- getKey("nonexistentKey")
	checkTrue(is.na(d))

	d <- getKey("key1")
	d.sub <- subset(d,obj=="test3")
	checkIdentical(d.sub$key1,"val3.1")

	destroyPgobjTables()
	dbDisconnect(dbh)
}

test.deleteKey <- function() {

	PgObjectsInit(dbname=getOption("pgobj.dbname"),
				  passwd=getOption("pgobj.password"))


	# if tables exists, we don't want to mess with real data
	destroyPgobjTables()
	createPgobjTables()

	test.obj <- data.frame(x=rnorm(10),y=rnorm(10))
	storeObj("test",test.obj)
	objid <- getObjId("test")
	storeKeyval("test",key="key1",val="val1")
	storeKeyval("test",key="key2",val="val2")
	# check exceptions

    checkException(deleteKey(1))
    checkException(deleteKey("test",1))
    checkException(deleteKey(1,"key1"))

	d <- getKeyvalObj("test")
	checkTrue(nrow(d)==2)
	deleteKey("test","key1")
	d <- getKeyvalObj("test")
	checkTrue(nrow(d)==1)


	destroyPgobjTables()
	dbDisconnect(dbh)
}


test.deleteKeyObj <- function() {

	PgObjectsInit(dbname=getOption("pgobj.dbname"),
				  passwd=getOption("pgobj.password"))


	# if tables exists, we don't want to mess with real data
	destroyPgobjTables()
	createPgobjTables()

	test.obj <- data.frame(x=rnorm(10),y=rnorm(10))
	storeObj("test",test.obj)
	objid <- getObjId("test")
	storeKeyval("test",key="key1",val="val1")
	storeKeyval("test",key="key2",val="val2")
	storeKeyval("test",key="key3",val="val3")
	# check exceptions

    checkException(deleteKeyObj(1))

	d <- getKeyvalObj("test")
	checkTrue(nrow(d)==3)
	deleteKeyObj("test")
	d <- getKeyvalObj("test")
	checkTrue(nrow(d)==0)


	destroyPgobjTables()
	dbDisconnect(dbh)
}





