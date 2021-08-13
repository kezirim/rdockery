library(mrsdeploy)
source('./config.R')
source('./SimpleCalculator/serviceConfig.R')

# login to remote R server
remoteLogin(webserver,
            username = username,
            password = password)

pause()

pause()
serviceAll <- listServices()
api <- getService('Calculator')
result <- api$calculate('+',10045,2000)
print(result$outputParameters$result)
swagger <- api$swagger()
write(swagger, 'swagger.json')
resume()
exit