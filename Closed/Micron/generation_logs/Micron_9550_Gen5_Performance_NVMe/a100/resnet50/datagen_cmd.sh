#!/bin/bash

# The log is in gcp, this is the command used to generate resnet50 data for a100 tests
cd /root/storage
./benchmark.sh datagen --workload resnet50 --accelerator-type a100 --num-parallel 8 --param dataset.num_files_train=18385 --param dataset.data_folder=/9550/resnet50_a100 -s 10.114.167.162