
getObjId <- function(name) {

	if(!is.character(name)) {
		stop("name is not character")
	}

	res<-FALSE
	d<-sql(paste("select id from robjects where
				 name='",name,"'",sep=''))
	if (nrow(d)==1) {
		res <- d$id[1]
	}
	return(res)
}
