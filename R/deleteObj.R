
deleteObj <- function(name) {

	if(!is.character(name)) {
		stop("name is not character")
	}

    if(!objectExists(name)) {
	return();
    }

	s <- getOption("pgobject.schema")
    #did<-sql(paste("select did from ",s,".robjects where name='",
	#			   name, "'",sep=''))$did;
	did <- getObjId(name)
	deleteKeyObj(name)

    qry<-paste("delete from ",s,".rdata where did=",did,sep='');
    qry<-paste(qry,";\n","delete from ",s,".robjects where name='",
	    name,"'",sep='');
    sql(qry);
}

