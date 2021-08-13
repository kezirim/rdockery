library(mrsdeploy)
source('./config.R')
source('./RowCount/serviceConfig.R')

# login to remote R server
remoteLogin(webserver,
            username = username,
            password = password)

pause()

rowCount <- function(connection_string, entity_id){
    library(RODBCext)

    # init row count
    row_count <- 0
    status <- "N/A"
    status <- tryCatch({
        # establish connection
        cn <- odbcDriverConnect(connection_string)

        # create and execute a query
        sql <-  sprintf("EXEC app.SimpleQuery @entity_id = %i", entity_id)
        data <- suppressWarnings(sqlExecute(cn, query = sql, fetch = TRUE, errors = TRUE, query_timeout = 0))

        # get the number of rows in data frame
        row_count <- nrow(data)

        #save result
        row_count <- ifelse(is.null(row_count) || is.na(row_count),0,row_count)
        result <- data.frame(entity_id=c(entity_id),row_count=c(row_count), stringsAsFactors = FALSE)
        sqlSave(cn, result, tablename = "app.OnProcessComplete", rownames = FALSE, append = TRUE)

        # connection tear-down
        odbcClose(cn)

        'OK'
    },
    error = function(cond){
        paste(cond, sep = ';', collapse = '')
    },
    warning = function(cond){
        paste(cond, sep = ';', collapse = '')
    })
    row_count <- ifelse(is.null(row_count) || is.na(row_count),0,row_count)
    data.frame(row_count = c(row_count), status = c(status), stringsAsFactors = FALSE)
}

# publish service
api <- publishService(
  serviceName,
  code = rowCount,
  model = NULL,
  inputs = list(connection_string = "character", entity_id = "numeric"),
  outputs = list(result = "data.frame"),
  v = version
)

# test service deployment
result <- api$rowCount(connection_string, entity_id = 1)
print(result)

resume()
exit
