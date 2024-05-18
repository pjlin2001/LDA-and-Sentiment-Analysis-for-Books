library(tidyverse)
library(syuzhet)
library(tidytext)
library(wordcloud2)

rm(list=ls())

args = (commandArgs(trailingOnly=TRUE))
if(length(args) == 1){
  book = args[1]
} else {
  cat('usage: Rscript sentiment.R <book_id>\n', file=stderr())
  stop()
}

df = read.csv(book)

find_spoiler = function(text){
  good = ""
  spoiler = ""
  sentences = trimws(unlist(str_split(text, "\\. |\\! |\\? |\\\" |\\) ")))
  for (sentence in sentences){
    if (grepl("^0", sentence)){
      sentence = sub("^0 ", "", sentence)
      good = str_c(good, sentence, ". ")
    }else if (grepl("^1", sentence)){
      sentence = sub("^1 ", "", sentence)
      spoiler = str_c(spoiler, sentence, ". ")
    }
  }
  return(list(good=good, spoiler=spoiler))
}

df <- df %>%
  rowwise() %>%
  mutate(result = list(find_spoiler(review_sentences))) %>%
  unnest_wider(result) %>%
  ungroup()

df_spoiler_word = df %>% 
  unnest_tokens(word, spoiler) %>% 
  anti_join(stop_words, by = "word") %>% 
  mutate(sent_word = get_sentiment(word, method = "afinn")) %>%
  filter(!grepl("\\d", word))

df_good_word = df %>% 
  unnest_tokens(word, good) %>% 
  anti_join(stop_words, by = "word") %>% 
  mutate(sent_word = get_sentiment(word, method = "afinn")) %>%
  filter(!grepl("\\d", word))


get_temp = 
  function(df){
    df_words_freq = df %>% 
      pull(word) %>% 
      table() %>% 
      sort(decreasing = T) %>% 
      as.data.frame()
    
    colnames(df_words_freq) = c("word", "freq")
    
    return(df_words_freq)
  }

aa = get_temp(df_spoiler_word)
bb = get_temp(df_good_word)
if (dim(aa)[1] >= 50 & dim(bb)[1] >= 50){
	cc = cbind(aa[1:50,], bb[1:50,])
} else{
	nums = min(dim(aa)[1], dim(bb)[1])
	cc = cbind(aa[1:nums,], bb[1:nums,])
}

colnames(cc) = c("word_s","freq_s", "word_g", "freq_g")
write.csv(cc, paste0("freq_", book), quote=F, row.names=F)

##### Sentiment ##### 
df_sent = df %>% 
  mutate(sentiment_good = get_sentiment(good, method = "afinn"),
         sentiment_spoiler = get_sentiment(spoiler, method = "afinn"),
         sentiment = get_sentiment(review_sentences, method = "afinn"))
df_sent = df_sent %>% 
  mutate(len_good = sapply(str_split(good, " "), length),
         len_spoiler = sapply(str_split(spoiler, " "), length),
         len = sapply(str_split(review_sentences, " "), length),
         sentiment = sentiment / len,
         sentiment_good = sentiment_good / len_good,
         sentiment_spoiler = sentiment_spoiler / len_spoiler,
         )

df_sent_summ = df_sent %>% 
  group_by(book_id) %>% 
  summarise(mean_good = mean(sentiment_good),
            mean_spoiler = mean(sentiment_spoiler),
            mean = mean(sentiment))

write.csv(df_sent_summ, paste0("sent_", book), quote=F, row.names=F)

write.csv(df_sent, paste0("df_sent_", book), quote=F, row.names=F)


