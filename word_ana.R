rm(list=ls())

args = commandArgs(trailingOnly = TRUE)
if (length(args) != 1){
   stop("usage: Rscript plot.R <file>")
}
file_name = args[1]

require("tidytext")
require("dplyr")
data = read.delim(file_name,header = TRUE, sep = "\t",quote = "")
positive_reviews <- data %>%
  filter(star_rating >= 4) %>%
    select(review_body)

negative_reviews <- data %>%
  filter(star_rating <= 3) %>%
  select(review_body)

data_clean <- data %>%
  mutate(review_body = tolower(review_body)) %>%
  unnest_tokens(word, review_body) %>%
  anti_join(stop_words)

positive_words <- positive_reviews %>%
  unnest_tokens(word, review_body) %>%
  anti_join(stop_words) %>%
  count(word, sort = TRUE)

negative_words <- negative_reviews %>%
  unnest_tokens(word, review_body) %>%
  anti_join(stop_words) %>%
  count(word, sort = TRUE)

positive_freq <- positive_words %>%
  filter(word != "br") %>%
  top_n(20) %>%
  mutate(sentiment = "Positive")

negative_freq <- negative_words %>%
  filter(word != "br") %>%
  top_n(20) %>%
  mutate(sentiment = "Negative")

word_freq <- bind_rows(positive_freq, negative_freq)
output_files = paste0("word_",file_name, ".csv")
write.csv(word_freq, output_files, row.names = FALSE)
