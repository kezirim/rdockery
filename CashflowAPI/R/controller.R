#* @param principal Principal Amount
#* @param rate Annual Interest Rate
#* @param remaining_term Remaining number of terms (in Months)
#* @get /simpleinterest
simpleinterest <- function(principal, interest_rate, remaining_term){
    principal <- as.numeric(principal)
    interest_rate <- as.numeric(interest_rate)
    remaining_year <- as.numeric(remaining_term) / 12
    total_accrued_amount <- principal * (1 + (interest_rate * remaining_year / 100))
    list(
        "Total Accrued Amount" = total_accrued_amount,
        "Principal Amount" = principal,
        "Interest Amount" = total_accrued_amount - principal
    )
}

#* @param principal Principal Amount
#* @param interest_rate Annual Interest Rate
#* @param remaining_term Remaining Number of Terms (in Months)
#* @get /amortschedule
amortschedule <- function(principal, interest_rate, remaining_term){

    principal <- as.numeric(principal)
    interest_rate <- as.numeric(interest_rate)
    remaining_term <- as.numeric(remaining_term)

    # calculate the monthly interest rate 
    r <- interest_rate / 12

    # initialize an amortization schedule data frame
    schedule <- data.frame(matrix(0, nrow=remaining_term, ncol=4))
    
    # rename the column names
    colnames(schedule) <- c("Month", "Principal Amount", "Interest Amount", "Principal Payment Amount")
    
    # calculate principal and interest payment
    pi_payment <- principal * (r * (1+r)^remaining_term)/((1+r)^remaining_term - 1)

    # loop to generate the amortization schedule for the loan
    for(i in 1:remaining_term){
        interest_payment <- r * principal
        schedule[i, "Month"] <- i
        schedule[i, "Principal Amount"] <- principal
        schedule[i, "Interest Amount"] <- interest_payment
        schedule[i, "Principal Payment Amount"] <- pi_payment - interest_payment
        principal <- principal - pi_payment + interest_payment
    }

    # return the amortization schedule
    schedule
}
