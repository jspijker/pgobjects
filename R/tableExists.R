tableExists <- function(table){
	# function checks if table exists, returns TRUE if so, FALSE if
	# otherwise

	# check input
	if(!is.character(table)) {
		stop("table is not character")
	}

    res<-sql(paste("select * from",table,"limit 0"),verbose=TRUE);

    if(is.data.frame(res)) {
        return(TRUE)
    }else {
        return(FALSE)
    }
}



