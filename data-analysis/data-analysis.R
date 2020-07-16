# NOTE: If you're running this script, make sure to set your working directory first with setwd("Path/to/this/directory")

##---------------------------------------------------------------##
##                Load libraries and import data                 ##
##---------------------------------------------------------------##

# Load libraries
library(readxl)
library(writexl)
library(dplyr)
library(ggplot2)
library(ggpubr)
library(meta)

# Import the dataset
time_data <- read_excel("dataset.xlsx", sheet = "time")
correctness_data <- read_excel("dataset.xlsx", sheet = "correctness")
rating_data <- read_excel("dataset.xlsx", sheet = "ratings")
physiological_data <- read_excel("dataset.xlsx", sheet = "physiological")
composite_data <- read_excel("dataset.xlsx", sheet = "composite")
all_data <- rbind(rbind(rbind(rbind(time_data, correctness_data), rating_data), physiological_data), composite_data)

# Set this to true if you want to run the pearson assumption tests. Note: this may take a few minutes.
pearson_assumption_test = TRUE



##---------------------------------------------------------------##
##      Calculation of correlation coefficients per variable     ##
##---------------------------------------------------------------##
# This section contains the code to calculate the correlation coefficients used in our meta-analysis.

# Get all unique variable names
time_vars <- unique(time_data$var_name)
correctness_vars  <- unique(correctness_data$var_name)
rating_vars <- unique(rating_data$var_name)
physiological_vars <- unique(physiological_data$var_name)
composite_vars <- unique(composite_data$var_name)

# Create empty dataframe to store correlation data
columns <- c("var_name", "cor", "n", "p_value")

# Function to calculate and print the correlation coefficients for the given variables and data using the given method
# Returns the correlation coefficients as a dataframe
print_correlation <- function(vars, input_data, correlation_method) {
  correlation_data <- as.data.frame(matrix(ncol = length(columns), nrow=0, dimnames = list(NULL,columns)))
  for (var in vars) {
    entries <- input_data %>% filter(var_name == var) # Take the entries for this variable name
    
    # Calculate the correlation coefficient
    correlation_result <- cor.test(entries$cognitive_complexity, entries$value, method=correlation_method)
    print(paste("The variable is", var,
                ". The correlation coefficient is ", correlation_result$estimate,
                " and its p-value is ", correlation_result$p.value,
                " and n is ", nrow(entries), " (", correlation_method, ").", sep=""))
      
    new_row <- data.frame(var_name=var, cor=correlation_result$estimate, n=nrow(entries), p_value=correlation_result$p.value, stringsAsFactors=FALSE)
    correlation_data <- rbind(correlation_data, new_row)
  }
  return(correlation_data)
}

# Calculate correlations for TIME variables (positive means support for hypothesis)
pearson_time_correlation_data <- print_correlation(time_vars, time_data, "pearson")
print_correlation(time_vars, time_data, "spearman")
kendall_time_correlation_data <- print_correlation(time_vars, time_data, "kendall")

# Calculate correlations for CORRECTNESS variables (negative means support for hypothesis)
pearson_correctness_correlation_data <- print_correlation(correctness_vars, correctness_data, "pearson")
print_correlation(correctness_vars, correctness_data, "spearman")
kendall_correctness_correlation_data <- print_correlation(correctness_vars, correctness_data, "kendall")

# Calculate correlations for RATING variables (negative means support for hypothesis)
pearson_rating_correlation_data <- print_correlation(rating_vars, rating_data, "pearson")
print_correlation(rating_vars, rating_data, "spearman")
kendall_rating_correlation_data <- print_correlation(rating_vars, rating_data, "kendall")

# Calculate correlations for PHYSIOLOGICAL variables
pearson_physiological_correlation_data <- print_correlation(physiological_vars, physiological_data, "pearson")
print_correlation(physiological_vars, physiological_data, "spearman")
kendall_physiological_correlation_data <- print_correlation(physiological_vars, physiological_data, "kendall")

# Calculate correlations for COMPOSITE variables (positive means support for hypothesis)
pearson_composite_correlation_data <- print_correlation(composite_vars, composite_data, "pearson")
print_correlation(composite_vars, composite_data, "spearman")
kendall_composite_correlation_data <- print_correlation(composite_vars, composite_data, "kendall")



##---------------------------------------------------------------##
##   Calculation of the time correctness (composite variables)   ##
##---------------------------------------------------------------##
# This section contains the code used to calculate the composite variables used in our correlation analysis.

