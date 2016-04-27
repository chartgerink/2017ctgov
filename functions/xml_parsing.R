if(!require(XML)) install.packages('XML')
library(XML)

folder_files <- 'ctgov_raw_xml_20160414'

files <- list.files(recursive = TRUE)
sel <- files[grepl(pattern = folder_files, x = files)]

dtdFile <- readLines('materials/public.dtd')

XML::parseDTD(dtdFile, asText = TRUE)

XML::xmlTreeParse(sel[1])

x <- XML::xmlTreeParse(sel[1])

y <- xmlRoot(x)

z <- xmlSApply(y, function(x) xmlSApply(x, xmlValue))

q <- data.frame(t(z), row.names = NULL)

file <- x$doc$file
xml_version <- x$doc$version
