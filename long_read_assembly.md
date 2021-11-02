# Long read assemlby #

## Table of Contents ##

1. [Performs high accuracy basecalling from FAST5 files](#basecalling) ([**guppy**](https://community.nanoporetech.com/protocols/Guppy-protocol/v/gpb_2003_v1_revaa_14dec2018/linux-guppy))
2. [Trim the adapters, barcodes and poor-quality bases](#trim) ([**guppy**](https://community.nanoporetech.com/protocols/Guppy-protocol/v/gpb_2003_v1_revaa_14dec2018/linux-guppy))
3. [(optional) base quality correction](#correction) ([**LorDEC**](http://www.atgc-montpellier.fr/lordec/))
4. [Assemble reads](#flye) ([**Flye**](https://github.com/fenderglass/Flye))
5. [Polish and imporve assembly](#racon) ([**Racon**](https://github.com/isovic/racon))
6. [Genomic assemblies evaluation and comparison](#quast) [(**QUAST**)](https://github.com/ablab/quast)
7. [Calculating average coverage of the genome](#average_coverage) ([**BWA**](https://github.com/lh3/bwa) and [**Samtools**](https://github.com/samtools/samtools))
8. [automation of the process](#automation)

<a name = "basecalling"></a>
### Performs high accuracy basecalling from FAST5 files (guppy) ###

Basecalling is the process of generating sequence data with its base quality score (.fastq) from the raw signaling results of the Nanopore MinION sequencer. Guppy is the current basecaller provided from Oxford Nanopore. Basecalling can be completed real-time during the sequencing run, however we can also generate high accuracy reads based on the complicated neural network based basecalling from Guppy. Additionally, Guppy can be used to trim the low quality reads and barcode sequences after basecalling is completed

Input files format - *.fast5*
output files format - *.fastq*

before starts, please check if guppy directory is in your PATH varaibles
```
export PATH=$PATH:/directory for guppy installation/bin
echo $PATH #check if ~/ont-guppy-cpu/bin is in the PATH variable
```

Oxford Nanaopore technology provide different type of sequencing library kits, and different flowcells from different technology. It is important to select the same kits/flowcells for basecalling to recognize the right signal. To check the list of the kits and flowcells
```
guppy_basecaller --print_workflows
```
Now you will see something like this
```
Available flowcell + kit combinations are:
flowcell       kit               barcoding config_name                    model version
FLO-PRO001     SQK-LSK109                  dna_r9.4.1_450bps_hac_prom     2021-05-05_dna_r9.4.1_promethion_384_dd219f32
FLO-PRO001     SQK-LSK109-XL               dna_r9.4.1_450bps_hac_prom     2021-05-05_dna_r9.4.1_promethion_384_dd219f32
FLO-PRO001     SQK-LSK110                  dna_r9.4.1_450bps_hac_prom     2021-05-05_dna_r9.4.1_promethion_384_dd219f32
FLO-PRO001     SQK-DCS109                  dna_r9.4.1_450bps_hac_prom     2021-05-05_dna_r9.4.1_promethion_384_dd219f32
FLO-PRO001     SQK-PCS109                  dna_r9.4.1_450bps_hac_prom     2021-05-05_dna_r9.4.1_promethion_384_dd219f32
FLO-PRO001     SQK-PCS110                  dna_r9.4.1_450bps_hac_prom     2021-05-05_dna_r9.4.1_promethion_384_dd219f32
FLO-PRO001     SQK-PRC109                  dna_r9.4.1_450bps_hac_prom     2021-05-05_dna_r9.4.1_promethion_384_dd219f32
FLO-PRO001     SQK-MLK110-96-XL  included  dna_r9.4.1_450bps_hac_prom     2021-05-05_dna_r9.4.1_promethion_384_dd219f32
FLO-PRO001     SQK-PCB109        included  dna_r9.4.1_450bps_hac_prom     2021-05-05_dna_r9.4.1_promethion_384_dd219f32
FLO-PRO001     SQK-PCB110        included  dna_r9.4.1_450bps_hac_prom     2021-05-05_dna_r9.4.1_promethion_384_dd219f32
FLO-PRO002     SQK-LSK109                  dna_r9.4.1_450bps_hac_prom     2021-05-05_dna_r9.4.1_promethion_384_dd219f32
FLO-PRO002     SQK-LSK109-XL               dna_r9.4.1_450bps_hac_prom     2021-05-05_dna_r9.4.1_promethion_384_dd219f32
FLO-PRO002     SQK-LSK110                  dna_r9.4.1_450bps_hac_prom     2021-05-05_dna_r9.4.1_promethion_384_dd219f32
```

Find the right combination between flowcells and library preparation kits (here, we are using "SQK-RBK004" and "FLO-MIN106"

```
flowcell       kit               barcoding config_name                    model version
FLO-MIN106     SQK-PBK004        included  dna_r9.4.1_450bps_hac          2021-05-17_dna_r9.4.1_minion_384_d37a2ab9
```

Now, specify the input file, output directory, and configuration name (don't forget to add configuration file extenstion (.cfg) at the end)

**hac** is representing "high accuracy"

```
guppy_basecaller -i [input.fast5] -s [output directory] 
                 -c dna_r9.4.1_450bps_hac.cfg --num_callers 2 --cpu_threads_per_caller 1
```
```
--num_callers : how many parallel basecallers to create
--cpu_threads_per_caller : how many threads will be used per each callers

[num_callers] * [cpu_threads_per_caller] = number of available threads
```

Now, it will generate multiple *.fastq* file from *.fast5* file in our output directory, you can simply combined all the sequences from *.fastq* files into one *.fastq* file
```
cd [output directory]
cat *.fastq > [output file name].fastq
```

Now, one huge *.fastq* file is generated as [output file name].fastq

<a name = "trim"></a>
### Trim the adapters, barcodes and poor-quality bases (guppy) ###



<a name = "correction"></a>
### (optional) base quality correction (LorDEC) ###

<a name = "flye"></a>
### Assemble reads (Flye) ###

<a name = "racon"></a>
### Polish and imporve assembly (Racon) ###

<a name = "quast"></a>
### Genomic assemblies evaluation and comparison (QUAST) ###

<a name = "average_coverage"></a>
### Calculating average coverage of the genome (BWA and Samtools) ###

<a name = "automation"></a>
### Automation of the process
