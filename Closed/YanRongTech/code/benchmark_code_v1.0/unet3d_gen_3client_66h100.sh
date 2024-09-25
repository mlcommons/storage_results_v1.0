# ./benchmark.sh datasize --workload unet3d --accelerator-type h100 --num-accelerators 66 --num-client-hosts 3 --client-host-memory-in-gb 251
#The benchmark will run for approx 13 minutes(best case)
#Minimum 231000 files are required which will consume 31539 GB of storage
#----------------------------------------------
#Set --param dataset.num_files_train=231000 with ./benchmark.sh datagen/run commands
./benchmark.sh datagen --hosts 192.168.11.14:72 --workload unet3d --accelerator-type h100 --num-parallel 72 --param dataset.num_files_train=231000 --param dataset.data_folder=/mnt/yrfs/mlperf/three_clients/unet3d
