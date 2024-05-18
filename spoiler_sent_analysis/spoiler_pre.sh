#!/bin/bash

for dir in log error output; do
    if [ ! -d "$dir" ]; then
        mkdir "$dir"
    fi
done

