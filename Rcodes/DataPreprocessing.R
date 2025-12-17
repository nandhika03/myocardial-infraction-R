#Packages
# Install if necessary
install.packages("visdat")
install.packages("naniar")
install.packages("dplyr")
install.packages("caret")
install.packages("ggplot2")
install.packages("e1071")

library(dplyr)

#Reading the data set
my = read.csv("C:\\Users\\vanna\\Downloads\\Myocardial_infarction_complications_Database.csv")
head(my)
dim(my)
str(my)
colnames(my)

#Input features with rows
my_inp <- my[, 1:123]

#Target feature
my_target <- my[, 124]
my_target <- as.factor(my_target)
levels(my_target)

#PREPROCESSING
# Converting variables into proper categories

# List of binary variables to convert to factors (including the newly added ones)
binary_columns <- c("SEX", "FIBR_PREDS", "PREDS_TAH", "JELUD_TAH", "FIBR_JELUD", 
                    "A_V_BLOK", "OTEK_LANC", "RAZRIV", "DRESSLER", "ZSN", 
                    "REC_IM", "P_IM_STEN", "IBS_NASL", "SIM_GIPERT", 
                    "GIPO_K", "GIPER_NA", "NA_KB", "NITR_S", "IM_PG_P", 
                    "ritm_ecg_p_01", "ritm_ecg_p_02", "ritm_ecg_p_04", 
                    "ritm_ecg_p_06", "ritm_ecg_p_07", "ritm_ecg_p_08", 
                    "n_r_ecg_p_01", "n_r_ecg_p_02", "n_r_ecg_p_03", "n_r_ecg_p_04", 
                    "n_r_ecg_p_05", "n_r_ecg_p_06", "n_r_ecg_p_08", "n_r_ecg_p_09", 
                    "n_r_ecg_p_10", "n_p_ecg_p_01", "n_p_ecg_p_03", "n_p_ecg_p_04", 
                    "n_p_ecg_p_05", "n_p_ecg_p_06", "n_p_ecg_p_07", "n_p_ecg_p_08", 
                    "n_p_ecg_p_09", "n_p_ecg_p_10", "fibr_ter_01", "fibr_ter_02", 
                    "fibr_ter_03", "fibr_ter_05", "fibr_ter_06", "fibr_ter_07", 
                    "fibr_ter_08", "nr_11", "nr_01", "nr_02", "nr_03", 
                    "nr_04", "nr_07", "nr_08", "np_01", "np_04", "np_05", 
                    "np_07", "np_08", "np_09", "np_10", "endocr_01", "endocr_02", 
                    "endocr_03", "zab_leg_01", "zab_leg_02", "zab_leg_03", 
                    "zab_leg_04", "zab_leg_06", "O_L_POST", "K_SH_POST", 
                    "MP_TP_POST", "SVT_POST", "GT_POST", "FIB_G_POST", 
                    "n_p_ecg_p_11", "n_p_ecg_p_12", "NOT_NA_KB", "LID_KB", 
                    "LID_S_n", "B_BLOK_S_n", "ANT_CA_S_n", "GEPAR_S_n", 
                    "ASP_S_n", "TRENT_S_n")

# Convert binary variables to factors
my_inp[binary_columns] <- lapply(my_inp[binary_columns], as.factor)

# Convert ordinal variables to ordered factors
ordinal_columns <- list(
  "FK_STENOK" = c(0, 1, 2, 3, 4),
  "INF_ANAM" = c(0, 1, 2, 3),
  "STENOK_AN" = c(0, 1, 2, 3, 4, 5, 6),
  "IBS_POST" = c(0, 1, 2),
  "DLIT_AG" = c(0, 1, 2, 3, 4, 5, 6, 7),
  "ZSN_A" = c(0, 1, 2, 3, 4),
  "ant_im" = c(0, 1, 2, 3, 4),
  "lat_im" = c(0, 1, 2, 3, 4),
  "inf_im" = c(0, 1, 2, 3, 4),
  "post_im" = c(0, 1, 2, 3, 4),
  "TIME_B_S" = c(1, 2, 3, 4, 5, 6, 7, 8, 9),
  "R_AB_1_n" = c(0, 1, 2, 3),
  "R_AB_2_n" = c(0, 1, 2, 3),
  "R_AB_3_n" = c(0, 1, 2, 3),
  "NA_R_1_n" = c(0, 1, 2, 3, 4),
  "NA_R_2_n" = c(0, 1, 2, 3),
  "NA_R_3_n" = c(0, 1, 2),
  "NOT_NA_1_n" = c(0, 1, 2, 3, 4),
  "NOT_NA_2_n" = c(0, 1, 2, 3),
  "NOT_NA_3_n" = c(0, 1, 2),
  "GB" = c(0, 1, 2, 3)
)



