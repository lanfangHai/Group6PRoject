rm(list=ls())
args = commandArgs(trailingOnly = TRUE)
if (length(args) != 1){
   stop("usage: Rscript plot.R <file>")
}
file_name = args[1]

data = read.delim(file_name,header = TRUE, sep = "\t")
category_name = regmatches(file_name, regexpr("(?<=us_).*?(?=_v1)", file_name, perl=TRUE))
hist_title = paste("Histogram of Sample Data for", category_name)
counts_file_name = paste(category_name, "_counts.csv",sep = "")

star_rating = data$star_rating[data$star_rating %in% 0:5]
counts_df = data.frame(table(star_rating))
write.csv(counts_df,counts_file_name,row.names = FALSE)
#pdf(plot_file_name)
#hist(data$star_rating, main=hist_title, xlab="Star_Rating", ylab="Frequency", col="skyblue", border="black")
#dev.off()
