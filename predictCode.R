#standard code for shiny files
Sys.setlocale("LC_ALL","English")
suppressPackageStartupMessages(
        c(library(stringi), 
          library(stringr), 
          library(dplyr), 
          library(shiny),
          library(wordcloud),
          library(shinythemes)))

lambda <- 0.5

load("frq4sln.RData")
load("frq3sln.RData")
load("frq2sln.RData")
load("frq1sln.RData")

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
predictTop <- function(instring){
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

cleanInput <- function(x){ #clean input and return max last three words
        # for the data.tables (frqx) i used undesscore as separator
        # cleanInput converts to underscores as well (if len >1)
        x <- tolower(x)
        x <- gsub("[^a-zA-Z']", " ", x)
        x <- stri_trim_both(x)
        x <- switch(as.character(stri_count_fixed(x, " ")+1), 
                                 "1"= "...",
                                 "2"= x,
                                 "3"= x,
                                 word(x,-3,-1))
        gsub(" ","_",x)
}

