#!/bin/bash

if [ ! -d "spoiler_data" ]; then
    mkdir spoiler_data
fi

if [ ! -d "spoiler_sent" ]; then
    mkdir spoiler_sent
fi

if [ ! -d "spoiler_freq" ]; then
    mkdir spoiler_freq
fi

if [ ! -d "spoiler_df_sent" ]; then
    mkdir spoiler_df_sent
fi

find . -maxdepth 1 -type f -name "freq_*.csv" -exec mv {} spoiler_freq/ \;
find . -maxdepth 1 -type f -name "df_sent_*.csv" -exec mv {} spoiler_df_sent/ \;
find . -maxdepth 1 -type f -name "sent_*.csv" -exec mv {} spoiler_sent/ \;
find . -maxdepth 1 -type f -regextype egrep -regex './[0-9]+\.csv$' -exec mv {} spoiler_data/ \;

tail -n +2 -q ./spoiler_sent/*.csv > spoiler_sent_all.csv

echo "sentiment_good,sentiment_spoiler,sentiment" > spoiler_df_sent_all.csv

for file in ./spoiler_df_sent/*.csv; do
    tail -n +2 "$file" | cut -d',' -f10,11,12 >> spoiler_df_sent_all.csv
done


