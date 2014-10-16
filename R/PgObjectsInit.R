

PgObjectsInit <- function(dbname,user=NA,host="localhost",
						  passwd="",dbhandle="dbh",port=5432,
						  schema="public",chunksize=7168) {

	if(!is.character(dbname)) {
		stop("dsn is not character")
	}

	if(is.na(user)) {
		user <- Sys.info()["user"]
	}

	if(!is.character(user)) {
		stop("user is not character")
	}

	if(!is.character(host)) {
		stop("hostname is not character")
	}

	if(!is.character(passwd)) {
		stop("passwd is not character")
	}

	if(!is.character(dbhandle)) {
		stop("dbhandle is not character")
	}
	if(!is.character(schema)) {
		stop("schema is not character")
	}

	if(!is.numeric(chunksize)) {
		stop("chunksize is not numeric")
	}

	if(!is.numeric(port)) {
		stop("port is not numeric")
	}


	# connect:
	drv <- dbDriver("PostgreSQL")
	dbh <- dbConnect(drv,dbname=dbname,user=user,
					 host=host,password=passwd,
					 port=port)

	assign(dbhandle,dbh,envir=.GlobalEnv)

	# test connection

	op <- options()
	options("pgobject.dbhandle"=dbhandle)
	options("pgobject.schema"=schema)
	options("pgobject.user"=user)
	options("pgobject.chunksize"=chunksize)

}

