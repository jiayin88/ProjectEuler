#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

#read training and test set
train <- read.table(paste("train_",args[1],".txt",sep=''),header=T)
test <- read.table(paste('test_',args[1],".txt",sep=''),header=T)

train$label <- as.factor(train$label)
test$label <- as.factor(test$label)

#perform SVM on training set and test model on test set
library(kernlab)

model1 <- ksvm(label~.,data=train,kernel='rbfdot',prob.model=T)
model2 <- ksvm(label~.,data=train,kernel='vanilladot',prob.model=T)
model3 <- ksvm(label~.,data=train,kernel='tanhdot',prob.model=T)

m1 <- predict(model1,test,type='probabilities')
m2 <- predict(model2,test,type='probabilities')
m3 <- predict(model3,test,type='probabilities')

colnames(m1) <- c('ksvm_rbfdot_0','ksvm_rbfdot_1')
colnames(m2) <- c('ksvm_vanilladot_0','ksvm_vanilladot_1')
colnames(m3) <- c('ksvm_tanhdot_0','ksvm_tanhdot_1')

mm <- cbind(m1,m2,m3)
rownames(mm) <- rownames(test)

m11 <- predict(model1,test)
m21 <- predict(model2,test)
m31 <- predict(model3,test)

kclass <- cbind(m11,m21,m31)
if(max(kclass)==2){
 kclass <- kclass - 1
}

colnames(kclass) <- c('ksvm_rbfdot','ksvm_vanilladot','ksvm_tanhdot')
rownames(kclass) <- rownames(test)

r1 <- table(Label=test$label,Pred=m11)
r2 <- table(Label=test$label,Pred=m21)
r3 <- table(Label=test$label,Pred=m31)

r1tab <- matrix(as.vector(r1),ncol=4)
r2tab <- matrix(as.vector(r2),ncol=4)
r3tab <- matrix(as.vector(r3),ncol=4)

rtab <- rbind(r1tab,r2tab,r3tab)
rownames(rtab) <- c('ksvm_rbfdot','ksvm_vanilladot','ksvm_tanhdot')
colnames(rtab) <- c('00','10','01','11')

fname <- paste("result_",args[1],"/",sep="")
write.table(rtab,paste(fname,'ksvm_result_',args[1],sep=''))
write.table(mm,paste(fname,'ksvm_prob_',args[1],sep=''))
write.table(kclass,paste(fname,'ksvm_class_',args[1],sep=''))

####

#perform SVM on training set and test model on training set
m1 <- predict(model1,train,type='probabilities')
m2 <- predict(model2,train,type='probabilities')
m3 <- predict(model3,train,type='probabilities')

colnames(m1) <- c('ksvm_rbfdot_0','ksvm_rbfdot_1')
colnames(m2) <- c('ksvm_vanilladot_0','ksvm_vanilladot_1')
colnames(m3) <- c('ksvm_tanhdot_0','ksvm_tanhdot_1')

mm <- cbind(m1,m2,m3)
rownames(mm) <- rownames(train)

m11 <- predict(model1,train)
m21 <- predict(model2,train)
m31 <- predict(model3,train)

kclass <- cbind(m11,m21,m31)
if(max(kclass)==2){
 kclass <- kclass - 1
}

colnames(kclass) <- c('ksvm_rbfdot','ksvm_vanilladot','ksvm_tanhdot')
rownames(kclass) <- rownames(train)

r1 <- table(Label=train$label,Pred=m11)
r2 <- table(Label=train$label,Pred=m21)
r3 <- table(Label=train$label,Pred=m31)

r1tab <- matrix(as.vector(r1),ncol=4)
r2tab <- matrix(as.vector(r2),ncol=4)
r3tab <- matrix(as.vector(r3),ncol=4)

rtab <- rbind(r1tab,r2tab,r3tab)
rownames(rtab) <- c('ksvm_rbfdot','ksvm_vanilladot','ksvm_tanhdot')
colnames(rtab) <- c('00','10','01','11')

fname <- paste("result_",args[1],"/train_",sep="")
write.table(rtab,paste(fname,'ksvm_result_',args[1],sep=''))
write.table(mm,paste(fname,'ksvm_prob_',args[1],sep=''))
write.table(kclass,paste(fname,'ksvm_class_',args[1],sep=''))


