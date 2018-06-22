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


![image](https://user-images.githubusercontent.com/32418025/41793962-c5d96c66-7655-11e8-92eb-3d975364f490.png)
![image](https://user-images.githubusercontent.com/32418025/41793997-e0c6034a-7655-11e8-8059-c65187ff6dd4.png)
![image](https://user-images.githubusercontent.com/32418025/41794066-0ef4b1bc-7656-11e8-8f67-e916cbd5da0d.png)


#### Weight Update Rule:

Uses Stochastic gradient descent for updating weights with learning rate 0.1.
X: is individual observation.
![image](https://user-images.githubusercontent.com/32418025/41794123-3d37d180-7656-11e8-95d0-9caa5a74d22e.png)


#### Voting System:

![image](https://user-images.githubusercontent.com/32418025/41794159-5754512e-7656-11e8-8209-596c3e3cd483.png)


#### Test Results:
<b>Note:<\b> The results shown below is 1 sample result. (However, I have run the program 10 times with randomly sampled test and train data to find the average performance).

Output of program contains:

    •	Actual and Predicted classes
    •	Confusion Matrix
    •	Accuracy
    •	Weights of each classifier used: 3 classifiers for 3 classes (One vs One)
    •	Epochs (No of iteration to converge/minimise error)
    •	Error vs Epoch graph

![image](https://user-images.githubusercontent.com/32418025/41794207-88bbb112-7656-11e8-999f-bea6362c842e.png)
![image](https://user-images.githubusercontent.com/32418025/41794233-9f7bbd0c-7656-11e8-9935-77110bf02172.png)

#### Conclusion: 

Most of the misclassification is observed, in distinguishing between BarnOwl and SnowyOwl. This also can be observed in Error vs Epoch graph where the blue line (SnowyOwl vs BarnOwl) not able to converge to zero. This may be due to, SnowyOwl and BarnOwl is not 100% linearly separable (this is also supported by above scatter plot – Exploring Data). If BarnOwl and SnowyOwl is fully linearly separable then we may get 100% accuracy. However, in this case there is 2-5 points which cannot separate by hyperplane hence average accuracy of 93% we may expect on any future data points. Moreover, One vs One approach is time consuming, since data is set small only 150 observation we can use OVO. In addition, OVO suits well for imbalanced data sets.

#### References: 
    •	https://en.wikipedia.org/wiki/Perceptron
    •	https://www.youtube.com/watch?v=1XkjVl-j8MM

