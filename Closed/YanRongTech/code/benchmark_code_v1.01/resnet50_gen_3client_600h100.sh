# ./benchmark.sh datasize --workload resnet50 --accelerator-type h100 --num-accelerators 600 --num-client-hosts 3 --client-host-memory-in-gb 251
#The benchmark will run for approx 9 minutes(best case)
#Minimum 95923 files are required which will consume 12814 GB of storage
#----------------------------------------------
#Set --param dataset.num_files_train=95923 with ./benchmark.sh datagen/run commands
./benchmark.sh datagen --hosts 192.168.11.14:72 --workload resnet50 --accelerator-type h100 --num-parallel 72 --param dataset.num_files_train=95923 --param dataset.data_folder=/mnt/yrfs/mlperf/three_clients/resnet50/
