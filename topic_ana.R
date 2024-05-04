rm(list=ls())

args = commandArgs(trailingOnly = TRUE)
if (length(args) != 1){
   stop("usage: Rscript plot.R <file>")
}
file_name = args[1]

require("tidytext")
require("dplyr")
require("tidyverse")
require("topicmodels")
require("reshape2")

data = read.delim(file_name,header = TRUE, sep = "\t",quote = "")

data_clean <- data %>%
  unnest_tokens(word, review_body) %>%
  anti_join(stop_words) %>%
  filter(!str_detect(word, "^\\d+$"))

dtm <- data_clean %>%
  filter(word != "br") %>%
  count(review_id, word) %>%
  cast_dtm(review_id, word, n)

fit <- LDA(dtm, k = 6, control = list(seed = 479))

beta = tidy(fit, matrix = "beta") |>
  group_by(topic) |>
  top_n(30,beta) |>
  ungroup() |>
  arrange(topic, -beta)

category_name = regmatches(file_name, regexpr("(?<=us_).*?(?=_v1)", file_name, perl=TRUE))
output_beta = paste0("beta_", category_name,".csv")
write.csv(beta, output_beta, row.names = FALSE)

doc_topics <- tidy(fit, matrix = "gamma")
top_documents_for_topic3 <- doc_topics %>%
  filter(topic == 3) %>%
  arrange(desc(gamma)) %>%
  top_n(10)

top_comments_for_topic3 <- data %>%
  semi_join(top_documents_for_topic3, by = c("review_id" = "document")) %>%
  select(review_id, review_body) 

output_text = paste0("text_", category_name,".csv")
write.csv(top_comments_for_topic3, output_text, row.names = FALSE)
