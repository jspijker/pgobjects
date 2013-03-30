sql <- function(query,verbose=FALSE,errors=TRUE, dbhandle=NA) {
	# this function is the workhorse of the pgobjects library, it runs
	# sql queries at the RDBMS and returns the result.
	# verbose: verbose messages
	# errors: if true, do some error handling, if false just return
	# error
	# dbhandle: name of database handle, must exist in .GlobalEnv


	# check dbhandle
	if(is.na(dbhandle)) {
		dbhandle=getOption("pgobject.dbhandle")
		if(is.null(dbhandle)) {
			stop("option pgobject.dbhandle does not exist (forgot
				PgobjectsInit?)")
		}
	} else {
		if (!is.character(dbhandle)) {
			stop("dbhandle is not character")
		}
	}


	# make global dbhandle local
	ldbh<-eval(parse(text=dbhandle))

	# check input, barf if necessary
	if (!is.character(query)) {
		stop("query is not character")
	}

	if (!is.numeric(dbGetInfo(ldbh)$backendPId)) {
		stop("dbhandle is not valid")
	}
	if (!is.logical(verbose)) {
		stop("verbose is not logical")
	}
	if (!is.logical(errors)) {
		stop("error is not logical")
	}

	if (verbose) {
		cat("Executing SQL: ",query,"\n")
	}

	#if query returns error we return NULL
	qry <- tryCatch(dbSendQuery(ldbh,query),
					error=function(w) return(NULL))

	if(!is.null(qry)) {
		# query is ok (but we ignore drivers warnings)
		res <- fetch(qry,n=-1)
	} else {
		# query returned error
		res <- NA
	}

	invisible (res)

}


