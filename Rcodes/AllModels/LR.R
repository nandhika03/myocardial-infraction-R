# Correlation plot
# Load necessary libraries
# Load necessary libraries
# Load necessary libraries
library(corrplot)

# Select only numeric columns from my_inp
numeric_columns <- sapply(my_inp, is.numeric)
numeric_data <- my_inp[, numeric_columns]

# Compute the correlation matrix for the numeric columns
cor_matrix <- cor(numeric_data)

# Generate a circular correlation plot with larger text labels
corrplot(cor_matrix, 
         method = "circle", 
         tl.col = "black",         # Variable label color
         tl.srt = 45,              # Rotate text labels for better readability
         tl.cex = 0.6,          # Increase the label text size
         diag = FALSE,             # Remove diagonal
         col = colorRampPalette(c("blue", "white", "red"))(200))  # Color scale from blue to red

#after correlation
# Load necessary libraries
library(caret)
library(corrplot)

# Select only numeric columns from my_inp
numeric_columns <- sapply(my_inp, is.numeric)
numeric_data <- my_inp[, numeric_columns]

# Compute the correlation matrix for the numeric columns
cor_matrix <- cor(numeric_data)

# Find highly correlated variables (correlation > 0.75 or < -0.75)
high_corr <- findCorrelation(cor_matrix, cutoff = 0.75,verbose= TRUE)

# Count and print the number of highly correlated variables to remove
num_removed <- length(high_corr)
cat("Number of variables to remove due to high correlation:", num_removed, "\n")

# Remove the highly correlated variables from the dataset
my_inp_filtered <- my_inp[, -high_corr]

# Confirm the structure of the dataset after removing the variables
cat("Number of variables remaining:", ncol(my_inp_filtered), "\n")

# Recheck the correlation plot after removing the highly correlated variables
cor_matrix_filtered <- cor(my_inp_filtered[sapply(my_inp_filtered, is.numeric)])

# Generate a circular correlation plot with the remaining variables
corrplot(cor_matrix_filtered, 
         method = "circle", 
         tl.col = "black",         # Variable label color
         tl.srt = 45,              # Rotate text labels for better readability
         tl.cex = 0.8,          # Increase the label text size
         diag = FALSE,             # Remove diagonal
         col = colorRampPalette(c("blue", "white", "red"))(200))  # Color scale from blue to red

# Print how many variables were removed
cat("Number of variables removed:", num_removed, "\n")

cat("Number of variables removed:", num_removed, "\n")
cat("Number of remaining variables:", ncol(my_inp_filtered), "\n")

levels(my_target) <- c("no_complication", "complication")

# Load required libraries
library(caret)

# Stratified random sampling (80-20 split)
set.seed(123)  # Set seed for reproducibility
train_index <- createDataPartition(my_target, p = 0.8, list = FALSE)

# Split the data into training and testing sets
train_data <- my_inp[train_index, ]
train_target <- my_target[train_index]
test_data <- my_inp[-train_index, ]
test_target <- my_target[-train_index]

# Combine training data for caret processing
train_combined <- data.frame(train_data, Target = train_target)

# Define the training control with 10-fold cross-validation
train_control <- trainControl(
  method = "cv",        # Cross-validation
  number = 10,          # 10 folds
  classProbs = TRUE,    # Enable probabilities
  summaryFunction = defaultSummary  # Evaluate with ROC, Sensitivity, and Specificity
)

# Train logistic regression model with preprocessing (scaling and centering)
set.seed(123)  # For reproducibility
logistic_model <- train(
  Target ~ .,                  # Formula (predict all features for Target)
  data = train_combined,       # Training data
  method = "glm",              # Logistic regression method
  family = "binomial",         # Logistic regression family
  trControl = train_control,   # Training control
  metric = "Kappa",
  preProcess = c("center", "scale")  # Preprocessing: centering and scaling
)

# Display the logistic regression model details
print(logistic_model)

# Evaluate model on test data
test_combined <- data.frame(test_data, Target = test_target)
predictions <- predict(logistic_model, newdata = test_combined)

# Generate a confusion matrix for the test set
confusion_matrix <- confusionMatrix(predictions, test_target)

# Print the confusion matrix
print(confusion_matrix)







