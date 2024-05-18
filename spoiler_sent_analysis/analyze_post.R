library(tidyverse)

##### Mean sentiment #####
df_sent_mean = read.csv("./data/spoiler_sent_all.csv",header = F)
colnames(df_sent_mean) = c("book_id", "good",
                           "spoiler", "all")

df_sent_mean_long = df_sent_mean %>% 
  pivot_longer(cols = -book_id)

ggplot(df_sent_mean_long) + 
  geom_boxplot(aes(y = value, x = name, group = name, fill = name)) + 
  scale_fill_manual(values = c("good" = "royalblue", 
                               "spoiler" = "tomato", 
                               "all" = "green3")) + 
  labs(x = "", y = "") + 
 ggtitle("Mean Sentiment Comparison Between Reviews") + 
  theme(legend.position = "none")

##### All Sentiment #####
df_sent_all = read.csv("./data/spoiler_df_sent_all.csv",header = T)
colnames(df_sent_all) = c("good", "spoiler", "all")

df_sent_all_long = df_sent_all %>% 
  pivot_longer(cols = everything())

ggplot(df_sent_all_long) + 
  geom_boxplot(aes(y = value, x = name, group = name, fill = name),
               outlier.shape = NA) + 
  scale_fill_manual(values = c("good" = "royalblue", 
                               "spoiler" = "tomato", 
                               "all" = "green3")) + 
  coord_cartesian(ylim = c(-0.2, 0.3)) +
  labs(x = "", y = "") + 
  ggtitle("Sentiment Comparison Between Reviews") + 
  theme(legend.position = "none")

##### Word Cloud #####
plot_word_cloud = function(df){
  set.seed(7)
  wordcloud2(df, size=.5, color='random-dark')
}

df_example = read.csv("./data/freq_1.csv")
plot_word_cloud(df_example[,1:2]) # Spoiler
plot_word_cloud(df_example[,3:4]) # Good

