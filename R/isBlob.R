isBlob <- function(blob) {

    # test if object is stored as a blob
    # arguments:
    # blob: name of object (or blob)

    if(!is.character(blob)) {
        stop("blob not character")
    }

    if(!objectExists(blob)) {
        stop("blob does not exists")
    }

	res<-sql(paste("select isblob from robjects where name='",blob,"'",sep=""))
    isblob <- ifelse(res$isblob[1],TRUE,FALSE)
    return(isblob)

}
