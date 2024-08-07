#!/bin/bash

cd ./../

python $(pwd)/python/backup.py $(pwd)/raw_file/queue
python $(pwd)/python/backup.py $(pwd)/raw_file/report

# ls $(pwd)/parquet/pbi/ibm_queue