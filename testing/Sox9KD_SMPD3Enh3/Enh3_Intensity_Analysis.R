library(dplyr)
library(tidyverse)
library(tidyr)

# Define path to measurement data
data_path = 'raw_source_data/'

# Loop through files in source data to pull in Fiji measurements
file_list = list.files(path = data_path)     # Determine files to loop through

for (file_ in file_list) {
  if (file_ == file_list[1]){   # Pull in first file to initialize df
    df <- read.csv(file.path(data_path, file_), header=TRUE, row.names=1)
    df['File'] <- file_
  }
  else {                       # Pull in the rest of the files and concatenate
    temp_data <- read.csv(file.path(data_path, file_), header=TRUE, row.names=1)
    temp_data['File'] <- file_
    df <- rbind(df, temp_data)  # Concatenates temp_data with df
  }
}

# Parse out relevant metadata from filenames and labels
df <- df %>% separate(Label, c('Channel', 'ROI'), ":")
df <- df %>% separate(File, c('Date','Treatment',
                              'Stains','Embryo','Somites','Mag','Type'), "_")
df <- unite(df, Emb_ID, c('Date','Treatment','Embryo'), sep = '_')
df <- select(df, -c('Min','Max','RawIntDen','Stains','Mag','Type')) # Drop unnecessary cols

# Normalize measured IntDen to electroporation control channel
# Define channels
measure_channel <- 'Enh3GFP'
norm_channel <- 'H2BRFP'

# Parse out and normalize data
data <- df[df$Channel==measure_channel & df$ROI!='Background',]
data['NormIntDen'] <- (data['IntDen'] / df[df$Channel==norm_channel 
                                    & df$ROI!='Background',]['IntDen'])
data <- select(data, -c('Area', 'Mean', 'IntDen')) # Drop unnecessary cols
data <- data %>% pivot_wider(names_from='ROI', values_from='NormIntDen')
data <- data %>% dplyr::rename('Cntl'='CntlArea', 'Expt'='ExptArea')

# Compute mean of control dataset and normalize everything to that
control_mean <- mean(data$Cntl)
data$Cntl <- data$Cntl/control_mean
data$Expt <- data$Expt/control_mean
# Determine the ratio of Experimental/Control IntDen
data$Ratio <- data$Expt/data$Cntl

# Save out analyzed data
write.csv(data, file=paste(Sys.Date(), 'normalized_data.csv', sep = "_", collapse = NULL))