# Convert ordinal variables to ordered factors
for (col in names(ordinal_columns)) {
  my_inp[[col]] <- factor(my_inp[[col]], levels = ordinal_columns[[col]], ordered = TRUE)
}

# Convert all remaining numeric columns to numeric
remaining_cols <- setdiff(colnames(my_inp), c(binary_columns, names(ordinal_columns)))

# Convert those columns to numeric
my_inp[remaining_cols] <- lapply(my_inp[remaining_cols], as.numeric)
# Check the structure of all columns to ensure correctness
str(my_inp)

#CONVERSIONS DONE
# CHECKING NUMBER OF CAT AND CONT VARIABLES

# Check the structure of the dataframe (to view column types)
str(my_inp)

# Get the number of continuous (numeric) variables
num_continuous <- sum(sapply(my_inp, is.numeric))

# Get the number of categorical variables (including both nominal and ordinal factors)
num_categorical <- sum(sapply(my_inp, is.factor))

# Print the results
cat("Number of continuous variables:", num_continuous, "\n")
cat("Number of categorical variables (including ordinal):", num_categorical, "\n")


# Checking for missing values
# Percentage of missing values per column
colSums(is.na(my_inp)) / nrow(my_inp) * 100
#There are no missing values in the Target column 
sum(is.na(my_target))

# Calculate the total number of missing values in the dataset
total_missing <- sum(is.na(my))
cat(total_missing)

# Calculate the total number of values in the dataset
total_values <- prod(dim(my))  # number of rows * number of columns

# Calculate the proportion of missing values
missing_proportion <- (total_missing / total_values)*100

# Print the result
cat("Proportion of missing values in the dataset:", missing_proportion, "\n")


library(visdat)
library(naniar)
# Get the total number of columns in my_inp
total_columns <- ncol(my_inp)

# Split the features into two halves
half <- total_columns %/% 2  # integer division

# First half of the columns
first_half <- my_inp[, 1:half]

# Second half of the columns
second_half <- my_inp[, (half + 1):total_columns]

# Combine the first half of features with the target class
combined_data_first <- cbind(first_half, class = my_target)

# Combine the second half of features with the target class
combined_data_second <- cbind(second_half, class = my_target)

# Visualize missing values for the first half of the features
gg_miss_fct(combined_data_first, fct = class)

# Visualize missing values for the second half of the features
gg_miss_fct(combined_data_second, fct = class)

str(my_inp)

#REMOVING FEATURES 
#ID does not have any meaning here
#IBS_NASAL AND KFK_BLOOD have more than 95% of missing values
my_inp = select(my_inp, -c("ID","IBS_NASL","KFK_BLOOD"))
dim(my_inp)

#HANDLING MISSING VALUES USING K-NN IMPUTATION
# Install and load necessary package
install.packages("VIM")
library(VIM)

# Assuming `my` is your complete dataset with both categorical and continuous data

# Apply KNN imputation (you can specify 'k' for the number of neighbors, default is 5)
# The 'kNN' function from VIM can handle both categorical and continuous variables
my_inp <- kNN(my_inp, k = 5, imp_var = FALSE)

# Check the imputed data
head(my_inp)

dim(my_inp)

# Get the number of continuous (numeric) variables
num_continuous <- sum(sapply(my_inp, is.numeric))

# Get the number of categorical variables (including both nominal and ordinal factors)
num_categorical <- sum(sapply(my_inp, is.factor))

# Print the results
cat("Number of continuous variables:", num_continuous, "\n")
cat("Number of categorical variables (including ordinal):", num_categorical, "\n")


# Optionally, you can check if there are any missing values left
sum(is.na(my_inp))  # Should return 0 if all missing values are imputed
## Distribution of numerical variables
# Count the number of numeric variables in the dataset
num_numeric_vars <- sum(sapply(my_inp, is.numeric))

# Print the result
cat("Number of numeric variables:", num_numeric_vars, "\n")

#PLOT -----------------------------------------------------------------------------------------------
library(ggplot2)
library(reshape2)

# Identify numeric columns in the dataset
numeric_columns <- sapply(my_inp, is.numeric)

# Subset the data with only numeric columns
numeric_data <- my_inp[, numeric_columns]

# Melt the numeric data for ggplot
numeric_data_melted <- melt(numeric_data)

