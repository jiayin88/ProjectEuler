# ProjectMammogram

This project is part of the MSc. (Mathematics) program in the University of Malaya. The goal is to create a pipeline of mammogram analysis to determine the chances of having cancer based on the region of interest using R programming. For more information, please read it here: (insert paper link).

What to expect in this repository:
1. Images used in this project. (https://drive.google.com/file/d/1gdxgpJrDR0F5DskV4cj4Bd-jIuc90Knj/view?usp=sharing)
2. Source codes written for this project.

The database used in this project are:
- CBIS-DDSM
- mini-MIAS

The moment used in this project are:
- Generalized pseudo-Zernike moment (gpzm_finalCode.r)
- Krawtchouk moment (krawt_finalCode.r)

The prediction model used here includes: 
- naive Bayes (nb.r)
- logistic regression (logit.r)
- neural network (nb.r)
- support vector machine (e1071.r, ksvm.r) 
- regression tree (nn20_0.5x.r)


The overall workflow is as follow:

1. Normalize image.
2. Resize image to 300x300 pixels.
3. Perform histogram equalization method.
4. Extract features using generalized-pseudo Zernike moment and Krawtchouk moment.
5. Perform two sample t-test.
6. Extract significant features.
7. Compress features using PCA.
8. Obtain first n principal components from PCA.
9. Split dataset into 80% training and 20% test set.
10. Use training set to train model.
11. Use test set to evaluate the trained model.
12. Check the model performance using contingency table and ROC.
13. Store probabilities of malignancy of the training set and test set.
14. Use the probabilities of malignancy from the training set to train another round of statistical model.
15. Evaluate the newly trained statistical model on the test set.
16. Check the model performance using contingency table and ROC.

The codes are not made for optimization as the goal is to create a workflow for ease of operation. Do enjoy and let me know any improvements that can be done. Cheers!
