#!/bin/bash
#
# WEKA MLPerf Storage v1.0 Single Client Run Script for Unet3D
#
# by Boni Bruno | WEKA Performance Engineering Director
#
##############################################################

server=100.127.7.221
workload=resnet50

# A100 runs

for i in {1..5}; do

  run_name="run${i}_1c_${workload}_a100_120a"

  echo "Starting run: $run_name"

  # Drop caches before executing another run and sleep for 30 seconds

  sync; echo 3 > /proc/sys/vm/drop_caches

  sleep 30

./benchmark.sh run -s $server -w $workload -g a100 -n 90 -r resnet-a100-a90/run${i} --param dataset.num_files_train=76692 --param reader.read_threads=1 --param reader.prefetch_size=0 --param reader.transfer_size=0 --param dataset.num_subfolders_train=996 --param dataset.data_folder=/mnt/weka/storage/resnet_data_a100 

  if [ $? -ne 0 ]; then
    echo "Run $run_name failed. Check dlio.log for details."
    exit 1
  else
    echo "Run $run_name completed successfully."
  fi

done

# H100 runs

for i in {1..5}; do

  run_name="run${i}_1c_${workload}_h100_70a"

  echo "Starting run: $run_name"
  
# Drop caches before executing another run and sleep for 30 seconds

  sync; echo 3 > /proc/sys/vm/drop_caches

  sleep 30

./benchmark.sh run -s $server -w $workload -g h100 -n 70 -r resnet-h100-70a/run${i} --param dataset.num_files_train=76692 --param reader.read_threads=1 --param reader.prefetch_size=0 --param reader.transfer_size=0 --param dataset.num_subfolders_train=996 --param dataset.data_folder=/mnt/weka/storage/resnet_data_h100 

  if [ $? -ne 0 ]; then
    echo "Run $run_name failed. Check dlio.log for details."
    exit 1
  else
    echo "Run $run_name completed successfully."
  fi

done
