# --------------------------------------------------------------------------- #
# Project: Connecting to MySQL Database and inserting data                    #
# Author: Guillem Perdigo                                                     #
# Date: 25 Sept 2019                                                          #
# --------------------------------------------------------------------------- #

# Comment with changes made to previous script to show on commit 


# 0. load libraries ####
library(RMariaDB)

# 1. connect to Mysql db ####

# path to the settings file we previously created
rmariadb.settingsfile <-
  "/Users/Guillem/Documents/Ubiqum/Others/MySQL_settings/newspaper_db_settings.cnf"

# connection
rmariadb.db<-"newspaper_search_results"
storiesDb <-
  dbConnect(RMariaDB::MariaDB(),
            default.file = rmariadb.settingsfile,
            group = rmariadb.db)

dbListTables(storiesDb) # this confirms we connected to the database

# 2. inserting 1 single line ####

# assign variables.
entryTitle <- "THE LOST LUSITANIA."
entryPublished <- "21 MAY 1916"

#convert the string value to a date to store it into the database
entryPublishedDate <- as.Date(entryPublished, "%d %B %Y")
entryUrl <- "http://newspapers.library.wales/view/4121281/4121288/94/"
searchTermsSimple <- "German+Submarine"

# create the query statement
query<-paste(
  "INSERT INTO tbl_newspaper_search_results (
  story_title,
  story_date_published,
  story_url,
  search_term_used) 
  VALUES('",entryTitle,"',
  '",entryPublishedDate,"',
  LEFT(RTRIM('",entryUrl,"'),99),
  '",searchTermsSimple,"')",
  sep = ''
  )

print(query) # in case you need to troubleshoot it

# execute the query on the storiesDb that we connected to above.
rsInsert <- dbSendQuery(storiesDb, query)

# clear the result
dbClearResult(rsInsert)

# disconnect to clean up the connection to the database.
dbDisconnect(storiesDb)

# 3. loading csv data to db ####

# csv's have been read & cleaned (script read_sampleCsvData.R)

# connection
rmariadb.db<-"newspaper_search_results"
storiesDb <-
  dbConnect(RMariaDB::MariaDB(),
            default.file = rmariadb.settingsfile,
            group = rmariadb.db)

dbListTables(storiesDb) # this confirms we connected to the database

# load the garden data to the MySQL db
dbWriteTable(
  storiesDb, # the database connection
  value = sampleGardenData, # the dataframe to upload
  row.names = FALSE, # we don't want to upload a column with row indeces
  name = "tbl_newspaper_search_results", # table where we insert data
  append = TRUE # add these values to what is in the table already
)

# load the Submarine data to the MySQL db
dbWriteTable(
  storiesDb,
  value = sampleSubmarineData,
  row.names = FALSE,
  name = "tbl_newspaper_search_results",
  append = TRUE
)

#disconnect to clean up the connection to the database
dbDisconnect(storiesDb)


