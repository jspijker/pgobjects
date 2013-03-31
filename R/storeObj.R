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

    str<-objToStr(obj);
    chunks<-splitStr(str);

	# test if object already exists
	if (objectExists(name)) {
		if(overwrite) {
			deleteObj(name);
		} else {
			stop("object already exists in database and overwrite=FALSE")
		}
	}

    nextobj<-sql("select did from did")$did;

    qry<-paste("insert into robjects (did,name) values (",
	    nextobj,",'",name,"');",sep='');
    sql(qry,v=verbose);

    if(persistent) {
	sql(paste("update robjects set persistent='t' where name='",
		    name,"';",sep=''),v=verbose);
    }

    if(!is.na(whendelete)) {
	sql(paste("update robjects set whendelete='",whendelete,
		    "' where name='",name,"';",sep=''),v=verbose);
    }

    cat("storing data: ",name,"\n");
    for (i in 1:length(chunks)) {
	str<-chunks[i];
	qry<-paste("insert into rdata (did,object,chunk) values ('",
		nextobj,"','",str,"',",i,");",sep='');
	sql(qry,verbose=verbose);
    }

}

