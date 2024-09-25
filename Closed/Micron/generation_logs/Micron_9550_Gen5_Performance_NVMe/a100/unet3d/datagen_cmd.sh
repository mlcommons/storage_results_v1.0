#!/bin/bash

# The log is in gcp, this is the command used to generate unet3d data for a100 tests
cd /root/storage
./benchmark.sh datagen --workload unet3d --accelerator-type a100 --num-parallel 8 --param dataset.num_files_train=28000 --param dataset.data_folder=/9550/unet3d_a100 -s 10.114.167.162