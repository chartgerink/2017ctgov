if(!require(XML)) install.packages('XML')
library(XML)

folder_files <- 'ctgov_raw_xml_20160414'

files <- list.files(recursive = TRUE)
sel <- files[grepl(pattern = folder_files, x = files)]
q <- NULL

for (i in 1:length(sel))
# for (i in 1:5)
{
  # Initial xml parse
  x <- XML::xmlTreeParse(sel[i])
  # Get the root of the xml tree
  y <- xmlRoot(x)
  # Get the XML values
  z <- xmlSApply(y, function(x) xmlSApply(x, xmlValue))
  # Get the names from the xml object
  q <- c(q, names(z))
  
  print(i)
}

write.table(q, file = 'data/names_trials', col.names = FALSE, row.names = FALSE)

read.table('data/names_trials', header = FALSE)

file <- x$doc$file
xml_version <- x$doc$version


dtdFile <- readLines('materials/public.dtd')

XML::parseDTD(dtdFile, asText = TRUE)

XML::xmlTreeParse(sel[1])
