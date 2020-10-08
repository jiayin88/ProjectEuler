#!/bin/bash

for i in {0..9}
do
 r=$(($RANDOM % 1000))
 Rscript code1.r $r
 
 a="result_"
 fname=$a$r
 mkdir $fname
 
 echo "Naive Bayes"
 Rscript nb.r $r
 echo "Neuralnet"
 Rscript nn20_0.5x.r $r
 echo "regression tree"
 Rscript c50.r $r
 echo "logistic regression"
 Rscript logit.r $r
 echo "kSVM"
 Rscript ksvm.r $r
 echo "svm"
 Rscript e1071.r $r

 t1='train_'
 t2='test_'
 txt='.txt'
 train1=$t1$r$txt
 test1=$t2$r$txt
 mv $train1 $fname
 mv $test1 $fname

 echo $i
 echo $r
done
