# Load required libraries
levels(my_target) <- c("no_complication", "complication")
library(caret)

# Stratified random sampling (80-20 split)
set.seed(129)  # Set seed for reproducibility
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
set.seed(129)  # For reproducibility
knn_model <- train(
  Target ~ .,                  # Formula (predict all features for Target)
  data = train_combined,       # Training data
  method = "knn",
  trControl = train_control,
  tuneGrid = data.frame(.k = 1:20),
  metric = "Kappa",
  preProcess = c("center", "scale")  # Preprocessing: centering and scaling
)

# Display the logistic regression model details
print(knn_model)

plot(knn_model)

# Evaluate model on test data
test_combined <- data.frame(test_data, Target = test_target)
predictions_knn <- predict(knn_model, newdata = test_combined)

# Generate a confusion matrix for the test set
confusion_matrix_knn <- confusionMatrix(predictions_knn , test_target)

# Print the confusion matrix
print(confusion_matrix_knn)
