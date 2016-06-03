#5 ngram and make table
library(quanteda); require(slam)
Sys.setlocale("LC_ALL","English")
remove_nonalpha <- function(x) gsub("[^a-zA-Z']", " ", x)
# changeapostrophe <- function(x) gsub("[`’]","'",x)

conT <- file("train.txt", "rb")
readTxt <- readLines(conT,-1, encoding = "UTF-8", warn = FALSE)          
close(conT)
readTxt<- remove_nonalpha(readTxt)
crpTxt <- corpus(readTxt)
rm(readTxt)

unigram <- dfm(crpTxt, ngrams = 1, verbose = FALSE, removeNumbers = TRUE)
unifrq <- sort(colSums(unigram), decreasing = TRUE)
rm(unigram)
write.csv(unifrq, "unifrq.csv")
rm(unifrq)
twogram <- dfm(crpTxt, ngrams = 2, verbose = FALSE)
twofrq <- sort(colSums(twogram), decreasing = TRUE)
rm(twogram)
write.csv(twofrq, "bifrq.csv")
rm(twofrq)
trigram <- dfm(crpTxt, ngrams = 3, verbose = FALSE)
trifrq <- sort(colSums(trigram), decreasing = TRUE)
rm(trigram)
write.csv(trifrq, "trifrq.csv")
rm(trifrq)
fourgram <- dfm(crpTxt, ngrams = 4, verbose = FALSE)
fourfrq <- sort(colSums(fourgram), decreasing = TRUE)
rm(fourgram)
write.csv(fourfrq, "fourfrq.csv")
rm(fourfrq)
# timeOut <- proc.time()-timeIN
rm(crpTxt)

rm(list = ls())

frq4 <- read.csv("fourfrq.csv")
colnames(frq4) <- c("fourgram", "count")
save(frq4, file = "frq4.RData")
rm(frq4)
frq3 <- read.csv("trifrq.csv")
colnames(frq3) <- c("trigram", "count")
save(frq3, file = "frq3.RData")
rm(frq3)
frq2 <- read.csv("bifrq.csv")
colnames(frq2) <- c("bigram", "count")
save(frq2, file = "frq2.RData")
rm(frq2)
frq1 <- read.csv("unifrq.csv")
colnames(frq1) <- c("unigram", "count")
save(frq1, file = "frq1.RData")
rm(frq1)

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

load("frq4.RData")
frq4 <- splitfirstlast(frq4)
colnames(frq4) <- c("fourgram","count","predictor", "outcome")
frq4 <- frq4[,c("predictor","outcome","count")]
frq4n <- tally(group_by(frq4, predictor), sort = FALSE)
frq4 <- merge(frq4,frq4n)
save(frq4, file = "frq4sln.RData")
rm(frq4)
rm(frq4n)

load("frq2.RData")
frq2 <- splitfirstlast(frq2)
colnames(frq2) <- c("bigram","count","predictor", "outcome")
frq2 <- frq2[,c("predictor", "outcome", "count")]
frq2n <- tally(group_by(frq2, predictor), sort = FALSE)
frq2 <- merge(frq2,frq2n)
save(frq2, file = "frq2sln.RData")
rm(frq2)
rm(frq2n)

load("frq3.RData")
frq3 <- splitfirstlast(frq3)
colnames(frq3) <- c("trigram","count","predictor", "outcome")
frq3 <- frq3[,c("predictor","outcome","count")]
frq3n <- tally(group_by(frq3, predictor), sort = FALSE)
frq3 <- merge(frq3,frq3n)
save(frq3, file = "frq3sln.RData")
rm(frq3)
rm(frq3n)


load("frq1.RData")
colnames(frq1) <- c("ngram","count")
save(frq1, file = "frq1sln.RData")
rm(frq1)


