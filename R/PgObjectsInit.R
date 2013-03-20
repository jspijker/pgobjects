

PgObjectsInit <- function(dbname,user=NA,host="localhost",passwd=NA,dbhandle="dbh",schema="public") {

	if(!is.character(dbname)) {
		stop("dsn is not character")
	}

	if(is.na(user)) {
		user=Sys.getenv("LOGNAME")
	}

	if(!is.character(user)) {
		stop("user is not character")
	}

	if(!is.character(host)) {
		stop("hostname is not character")
	}

	if(!is.na(passwd)&&!is.character(passwd)) {
		stop("passwd is not character")
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

