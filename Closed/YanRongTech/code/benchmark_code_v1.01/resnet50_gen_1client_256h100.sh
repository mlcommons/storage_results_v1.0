# ./benchmark.sh datasize --workload resnet50 --accelerator-type h100 --num-accelerators 256 --num-client-hosts 1 --client-host-memory-in-gb 251
#The benchmark will run for approx 9 minutes(best case)
#Minimum 40927 files are required which will consume 5467 GB of storage
#----------------------------------------------
#Set --param dataset.num_files_train=40927 with ./benchmark.sh datagen/run commands
./benchmark.sh datagen --hosts 192.168.11.14:72 --workload resnet50 --accelerator-type h100 --num-parallel 72 --param dataset.num_files_train=40927 --param dataset.data_folder=/mnt/yrfs/mlperf/one_client/resnet50/
