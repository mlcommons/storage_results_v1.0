#!/bin/bash

./benchmark.sh datagen -s '127.0.0.1' -c closed -g a100 -n 24 -w cosmoflow -r /root/results/cosmoflow/datagen --param dataset.num_files_train=485909 --param dataset.data_folder=/9400nvme/cosmoflow --param dataset.num_subfolders_train=1000
./benchmark.sh datagen -s '127.0.0.1' -c closed -g a100 -n 24 -w resnet50 -r /root/results/resnet50/datagen --param dataset.num_files_train=12629 --param dataset.data_folder=/9400nvme/resnet50
./benchmark.sh datagen -s '127.0.0.1' -c closed -g a100 -n 24 -w unet3d -r /root/results/unet3d/datagen --param dataset.num_files_train=17500 --param dataset.data_folder=/9400nvme/unet3d
