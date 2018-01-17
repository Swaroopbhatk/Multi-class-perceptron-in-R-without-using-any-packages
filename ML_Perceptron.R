#Name: Swaroop S Bhat
#Student Id: 17230755
#Class: 178-CT475 (MSc Data Analytics)
#********************************************************************************
#Installing the below packages is necerssary if it is not installed in the system
# install.packages("ggplot2")
# install.packages("dplyr")
# install.packages("lubridate")
# install.packages("readr")
# install.packages("stringr")
library("ggplot2")
library("dplyr")
library("lubridate")
library("readr")
library("stringr")


#Note: Program runs for approximately 4 minutes due to 1000 epochs (loops to converge error)

#********************************************* NOTE *************************************************
#Steps to run the program
#1. set the R directory to the directory where the data set is stored. setwd("path")
#2. Run the program. (Everything is prameterized, hence no need to call any functions)

#Note: For convinencce purpose.. Splitting of data to training (2/3) and testing (1/3)
#is already done. And calling the training and prediction function is already parametized
#and hence, no need to call the functions explicitly. 
#****************************************************************************************************


options(warn = -1)
Data_set = suppressMessages(read_csv("owls15.csv", col_names = FALSE))
colnames(Data_set) = c("Body_Length", "Wing_Length", "Body_Width", "Wing_Width", "Type")
start_time = Sys.time()#To calculate elapsed time of the program
Estimated_Accuracy  = vector(mode = 'numeric', length = 10)#To store accuracy over repetition


