### Contents:
[**Predict the Health Care Cost**](https://github.com/rerock/HealthCare#predict-the-health-care-cost)<br>
[**Assess Health Care Quality**](https://github.com/rerock/HealthCare#assess-health-care-quality)<br>
[**Code**](https://github.com/rerock/HealthCare/blob/master/Code.R)

----
## Predict the Health Care Cost
### 1. Introduction 

- <b>Statistics Concepts:</b> <br>
Classification And Regression Tree (CART), K-fold Cross Validation, Pruning, Penalty Error, Random Forests, Boosting 

- <b> Objective:</b> <br>
Given a 1% random sample of Medicare beneficiaries, limited to those still alive at the end of 2008, I predicted the cost buckets the patients fell into in 2009 using Multi-Class CART models.

### 2. Data Overview

- <b>Data Structure:</b><br> 
ClaimsData.csv, represent a 1% random sample of Medicare beneficiaries, limited to those still alive at the end of 2008. There are total 458,005 observations with 16 variables<br>
  - Variables:
    - patient's age in years at the end of 2008
    - Reimbursement2008: the total amount of Medicare reimbursements for this patient in 2008
    - Reimbursement2009
    - Bucket2008: the cost bucket the patient fell into in 2008
    - Bucket2009
    - Several binary variables indicating whether patient had particular disease in 2008: 
      - alzheimers, 
      - arthritis, 
      - cancer,
      - chronic obstructive pulmonary disease(copd), 
      - depression,
      - diabetes, 
      - heart.failure, 
      - ischemic heart disease(ihd),
      - kidney disease, 
      - osteoporosis, 
      - and stroke.

- <b> Cost Buckets:</b><br>
An important aspect of the variables is that all the variables are related to cost. So rather than using costs directly, I bucketed costs and considered everyone in the group equally.<br>
I defined 5 cost buckets:
 - the first cost bucket contains patients with costs less than 3K
 - the second cost bucket contains patients with costs between 3K to 8K
 - the third cost bucket contains patients with costs between 8K to 19K
 - the fourth cost bucket contains patients with costs between 19K to 55K
 - the fifth cost bucket contains patients with costs greater than 55K
- <b>Penalty Error/Matrix:</b><br>
Penalty Error: If you classify a very high-risk patient as a low-risk patient, this is more costly than the reverse, namely classifying a low-risk patient as a very high-risk patient.
Penalty matrix is defined as followed: 
	- The diagonals, where the forecast = outcome,  are zeros 
	- The top right half, where the forecast > outcome, are the error differences
	- The bottom left half, where the forecast < outcome, double the error differences 
	
----

## Access Helath Care Quality

- <b>Statistics Concepts:</b> <br>
Logistic Regression Model, Multicollinearity, Threshold Value, Sensitivity, Specificity, Receiver Operator Characteristic Curve (ROC), Area Under the ROC Curve (AUC) 

- <b> Objective:</b> <br>
Given a large health insurance claims database with a random sample of 1310 diabetes patients, I built a logistic regression model to detect most of the diabetic patients who might be receiving low quality care.

- <b>Usage</b>
  - Assessing quality correctly can control costs better
  - Intervene and improve outcomes for patients with low quality care

