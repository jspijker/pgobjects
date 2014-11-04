pgobjects
=========

R package to store R objects (including functions, environments etc) into a PostgreSQL database.

This packages makes it possible to store a object into a postgres
database. For example large datasets, like data.frames or lists can be
stored into the database. From this database the datasets can be shared 
between other users, machines or projects.

This package also contains functions to connect to a database and an
user friendly interface to SQL queries.

This package is a rewrite from scratch of an older (unpublished) package, which is
already working fine (i.e. works for me) for several years.

Please note: this is work in progress, do not expect a functional
package yet.



code example
============

```R
# create object:
x <- data.frame(rnorm(100),rnorm(100))

# store object to database
StoreObjToDb("x.data.frame",x)

# get opject from database, assign to 'y'
y <- GetObFromDb("x.data.frame")
```


LICENCE and COPYRIGHT
=====================

Copyright (C) 2013 Vectrun (vectrun at gmail dot com)

pgobjects is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or (at
your option) any later version.

pgobjects is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with localoptions.  If not, see <http://www.gnu.org/licenses/>.

See Licence.txt for full licence.


