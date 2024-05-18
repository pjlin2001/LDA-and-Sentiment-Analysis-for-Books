rm(list=ls())

args = (commandArgs(trailingOnly=TRUE))
if(length(args) == 1){
  book = args[1]
} else {
  cat('usage: Rscript spoiler_split.R <book_id>\n', file=stderr())
  stop()
}

library(tidyverse)


df = read.csv("spoiler_reviews.csv")
df_sub = df %>% filter(book_id == book)
df_sub$review_sentences = gsub("\\[|\\]||'|,|'|\\\"", "", df_sub$review_sentences)
write.csv(df_sub, paste0(book,".csv"), row.names=F, quote=F)