# Note: The variable names are hard-coded because some datasets had multiple time variables.
#       We only chose one time variable per snippet to compute the composite variable.
time_var_names <- c("1_time", "4_time_tasks_a", "4_time_tasks_b", "5_time_for_all_answers", "6_tnpu", "9_tr", "10_duration")
correctness_var_names <- c("1_correct", "4_correctness_tasks_a", "4_correctness_tasks_b", "5_correctness", "6_au", "9_acc", "10_correct")
composite_var_names <- c("1_tc", "4_tc_tasks_a", "4_tc_tasks_b", "5_tc", "6_tc", "9_tc", "10_tc")
tc_var_description <- "Timed Correctness. Composite variable calculated from the time and correctness of comprehension task."

# Go through each pair of time and correctness for each study
for(i in 1:7) {
  # Get values for time and correctness
  entries_time <- time_data %>% filter(var_name == time_var_names[i])
  entries_correctness <- correctness_data %>% filter(var_name == correctness_var_names[i])
  # Add time values to correctness entries
  entries_correctness$time <- entries_time$value
  
  max_correctness <- max(entries_correctness$value, na.rm = TRUE)
  max_time <- max(entries_correctness$time, na.rm = TRUE)
  
  # Calculate new tc values
  for(j in 1:nrow(entries_correctness)) {
    tc_result <- (entries_correctness[j, "time"] / max_time) * (1 - (entries_correctness[j, "value"] / max_correctness))
    entries_time[j, "value"] <- tc_result
    entries_time[j, "description"] <- paste("Timed Correctness. Composite variable calculated from time (", 
                                            entries_time[j, "var_name"],
                                            ") and correctness (", entries_correctness[j, "var_name"], ").", sep = "")
  }
  
  # Create new composite entries from time entries
  entries_composite <- entries_time
  entries_composite$var_name <- composite_var_names[i] # Rename variable name
  
  # Add new composite entries to all composite entries
  if (exists("tc_data")) {
    tc_data <- rbind(tc_data, entries_composite)
  } else {
    tc_data <- entries_composite
  }
}

# Rename tc value column
colnames(tc_data)[which(names(tc_data) == "time")] <- "tc"
# Write to Excel file
write_xlsx(tc_data, "tc-data.xlsx") 



##---------------------------------------------------------------##
##                Testing Pearson Assumptions                    ##
##---------------------------------------------------------------##
# This section contains code to create the q-q-/density-/scatter-plots and conduct the Shapiro-Wilk test.
# We used these to test the data for the assumptions necessary for the pearson correlation coefficient.

# Prints and saves the given plot, creates the corresponding directory if it doesn't exist yet.
print_and_save_plot <- function(plot, plot_label, did, var_name) {
  print(plot)
  path = paste("./", plot_label, "/", sep="")
  dir.create(path, showWarnings = FALSE) # Create directory if it doesn't exist
  ggsave(plot, filename = file.path(path, paste(did, "_", var_name, "_", plot_label, ".png", sep = "")),
         dpi = 200, type = "cairo", width = 7, height = 5, units = "in") # Export plot to PNG
}

# Prints and saves the Q-Q plot for the given variable
print_qq_plot <- function(variable, did, var_name) {
  qq_plot <- ggqqplot(variable,
                      title= paste("Q-Q Plot for ", var_name, " (Dataset ", did, ")", sep = ""))
  print_and_save_plot(qq_plot, "q-q-plot", did , var_name)
}
# Prints and saves the density plot for the given variable
print_density_plot <- function(variable, did, var_name, label) {
  density_plot <- ggdensity(variable,
                            main = paste("Density plot for ", var_name, " (Dataset ", did, ")", sep = ""),
                            xlab = label)
  print_and_save_plot(density_plot, "density-plot", did , var_name)
}
# Prints the scatter plot for the given variable.
print_scatter_plot <- function(entries, var_name, label) {
  scatter_plot <- ggplot(entries, aes(x=cognitive_complexity, y=value)) +
    geom_point() +
    geom_smooth(method=lm, formula = y~x, color="red", fill="#69b3a2", se=TRUE) +
    labs(title=paste(label, ": ", var_name, " Scatterplot ", "(n=", nrow(entries), ")", sep=""))
  print_and_save_plot(scatter_plot, "scatter-plot", "", var_name)
}

# Prints the results of the Shapiro-Wilk test for the given variable
print_shapiro_wilk <- function(variable, did, var_name) {
  shapiro_result <- shapiro.test(variable)
  print(paste(shapiro_result$method, " for ", var_name, " (Dataset ", did, ")",
                ": W = ", shapiro_result$statistic,
                ", p-value = ", shapiro_result$p.value, sep=""))
}

