library(mrsdeploy)
source('./config.R')
source('./ExpectedCashflow/config.R')

# login to remote R server
remoteLogin(webserver,
            username = username,
            password = password,
            session = FALSE)
        

calcExpectedCashflow <- function(connection_string, entity_id, period_id, pd_pool_id, lgd_pool_id, cpr_pool_id){
    rlibrary <- data.frame(
        lib_name = c("data.table", "foreach", "iterators", "parallel", "doParallel", "RODBCext","EADModel"),
        lib_status = "undefined",
        stringsAsFactors = FALSE
    )

    for(row in 1: nrow(rlibrary)){
        lib_name <- rlibrary[row, "lib_name"]
        lib_status <- tryCatch({
            library(lib_name, character.only = TRUE)
            "success"
        },
        error = function(cond) paste("ERROR: ", cond),
        warning = function(cond)paste("ERROR: ", cond))
        rlibrary[row, "lib_status"] <- lib_status
    }

    failed_libs <- which(rlibrary$lib_status != "success")
    if(length(failed_libs) > 0){
        err_msg <- sprintf("Library not found: %s",paste(rlibrary[failed_libs,]$lib_name, sep = ",", collapse=""))
        stop(err_msg)
    }

    status <- tryCatch({
        # establish connection
        cn <- odbcDriverConnect(connection_string)

        # fetch data
        sql <-  sprintf("EXEC app.FI_get @entity_id = %i,@period_id=%i,@pd_pool_id=%i,@lgd_pool_id=%i,@cpr_pool_id=%i", entity_id,period_id,pd_pool_id,lgd_pool_id,cpr_pool_id)
        data <- suppressWarnings(sqlExecute(cn, query = sql, fetch = TRUE, errors = TRUE, query_timeout = 0))

        #invoke expected cashflow calculation
        #estimateCashflow(data)

        #do something else after process is complete
        sql <- sprintf("EXEC app.OnProcessComplete @period_id=%i,@pd_pool_id=%i,@lgd_pool_id=%i,@cpr_pool_id=%i", period_id,pd_pool_id,lgd_pool_id,cpr_pool_id)
        sqlExecute(cn, query = sql, fetch = FALSE, errors = TRUE, query_timeout = 0)

        "OK"
    },
    warning = function(cond){
        paste(cond, sep = ",", collapse = "")
    },
    error = function(cond){
        paste(cond, sep = ",", collapse = "")
    });

    data.frame(status = c(status), stringsAsFactors = FALSE)
}

# publish service
api <- publishService(
  serviceName,
  code = calcExpectedCashflow,
  model = NULL,
  inputs = list(connection_string = "character", entity_id = "numeric", period_id = "numeric", pd_pool_id = "numeric", lgd_pool_id = "numeric", cpr_pool_id = "numeric"),
  outputs = list(result = "data.frame"),
  v = version
)