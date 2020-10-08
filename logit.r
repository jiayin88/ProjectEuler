#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

#read training and test set
train <- read.table(paste("train_",args[1],".txt",sep=''),header=T)
test <- read.table(paste('test_',args[1],".txt",sep=''),header=T)

test$label <- as.factor(test$label)
train$label <- as.factor(train$label)

#perform logistic regression with lasso on training set and test model on test set
library(caTools)
library(glmnet)

train.mat <- as.matrix(train[,-ncol(train)])
test.mat <- as.matrix(test[,-ncol(test)])

model <- cv.glmnet(train.mat,train$label,family = "binomial")

pred1 <- predict(model,newx=test.mat,type='class',s='lambda.min')
res11 <- table(Label=test$label, Pred=pred1)

pred2 <- predict(model,newx=test.mat,type='response',s='lambda.min')
colnames(pred2) <- "Logit_lambdaMin"
res12 <- table(Label=test$label,Pred=ifelse(pred2>0.55,1,0))

rtab <- rbind(as.vector(res11),as.vector(res12))
rownames(rtab) <- c('logit_class','logit_response')
colnames(rtab) <- c('00','10','01','11')

predTab <- data.frame(pred1)
colnames(predTab) <- "Logit_Class"

fname <- paste("result_",args[1],"/",sep="")
write.table(rtab,paste(fname,"logit_result_",args[1],sep=""))
write.table(pred2,paste(fname,"logit_prob_",args[1],sep=""))
write.table(predTab,paste(fname,"logit_class_",args[1],sep=""))

###

#perform logistic regression with lasso on training set and test model on training set
pred1 <- predict(model,newx=train.mat,type='class',s='lambda.min')
res11 <- table(Label=train$label, Pred=pred1)

pred2 <- predict(model,newx=train.mat,type='response',s='lambda.min')
colnames(pred2) <- "Logit_lambdaMin"
res12 <- table(Label=train$label,Pred=ifelse(pred2>0.55,1,0))

rtab <- rbind(as.vector(res11),as.vector(res12))
rownames(rtab) <- c('logit_class','logit_response')
colnames(rtab) <- c('00','10','01','11')

predTab <- data.frame(pred1)
colnames(predTab) <- "Logit_Class"

fname <- paste("result_",args[1],"/train_",sep="")
write.table(rtab,paste(fname,"logit_result_",args[1],sep=""))
write.table(pred2,paste(fname,"logit_prob_",args[1],sep=""))
write.table(predTab,paste(fname,"logit_class_",args[1],sep=""))



