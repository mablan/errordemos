# If googleErrorReportingR is not installed:
# devtools::install_github("https://github.com/ixpantia/googleErrorReportingR")
#
# Based in plumber examples in:  https://www.rplumber.io/

library(plumber)
library(tidyverse)
library(googleErrorReportingR)


project_id <- Sys.getenv("PROJECT_ID")
api_key <- Sys.getenv("ERROR_REPORTING_API_KEY")


#* @apiTitle Plumber Example API

#* Echo back the input
#* @param msg The message to echo
#* @get /echo
function(msg = "") {
  list(msg = paste0("The message is: '", msg, "'"))
}

#* Plot a histogram
#* @serializer png
#* @param n The number of random values
#* @get /plot
function(n = 100) {
  
  message <- format_error_message()
  message$serviceContext$version <- "v0.0.1"
  
  if (n < 0) {
    
    # This is to try to catch the error before the stop (stop demo)
    message$serviceContext$service <- "Argument should be an integer greather than 0"
    
    
    googleErrorReportingR::report_error(message)
    
    stop("Argument should be an integer greather than 0")
        
    
    
  } else {
      rand <- rnorm(n)
      hist(rand)
  }
  
}

#* Return the sum of two numbers
#* @param a The first number to add
#* @param b The second number to add
#* @post /sum
function(a, b) {
  as.numeric(a) + as.numeric(b)
}


