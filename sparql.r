#default function to check whether package is installed, if not download. Afterward load the package/library
loadLibrary <- function(libName) {
	if(!(libName %in% rownames(installed.packages()))) {install.packages(libName, repos="http://cran-mirror.cs.uu.nl/")}
	library(libName, character.only=TRUE)
}

loadLibrary("jsonlite")

#############################################################################################################################
# Function to parse the response body from JSON to an R data.frame object
# Input:
#   responseBody: HTML body from response of REST call
# Output:
#   data.frame containing the parsed result of the HTML response body
#############################################################################################################################
parseResponseBody <- function(responseBody) {
  #remove newline form JSON result string
  jsonParsed <- fromJSON(gsub("\r\n", "", responseBody))
  
  jsonVars <- (jsonParsed$head)$vars
  jsonResults <- (jsonParsed$results)$bindings
  
  #loop over rows
  for(var in jsonVars) {
    internalFrame <- jsonResults[,var]
    
    jsonResults[,var] <- internalFrame$value
    
    if(length(unique(internalFrame$type))>0) {
      varType <- unique(internalFrame$type[!is.na(internalFrame$type)])
      dataType <- unique(internalFrame$datatype[!is.na(internalFrame$datatype)])
      
      varTypeDetected <- FALSE;
      
      if(varType=="uri") {
        varTypeDetected <- TRUE;
      } else if(varType=="literal") {
      	varTypeDetected <- TRUE;
      } else if(varType=="typed-literal") {
        if(dataType=="http://www.w3.org/2001/XMLSchema#int") {
          varTypeDetected <- TRUE;
          jsonResults[,var] <- as.numeric(jsonResults[,var])
        }
        
        if(dataType=="http://www.w3.org/2001/XMLSchema#double") {
          varTypeDetected <- TRUE;
          jsonResults[,var] <- as.numeric(jsonResults[,var])
        }
        
        if(dataType=="http://www.w3.org/2001/XMLSchema#string") {
          varTypeDetected <- TRUE;
        }
        
      }
      
      if(!varTypeDetected) {
        warning(paste("Could not detect R class type for RDF data type ", dataType, " for column ", var))
      }
    } else {
      warning(paste("No uniform RDF data type for variable ", var))
    }
  }
  
  #return final data.frame with result values
  jsonResults
}