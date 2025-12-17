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

# Assuming `my` is your dataframe
# Exclude the 121st column from the input features
input_columns <- setdiff(1:123, 121)  # All columns except the 121st
my_inp <- my[, input_columns]

# Check the name of the excluded column (121st column)
excluded_column_name <- colnames(my)[121]
cat("The name of the excluded column (used as target):", excluded_column_name, "\n")

# Target column is the 121st column
my_target <- my[, 121]

# Convert target variable to a factor
my_target <- as.factor(my_target)

# Print the levels of the target variable
cat("Levels of the target variable:", levels(my_target), "\n")

# Load necessary library for visualization
library(ggplot2)

# Create a bar chart showing the distribution of the target variable
ggplot(data = data.frame(Target = my_target), aes(x = Target)) +
  geom_bar(fill = "lightblue", color = "black") +
  theme_minimal() +
  labs(
    title = "Distribution of the Target Variable",
    x = "Target Levels",
    y = "Frequency"
  )


#PREPROCESSING
# Converting variables into proper categories

# List of binary variables to convert to factors (including the newly added ones)
binary_columns <- c("SEX", "FIBR_PREDS", "PREDS_TAH", "JELUD_TAH", "FIBR_JELUD", 
                    "A_V_BLOK", "OTEK_LANC", "RAZRIV", "DRESSLER",  
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
#install.packages("VIM")
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

#-----------------------------------------------------------------------------------------------------------------------------------
#DUMMY VARIABLE IMPUTATION:
# Load necessary libraries
library(caret)
library(dplyr)

# Assuming my_inp is your dataframe
# Step 1: Identify categorical variables (factors or ordered factors)
categorical_columns <- sapply(my_inp, is.factor)

# Extract categorical data for near-zero variance analysis
categorical_data <- my_inp[, categorical_columns]

# Step 2: Find near-zero variance predictors only for categorical variables
nzv_categorical <- nearZeroVar(categorical_data, saveMetrics = TRUE)

# Print the results of near-zero variance analysis
print(nzv_categorical)

# Get the names of zero and near-zero variance categorical predictors
nzv_categorical_predictors <- rownames(nzv_categorical[nzv_categorical$nzv == TRUE, ])

# Print the number of zero and near-zero variance categorical predictors
cat("Number of zero and near-zero variance categorical predictors:", length(nzv_categorical_predictors), "\n")

# Remove zero and near-zero variance categorical predictors
if (length(nzv_categorical_predictors) > 0) {
  categorical_data <- categorical_data[, !(colnames(categorical_data) %in% nzv_categorical_predictors)]
} else {
  cat("No zero or near-zero variance categorical predictors found.\n")
}

# Confirm the structure of categorical data after removing NZV predictors
str(categorical_data)
dim(categorical_data)

# Step 3: Create dummy variables for the remaining categorical features
# Convert categorical_data back to characters for dummy variable creation
categorical_data <- categorical_data %>%
  mutate(across(where(is.factor), ~ as.character(.)))

# Generate dummy variables
dummy_variables <- model.matrix(~ . - 1, data = categorical_data)

# Combine dummy variables with the original non-categorical columns
my_inp <- my_inp %>%
  select(where(~ !is.factor(.))) %>%  # Keep only non-categorical variables
  bind_cols(as.data.frame(dummy_variables))  # Add dummy variables

# View the structure and dimensions of the modified dataframe
str(my_inp)
cat("Dimensions of the dataframe after adding dummy variables:", dim(my_inp), "\n")

# Step 4: Find near-zero variance predictors for the entire dataset after dummy variable creation
nz <- nearZeroVar(my_inp, saveMetrics = TRUE)

# Print the results of near-zero variance analysis
print(nz)

# Get the names of the zero and near-zero variance predictors
nz_predictors <- rownames(nz[nz$nz == TRUE, ])

# Print the number of zero and near-zero variance predictors
cat("Number of zero and near-zero variance predictors:", length(nz_predictors), "\n")

# Remove zero and near-zero variance predictors
if (length(nz_predictors) > 0) {
  my_inp <- my_inp[, !(colnames(my_inp) %in% nz_predictors)]
} else {
  cat("No zero or near-zero variance predictors found.\n")
}

# Confirm the structure and dimensions of the final dataframe
str(my_inp)
cat("Final dimensions of the dataframe:", dim(my_inp), "\n")

# Step 5: Summary of continuous and categorical variables
num_continuous <- sum(sapply(my_inp, is.numeric))
num_categorical <- sum(sapply(my_inp, is.factor))

cat("Number of continuous variables:", num_continuous, "\n")
cat("Number of categorical variables (including ordinal):", num_categorical, "\n")


head(my_inp)
