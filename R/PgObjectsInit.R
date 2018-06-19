#' Initialize pgobjects database connection
#'
#' Function to open connection to a database and returns a database handle
#'
#' This function opens a database connection using the postgresql
#' driver. It returns a database handle which is used within other
#' functions of the pgobjects package.
#' 
#' @param dbname Name of the database to connect to
#' @param user Username
#' @param host hostname, default 'localhost'
#' @param passwd Password for the database (if any)
#' @param dbhandle Name of the dbhandle in .Globalenv
#' @param port Portnumber of database, defaults to 5432
#' @param schema Which database schema to use, defaults to 'public'
#' @param chunksize Chunksize, size of individual chunks 
#'
#' @export

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

	# load libraries
	for (libs in c("RPostgreSQL","localoptions",
				   "digest","RCurl","bitops")) {
		if(!require(libs,character.only=TRUE)) {
			stop(paste("library",libs,"not available"))
		}
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