# Create the plot using ggplot2
ggplot(numeric_data_melted, aes(x = value)) +
  geom_histogram(fill = "skyblue", color = "black", bins = 30) +  # Use geom_histogram for numeric values
  facet_wrap(~ variable, scales = "free_x", ncol = 3) +  # Create a 3-column grid
  theme_minimal(base_family = "sans", base_size = 15) +  # Use a minimal theme with larger text
  theme(
    panel.background = element_rect(fill = "white", color = NA),  # Set panel background to white
    strip.background = element_rect(fill = "white", color = NA),  # Facet label background
    strip.text = element_text(color = "black"),  # Facet label text color
    axis.text = element_text(color = "black"),  # Axis text color
    axis.title = element_text(color = "black"),  # Axis title color
    plot.title = element_text(color = "black", hjust = 0.5)  # Title color and centering
  )

#BOXPLOT 

library(ggplot2)
library(reshape2)

# Identify numeric columns in the dataset
numeric_columns <- sapply(my_inp, is.numeric)

# Subset the data with only numeric columns
numeric_data <- my_inp[, numeric_columns]

# Melt the numeric data for ggplot
numeric_data_melted <- melt(numeric_data)

# Create boxplots using ggplot2
ggplot(numeric_data_melted, aes(x = variable, y = value)) +
  geom_boxplot(fill = "skyblue", color = "black") +  # Boxplot with skyblue fill and black borders
  facet_wrap(~ variable, scales = "free_y", ncol = 3) +  # Create a 3-column grid
  theme_minimal(base_family = "sans", base_size = 12) +  # Use a minimal theme with a smaller font size
  theme(
    panel.background = element_rect(fill = "white", color = NA),  # Set panel background to white
    strip.background = element_rect(fill = "lightgray", color = NA),  # Facet label background
    strip.text = element_text(color = "black", face = "bold"),  # Facet label text color and bold
    axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, size = 8),  # Rotate x-axis labels
    axis.text.y = element_text(size = 10),  # y-axis label text size
    axis.title.x = element_blank(),  # Remove x-axis title to save space
    axis.title.y = element_text(size = 12),  # y-axis title size
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16),  # Centered and bold plot title
    plot.margin = margin(10, 10, 10, 10)  # Increase margins around the plot
  ) 
# CALCULATING SKEWNESS OF NUMERICAL FEATURES
# Load the e1071 package
library(e1071)

# Identify the numeric columns
numeric_columns <- my_inp[, sapply(my_inp, is.numeric)]

# Calculate skewness for each numeric column
skewness_values <- apply(numeric_columns, 2, skewness)

# Print the skewness values
print(skewness_values)

#DEALING WITH SKEWNESS AND OUTLIERS USING BOXCOX TRANSFORMATION
# Load the caret package
library(caret)

# Step 1: Identify numeric columns in the dataset
numeric_columns <- colnames(my_inp)[sapply(my_inp, is.numeric)]

# Step 2: Apply Box-Cox transformation and Spatial Sign transformation
preprocess_params <- preProcess(my_inp[, numeric_columns], method = c("BoxCox", "spatialSign"))
preprocess_params  # View the preprocessing parameters

# Step 3: Apply the transformations to the numeric columns
my_inp_box <- predict(preprocess_params, my_inp[, numeric_columns])

# Step 4: Identify non-numeric (categorical) columns
categorical_columns <- colnames(my_inp)[!sapply(my_inp, is.numeric)]

# Step 5: Extract the categorical columns
my_inp_cat <- my_inp[, categorical_columns]

# Step 6: Combine the transformed numeric columns (my_inp_box) with the categorical columns
my_inp <- cbind(my_inp_cat, my_inp_box)

# Step 7: Check the structure of the combined dataset
str(my_inp)

# Identify the numeric columns
numeric_columns <- my_inp[, sapply(my_inp, is.numeric)]

# Calculate skewness for each numeric column
skewness_values <- apply(numeric_columns, 2, skewness)

# Print the skewness values
print(skewness_values)


#PLOTTING AFTER TRANSFORMATION ------------------------------------------------------------------------------------------
# Load necessary libraries
library(ggplot2)
library(reshape2)

# Identify numeric columns in the dataset
numeric_columns <- sapply(my_inp, is.numeric)

# Subset the data with only numeric columns
numeric_data <- my_inp[, numeric_columns]

# Melt the numeric data for ggplot
numeric_data_melted <- melt(numeric_data)

