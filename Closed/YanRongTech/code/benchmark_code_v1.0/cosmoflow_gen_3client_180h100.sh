# ./benchmark.sh datasize --workload cosmoflow --accelerator-type h100 --num-accelerators 180 --num-client-hosts 3 --client-host-memory-in-gb 251
#The benchmark will run for approx 2 minutes(best case)
#Minimum 1429258 files are required which will consume 3764 GB of storage
#----------------------------------------------
#Set --param dataset.num_files_train=1429258 with ./benchmark.sh datagen/run commands
./benchmark.sh datagen --hosts 192.168.11.14:72 --workload cosmoflow --accelerator-type h100 --num-parallel 72 --param dataset.num_files_train=1429258 --param dataset.data_folder=/mnt/yrfs/mlperf/three_clients/cosmoflow/
