objectExists <- function(name) {

	if(!is.character(name)) {
		stop("name is not character")
	}

	s <- getOption("pgobject.schema")

	res<-FALSE
	d<-sql(paste("select name from ",s,".robjects where
				 name='",name,"'",sep=''))
	if (nrow(d)>=1) {
		res <- TRUE
	}
	return(res)
}


