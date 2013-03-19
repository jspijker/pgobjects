
test.PgObjectsInit<-function() {

	checkException(PgObjectsInit(dsn=1))
	checkException(PgObjectsInit(dsn="string",dbhandle=1))
	checkException(PgObjectsInit(dsn="string",dbhandle="string",schema=1))
	checkException(PgObjectsInit(dsn="string",user=1))
	checkException(PgObjectsInit(dsn="string",user="nonexistentuser"))

	#TODO: how to check if DNS is correct syntax/format?
	#checkException(PgObjectsInit(dsn="SomeMalformedDsn"))

	PgObjectsInit(Rdsn,user="postgres")
	checkIdentical(getOption("pgobject.dbhandle"),"dbh")
	checkIdentical(getOption("pgobject.schema"),"public")
	checkIdentical(getOption("pgobject.user"),"postgres")

	PgObjectsInit(Rdsn)
	user=Sys.getenv("LOGNAME")
	checkIdentical(getOption("pgobject.user"),user)


	PgObjectsInit(Rdsn,dbhandle="testdbhandle",schema="testschema")
	checkIdentical(getOption("pgobject.dbhandle"),"testdbhandle")
	checkIdentical(getOption("pgobject.schema"),"testschema")
	checkIdentical(exists("testdbhandle"),TRUE)
	checkIdentical(class(testdbhandle),"RODBC")

	# close
	# all
	# odbc
	odbcCloseAll()
}


