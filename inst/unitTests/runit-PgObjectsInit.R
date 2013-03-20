# read localoptions, these options should contain password info:
# make shure the following lines are part of your option file (replace
# options with your own values:
# pgtest.dbname databasename
# pgtest.user username
# pgtest.password password
# pgtest.host hostname

library(localoptions)
readOptions("~/.R.options")

test.PgObjectsInit<-function() {

	#aim: connect to database
	# options: dbname, host=localhost, user=NA, password=NA,
	# dbhandle=dbh, dbschema=public



	checkException(PgObjectsInit(dnname=1))
	checkException(PgObjectsInit(dbname="string",dbhandle=1))
	checkException(PgObjectsInit(dbname="string",host=1))
	checkException(PgObjectsInit(dbname="string",user=1))
	checkException(PgObjectsInit(dbname="string",password=1))
	checkException(PgObjectsInit(dbname="string",schema=1))
	checkException(PgObjectsInit(dbname="string",dbschema=1))


	PgObjectsInit(getOption("pgtest.dbname"))
#	checkIdentical(getOption("pgobject.dbhandle"),"dbh")
#	checkIdentical(getOption("pgobject.schema"),"public")
#	checkIdentical(getOption("pgobject.user"),"postgres")
#
#	PgObjectsInit(Rdsn)
#	user=Sys.getenv("LOGNAME")
#	checkIdentical(getOption("pgobject.user"),user)
#
#
#	PgObjectsInit(Rdsn,dbhandle="testdbhandle",schema="testschema")
##	checkIdentical(getOption("pgobject.dbhandle"),"testdbhandle")
#	checkIdentical(getOption("pgobject.schema"),"testschema")
#	checkIdentical(exists("testdbhandle"),TRUE)
#	checkIdentical(class(testdbhandle),"RODBC")

	#odbcCloseAll()
}


