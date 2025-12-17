## Myocardial Infarction Complications Prediction: Course Project MA5790 (Predictive Modelling)

I worked on this project as part of my **Predictive Modelling** course final project. This course was a game-changer for me, offering deep insights into R and the mathematics behind predictive models. I later went on to become the Teaching assistant for the same course in the Fall of 2025. 

#### Note: As this was a course project, all methods taught in the course were supposed to be executed and tested, hence the results did not matter. 

#### Summary:
This study focuses on predicting chronic heart failure (ZSN) using a dataset collected in Krasnoyarsk between 1992 and 1995, consisting of 1,700 patients with 122 variables, including 14 continuous and 108 categorical predictors. Data preprocessing involved addressing 15,794 missing values using KNN imputation, removing near-zero variance features, and applying Box-Cox and Spatial Sign transformations to handle skewness and outliers, resulting in 81 features for analysis. Models were evaluated using stratified random sampling, 10-fold cross-validation, and the Kappa metric to address the imbalanced target variable. Partial Least Squares Discriminant Analysis (PLSDA) achieved the highest performance among linear models with a testing Kappa value of 0.3842, followed by Logistic Regression with a Kappa value of 0.357.

#### Why This Project?
The [dataset](https://github.com/nandhika03/myocardial-infraction-R/tree/main/Datasets) we chose is open-source and available [here](https://archive.ics.uci.edu/dataset/579/myocardial+infarction+complications).  
The requirement of the course project was to identify open-source datasets that had high dimensionality. Hence, we chose to go with this dataset. The strcuture of the dataset and descriptions of clinical features can be found [here](https://github.com/nandhika03/myocardial-infraction-R/blob/main/Datasets/Descriptive%20statistics.pdf).
---
#### What was the Goal of this Project?
The primary goal of this project is to to evaluate and compare the performance of various linear and non-linear predictive models, providing insights into the most effective approaches for addressing the challenges posed by imbalanced datasets and diverse clinical variables.
The secondary goal of this project is to predict chronic heart failure (ZSN) complications in patients who have experienced myocardial infarction (MI) using clinical data collected during hospitalization. By identifying high-risk patients early, this research aims to enhance critical care management, facilitate timely preventive measures, and improve long-term patient outcomes.

#### Data Splitting & Preprocessing:
- Initially, the dataset contained 15,974 missing values across the predictors. These were addressed using KNN imputation with K=5. 3 predictors with over 95% missing data were excluded from the study, along with the variable ID, which was deemed irrelevant. Following these adjustments, the dataset included 119 variables: 11 continuous and 108 categorical.
- Among the categorical variables, 62 degenerate variables (those with insufficient variability) were identified and removed. Dummy variable encoding was then applied to the categorical variables, resulting in 115 total variables. A second inspection revealed additional degenerate variables, which were subsequently removed, leaving a final set of 81 predictors for analysis.
- The remaining predictors were examined for high correlation, using a cut-off value of 75%.
- 6 predictors were identified as highly correlated. These variables will be excluded during model building for models that are not designed to handle highly correlated predictors. 


### 2️⃣ **Data Splitting:**
- 📊 Performed a **stratified split** due to the highly imbalanced target variable (presence/absence of complications).  
- Used a standard **80%-20% split** for training and testing datasets.

### 3️⃣ **Evaluation Metric:**
- Selected **Kappa** as the classification metric to ensure fairness for the imbalanced dataset. ✅

### 4️⃣ **Model Building:**
- Developed both **linear** and **non-linear** classification models.  
- 🏆 The **Partial Least Squares Discriminant Analysis (PLS-DA)** model emerged as the best performer with the highest Kappa value (~3.8).

---

## 📂 Files Included:
1. **Dataset**: Contains predictors and target variables.  
2. **Predictor Descriptions**: Detailed explanations of each feature.  
3. **Final Report**: Comprehensive analysis of our approach and results (INCLUDES FULL R CODE for building all models) 
4. **Presentation Slides**: Summary of the project for our class presentation. 🎤
5. **Preprocessing code**: Includes all R codes used to develop the pre-processing


---

## 🤝 Collaboration:
This project was a collaborative effort with my teammate **Ganesh**. Working together made the entire process enjoyable and insightful. 🙌

---

## 🌟 Key Learnings:
- Tackling **imbalanced datasets** in medical data science.  
- The power of **R** in predictive modeling.  
- How to use metrics like **Kappa** effectively for model evaluation.  

For more details, check out our files!  
🎉 **Happy Predicting!** 🎉
