# test ngram and make table
library(quanteda); require(slam)
Sys.setlocale("LC_ALL","English")
remove_nonalpha <- function(x) gsub("[^a-zA-Z']", " ", x)
# changeapostrophe <- function(x) gsub("[`’]","'",x)

conT <- file("test.txt", "rb")
readTxt <- readLines(conT,-1, encoding = "UTF-8", warn = FALSE)          
close(conT)
readTxt<- remove_nonalpha(readTxt)
crpTxt <- corpus(readTxt)
rm(readTxt)

fourgram <- dfm(crpTxt, ngrams = 4, verbose = FALSE)
fourfrq <- sort(colSums(fourgram), decreasing = TRUE)
rm(fourgram)
write.csv(fourfrq, "fourtest.csv")
rm(fourfrq)
# timeOut <- proc.time()-timeIN
rm(list = ls())

test4 <- read.csv("fourtest.csv")
colnames(test4) <- c("fourgram", "count")
save(test4, file = "test4.RData")
rm(test4)

## split 
Sys.setlocale("LC_ALL","English")
library(stringi); library(stringr); library(dplyr)


# first
splitfirst <- function(x){gsub("_[A-Za-z']+$","",x)}
# last
splitlast <- function(x){
        x<- str_extract(x,"_[A-Za-z']+$")
        gsub("_","",x)
}
splitfirstlast <- function(x) {
        x$first <- splitfirst(x[, 1])
        x$last <- splitlast(x[, 1])
        x
}
splitlasttwo <- function(x){
        x<-str_extract(x,"_[A-Za-z']+_[A-Za-z']+$")
        gsub("^_","",x)
}

load("test4.RData")
test4 <- splitfirstlast(test4)
colnames(test4) <- c("fourgram","count","predictor", "outcome")
test4 <- test4[,c("predictor","outcome","count")]
test4n <- tally(group_by(test4, predictor), sort = FALSE)
test4 <- merge(test4,test4n)
save(test4, file = "testn.RData")
rm(test4)
rm(test4n)



