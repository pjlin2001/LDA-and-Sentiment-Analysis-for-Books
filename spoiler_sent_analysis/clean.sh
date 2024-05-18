#!/bin/bash

# Before running this script, change "rm" to "ls" and run that
# version. Check its output to be sure you are not including files you
# should not remove.

# Remove files written by HTCondor:
rm -f *.dag.*
rm -f error/*.err output/*.out log/*.log
rm -f spoiler_sent/*.csv
rm -f spoiler_freq/*.csv
# Remove files written by my code:
# ls -f data.txt.0[0-3]* mean sd sumsOfNumbers sumsOfSquaredDeviations inputFileList
