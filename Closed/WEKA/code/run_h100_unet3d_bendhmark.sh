#!/bin/bash
server=100.127.7.221
workload=unet3d
# H100 runs
for i in {1..5}; do
  run_name="run${i}_1c_${workload}_h100_13a"
  echo "Starting run: $run_name"
  # Drop caches before executing another run and sleep for 30 seconds

  echo "Clearing cache before run."
    sync; echo 3 > /proc/sys/vm/drop_caches
    sleep 30
  ./benchmark.sh run -s $server -w $workload -g h100 -n 13 -r /root/boni/mlperf/$workload-h100/run${i} --param dataset.num_files_train=75000 --param dataset.num_subfolders_train=1000 --param dataset.data_folder=/mnt/weka/storage/unet3d_data_h100 --param reader.read_threads=32 --param reader.prefetch_size=0 --param reader.transfer_size=0
  if [ $? -ne 0 ]; then
    echo "Run $run_name failed. Check ${run_name}.log for details."
    exit 1
  else
    echo "Run $run_name completed successfully."
  fi
done
