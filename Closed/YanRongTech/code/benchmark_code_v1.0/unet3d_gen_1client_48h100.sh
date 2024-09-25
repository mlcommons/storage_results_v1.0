# ./benchmark.sh datasize --workload unet3d --accelerator-type h100 --num-accelerators 48 --num-client-hosts 1 --client-host-memory-in-gb 251
#The benchmark will run for approx 13 minutes(best case)
#Minimum 168000 files are required which will consume 22937 GB of storage
#----------------------------------------------
#Set --param dataset.num_files_train=168000 with ./benchmark.sh datagen/run commands
./benchmark.sh datagen --hosts 192.168.11.14:72 --workload unet3d --accelerator-type h100 --num-parallel 72 --param dataset.num_files_train=168000 --param dataset.data_folder=/mnt/yrfs/mlperf/one_client/unet3d/
