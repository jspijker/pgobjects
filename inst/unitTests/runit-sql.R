library(RPostgreSQL)
library(localoptions)
readOptions("~/.R.options")

test.sql<-function() {

	PgObjectsInit(dbname=getOption("pgobj.dbname"),
				  passwd=getOption("pgobj.password"))

# check options
    checkException(sql(1))
    checkException(sql("string",dbhandle=1))
    checkException(sql(query="string",dbhandle=1))
    checkException(sql("string",errors="a"))
    checkException(sql("string",errors=1))
    checkException(sql("string",verbose="a"))
    checkException(sql("string",verbose=1))

	# test valid query
    res<-sql("select 1 as field")
    checkIdentical(as.character(res$field[1]),"1")

	# stest invalid query
    res<-sql("select nonexistingfield from nonexistingtable",
			 verbose=TRUE)
	checkTrue(is.na(res))

	# test ignore DBI warnings
	res<-sql("select * from pg_user limit 0")
	checkTrue(is.data.frame(res))

	# test null query / create table
	res <- sql("drop table public.pgobjtest") # remove table in case it exists
	res <- sql("create table public.pgobjtest (test integer);",verbose=TRUE)
	checkTrue(is.null(res))
	checkTrue(tableExists("public.pgobjtest"))
	res <- sql("drop table public.pgobjtest")
	checkTrue(!tableExists("public.pgobjtest"))


	#close db 
	dbDisconnect(dbh)
}




