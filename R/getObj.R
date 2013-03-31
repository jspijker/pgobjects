unSplitStr <-
function(splitlst) {
    str<-paste(splitlst,collapse="")
    return(str)
}


strToObj <- function(str) {
    str<-base64(str,encode=F);
    obj<-unserialize(charToRaw(str));
    return(obj);
}


getObj <- function(name) {

	if(!objectExists(name)) {
		msg<-paste("GetObjFromDb: object",name,"not found, stop.")
		stop(msg)
	}

    did<-sql(paste("select did from robjects where name='",name,
	    "'",sep=''))$did

    qry<-paste("select chunk, object from rdata where did=",
	    did," order by chunk",sep='')
    d<-sql(qry)


    d<-unSplitStr(d$object)
    d<-strToObj(d)
    return(d)
}

