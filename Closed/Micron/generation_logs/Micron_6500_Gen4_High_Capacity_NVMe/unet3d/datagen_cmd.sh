#!/bin/bash

# The datagen log for unet3d was lost. This was the command used to generate data. Note the single accelerator.
cd /root/storage
./benchmark.sh datagen -s '127.0.0.1' -c closed -w unet3d -g h100 -n 1 -r /root/results/unet3d/datagen -p dataset.num_files_train=37500 -p dataset.data_folder=/6500-B7C4