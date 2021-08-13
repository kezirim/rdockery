library(mrsdeploy)
source('./config.R')
source('./Cashflow/serviceConfig.R')

# login to remote R server
remoteLogin(webserver,
            username = username,
            password = password)

pause()


cfschedule <- function(amount, rate, rterm){
  library(data.table)
  # initialization
  interest <- 0
  principal <- 0
  payment <- amount * rate / (1 - (1+rate)^(-rterm))
  
  pmt <- lapply(1:rterm, function(i){
    interest <<- rate * amount
    principal <<- payment -interest
    amount <<- amount - principal
    data.frame(term = i, payment = payment, principal = principal, interest = interest, amount = amount)
  })
  schedule <- rbindlist(pmt)
  as.data.frame(schedule)
}

# data types: “numeric”, “integer”, “logical”, “character”, “vector”, “matrix”, “data.frame”

# publish a standard service
api <- publishService(
  serviceName,
  code = cfschedule,
  model = NULL,
  inputs = list(amount = "numeric", rate = "numeric", rterm = "numeric"),
  outputs = list(cashflow = "data.frame"),
  v = version
)

result <- api$cfschedule(20000, 0.004167, 24)
print(result)

deleteService(serviceName, version)

resume()
exit