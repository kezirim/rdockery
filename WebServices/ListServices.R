library(mrsdeploy)
source('./config.R')

# login to remote R server
remoteLogin(webserver,
            username = username,
            password = password)

pause()


serviceAll <- listServices()
for(service in serviceAll){
    print(service['name'])
}

resume()
exit
