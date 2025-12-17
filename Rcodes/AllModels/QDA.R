# Ensure valid levels for the target variable
levels(my_target) <- c("no_complication", "complication")


# Split data: Stratified random sampling (80-20 split)
set.seed(108)
train_index <- createDataPartition(my_target, p = 0.8, list = FALSE)
train_data <- my_inp[train_index, ]
train_target <- my_target[train_index]
test_data <- my_inp[-train_index, ]
test_target <- my_target[-train_index]

# Combine training data for caret processing
train_combined <- data.frame(train_data, Target = train_target)

# Train control: 10-fold cross-validation
train_control <- trainControl(
  method = "cv",
  number = 10,
  classProbs = TRUE,
  summaryFunction = defaultSummary
)

# 1. Standardize and apply PCA to the training and test data
library(caret)

# Standardize and apply PCA to the training data
pre_proc <- preProcess(train_combined[, -ncol(train_combined)], method = c("center", "scale", "pca"))

# Apply PCA transformation to the training data
train_pca <- predict(pre_proc, train_combined[, -ncol(train_combined)])

# Apply PCA transformation to the test data (use the same preProc object)
test_pca <- predict(pre_proc, test_combined[, -ncol(test_combined)])

# Combine PCA-transformed data with target variable
train_combined_pca <- data.frame(train_pca, Target = train_target)
test_combined_pca <- data.frame(test_pca, Target = test_target)

# 2. Train QDA model using PCA-transformed data
set.seed(108)
qda_model_pca <- train(
  Target ~ .,                  # Formula (predict all features for Target)
  data = train_combined_pca,    # Training data
  method = "qda",              # QDA method
  metric = "Kappa",            # Optimize based on Kappa
  trControl = train_control,   # Training control
  preProcess = NULL,           # No additional preprocessing, PCA already applied
  prior = c(0.2, 0.8)          # Class priors (adjust as needed)
)

# Display the model
print(qda_model_pca)

# Plot the results
plot(qda_model_pca)

# 3. Evaluate model on test data (PCA-transformed test data)
predictions_qda_pca <- predict(qda_model_pca, newdata = test_combined_pca)

# Generate a confusion matrix for the test set
confusion_matrix_qda_pca <- confusionMatrix(predictions_qda_pca, test_target)

# Print the confusion matrix
print(confusion_matrix_qda_pca)

# Check the number of components retained after PCA
num_components <- length(pre_proc$rotation[1, ])  # or use the `ncol()` function to get the number of principal components

# Print the number of features (principal components) retained after PCA
cat("Number of features (principal components) retained after PCA:", num_components, "\n")

