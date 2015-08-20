splitStr <- function(str,chunksize=getOption("pgobject.chunksize")) {

    s<-chunksize;
    n<-nchar(str);
    chunks<-n/floor(s);
    splitlst<-list()
    for (i in 0:chunks) {
	i1<-i*s+1;
	i2<-(i+1)*s
	chunk<-substr(str,i1,i2);
	splitlst[i+1]<-chunk;
    }
    return(splitlst);
}


objToStr <- function(obj) {
    str<-rawToChar(serialize(obj,NULL,ascii=TRUE));
    str<-base64(str,encode=T)[1];
    return(str);
}

storeObj <- function(name,obj,verbose=FALSE,persistent=FALSE,
	whendelete=NA,overwrite=TRUE) {

	if(!is.character(name)) {
		stop("name is not character")
	}

	if(!is.logical(verbose)) {
		stop("verbose is not logical")
	}
	if(!is.logical(persistent)) {
		stop("persistent is not logical")
	}

	if(!is.logical(overwrite)) {
		stop("overwrite is not logical")
	}

	if(!is.na(whendelete)&&!is.character(whendelete)) {
		stop("whendelete is not character")
	}

	s <- getOption("pgobject.schema")


	hash <- digest(obj)

    	# test if object already exists
	if (objectExists(name)) {
		if(overwrite) {
			dbhash <- getObjHash(name)
			if(dbhash==hash) {
				cat("not storing data, object already in database\n")
				return()
			} else {
				deleteObj(name)
			}
		} else {
			stop("object already exists in database and overwrite=FALSE")
		}
	}

	str<-objToStr(obj);
    chunks<-splitStr(str);

    nextobj<-sql(paste("select did from ",s,".did;",sep=''))$did;

    qry<-paste("insert into ",s,".robjects (did,name,hash) values (",
	    nextobj,",'",name,"','",hash,"');",sep='');
    res <- sql(qry,verbose=verbose);

	if(!is.null(res)&&is.na(res)) {
		stop("query returned error")
	}

	if(persistent) {
		sql(paste("update ",s,".robjects set persistent='t' where name='",
				  name,"';",sep=''),verbose=verbose);
	}

    if(!is.na(whendelete)) {
	sql(paste("update ",s,".robjects set whendelete='",whendelete,
		    "' where name='",name,"';",sep=''),verbose=verbose);
    }

	cat("storing data: ",name,"\n");
	for (i in 1:length(chunks)) {
		str<-chunks[i];
		qry<-paste("insert into ",s,".rdata (did,object,chunk) values ('",
				   nextobj,"','",str,"',",i,");",sep='');
		sql(qry,verbose=verbose);
	}

}

