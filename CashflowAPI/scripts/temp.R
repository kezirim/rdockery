principal <- 100
interest_rate <- 0.25
remaining_term <- 5
expected_df <- data.frame(
  "Month" = c(1,2,3,4,5), 
  "Principal Amount" = c(100.00000,80.81615,61.23264,41.24114,20.83316), 
  "Interest Amount" = c(2.0833333,1.6836699,1.2756801,0.8591905,0.4340241), 
  "Principal Payment Amount" = c(19.18385,19.58351,19.99150,20.40799,20.83316),
  check.names = FALSE,
  stringsAsFactors = FALSE
)
actual_df <- amortschedule(principal, interest_rate, remaining_term)