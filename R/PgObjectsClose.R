# close object

PgObjectsClose <- function(handle=get(getOption("pgobject.dbhandle"))) {

	res<-dbDisconnect(handle)
	invisible(res)

}

