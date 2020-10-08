#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

#read training and test set
train <- read.table(paste("train_",args[1],".txt",sep=''),header=T)
test <- read.table(paste('test_',args[1],".txt",sep=''),header=T)

train$label <- as.factor(train$label)
test$label <- as.factor(test$label)

#perform SVM on training set and test model on test set
library(e1071)

model1 <- svm(label~.,train,kernel='radial',probability=T)
model2 <- svm(label~.,train,kernel='sigmoid',probability=T)

m1 <- predict(model1,test,decision.values=T,probability=T)
m2 <- predict(model2,test,decision.values=T,probability=T)

s1 <- attr(m1,'probabilities')
s2 <- attr(m2,'probabilities')

colnames(s1) <- c('svm_radial_1','svm_radial_0')
colnames(s2) <- c('svm_sigmoid_1','svm_sigmoid_0')

sprob <- cbind(s1,s2)
rownames(sprob) <- rownames(test)

sclass <- cbind(m1,m2)
colnames(sclass) <- c('svm_radial','svm_sigmoid')
rownames(sclass) <- rownames(test)


r1 <- table(Label=test$label,Pred=m1)
r2 <- table(Label=test$label,Pred=m2)

r1tab <- matrix(as.vector(r1),ncol=4)
r2tab <- matrix(as.vector(r2),ncol=4)

rtab <- rbind(r1tab,r2tab)
rownames(rtab) <- c('svm_radial','svm_sigmoid')
colnames(rtab) <- c('00','10','01','11')

fname <- paste("result_",args[1],"/",sep="")
write.table(rtab,paste(fname,'svm_result_',args[1],sep=''))
write.table(sprob,paste(fname,'svm_prob_',args[1],sep=''))
write.table(sclass,paste(fname,'svm_class_',args[1],sep=''))

###

#perform SVM on training set and test model on training set
m1 <- predict(model1,train,decision.values=T,probability=T)
m2 <- predict(model2,train,decision.values=T,probability=T)

s1 <- attr(m1,'probabilities')
s2 <- attr(m2,'probabilities')

colnames(s1) <- c('svm_radial_1','svm_radial_0')
colnames(s2) <- c('svm_sigmoid_1','svm_sigmoid_0')

sprob <- cbind(s1,s2)
rownames(sprob) <- rownames(train)

sclass <- cbind(m1,m2)
colnames(sclass) <- c('svm_radial','svm_sigmoid')
rownames(sclass) <- rownames(train)


r1 <- table(Label=train$label,Pred=m1)
r2 <- table(Label=train$label,Pred=m2)

r1tab <- matrix(as.vector(r1),ncol=4)
r2tab <- matrix(as.vector(r2),ncol=4)

rtab <- rbind(r1tab,r2tab)
rownames(rtab) <- c('svm_radial','svm_sigmoid')
colnames(rtab) <- c('00','10','01','11')

fname <- paste("result_",args[1],"/train_",sep="")
write.table(rtab,paste(fname,'svm_result_',args[1],sep=''))
write.table(sprob,paste(fname,'svm_prob_',args[1],sep=''))
write.table(sclass,paste(fname,'svm_class_',args[1],sep=''))


