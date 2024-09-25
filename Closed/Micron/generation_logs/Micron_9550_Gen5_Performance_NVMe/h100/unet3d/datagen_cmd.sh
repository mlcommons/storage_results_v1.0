#!/bin/bash

# The log is in GCP, this is the command used to generate Unet3D data for the H100 tests
cd /root/storage
./benchmark.sh datagen --workload unet3d --accelerator-type h100 --num-parallel 8 --param dataset.num_files_train=14000 --param dataset.data_folder=/9550/unet3d_h100 -s 10.114.167.16