#!/bin/bash

# The log is in gcp, this is the command used to generate cosmoflow data for a100 tests
cd /root/storage
./benchmark.sh datagen --workload cosmoflow --accelerator-type a100 --num-parallel 8 --param dataset.num_files_train=485909 --param dataset.data_folder=/9550/cosmoflow_a100 -s 10.114.167.162