# Prints and saves the q-q-/density-/scatter-plots and prints the results of the Shapiro-Wilk test used to test for the pearson correlation assumptions
test_pearson_assumptions <- function(vars, input_data, label) {
  for (var in vars) {
    entries <- input_data %>% filter(var_name == var) # Take the entries for this variable

    # Q-Q-/Density-plot and Shapiro-Wilk test for cognitive complexity of the dataset that contains the given variable
    print_density_plot(entries$cognitive_complexity, entries[1, "did"], "cognitive_complexity", "Cognitive Complexity")
    print_qq_plot(entries$cognitive_complexity, entries[1, "did"], "cognitive_complexity")
    print_shapiro_wilk(entries$cognitive_complexity, entries[1, "did"], "cognitive_complexity")

    # Q-Q-/Density-plot and Shapiro-Wilk test for the given variable
    print_density_plot(entries$value, entries[1, "did"], var, label)
    print_qq_plot(entries$value, entries[1, "did"], var)
    print_shapiro_wilk(entries$value, entries[1, "did"], var)

    # Scatterplot with linear trend and confidence interval
    print_scatter_plot(entries, var, label)
  }
}

# Runs pearson assumption tests for all variables types if wanted. Note: Generating all the images may take a few minutes.
if (pearson_assumption_test == TRUE) {
  # Tests for time variables
  test_pearson_assumptions(time_vars, time_data, "Time")
  # Tests for correctness variables
  test_pearson_assumptions(correctness_vars, correctness_data, "Correctness")
  # Tests for rating variables
  test_pearson_assumptions(rating_vars, rating_data, "Rating")
  # Tests for physiological variables
  test_pearson_assumptions(physiological_vars, physiological_data, "Brain Deactivation")
  # Tests for composite variables
  test_pearson_assumptions(composite_vars, composite_data, "Rating")
}



##---------------------------------------------------------------##
##                  Descriptive Statistics                       ##
##---------------------------------------------------------------##
# This section contains the code to calcualte some descriptive statistics on the cognitive complexity of the code snippets per study.

# Take the data for all snippets
entries <- all_data
# Data frame to store unique snippets
columns <- c("did", "sid", "cog_complexity")
all_snippets <- as.data.frame(matrix(ncol = length(columns), nrow=0, dimnames = list(NULL,columns)))
# Data frame to store descriptive statistics about cognitive complexity of code snippets per study
columns <- c("did", "med", "min", "max", "sd")
cog_complexity_data <- as.data.frame(matrix(ncol = length(columns), nrow=0, dimnames = list(NULL,columns)))

# Take only unique snippets with their DID, snippet ID and cognitive complexity
for(entry_index in 1:nrow(entries)) {
  entry <- entries[entry_index,]
  
  # Create SID by concatenating DID and snippet ID
  this_sid <- paste(entry[1], entry[5], sep = "_")
  
  # Add if SID doesn't exist yet
  if (all(all_snippets$sid != this_sid)) {
    all_snippets <- rbind(all_snippets, data.frame(did = entry[1], sid = this_sid, cog_complexity = entry[6]))
  }
}

all_dids <- unique(all_snippets$did)

# Calculate descriptive statistics on cognitive complexity on all data sets
for(this_did in all_dids) {
  entries <- all_snippets %>% filter(did == this_did)
  
  cog_complexity_data <- rbind(cog_complexity_data, data.frame(did = this_did,
                                                               med = median(entries$cognitive_complexity),
                                                               min = min(entries$cognitive_complexity),
                                                               max = max(entries$cognitive_complexity),
                                                               sd  = round(sd(entries$cognitive_complexity), digits = 2),
                                                               sno = nrow(entries)))
}

print(cog_complexity_data)



##---------------------------------------------------------------##
##                       Meta-Analysis                           ##
##---------------------------------------------------------------##
# This section contains the code we used to conduct our multi-level random-effects correlation meta-analysis.

# Returns pearson's r for the given tau using Kendall's formula (1970)
convert_to_pearson <- function(tau) {
  return(sin(0.5 * pi * tau))
}

# Combines the effect sizes of variables at the given positions, replacing them in the correlation data and returning it
combine_study_outcomes <- function(var_positions, label, correlation_data) {
  # Get the mean of the effect sizes
  effect_size_sum <- 0
  effect_size_number <- length(var_positions)
  for (i in 1:effect_size_number){
    effect_size_sum <- effect_size_sum + correlation_data[var_positions[i], "cor"]
  }
  pooled_effect_size <- effect_size_sum / effect_size_number
  
  correlation_data[var_positions[1], "var_name"] <- label
  correlation_data[var_positions[1], "cor"] <- pooled_effect_size
  correlation_data <- correlation_data[-c(tail(var_positions, n=-1)),]
  return(correlation_data)
}

