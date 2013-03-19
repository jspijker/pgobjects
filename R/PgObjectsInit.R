
PgObjectsInit <- function(dsn,user=NA,dbhandle="dbh",schema="public") {

	if(is.na(user)) {
		user=Sys.getenv("LOGNAME")
	}

	if(!is.character(user)) {
		stop("user is not character")
	}

	if(!is.character(dsn)) {
		stop("dsn is not character")
	}

	if(!is.character(dbhandle)) {
		stop("dbhandle is not character")
	}
	if(!is.character(schema)) {
		stop("schema is not character")
	}

	# connect:

	# try(odbcCloseAll())
	# assign(dbhandle,odbcConnect(Rdsn),envir=.GlobalEnv)

	# test connection

	op <- options()
	options("pgobject.dbhandle"=dbhandle)
	options("pgobject.schema"=schema)
	options("pgobject.user"=user)

}


