library(mrsdeploy)
source('./config.R')
source('./RowCount/serviceConfig.R')

# login to remote R server
remoteLogin(webserver,
            username = username,
            password = password,
            session = FALSE)

#pause()

record <- data.frame(connection_string = c(connection_string), entity_id = c(1), stringsAsFactors=FALSE)
service <- getService(serviceName, version)
txBatch <- service$batch(record, parallelCount = 1)
txBatch <- txBatch$start()
txExecutionId <- txBatch$id

batchRes <- NULL
while(TRUE) {
  batchRes <- txBatch$results(showPartialResult = TRUE)  #Default is true

  if (batchRes$state == txBatch$STATE$failed) { stop("Batch execution failed") } 
  if (batchRes$state == txBatch$STATE$complete) { break }
  
  message("Polling for asynchronous batch to complete...")
  Sys.sleep(3)
}

print("Batch processing complete!")
print(sprintf("Total # of Items processed: %i",batchRes$totalItemCount))
print(batchRes$execution(1)$outputParameters$result)

#resume()
#exit