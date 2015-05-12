
setwd("/Users/Wen/Dropbox/MIT/files")

# Read in the data
Claims = read.csv("ClaimsData.csv")

str(Claims)

# Percentage of patients in each cost bucket
table(Claims$bucket2009)/nrow(Claims)

# Split the data
library(caTools)

set.seed(88)

spl = sample.split(Claims$bucket2009, SplitRatio = 0.6)

ClaimsTrain = subset(Claims, spl==TRUE)

ClaimsTest = subset(Claims, spl==FALSE)



# Baseline method
Classification_Matrix = table(ClaimsTest$bucket2009, ClaimsTest$bucket2008)
Accuracy=sum(diag(Classification_Matrix))/nrow(ClaimsTest)


# Penalty Matrix
PenaltyMatrix = matrix(c(0:4,2*(1),0:3,2*(2:1),0:2,2*(3:1),0:1,2*(4:1),0),byrow=T,nrow=5)

PenaltyMatrix

# Penalty Error of Baseline Method
Classification_Matrix_W_Error = as.matrix(Classification_Matrix)*PenaltyMatrix

Penalty_Error = sum(Classification_Matrix_W_Error)/nrow(ClaimsTest)




# Load necessary libraries
library(rpart)
library(rpart.plot)

# CART model

# Cross Validation Takes a significant amount of time on a data set of almost 275,000 observations in our training set.
train(bucket2009 ~ age + alzheimers + arthritis + cancer + copd + depression + diabetes + heart.failure + ihd + kidney + osteoporosis + stroke + bucket2008 + reimbursement2008, data=ClaimsTrain, method = "rpart", trControl = numFolds, tuneGrid = cpGrid )
# The final value used for the model was cp = 5e-05.

ClaimsTree = rpart(bucket2009 ~ age + alzheimers + arthritis + cancer + copd + depression + diabetes + heart.failure + ihd + kidney + osteoporosis + stroke + bucket2008 + reimbursement2008, data=ClaimsTrain, method="class", cp=0.00005)

prp(ClaimsTree)


# Make predictions
PredictTest = predict(ClaimsTree, newdata = ClaimsTest, type = "class")

CM=table(ClaimsTest$bucket2009, PredictTest)

accuracy=sum(diag(CM))/nrow(ClaimsTest)

# Penalty Error
CM_WE=as.matrix(CM)*PenaltyMatrix

sum(CM_WE)/nrow(ClaimsTest)

# New CART model with loss matrix
ClaimsTree = rpart(bucket2009 ~ age + alzheimers + arthritis + cancer + copd + depression + diabetes + heart.failure + ihd + kidney + osteoporosis + stroke + bucket2008 + reimbursement2008, data=ClaimsTrain, method="class", cp=0.00005, parms=list(loss=PenaltyMatrix))

# Redo predictions and penalty error
PredictTest = predict(ClaimsTree, newdata = ClaimsTest, type = "class")

CM=as.matrix(table(ClaimsTest$bucket2009, PredictTest))

accuracy=sum(diag(CM))/nrow(ClaimsTest)

sum(CM*PenaltyMatrix)/nrow(ClaimsTest)


accuracy=rep(0,5)
for (i in 1:5){
  accuracy[i]=CM[i,i]/sum(CM[i,])  
}
accuracy


# Read in dataset
quality = read.csv("quality.csv")

# Look at structure
str(quality)

# Table outcome
table(quality$PoorCare)

# Baseline accuracy
980/1310

# Install and load caTools package
#install.packages("caTools")
library(caTools)

# Randomly split data
set.seed(88)
split = sample.split(quality$PoorCare, SplitRatio = 0.75)
split

# Create training and testing sets
qualityTrain = subset(quality, split == TRUE)
qualityTest = subset(quality, split == FALSE)

# Logistic Regression Model
QualityLog = glm(PoorCare ~ OfficeVisits + Narcotics, data=qualityTrain, family=binomial)
summary(QualityLog)

# Make predictions on training set
predictTrain = predict(QualityLog, type="response")

# Analyze predictions
summary(predictTrain)
tapply(predictTrain, qualityTrain$PoorCare, mean)





# Confusion matrix for threshold of 0.5
table(qualityTrain$PoorCare, predictTrain > 0.5)

# Sensitivity and specificity
100/250
700/740

# Confusion matrix for threshold of 0.7
table(qualityTrain$PoorCare, predictTrain > 0.7)

# Sensitivity and specificity
80/250
730/740

# Confusion matrix for threshold of 0.2
table(qualityTrain$PoorCare, predictTrain > 0.2)

# Sensitivity and specificity
160/250
540/740




# Install and load ROCR package
# install.packages("ROCR")
library(ROCR)

# Prediction function
ROCRpred = prediction(predictTrain, qualityTrain$PoorCare)

# Performance function
ROCRperf = performance(ROCRpred, "tpr", "fpr")

# Plot ROC curve
plot(ROCRperf)

# Add colors
plot(ROCRperf, colorize=TRUE)

# Add threshold labels 
plot(ROCRperf, colorize=TRUE, print.cutoffs.at=seq(0,1,by=0.1), text.adj=c(-0.2,1.7))

#Compute the test set prediction

predictTest = predict(QualityLog, type="response", newdata=qualityTest)

# compute the test set AUC
  
ROCRpredTest = prediction(predictTest, qualityTest$PoorCare)

auc = as.numeric(performance(ROCRpredTest, "auc")@y.values)
auc

a=table(qualityTest$PoorCare, predictTest > 0.2)
accuracy=sum(diag(a))/sum(a)
accuracy

