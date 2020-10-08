#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

#read training and test set
train <- read.table(paste("train_",args[1],".txt",sep=''),header=T)
test <- read.table(paste('test_',args[1],".txt",sep=''),header=T)

train$label <- as.factor(train$label)
test$label <- as.factor(test$label)

#perform neural network on training set and test model on test set
library(neuralnet)

#custom <- function(x) {x/(1+exp(-2*0*x))}
#nn <- neuralnet((label == 1) ~.,train,hidden=20,act.fct=custom)
nn <- neuralnet((label == 1) ~.,train)

nprob <- predict(nn,test,type='prob')
nclass <- abs(round(nprob))
nclass <- ifelse(nprob>=1,1,0)

colnames(nprob) <- 'nn_20_0.5x'

rr <- table(Label=test$label, Pred=nclass)
rtab <- matrix(as.vector(rr),ncol=4)
rownames(rtab) <- c('nn_20_x/2')
colnames(rtab) <- c('00','10','01','11')

predTab <- data.frame(nclass)
colnames(predTab) <- "nn_20_0.5x"
rownames(predTab) <- rownames(test)

fname <- paste("result_",args[1],"/",sep="")
write.table(rtab,paste(fname,"nn20_0.5x_result_",args[1],sep=""))
write.table(nprob,paste(fname,"nn20_0.5x_prob_",args[1],sep=""))
write.table(predTab,paste(fname,"nn20_0.5x_class_",args[1],sep=""))

####

#perform neural network on training set and test model on training set

nprob <- predict(nn,train,type='prob')
nclass <- abs(round(nprob))
nclass <- ifelse(nprob>=1,1,0)

colnames(nprob) <- 'nn_20_0.5x'

rr <- table(Label=train$label, Pred=nclass)
rtab <- matrix(as.vector(rr),ncol=4)
rownames(rtab) <- c('nn_20_x/2')
colnames(rtab) <- c('00','10','01','11')

predTab <- data.frame(nclass)
colnames(predTab) <- "nn_20_0.5x"
rownames(predTab) <- rownames(train)

fname <- paste("result_",args[1],"/train_",sep="")
write.table(rtab,paste(fname,"nn20_0.5x_result_",args[1],sep=""))
write.table(nprob,paste(fname,"nn20_0.5x_prob_",args[1],sep=""))
write.table(predTab,paste(fname,"nn20_0.5x_class_",args[1],sep=""))




