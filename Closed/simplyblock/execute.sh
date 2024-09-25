#!/bin/bash
for i in {3..5} ; do
  sudo sync
  sudo bash -c 'echo 3 > /proc/sys/vm/drop_caches'
  ./benchmark.sh run --hosts 172.31.74.102 --workload resnet50 --accelerator-type h100 --num-accelerators 24 --results-dir run${i} --param dataset.num_files_train=3836 --param dataset.data_folder=resnet50_data
done

