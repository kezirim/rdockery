library("plumber")

r <- plumb("controller.R")
r$run(port=8787, host="0.0.0.0")