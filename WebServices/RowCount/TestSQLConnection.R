source('./config.R')
library(RODBC)
cn <- odbcDriverConnect(connection_string)
sql <- "EXEC app.GetData @entity_id = 1"
data <- sqlQuery(cn, sql, errors = TRUE, stringsAsFactors = FALSE)
print(odbcGetErrMsg(cn))
print(nrow(data))
odbcClose(cn)