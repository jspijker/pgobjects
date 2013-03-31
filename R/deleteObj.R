
deleteObj <- function(name) {

	if(!is.character(name)) {
		stop("name is not character")
	}

    if(!objectExists(name)) {
	return();
    }

    did<-sql(paste("select did from robjects where name='",name,
	    "'",sep=''))$did;
    qry<-paste("delete from rdata where did=",did,sep='');
    qry<-paste(qry,";\n","delete from robjects where name='",
	    name,"'",sep='');
    sql(qry);
}

