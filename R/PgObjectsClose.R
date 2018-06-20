#' Close database connectio object
#'
#' This function closes the database connection opened by
#' \code{\link{PgObjectsInit}}
#'
#' @param handle dbhandle of open connection
#'
#' The dbhandle is retrieved from the R options, usually you don't
#' supply this parameter.
#'
# @export


PgObjectsClose <- function(handle=get(getOption("pgobject.dbhandle"))) {

	res<-dbDisconnect(handle)
	invisible(res)

}

