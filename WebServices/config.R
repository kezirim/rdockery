# all data specified below are fictitious
# replace with actual data to use
webserver <- "http://webservicetest.eastus.cloudapp.azure.com:12800"
username <- "my_admin"
password <- "my_p@ssw0rd"
database <- "my_database"
dbuser <- "my_dbuser"
dbpwd  <- "my_dbp@ssw0rd"
connection_string <- sprintf("driver={SQL Server Native Client 11.0};server=0.0.0.0,1433;database=%s;UID=%s;PWD=%s;", database, dbuser, dbpwd)