library(mrsdeploy)
source('./RowCount/serviceConfig.R')
source('./config.R')
# login to remote R server
remoteLogin(webserver,
            username = username,
            password = password)

pause()

deleteService(serviceName, version)

resume()
exit