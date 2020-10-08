#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

#read training and test set
train <- read.table(paste("train_",args[1],".txt",sep=''),header=T)
test <- read.table(paste('test_',args[1],".txt",sep=''),header=T)

test$label <- as.factor(test$label)
train$label <- as.factor(train$label)

#perform naive Bayes classifier on training set and test model on test set
library(naivebayes)

train.mat <- apply(train[,-ncol(train)],2,as.numeric)
test.mat <- apply(test[,-ncol(test)],2,as.numeric)

nb <- naive_bayes(train.mat,as.factor(train$label))

nbClass <- predict(nb,test.mat,type='class')
nbProb <- predict(nb,test.mat,type='prob')

colnames(nbProb) <- c('nb_0','nb_1')
rownames(nbProb) <- rownames(test)

rr <- table(Label=test$label, Pred=nbClass)
rtab <- matrix(as.vector(rr),ncol=4)
rownames(rtab) <- c('nb_class')
colnames(rtab) <- c('00','10','01','11')

predTab <- data.frame(nbClass)
colnames(predTab) <- "nb_Class"
rownames(predTab) <- rownames(test)

fname <- paste("result_",args[1],"/",sep="")
write.table(rtab,paste(fname,"nb_result_",args[1],sep=""))
write.table(nbProb,paste(fname,"nb_prob_",args[1],sep=""))
write.table(predTab,paste(fname,"nb_class_",args[1],sep=""))

####

#perform naive Bayes classifier on training set and test model on training set
nbClass <- predict(nb,train.mat,type='class')
nbProb <- predict(nb,train.mat,type='prob')

colnames(nbProb) <- c('nb_0','nb_1')
rownames(nbProb) <- rownames(train)

rr <- table(Label=train$label, Pred=nbClass)
rtab <- matrix(as.vector(rr),ncol=4)
rownames(rtab) <- c('nb_class')
colnames(rtab) <- c('00','10','01','11')

predTab <- data.frame(nbClass)
colnames(predTab) <- "nb_Class"
rownames(predTab) <- rownames(train)

fname <- paste("result_",args[1],"/train_",sep="")
write.table(rtab,paste(fname,"nb_result_",args[1],sep=""))
write.table(nbProb,paste(fname,"nb_prob_",args[1],sep=""))
write.table(predTab,paste(fname,"nb_class_",args[1],sep=""))



