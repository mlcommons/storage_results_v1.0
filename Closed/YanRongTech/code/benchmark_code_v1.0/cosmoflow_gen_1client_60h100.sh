# ./benchmark.sh datasize --workload cosmoflow --accelerator-type h100 --num-accelerators 60 --num-client-hosts 1 --client-host-memory-in-gb 251
#The benchmark will run for approx 2 minutes(best case)
#Minimum 476419 files are required which will consume 1254 GB of storage
#----------------------------------------------
#Set --param dataset.num_files_train=476419 with ./benchmark.sh datagen/run commands
./benchmark.sh datagen --hosts 192.168.11.14:72 --workload cosmoflow --accelerator-type h100 --num-parallel 72 --param dataset.num_files_train=476419 --param dataset.data_folder=/mnt/yrfs/mlperf/one_client/cosmoflow