# Create the plot using ggplot2
ggplot(numeric_data_melted, aes(x = value)) +
  geom_histogram(fill = "skyblue", color = "black", bins = 50) +  # Increase bins for more detail
  facet_wrap(~ variable, scales = "free_x", ncol = 3) +  # Create a 3-column grid
  ylim(0, 400)+ 
  theme_minimal(base_size = 15) +  # Use a minimal theme with larger text
  labs(title = "Histograms of Numeric Variables", x = "Value", y = "Count") +  # Add titles and labels
  theme(
    strip.background = element_rect(fill = "white", color = NA),  # Facet label background
    strip.text = element_text(color = "black"),  # Facet label text color
    axis.text = element_text(color = "black"),  # Axis text color
    axis.title = element_text(color = "black")  # Axis title color
  )

#BOXPLOT AFTER TRANSFORMATION -------------------------------------------------------------
# Reset the plotting layout and background to default (optional)
#par(mfrow = c(1, 1), bg = "white")
# Load necessary libraries
library(ggplot2)
library(reshape2)

# Identify numeric columns in the dataset
numeric_columns <- sapply(my_inp, is.numeric)

# Subset the data with only numeric columns
numeric_data <- my_inp[, numeric_columns]

# Melt the numeric data for ggplot
numeric_data_melted <- melt(numeric_data)

# Create boxplots using ggplot2
ggplot(numeric_data_melted, aes(x = variable, y = value)) +
  geom_boxplot(fill = "cyan", color = "black") +  # Boxplot fill and border color
  theme_minimal() +  # Use a minimal theme
  labs(title = "Boxplots after of Numeric Variables") +  # Title
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)  # Rotate x-axis labels for better visibility
  ) +
  facet_wrap(~ variable, scales = "free_y", ncol = 3)  # Create a grid layout for the plots
# Distribution for categorical
# DISTRIBUTION OF CATEGORICAL VARIABLES
library(reshape2)

# Melt the dataset
my_inp_melted <- melt(my_inp, id.vars = NULL)

# Get the names of categorical variables from the original dataset
# Check and convert categorical variables to factors (if they are not already)
my_inp[categorical_vars] <- lapply(my_inp[categorical_vars], as.factor)

# Melt the data for visualization (reshape data to long format)
my_inp_melted <- melt(my_inp, id.vars = NULL, measure.vars = names(categorical_vars[categorical_vars]))

# Filter the melted data frame to include only categorical variables
my_inp_melted <- my_inp_melted[my_inp_melted$variable %in% names(categorical_vars[categorical_vars]), ]

# Check the structure of the melted data frame
str(my_inp_melted)

# Ensure you have the necessary libraries loaded
library(ggplot2)
library(reshape2)
library(scales)  # for formatting of axis labels

# Plot the distribution of categorical variables
ggplot(my_inp_melted, aes(x = value)) +
  geom_bar(fill = "skyblue", alpha = 0.8) +  # Set color and transparency
  facet_wrap(~ variable, scales = "free_x") +  # Adjust layout for each variable
  labs(title = "Distribution of Categorical Variables",
       x = "Category",
       y = "Count") +  # Add title and axis labels
  theme_minimal() +  # Use minimal theme
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),  # Center and style title
    axis.title.x = element_text(size = 12, face = "bold"),  # Style x-axis title
    axis.title.y = element_text(size = 12, face = "bold"),  # Style y-axis title
    axis.text.x = element_text(angle = 45, hjust = 1, size = 8),  # Adjust x-axis text
    axis.text.y = element_text(size = 8),  # Adjust y-axis text size
    strip.text = element_text(size = 10, face = "bold")  # Style facet labels
  )

# near zero
# Load the necessary library
library(caret)

# Assuming my_inp is your dataframe
# Find near-zero variance predictors, saving metrics
nzv <- nearZeroVar(my_inp, saveMetrics = TRUE)

# Print the results of near-zero variance analysis
print(nzv)

# Get the names of the zero and near-zero variance predictors
nzv_predictors <- rownames(nzv[nzv$nzv == TRUE, ])

# Print the number of zero and near-zero variance predictors
cat("Number of zero and near-zero variance predictors:", length(nzv_predictors), "\n")

# Remove zero and near-zero variance predictors
if (length(nzv_predictors) > 0) {
  my_inp <- my_inp[, !(colnames(my_inp) %in% nzv_predictors)]
} else {
  cat("No zero or near-zero variance predictors found.\n")
}

# Confirm the structure of my_inp after removing variables
str(my_inp)

# Get the number of continuous (numeric) variables
num_continuous <- sum(sapply(my_inp, is.numeric))

# Get the number of categorical variables (including both nominal and ordinal factors)
num_categorical <- sum(sapply(my_inp, is.factor))

# Print the results
cat("Number of continuous variables:", num_continuous, "\n")
cat("Number of categorical variables (including ordinal):", num_categorical, "\n")


#DUMMY VARIABLE IMPUTATION:
# Load necessary libraries
library(dplyr)

