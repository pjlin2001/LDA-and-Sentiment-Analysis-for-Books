rm(list=ls())

library(tidyverse)
library(ggplot2)
library(readr)
library(syuzhet)
library(tidytext)
library(wordcloud2)


setwd("F:\\office\\2023 fall\\stat 605\\project")
# df <- read.csv("filtered1.csv")
# 
# df_essence <- df %>% filter(n_votes>5)
# df_normal <- df %>% filter(n_votes<=0)

# get_info <- function(filename="filtered_data"){
#   ess_data <- data.frame()
#   norm_data <- data.frame()
#   files <- dir(filename)
#   for (file in files){
#     df <- read.csv(paste("filtered_data/",file,sep=""))
#     #print(df[1,])
#     ess <- df %>% filter(n_votes>5) %>% 
#       mutate(senti = get_sentiment(review_text, method = "afinn")) %>% group_by(book_id) %>% 
#       summarise(rating_mean = mean(rating), rating_var = var(rating), senti_mean=mean(senti),senti_var=var(senti))
#     
#     normal <- df %>% filter(n_votes==0) %>% 
#       mutate(senti = get_sentiment(review_text, method = "afinn")) %>% group_by(book_id) %>% 
#       summarise(rating_mean = mean(rating), rating_var = var(rating), senti_mean=mean(senti),senti_var=var(senti))
#     ess_data <- rbind(ess_data,ess)
#     norm_data <- rbind(norm_data,normal)
#   }
#   
#   write.csv(ess_data,"ess_data.csv")
#   write.csv(norm_data,"norm_data.csv")
#   
# }
# 
# 
# 
# 
# get_info()

ess_data <- read.csv("ess_data.csv")
norm_data <- read.csv("norm_data.csv")


top_3_books <- norm_data %>%
  arrange(desc(rating_mean)) %>%                       # Sort by rating_mean in descending order
  slice_head(n = 20) %>%                               # Select the top 20 books
  filter(senti_mean > median(senti_mean),              # Filter for relatively high senti_mean
         senti_var < median(senti_var)) %>%            # Filter for relatively low senti_var
  arrange(desc(senti_mean), senti_var) %>%             # Arrange by high senti_mean and low senti_var
  slice_head(n = 3) %>%                                # Select the top 3 books based on these criteria
  select(book_id)                                      # Extract only the book_id column

print(top_3_books)


book1 <- read.csv("filtered_data/filtered29780253.csv")
book2 <- read.csv("filtered_data/filtered11387515.csv")


b1 <- book2 %>% unnest_tokens(word, review_text) %>% 
  anti_join(stop_words, by = "word") %>%
  mutate(sent_word = get_sentiment(word, method = "afinn")) %>% 
  group_by(review_id) %>% pull(word) %>% 
  table() %>% 
  sort(decreasing = T) %>% 
  as.data.frame() %>% slice_head(n = 50)

colnames(b1) = c("word", "freq")

wordcloud2(b1)











