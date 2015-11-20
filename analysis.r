#empty repository
rm(list=ls())

source("sparql.r")

#read SPARQL results from file
results <- paste(readLines(file("results.json")), collapse=" ")

#parse JSON results in a data.frame object
results <- parseResponseBody(results)
message("===============================================================")
message(paste0("Found ", length(unique(results$PatientShape)), " matching patients"))
message("===============================================================")