for(k in 1:10)#10 random samples to estimate future accuracy
{
  
  Perceptron_Alg = function(Data_set)
  {
    
    Owl_data = Data_set
    
    z_norm <- function(x){((x - min(x))/(max(x) - min(x)))}#Normalising data
    Owl_data$Type <- as.factor(Owl_data$Type)
    Nrm_data <- as_data_frame(sapply(Owl_data[,-5], z_norm))
    Nrm_data$Type <- Owl_data$Type
    
    #Exploring Data
    print(ggplot(Owl_data)+
            geom_point(aes(x = Body_Length, y = Body_Width, colour = Type))+
            ggtitle("Exploring Data")+
            xlab("Body Length")+
            ylab("Body Width")+
            theme(plot.title = element_text(hjust = 0.5)))
    print(ggplot(Owl_data)+
            geom_point(aes(x = Wing_Length, y = Wing_Width, colour = Type))+
            ggtitle("Exploring Data")+
            xlab("Wing Length")+
            ylab("Wing Width")+
            theme(plot.title = element_text(hjust = 0.5)))
    
    #Testing and Training data
    set.seed(k+50)
    index = sample(1:nrow(Nrm_data), size = (nrow(Nrm_data)*2/3), prob = NULL, replace= FALSE)
    Test_data = Nrm_data[-index, ] #This is test data set. Used for validation
    Train_data = Nrm_data[index, ] #This data set is further splitted according to the classification for one vs one classification
    
    
    #Seperating training data set according to the classification for One vs one approach
    C1_data <- Train_data[Train_data$Type == "LongEaredOwl", ] #LongEaredOwl Data
    C2_data <- Train_data[Train_data$Type == "SnowyOwl", ] #SnowyOwl
    C3_data <- Train_data[Train_data$Type == "BarnOwl", ] #BarnOwl
    
    #*************************************************************************************************
    #One Vs One classification. Hence Preparing the training data accordingly
    
    #*************************** LongEared vs Snowvy Owl *********************************************
    Class_data1 <- rbind(C1_data, C2_data)
    Class_data1$Type <- ifelse((Class_data1$Type == "LongEaredOwl"), 1, -1)
    
    Train_data1 <- Class_data1[, -5]
    desired_Op_Train1 <- lapply(Class_data1[, 5], function(x){x})[[1]]
    
    #****************************** SnowyOwl vs BarnOwl *******************************************
    Class_data2 <- rbind(C2_data, C3_data)
    Class_data2$Type <- ifelse((Class_data2$Type == "SnowyOwl"), 1, -1)
    
    Train_data2 <- Class_data2[, -5]
    desired_Op_Train2 <- lapply(Class_data2[, 5], function(x){x})[[1]]
    
    #********************************Barn_Owl Vs LongEaredOwl************************************
    Class_data3 <- rbind(C1_data, C3_data)
    Class_data3$Type <- ifelse((Class_data3$Type == "BarnOwl"), 1, -1)
    
    Train_data3 <- Class_data3[, -5]
    desired_Op_Train3 <- lapply(Class_data3[, 5], function(x){x})[[1]]
    
    
    #********************************************************************************************
    #                                       Training weights and bias
    #*******************************************************************************************
    #Default weight and bias of perceptron algorithm
    Default_Bias = 0.03
    lr_rate = 1 # Learning rate
    Initial_wt = c(0.01,0.01,0.01,0.01)
    
    
    
    #Perceptron Training
    Train_Perc = function(Train_data, b, w, lr, desired)
    {
      Bias = b
      Weights = w
      m = lr#learning rate
      desired_op = desired
      Predicted_value = vector(mode = 'numeric', length = nrow(Train_data))#to store predicted class
      Total_RMSE = vector(mode = 'numeric', length = 100)#To store Root Mean Squared Error for each repeats
      
      #Learning weights to optimally seperate class
      Learning_Weights <- function(x, y)
      {
        
        Pred_value <- Predict_value(x)
        Func_x[y] <<- Pred_value
        Error_L <- (desired_op[y] - Pred_value)#Error = Actual - Predicted
        Total_Errors <<- c(Total_Errors, Error_L)
        if(Error_L != 0)
        {
          #Updating weights and bias if error is not zero
          Bias <<- Bias + m * Error_L
          Weights <<- Weights + (Error_L * m * as.numeric(x))
        }
        
      }
      
      #Hard threshold
      #Prediction based on sum of (weights*X[i]): if sum is greater that 0 predic 1 else predict -1
      Predict_value = function(x)
      {
        value = sum(unlist(c((Weights * as.numeric(x)), Bias)))
        Pred_value = ifelse((value > 0), 1, -1)
        return(Pred_value)
        
      }
      
      #Epoch which leads to the convergence of error(if linear seperable) or to find effective dicision hyperplane
      s = 0
      repeat
      {
        
        Total_Errors = vector(mode = 'numeric', length = 100)
        Func_x = vector(mode = 'numeric', length = nrow(Train_data))
        
        for(i in 1:nrow(Train_data))
        {
          Learning_Weights(Train_data[i,], i)
        }
        
        s = s+1
        RMSE = sqrt(sum(Total_Errors^2)/length(desired_op))#RMSE
        Total_RMSE[s] <- RMSE
        #Condition to go out of repeat
        if((RMSE < 0.02) | (s==1000)){
          break
        }
      }
      Predicted_value <- Func_x
      
      #Final values of paramter selected
      Final_param = list(Bias_va = Bias,
                         Weight = Weights, 
                         Predicted_value = Predicted_value,
                         Actual_value = desired_op,
                         RMSE_Epochs = Total_RMSE
      )
      return(Final_param)
    }
    
    
    #*****************************************************************************
    #Test data prediction and comparing the accuracy
    Test = function(h, W, b){
      Weights = W
      Bias = b
      
      #Prediction based on sum of (weights*X[i]): if sum is greater that 0 predic 1 else predict -1
      Test_predict = function(x)
      {
        for(i in 1:nrow(x))
        {
          value = sum(unlist(c((Weights * as.numeric(x[i,])), Bias)))
          Pred_value = ifelse((value > 0), 1, -1)
          Test_predict_val[i] <<- Pred_value
        }
      }
      
      Test_predict_val = vector(mode = 'numeric', length = nrow(h))
      Test_predict(h)
      
      Test_result = list(Predicted = Test_predict_val)
      
      return(Test_result)
      
    }               
    
    
    #Voting system to predict the class = majority voting
    Pecp_Predicted_Class = function(Predicted1,Predicted2,Predicted3)
    {
      
      Predicted_class = vector(mode = 'numeric', length = nrow(Test_data))
      
      for(i in 1:length(Test_data$Type))
      {
        if((Predicted1[i] == 1) & (Predicted3[i] == -1)){
          Predicted_class[i] = "LongEaredOwl"
        }
        if((Predicted1[i] == -1) & (Predicted2[i] == 1)){
          Predicted_class[i] = "SnowyOwl"
          
        }
        if((Predicted2[i] == -1) & (Predicted3[i] == 1)){
          Predicted_class[i] = "BarnOwl"
          
        }
      }
      return(Predicted_class)
    }
    
    #**********************************************************************************
    #Training the algorithm based on 2/3 of data: Splitting of data has been done at the begining
    t = Train_Perc(Train_data1, Default_Bias, Initial_wt, lr_rate, desired_Op_Train1)
    e = Train_Perc(Train_data2, Default_Bias, Initial_wt, lr_rate, desired_Op_Train2)
    v = Train_Perc(Train_data3, Default_Bias, Initial_wt, lr_rate, desired_Op_Train3)
    
    
    #Testing the algorithm based on testing data 1/3 (Unseen data) : Splitting of data has been done at the begining
    t1 = Test(Test_data[,-5], t$Weight, t$Bias_va)
    t2 = Test(Test_data[,-5], e$Weight, e$Bias_va)
    t3 = Test(Test_data[,-5], v$Weight, v$Bias_va)
    
    #ggplot to see the error convergence if points are linearly seperable
    Learning = function(a, b, c)
    {
      print(ggplot()+
              geom_smooth(aes(x = c(1:150), y = a[1:150], colour = "LongEared vs SnowyOwl"), se = F)+
              geom_smooth(aes(x = c(1:150), y = b[1:150], colour = "SnowyOwl vs BarnOwl"), se=F)+
              geom_smooth(aes(x = c(1:150), y = c[1:150], colour = "BarnOwl vs LongearedOwl"), se=F)+
              ggtitle("Error vs Epoch")+
              xlab("Eopchs")+
              ylab("RMSE_Train")+
              theme(plot.title = element_text(hjust = 0.5)))
    }
    
    (Learning(t$RMSE_Epochs, e$RMSE_Epochs, v$RMSE_Epochs))
    
    #Confusion matrix to find the missclassification
    confusion_matrix = table(Actual = Test_data$Type, Predicted = Pecp_Predicted_Class(t1$Predicted,t2$Predicted,t3$Predicted))
    
    
    
    #To display the final parameters (Epochs and weights), Accuracy and confusion matrix on screen
    op_list = list(
      Predicted_Class = Pecp_Predicted_Class(t1$Predicted,t2$Predicted,t3$Predicted),
      Actual_Class = Test_data$Type,
      Confusion_Matrix = confusion_matrix,
      Accuracy = ((confusion_matrix["BarnOwl","BarnOwl"]+confusion_matrix["LongEaredOwl","LongEaredOwl"]+confusion_matrix["SnowyOwl","SnowyOwl"])/length(Test_data$Type)),
      Classfier1_Weight = c(unlist(t$Weight), Bias = t$Bias_va),
      Classfier2_Weight = c(unlist(e$Weight), Bias = e$Bias_va),
      Classfier3_Weight = c(unlist(v$Weight), Bias = v$Bias_va),
      Epochs_class1 = length(t$RMSE_Epochs),
      Epochs_class2 = length(e$RMSE_Epochs),
      Epochs_class2 = length(v$RMSE_Epochs)
    )
    print(op_list)
    Estimated_Accuracy[k] <<- unlist(op_list[4])
    
  }
  Perceptron_Alg(Data_set) #calling the function to train and test
}

#Mean Accuracy
(Estimated_Accuracy)
cat("Likely Expected Accuracy (mean) on prediction is:", mean(Estimated_Accuracy))
cat("Time Elapsed: ",(Sys.time() - start_time))



