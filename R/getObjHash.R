
getObjHash <- function(name) {

	if(!is.character(name)) {
		stop("name is not character")
	}

	res<-FALSE
	d<-sql(paste("select hash from robjects where
				 name='",name,"'",sep=''))
	if (!is.na(d) && nrow(d)==1) {
		res <- d$hash[1]
	} else {
		res <- NA
	}

	return(res)
}
