objectExists <- function(name) {

	if(!is.character(name)) {
		stop("name is not character")
	}

	res<-FALSE
	d<-sql(paste("select name from robjects where
				 name='",name,"'",sep=''))
	if (nrow(d)>=1) {
		res <- TRUE
	}
	return(res)
}


