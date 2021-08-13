library(mrsdeploy)
source('./config.R')
source('./SimpleCalculator/serviceConfig.R')

# login to remote R server
remoteLogin(webserver,
            username = username,
            password = password)

pause()

calculate <- function(op,a,b){
  result <- ifelse(op == '+', a+b, ifelse(op == '-', a - b, ifelse(op == '*', a * b, ifelse(op == '/',a/b,NA))))
  result
}

# test function locally by printing result
print(calculate('+',10,20))


# publish a standard service
api <- publishService(
  serviceName,
  code = calculate,
  model = NULL,
  inputs = list(op = "character", a = "numeric", b = "numeric"),
  outputs = list(answer = "numeric"),
  v = version
)

# print api capabilities
# print(api$capabilities())

result <- api$calculate('+', 10, 20)
print(result$outputParameters$result)

result <- api$calculate('-', 10, 20)
print(result$outputParameters$result)

result <- api$calculate('*', 10, 20)
print(result$outputParameters$result)

result <- api$calculate('/', 10, 20)
print(result$outputParameters$result)

resume()
