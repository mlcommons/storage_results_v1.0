# MLPerf™ Storage v1.0 Results

This is the repository containing results and code for the [v1.0 version of the MLPerf™ Storage benchmark](https://github.com/mlcommons/storage_results_v1.0). For final results please see [MLPerf™ Storage v1.0 benchmark results](https://mlcommons.org/benchmarks/storage/).

For benchmark code and rules please see the [GitHub repository](https://github.com/mlcommons/storage).

## MLPerf™ Storage results directory structure

A submission is for one instance of running the benchmark. An org may make multiple submissions.

In case of submission of results for multiple systems, please use `<system_desc_id>` to differentiate these. System names may be arbitrary. We recognize implementations for multiple systems of the same organization could have different dependencies on a common code base and on each other.

Please document in the `<system_desc_id>`.pdf and `<system_desc_id>`.json files:
* The hardware and software used on the client system(s) running the benchmark code
   - The CPU used, the DRAM capacity used, the PCIe connections used, etc
* The networking (if any) that connects the client system(s) to the storage system
   - Including the protocol name and version used
   - The hardware technology, link speeds, connection topology, etc
* The construction of the storage system
   - The number and interface type for any commodity drives
   - The software version and configuration options used during the test

A submission should take the form of a directory with the following structure. The structure must be followed regardless of the actual location of the actual code, e.g. in the MLPerf repo or an external code host site.
```
<division>
└── <submitting_organization>
    ├── code #the complete package of the benchmark code, configuration, and license files
    ├── systems #(holds one pair of description files for each system benchmarked)
    │   ├── <system_desc_id>.pdf #describes the test hardware, software, and configuration in human-readable format
    │   └── <system_desc_id>.json #describes the test hardware, software, and configuration in JSON format
    └── results
        └── <system_desc_id> # (one folder for each system benchmarked)
            └── <benchmark> #which workload is this
                ├── mlperf_storage_report.json #overall pass/fail and statistical summary of this workload
                └── run<1-5> #(one folder per final run of the benchmark)
                    └── <identifier> #(one folder for each client system during this run)
                        ├── configs #configuraton active for this run of the benchmark
                        │   ├── config.yaml #defines the I/O parameters for of the workload for this test
                        │   ├── hydra.yaml #defines the MPI configuration used for this test
                        │   └── overrides.yaml #records all comand line options used for this test
                        ├── <accnumber>_output.json #raw output of the test run
                        ├── dlio.log #complete log of I/O operations performed by the test
                        ├── per_epoch_stats.json #array of stats for each epoch processed during the tes
                        └── summary.json #summary of the test's pass/fail status and core statistics
```

System names and implementation names may be arbitrary.

`<division>` must be one of {closed, open}.

`<benchmark>` must be one of {unet3d, resnet50, cosmoflow}.

`<identifier>` is user-defined but typically the name of a client system.

`<accnumber>` is a number {0,1,...,n} for each simulated accelerator during this run.
