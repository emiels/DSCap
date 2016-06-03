# 30/30/15 

library(quanteda); require(slam); library(stringi)
nrLines <- 30000

Sys.setlocale("LC_ALL","English")
changeapostrophe <- function(x) gsub("[`’]","'",x)
remove_nonalpha <- function(x) gsub("[^a-zA-Z0-9']", " ", x)

readSample <- function(filename, nrLines = nrLines){
        con <- file(paste("Coursera-SwiftKey/final/en_US/en_US",filename,"txt",sep="."),"rb")
        readTxt <- readLines(con,nrLines, encoding = "UTF-8", warn = FALSE)            
        close(con)
        changeapostrophe(readTxt)
        remove_nonalpha(readTxt)
        readTxt
}

readBlogs <- readSample("blogs", nrLines = nrLines)
readNews <- readSample("news", nrLines = nrLines)
readTwitter <- readSample("twitter", nrLines = nrLines/2)
readTxt <- c(readBlogs, readNews, readTwitter)
rm(readBlogs);rm(readNews);rm(readTwitter)
library(caret)
textlines <- 1:length(readTxt)
inTrain <- createDataPartition(textlines,p=0.70, list = FALSE)
inTest <- setdiff(textlines, inTrain)

train <- readTxt[inTrain]
test <- readTxt[inTest]

conTrain <- file("train.txt")
writeLines(train, conTrain)
close(conTrain)
conTest <- file("test.txt")
writeLines(test, conTest)
close(conTest)
rm(list = ls())