# Combines the effect sizes of variables at the given positions, replacing them in the correlation data, adding up their n and returning it
combine_study_subgroups <- function(var_positions, label, correlation_data) {
  # Calculate and replace n
  n <- 0
  for (i in 1:length(var_positions)){
    n <- n + correlation_data[var_positions[i], "n"]
  }
  correlation_data[var_positions[1], "n"] <- n
  # Combinine the effect sizes
  correlation_data <- combine_study_outcomes(var_positions, label, correlation_data)
  return(correlation_data)
}

# Performs a correlation meta analysis on the given data and saves the forestplot to file
print_meta_analysis <- function(correlation_data, generateForestPlot, label) {
  meta_analysis_result <- metacor(cor, n, data = correlation_data,
                                  studlab = correlation_data$var_name,
                                  sm = "ZCOR", comb.fixed=FALSE,
                                  method.tau = "SJ")
  print(meta_analysis_result)
  if (generateForestPlot) {
    path = "./forest-plot/"
    dir.create(path, showWarnings = FALSE) # Create directory if it doesn't exist
    png(file = paste(path, label, "_forestplot.png", sep = ""), width = 1235, height = 575, res = 180)
    # pdf(file = paste(path, label, "_forestplot.pdf", sep = ""))
    forest_plot <- forest(meta_analysis_result)
    dev.off()
    print(forest_plot)
  }
}

# Convert all kendall's tau to pearsons r
kendall_time_correlation_data$cor <- sapply(kendall_time_correlation_data$cor, convert_to_pearson)
kendall_correctness_correlation_data$cor <- sapply(kendall_correctness_correlation_data$cor, convert_to_pearson)
kendall_rating_correlation_data$cor <- sapply(kendall_rating_correlation_data$cor, convert_to_pearson)
kendall_physiological_correlation_data$cor <- sapply(kendall_physiological_correlation_data$cor, convert_to_pearson)
kendall_composite_correlation_data$cor <- sapply(kendall_composite_correlation_data$cor, convert_to_pearson)

# Replace converted pearsons r with  real pearsons r where appropriate
time_correlation_data <- kendall_time_correlation_data
correctness_correlation_data <- kendall_correctness_correlation_data
rating_correlation_data <- kendall_rating_correlation_data
physiological_correlation_data <- kendall_physiological_correlation_data
composite_correlation_data <- kendall_composite_correlation_data

time_correlation_data[4, "cor"] <- pearson_time_correlation_data[4, "cor"]
# correctness_correlation_data[ , "cor"] <- pearson_correctness_correlation_data[ , "cor"]
# rating_correlation_data[ , "cor"] <- pearson_rating_correlation_data[ , "cor"]
physiological_correlation_data[ 2, "cor"] <- pearson_physiological_correlation_data[ 2, "cor"]
# composite_correlation_data[, "cor"] <- pearson_composite_correlation_data[, "cor"]

# Combine multiple outcomes or time-points within studies
time_correlation_data <- combine_study_outcomes(c(7,8,9), "7_pooled_time", time_correlation_data)
time_correlation_data <- combine_study_outcomes(c(9,10), "9_pooled_time", time_correlation_data)
rating_correlation_data <- combine_study_outcomes(c(1,2), "1_pooled_rating", rating_correlation_data)
rating_correlation_data <- combine_study_outcomes(c(4,5), "9_pooled_rating", rating_correlation_data)

# Combine independent subgroups within studies
time_correlation_data <- combine_study_subgroups(c(3,4), "4_pooled_time", time_correlation_data)
correctness_correlation_data <- combine_study_subgroups(c(2,3), "4_pooled_correctness", correctness_correlation_data)
composite_correlation_data <- combine_study_subgroups(c(2,3), "4_pooled_tc", composite_correlation_data)

# Perform correlation meta analysis and generate forest plot for time, correctness, rating, physiological and composite variables
print_meta_analysis(time_correlation_data, TRUE, "time")
print_meta_analysis(correctness_correlation_data, TRUE, "correctness")
print_meta_analysis(rating_correlation_data, TRUE, "rating")
print_meta_analysis(physiological_correlation_data, TRUE, "physiological")
print_meta_analysis(composite_correlation_data, TRUE, "composite")