# Assuming my_inp is your dataframe with categorical features

# Identify categorical columns (factors and ordered factors)
categorical_columns <- sapply(my_inp, is.factor)

# Create dummy variables for categorical features
my_inp <- my_inp %>%
  mutate(across(where(is.factor), ~ as.character(.))) %>%  # Convert factors to characters
  select(where(~ !is.factor(.))) %>%                      # Keep non-categorical variables
  bind_cols(model.matrix(~ . - 1, data = my_inp[categorical_columns]))  # Create dummies

# View the dummy variables
head(my_inp)

dim(my_inp)
# Load the necessary library
library(caret)

# Assuming my_inp is your dataframe
# Find near-zero variance predictors, saving metrics
nz <- nearZeroVar(my_inp, saveMetrics = TRUE)

# Print the results of near-zero variance analysis
print(nz)

# Get the names of the zero and near-zero variance predictors
nz_predictors <- rownames(nz[nz$nz == TRUE, ])

# Print the number of zero and near-zero variance predictors
cat("Number of zero and near-zero variance predictors:", length(nzv_predictors), "\n")

# Remove zero and near-zero variance predictors
if (length(nz_predictors) > 0) {
  my_inp <- my_inp[, !(colnames(my_inp) %in% nz_predictors)]
} else {
  cat("No zero or near-zero variance predictors found.\n")
}

# Confirm the structure of my_inp after removing variables
str(my_inp)

# Get the number of continuous (numeric) variables
num_continuous <- sum(sapply(my_inp, is.numeric))

# Get the number of categorical variables (including both nominal and ordinal factors)
num_categorical <- sum(sapply(my_inp, is.factor))

# Print the results
cat("Number of continuous variables:", num_continuous, "\n")
cat("Number of categorical variables (including ordinal):", num_categorical, "\n")
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

#pca
# Load necessary libraries
library(caret)
library(ggplot2)

# Assuming my_inp is your dataframe with numeric variables only
numeric_data <- my_inp[, sapply(my_inp, is.numeric)]

# Check for missing values and handle them (impute or remove)
if (any(is.na(numeric_data))) {
  numeric_data[is.na(numeric_data)] <- apply(numeric_data, 2, median, na.rm = TRUE)
}

# Preprocess the data with PCA
pca_model <- preProcess(numeric_data, method = c("center", "scale", "pca"))

# Transform the data
pca_data <- predict(pca_model, numeric_data)

# View the PCA-transformed data
head(pca_data)

# Display the number of components retained
num_components <- length(pca_model$rotation[,1])  # Number of PCA components
cat("Number of components retained:", num_components, "\n")

# Extract the proportion of variance explained by each component
explained_variance <- pca_model$importance[2, ]  # Get the second row for proportion of variance

# Create a scree plot
scree_plot <- data.frame(Components = 1:num_components, Variance = explained_variance)
ggplot(scree_plot, aes(x = Components, y = Variance)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  geom_line(aes(group = 1), color = "red") +
  geom_point() +
  labs(title = "Scree Plot",
       x = "Principal Components",
       y = "Proportion of Variance Explained") +
  theme_minimal() +
  theme(axis.text.x = element_text(size = 12), 
        axis.text.y = element_text(size = 12),
        plot.title = element_text(size = 16, face = "bold", hjust = 0.5))

# Load necessary libraries
library(caret)
library(ggplot2)

# Assuming my_inp is your dataframe with numeric variables only
numeric_data <- my_inp[, sapply(my_inp, is.numeric)]

# Check for missing values and handle them (impute or remove)
if (any(is.na(numeric_data))) {
  numeric_data[is.na(numeric_data)] <- apply(numeric_data, 2, median, na.rm = TRUE)
}

# Perform PCA using prcomp
pca_result <- prcomp(numeric_data, center = TRUE, scale. = TRUE)

# Extract the proportion of variance explained by each component
explained_variance <- summary(pca_result)$importance[2, ]  # Second row gives proportion of variance

# Number of components retained
num_components <- length(explained_variance)
cat("Number of components retained:", num_components, "\n")

# Create a scree plot
scree_plot <- data.frame(Components = 1:num_components, Variance = explained_variance)

ggplot(scree_plot, aes(x = Components, y = Variance)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  geom_line(aes(group = 1), color = "red") +
  geom_point() +
  labs(title = "Scree Plot",
       x = "Principal Components",
       y = "Proportion of Variance Explained") +
  theme_minimal() +
  theme(axis.text.x = element_text(size = 12), 
        axis.text.y = element_text(size = 12),
        plot.title = element_text(size = 16, face = "bold", hjust = 0.5))
