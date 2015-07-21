
getObjId <- function(name) {

	if(!is.character(name)) {
		stop("name is not character")
	}

	s <- getOption("pgobject.schema")
	res<-FALSE
	d<-sql(paste("select id from ",s,".robjects where name='",
				 name,"'",sep=''))
	if (!is.na(d) && nrow(d)==1) {
		res <- d$id[1]
	} else {
		res <- NA
	}
	return(res)
}
