storeKeyval <- function(obj,key,val,overwrite=FALSE) {
	# stores a key, value pair for specific object
	# obj: name of object
	# key: name of key
	# value: value of key

	if (!is.character(obj)) {
		stop("obj is not character")
	}

	if (!is.character(key)) {
		stop("key is not character")
	}

	if (!is.character(val)) {
		stop("val is not character")
	}

	if (!is.logical(overwrite)) {
		stop("overwrite is not logical")
	}

	# get did
	did <- getObjId(obj)
	# schema
	s <- getOption("pgobject.schema")

	if(is.na(did)) {
		stop(paste("object",obj,"not found"))
	}

	# check if key exists
	qry <- paste ("select key,value from ",s,".rkeyvalue where did=",did,
				  "and key='",key,"';",sep='');
	d <- sql(qry)
	if(nrow(d)==0) {
	qry <- paste("insert into ",s,".rkeyvalue (did,key,value) values ('"
				 ,did,"','",key,"','",val,"');",sep='')
	print(qry)
	sql(qry)
	} else {
		if(overwrite) {
			qry <- paste("update ",s,".rkeyvalue set value='",val,
						 "' where did=",did,";",sep='')
			print(qry)
			sql(qry)
		} else {
			stop(paste("key",key,
					   "already exists and overwrite=FALSE"))
		}
	}
}

getKeyvalObj <- function(obj) {
	# get specific key, value pair for object
	# obj: object name

	if (!is.character(obj)) {
		stop("obj is not character")
	}

	# get did
	did <- getObjId(obj)

	# schema
	s <- getOption("pgobject.schema")

	if(is.na(did)) {
		stop(paste("object",obj,"not found"))
	}

	qry <- paste("select key,value from ",s,".rkeyvalue where did=",
				 did,";",sep='')
	d<-sql(qry)
	return(d)
}


getKeyval <- function(obj,key) {
	# get value for specific key, object
	# obj: object name
	# key: key name

	if (!is.character(obj)) {
		stop("obj is not character")
	}

	if (!is.character(key)) {
		stop("key is not character")
	}

	d<-getKeyvalObj(obj);
	okey <- key
	d2 <- subset(d,key==okey)$val[1]
	return(d2)
}

getKey <- function(key) {
	# get for all objects with 'key'  the value of 'key'
	# key: key name

	if (!is.character(key)) {
		stop("key is not character")
	}

	# get schema
	s <- getOption("pgobject.schema")

	qry <- paste("select did from ",s,".rkeyvalue where key='",
				 key,"';",sep='')
	print(qry)
	d <- sql(qry)
	if(nrow(d)==0) {
		return(NA)
	}

	onames <- data.frame()
	for (i in d$did) {
		qry <- paste("select name,value from
					 ",s,".robjects,",s,".rkeyvalue where ",
					 s,".robjects.did=", i," and ",s,".rkeyvalue.did=",i,
					 "and key='",key,"';",sep='')
		name <- sql(qry)
		onames <- rbind(onames,name)
	}
		
	names(onames) <- c("obj",key)
	return(onames)
}


deleteKey <- function(obj,key) {
	# delete specific key for obj
	# obj: object name
	# key: key

	if (!is.character(obj)) {
		stop("obj is not character")
	}

	if (!is.character(key)) {
		stop("key is not character")
	}

	s <- getOption("pgobject.schema")
	did <- getObjId(obj)
	# check if key exists
	d <- getKeyval(obj,key)
	if(length(d)==0) {
		warning(paste("key",key,"does not exists"))
	} else {
		qry <- paste("delete from ",s,".rkeyvalue where key='",
					 key, "' and did=",did,";",sep='')
					 sql(qry)
	}
}

deleteKeyObj <- function(obj) {
	# delete all keys for object
	# obj: object name


	if (!is.character(obj)) {
		stop("obj is not character")
	}

	keys <- getKeyvalObj(obj)
	for (i in keys$key) {
		deleteKey(obj,i)
	}
}


