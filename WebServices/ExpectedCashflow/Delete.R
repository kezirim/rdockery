library(mrsdeploy)
source('./ExpectedCashflow/config.R')
source('./config.R')

# login to remote R server
remoteLogin(webserver,
            username = username,
            password = password,
            session = FALSE)

# delete service
deleteService(serviceName, version)