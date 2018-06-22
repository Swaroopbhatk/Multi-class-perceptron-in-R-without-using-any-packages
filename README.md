## Multiclass Classification Using Perceptron

#### Overview:

The goal of this task is to select, implement and evaluate a machine learning algorithm. The selected algorithm is perceptron and its design and implementational assumption is mentioned in further sections.
Tools/Coding language used: R Studio, R
Algorithm Selected: Perceptron (One vs One approach) with SGD to find optimal weights.

#### Description of Perceptron:

It is a type of linear classifier, i.e. a classification algorithm that makes its predictions based on a linear predictor function combining a set of weights with the feature vector [1]. This based on hard threshold.

![image](https://user-images.githubusercontent.com/32418025/41793897-7a60df1c-7655-11e8-81d0-9d9bd072b555.png)

b: is the bias. Bias shifts the decision boundary away from the origin and does not depend on input value.
Given is the multiclass data sets with classes “LongEaredOwl”, “SnowyOwl” and “BarnOwl’. Hence, I used One Vs One (OVO) approach. Where 3 classifiers used – One for LongEaredOwl vs SnowyOwl, Second for SnowyOwl vs BarnOwl and Third for LongEaredOwl vs BarnOwl. Output is predicted based on majority votes of three classifier. Advantage of one vs one is less sensitive to imbalanced data sets. However, it is computationally expensive. Assuming accuracy as important factor, I used one vs one approach.

##### Procedure: (only for one classifier)
    •	Initialise the weights (reasonable random weights)
    •	Initialise learning rate (usually between 0 to 1) m
    •	Repeat until converges (or condition satisfies)
    •	For each training instance (x)
      -	Compute output f (w.x)
      -	Note Error = output – actual (update bias and weight only if error not equal to 0)
      -	Bias = bias + m * error
      -	W(i) = w(i) + error * m * x(i); where, W: weight vector, X: input vector
    •	Similarly, we need to build 3 classifiers and based on max voting from 3 classifier we need to predict the class and evaluate performance of our model.
    •	Detailed implementation is given below.


