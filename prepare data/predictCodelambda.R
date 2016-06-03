#standard code for shiny files
Sys.setlocale("LC_ALL","English")
suppressPackageStartupMessages(
        c(library(stringi), 
          library(stringr), 
          library(dplyr)))

load("frq4sm.RData")
load("frq3sln.RData")
load("frq2sln.RData")
load("frq1sln.RData")
load("testn.RData")
totest <- 1:nrow(test4)
totest <-sample(totest, 1000, replace = FALSE)
test4 <- test4[totest,]

splitfirst <- function(x){gsub("_[A-Za-z']+$","",x)}
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
predictTop <- function(instring, lambda){
        f4 <- filter(frq4, predictor == instring)
        f3 <- filter(frq3, predictor == splitlasttwo(instring))
        f2 <- filter(frq2, predictor == splitlast(instring))
        c3x <- filter(frq3, predictor == splitfirst(instring))[1, 4]
        c2x <- filter(frq2, predictor == splitfirst(splitfirst(instring)))[1, 4]
        c1x <- frq1[frq1$outcome == splitfirst(splitfirst(instring)), ][1, 4]
        if (is.null(c1x)){c1x <- sum(f2$count)}
        alfa43 <- 1-sum(((f4$count-lambda)/c3x))
        alfa32 <- 1-sum(((f3$count-lambda)/c2x))
        alfa21 <- 1-sum(((f2$count-lambda)/c1x))
        
        f4 <- arrange(top_n(f4, n = 3, count), desc(count))[,]
        f3 <- arrange(top_n(f3, n = 3, count), desc(count))[,]
        f2 <- arrange(top_n(f2, n = 3, count), desc(count))[,]
        f4$score <- round(((f4$count - lambda) / c3x)*1000)
        f3$score <- round(1000*(alfa43 * (f3$count - lambda) / c2x))
        f2$score <- round(1000*(alfa32 * alfa43 * (f2$count - lambda) / c1x))
        names(f2)<- names(f4); names(f3)<- names(f4) #solves match.names-error
        result <- subset(arrange(rbind(f4,f3,f2), desc(score)), select = c("outcome","score"))
        result <- top_n(result[!duplicated(result$outcome),], n=5, score)[1:4,]
        if(is.na(result[1,1])){result[1,1]<- c("the")
        result[1,2]<- 1} # is nothing returned, show most common word
        result <- result[!is.na(result[,1]),]
        result}

lda <- 0.6

timeIn <- proc.time()
output <- ""

test4$match <- FALSE
for (i in 1:nrow(test4)) {
        test4[i, 5] <-
                test4[i, 2] %in% predictTop(test4[i, 1], lda)[, 1]
        
}
output <- append(output, c(lda, sum(test4$match)))

output
# save(output, file = "lambdaout.RData")
proc.time()-timeIn
quit(save = "no")


