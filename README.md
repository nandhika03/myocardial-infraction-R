## Myocardial Infarction Complications Prediction: Course Project MA5790 (Predictive Modelling)
#### Note: As this was a course project, all methods taught in the course were supposed to be executed and tested, hence the results did not matter. 
I worked on this project as part of my **Predictive Modelling** course final project. This course was a game-changer for me, offering deep insights into R and the mathematics behind predictive models. I later went on to become the Teaching assistant for the same course in the Fall of 2025. 

#### Summary:
This study focuses on predicting chronic heart failure (ZSN) using a dataset collected in Krasnoyarsk between 1992 and 1995, consisting of 1,700 patients with 122 variables, including 14 continuous and 108 categorical predictors. Data preprocessing involved addressing 15,794 missing values using KNN imputation, removing near-zero variance features, and applying Box-Cox and Spatial Sign transformations to handle skewness and outliers, resulting in 81 features for analysis. Models were evaluated using stratified random sampling, 10-fold cross-validation, and the Kappa metric to address the imbalanced target variable. Partial Least Squares Discriminant Analysis (PLSDA) achieved the highest performance among linear models with a testing Kappa value of 0.3842, followed by Logistic Regression with a Kappa value of 0.357. _The predictive ability of the model is not upto the mark and needs a lot of training and adjusting of pre-processing methods_. This model cannot be used for clinical predictability. 

#### Models built and their results:
The Linear models that have been built here involve a common preprocessing which is centering and scaling. Additionally, for the Logistic Regression and Linear Discriminant Analysis model, highly correlated features have been removed with a cut-off of 75%, whereas the Partial Least Squares Discriminant Analysis and Penalized Models has the capability to handle correlated predictors. The results are tabulated as follows: ![LINEAR MODELS](https://github.com/nandhika03/myocardial-infraction-R/blob/main/Findings%26Reports/Screenshot%202025-12-17%20070615.png)


The Partial Least Squares Discriminant Analysis (PLSDA) and Logistic Regression models achieved the highest testing Kappa values, 0.3842 and 0.357, respectively. PLSDA has the added advantage of performing feature selection through its components. Given its higher Kappa value and feature selection capability, we consider PLSDA the best model. Logistic Regression, while effective, does not offer the same feature selection benefit. PLSDA’s ability to handle complex datasets with many predictors makes it a better fit for this study. Therefore, we will proceed with PLSDA as the preferred model. 

The non-linear also undergo a common centering and scaling preprocessing, except for the Naive Bayes model. The high correlated predictors are removed for the neural networks, Quadratic Discriminant Analysis, Mixture Discriminant Analysis and Naive Bayes. The neural network model is tested for two cases: with spatial Sign and without spatial Sign. The difference in the kappa value with spatial Sign was slightly higher than the latter. The Box-Cox transformation is being applied on the predictors only in the Naive Bayes model. The results are tabulated as follows: ![non-linear models](https://github.com/nandhika03/myocardial-infraction-R/blob/main/Findings%26Reports/Screenshot%202025-12-17%20070633.png)

Mixture Discriminant Analysis (MDA) emerged as the best-performing non-linear model; however, its testing Kappa value was lower than that of Partial Least Squares Discriminant Analysis (PLSDA) and Logistic Regression, which were the best overall models due to their higher testing Kappa values.  
#### Why This Project?
The [dataset](https://github.com/nandhika03/myocardial-infraction-R/tree/main/Datasets) we chose is open-source and available [here](https://archive.ics.uci.edu/dataset/579/myocardial+infarction+complications).  
The requirement of the course project was to identify open-source datasets that had high dimensionality. Hence, we chose to go with this dataset. The strcuture of the dataset and descriptions of clinical features can be found [here](https://github.com/nandhika03/myocardial-infraction-R/blob/main/Datasets/Descriptive%20statistics.pdf).

#### What was the Goal of this Project?
The primary goal of this project is to to evaluate and compare the performance of various linear and non-linear predictive models, providing insights into the most effective approaches for addressing the challenges posed by imbalanced datasets and diverse clinical variables.
The secondary goal of this project is to predict chronic heart failure (ZSN) complications in patients who have experienced myocardial infarction (MI) using clinical data collected during hospitalization. By identifying high-risk patients early, this research aims to enhance critical care management, facilitate timely preventive measures, and improve long-term patient outcomes.

#### Data Splitting & Preprocessing:
- Initially, the dataset contained 15,974 missing values across the predictors. These were addressed using KNN imputation with K=5. Three predictors with over 95% missing data were excluded from the study, along with the variable ID, which was deemed irrelevant. Following these adjustments, the dataset included 119 variables: 11 continuous and 108 categorical. The dataset was divided into a training set (80%) and a testing set (20%) using stratified random sampling to address the imbalance in the target feature.
- Among the categorical variables, 62 degenerate variables (those with insufficient variability) were identified and removed. Dummy variable encoding was then applied to the categorical variables, resulting in 115 total variables. A second inspection revealed additional degenerate variables, which were subsequently removed, leaving a final set of 81 predictors for analysis.
- The remaining predictors were examined for high correlation, using a cut-off value of 75%.
- 6 predictors were identified as highly correlated. These variables will be excluded during model building for models that are not designed to handle highly correlated predictors.
- The distributions of 12 continuous variables are inspected. The distributions of the continuous variables are generally right skewed, with most of the data concentrated in the lower to middle ranges, and a long tail extending towards higher values. A few variables show a more uniform distribution, but the majority exhibit peaks at certain values, indicating some clustering in specific ranges. There are also some outliers present in the upper ranges of several variables. To address skewness and outliers, Box-Cox and Spatial Sign transformations were applied

#### Evaluation Metric:
Each model will be trained and evaluated using the dataset to assess its effectiveness in achieving the desired predictive outcomes. A 10-fold cross-validation method is applied for resampling and optimizing the model's hyperparameters. The evaluation metric selected for this study is the ** Kappa** value, as it accounts for the imbalance in the target variable's distribution and provides an unbiased measure of model performance.

#### Collaboration:
This project was a collaborative effort with my teammate **Ganesh**. Working together made the entire process enjoyable and insightful.

#### Key Learnings:
- Not all models work on data in the same way
- Imbalance should be handled very carefully
- DOCUMENTATION NEEDS TO BE ALL ALONG THE PROJECT
- Medical data is sure complex to deal with!

For more details, check out our files!  
_Happy Predicting!_
