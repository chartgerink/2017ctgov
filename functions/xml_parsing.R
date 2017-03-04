#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)

if (length(args) == 0) stop('Missing arguments. Should be supplied two.
                             1. folder of ctgov xmls
                             2. filename for write-out (no extension necessary)')

if(!require(XML)) install.packages('XML')
if(!require(plyr)) install.packages('plyr')
if(!require(magrittr)) install.packages('magrittr')

folder_files <- args[1]
source('functions/rct_baseline.R')

files <- list.files(recursive = TRUE)
sel <- files[grepl(pattern = folder_files, x = files)]
res <- data.frame(nct_id = NULL,
			study_design = NULL,
			randomized = NULL,
			start_date = NULL,
			completion_date = NULL,
			overall_status = NULL,
			trial_condition = NULL,
			trial_phase = NULL,
			oversight_authority = NULL,
			trial_source = NULL,
			fda_regulated = NULL,
			number_of_arms = NULL,
			intervention_type = NULL,
			chi2 = NULL,
			df = NULL,
			pval = NULL)

for (i in 1:length(sel))
{
  # Initial xml parse
  x <- XML::xmlTreeParse(sel[i])
  # Get the root of the xml tree
  y <- XML::xmlRoot(x)
  z <- XML::xmlToList(y)

  nct_id <- z$id_info$nct_id %>% as.character %>% tail(n = 1)
  study_design <- z$study_design
  randomized <- grepl(study_design, pattern = '\\srandomized', ignore.case = TRUE)
  start_date <- z$start_date %>% is.null %>% ifelse(NA, z$start_date) %>% unlist
  completion_date <- z$completion_date %>% is.null %>% ifelse(NA, z$completion_date) %>% unlist
  overall_status <- z$overall_status
  trial_condition <- z$condition
  trial_phase <- z$phase
  oversight_authority <- z$oversight$authority
  trial_source <- z$source
  fda_regulated <- z$is_fda_regulated
  number_of_arms <- z$number_of_arms
  intervention_type <- z$intervention$intervention_type

  base_measures <- y[['clinical_results']][['baseline']][['measure_list']]
  df = data.frame(title = NULL, sub_title = NULL, units = NULL, param = NULL, group = NULL, value = NULL, spread = NULL)
  for (j in 1:length(base_measures))
  {
    base_measure <- base_measures[[j]]
    title <- base_measure[['title']][1]$text %>% as.character %>% tail(n = 1)
    units <- base_measure[['units']][1]$text %>% as.character %>% tail(n = 1)
    param <- base_measure[['param']][1]$text %>% as.character %>% tail(n = 1)
    cat_count <- length(base_measure[['category_list']])
    if (cat_count > 1)
    {
      for (cat in 1:cat_count)
      {
        base_me <- base_measure[['category_list']][cat]
        sub_title <- base_me$category[['sub_title']][1]$text %>% as.character %>% tail(n = 1)
        group_count <- length(base_me$category[['measurement_list']])
        for (q in 1:group_count)
        {
           tmp <- XML::xmlToList(base_me$category[['measurement_list']][q]$measurement)
           group <- tmp['group_id'] %>% as.character
           value <- tmp['value'] %>% as.numeric
           spread <- tmp['spread'] %>% as.numeric
           df <- rbind(df, data.frame(title, sub_title, units, param, group, value, spread))
        }
      }

    } else
    {
      group_count <- length(base_measure[['category_list']][['category']][['measurement_list']])
      for (q in 1:group_count)
      {
         tmp <- XML::xmlToList(base_measure[['category_list']][['category']][['measurement_list']][q]$measurement)
         group <- tmp['group_id'] %>% as.character
         value <- tmp['value'] %>% as.numeric
         spread <- tmp['spread'] %>% as.numeric
         df <- rbind(df, data.frame(title, sub_title = NA, units, param, group, value, spread))
      }
    }
  }
  rct <- rct_baseline_ctgov(df)
  print(i)
  res <- rbind(res, data.frame(nct_id = nct_id,
                        study_design = study_design,
                        randomized = randomized,
                        start_date = start_date,
                        completion_date = completion_date,
                        overall_status,
                        trial_condition,
                        trial_phase,
                        oversight_authority,
                        trial_source,
                        fda_regulated,
                        number_of_arms,
                        intervention_type,
                        rct$chi2,
                        rct$df,
                        rct$pval))
}

write.csv(res, sprintf('data/%s.csv', args[2]), row.names = FALSE)
