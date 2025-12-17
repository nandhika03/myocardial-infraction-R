# Load required libraries
levels(my_target) <- c("no_complication", "complication")
library(caret)

# Stratified random sampling (80-20 split)
set.seed(125)  # Set seed for reproducibility
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

library(caret)
# Train logistic regression model with preprocessing (scaling and centering)

#cost_values <- seq(0.9, 1.1, by = 0.01)  # Range of Cost around 1.0
#tune_grid <- expand.grid(Cost = cost_values)

set.seed(130)  # For reproducibility
svm_model <- train(
  Target ~ .,                  # Formula (predict all features for Target)
  data = train_combined,       # Training data
  method = "svmRadial",
  #tuneGrid = expand.grid(.sigma = sigest(as.matrix(trainPredictors))[1], 
  #.C = 2^(seq(-4, 4))), 
  trControl = train_control,   # Training control
  metric = "Kappa",
  #tuneGrid_svm = tune_grid,
  preProcess = c("center", "scale"),
  tuneLength = 5 # Preprocessing: centering and scaling
)

# Display the logistic regression model details
print(svm_model)

plot(svm_model)

# Evaluate model on test data
test_combined <- data.frame(test_data, Target = test_target)
predictions_svm <- predict(svm_model, newdata = test_combined)

# Generate a confusion matrix for the test set
confusion_matrix_svm <- confusionMatrix(predictions_svm , test_target)

# Print the confusion matrix
print(confusion_matrix_svm)
