destroyPgobjTables <- function(schema=getOption("pgobject.schema")) {

	if(!is.character(schema)) {
		stop("schema is not character")
	}

	dropqry<-"
	drop SEQUENCE public.rkeyvalue_seq CASCADE;
	drop TABLE public.rkeyvalue;
	drop SEQUENCE public.rdata_seq CASCADE;
	drop TABLE public.rdata;
	drop SEQUENCE public.robjects_seq CASCADE;
	drop TABLE public.robjects;
	drop SEQUENCE public.did_seq CASCADE;
	"

	qry<-gsub("public",schema,dropqry)
	qry<-gsub("\t"," ",qry)
	qry<-gsub("\n"," ",qry)
	qry <- gsub(" +"," ",qry,perl=TRUE)
	cat("XXXX schema:",schema,"\n")
	sql(qry,verbose=TRUE)

}

createPgobjTables <- function(schema=getOption("pgobject.schema"), delete=FALSE) {

	# flow:

	# test if schema exists, if not, create.

	# test if robjects table already exists, if true and delete==TRUE,
	# delete tables

	# create robjects, use createquery
	# if needed, grant user rights (user must be superuser?)

	if(!is.character(schema)) {
		stop("schema is not character")
	}

	if(!is.logical(delete)) {
		stop("delete is not logical")
	}

	if(tableExists("robjects")){
		if(delete) {
			destroyPgobjTables(schema)
		} else {
			stop("table already exists and delete!=TRUE")
		}
	}


	createqry<-"
	begin;

	CREATE SEQUENCE public.robjects_seq;
	CREATE TABLE public.robjects (
								  id              integer PRIMARY KEY DEFAULT nextval('public.robjects_seq'),
								  did             integer UNIQUE,
								  name            varchar(250) UNIQUE NOT NULL,
								  hash            varchar (40) NOT NULL,
								  time            timestamp DEFAULT NOW(),
								  persistent      boolean DEFAULT 'f',
								  whendelete      timestamp DEFAULT NOW()+'24:00:00'
								  );

	CREATE SEQUENCE public.rdata_seq;
	CREATE TABLE public.rdata (
							   id      integer PRIMARY KEY DEFAULT nextval('public.rdata_seq'),
							   did     integer REFERENCES public.robjects(did),
							   chunk   integer,
							   object  text
							   );

	CREATE SEQUENCE public.did_seq;
	CREATE VIEW public.did as SELECT nextval('public.did_seq') as did;


	CREATE SEQUENCE public.rkeyvalue_seq;
	CREATE TABLE public.rkeyvalue (
								  id            integer PRIMARY KEY DEFAULT nextval('public.rkeyvalue_seq'),
								  did			integer REFERENCES public.robjects(did),	
								  key			varchar(40) NOT NULL,
								  value			varchar(250) NOT NULL
								  );
	commit;
	"

	qry<-gsub("public",schema,createqry)
	qry<-gsub("\t"," ",qry)
	qry<-gsub("\n"," ",qry)
	qry <- gsub(" +"," ",qry,perl=TRUE)

	res <- sql(qry)

	if(!is.null(res)) {
		res <- sql("abort")
		stop("creating of pgobject tables failed")
	}
}




