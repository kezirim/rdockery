library(mrsdeploy)
source('./config.R')
source('./RowCount/serviceConfig.R')

# login to remote R server
remoteLogin(webserver,
            username = username,
            password = password)

pause()

entity_id <- 1
api <- getService('RowCount')
result <- api$rowCount(connection_string, entity_id)
print(result$outputParameters$result)

resume()
exit