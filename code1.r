#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

library(caTools)
library(glmnet)

library(parallel)

#reading the feature tables
tab <- read.table("mias-p0.txt",header=T)
ranNum <- as.numeric(args[1])

tab.cp <- tab

#removing any features that have 0 variance or NA
tab.var <- apply(tab,2,var)
n <- which(tab.var==0)

if(length(n) > 0){
tab <- tab[,-n]
}

tab.na <- apply(tab,2,sum)
n <- which(is.na(tab.na))

if(length(n)>0){
 tab <- tab[,-n]
}

tab <- scale(tab[,-ncol(tab)])
tab <- data.frame(tab)
tab$label <- tab.cp$label

#using selected seed to split table to training and test set
set.seed(ranNum)
split <- sample.split(tab$label, SplitRatio = 0.70)
train <- subset(tab, split == T)
test <- subset(tab, split == F)

getTT <- function(x,data){
        d <- t.test(data[,x]~label,data)
        c(d$statistic,d$p.value)
}

no_cores <- detectCores() - 2
clust <- makeCluster(no_cores)

#perform t-test on training set
train.t <- parLapply(clust,1:(ncol(train)-1),getTT,train)

stopCluster(clust)

names(train.t) <- colnames(train)[1:(ncol(train)-1)]

res <- do.call(rbind,train.t)
res <- data.frame(res)
colnames(res) <- c("tstat","pval")

res$rank <- rank(res$tstat)

#identify index of sorted rank
r <- c()
for(i in 1:(ncol(train)-1)){
ra <- which(res$rank == i)
r <- c(r,ra)
}

#rearrange according to sorted rank
res <- res[r,]

train.pvaln3 <- rownames(res)[which(abs(res$pval)<0.01)]

train.pvaln <- train.pvaln3
#print(length(train.pvaln3))

#search and sort the selected features to be same in both training and test set
cname <- c()
for(i in 1:length(train.pvaln)){
        cn <- which(colnames(train)==train.pvaln[i])
        cname <- c(cname,cn)
}

train.roi <- train[,cname]
test.roi <- test[,cname]

#perform PCA on training set and select top 80% of the PC
train.pca <- prcomp(train.roi,scale.=F)
test.pca <- predict(train.pca,test.roi)

t <- summary(train.pca)
tt <- t$importance

tt1 <- which(tt[3,]>=0.8)
tt2 <- tt1[1]

tr <- data.frame(train.pca$x[,1:tt2],label=train$label)
te <- data.frame(test.pca[,1:tt2],label=test$label)

#save result
write.table(tr,paste("train","_",ranNum,".txt",sep=""))
write.table(te,paste("test","_",ranNum,".txt",sep=""))


