#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

#read training and test sets
train <- read.table(paste("train_",args[1],".txt",sep=''),header=T)
test <- read.table(paste('test_',args[1],".txt",sep=''),header=T)

test$label <- as.factor(test$label)
train$label <- as.factor(train$label)

#implementing and saving results of a C50 regression tree
library(C50)

treeModel <- C5.0(train[,-ncol(train)],as.factor(train$label),rules=T,trials=30)

tprob <- predict.C5.0(treeModel,test,type='prob')
tclass <- predict.C5.0(treeModel,test,type='class')

colnames(tprob) <- c('c50_0','c50_1')
rownames(tprob) <- rownames(test)

rr <- table(Label=test$label, Pred=tclass)
rtab <- matrix(as.vector(rr),ncol=4)
rownames(rtab) <- c('c50_class')
colnames(rtab) <- c('00','10','01','11')

predTab <- data.frame(tclass)
colnames(predTab) <- "c50_Class"
rownames(predTab) <- rownames(test)

fname <- paste("result_",args[1],"/",sep="")
write.table(rtab,paste(fname,"c50_result_",args[1],sep=""))
write.table(tprob,paste(fname,"c50_prob_",args[1],sep=""))
write.table(predTab,paste(fname,"c50_class_",args[1],sep=""))

#retrieving and saving the predicted probability of malignancy of a C50 regression tree
tprob <- predict.C5.0(treeModel,train,type='prob')
tclass <- predict.C5.0(treeModel,train,type='class')

colnames(tprob) <- c('c50_0','c50_1')
rownames(tprob) <- rownames(train)

rr <- table(Label=train$label, Pred=tclass)
rtab <- matrix(as.vector(rr),ncol=4)
rownames(rtab) <- c('c50_class')
colnames(rtab) <- c('00','10','01','11')

predTab <- data.frame(tclass)
colnames(predTab) <- "c50_Class"
rownames(predTab) <- rownames(train)

fname <- paste("result_",args[1],"/train_",sep="")
write.table(rtab,paste(fname,"c50_result_",args[1],sep=""))
write.table(tprob,paste(fname,"c50_prob_",args[1],sep=""))
write.table(predTab,paste(fname,"c50_class_",args[1],sep=""))






