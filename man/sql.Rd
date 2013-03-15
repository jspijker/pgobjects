\name{sql}
\alias{sql}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{sql, run queries}
\description{
    sql executes queries on the database and returns the result
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
sql(query, verbose = FALSE, errors = TRUE,dbhandle=db.con)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{query}{
      the sql query
}
  \item{verbose}{
      be verbose
}
  \item{errors}{
      should errors be printed
}
  \item{dbhandle}{
      database handle from odbcConnect
%%     ~~Describe \code{errors} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

%% Add one or more standard keywords, see file 'KEYWORDS' in the
%% R documentation directory.

\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
