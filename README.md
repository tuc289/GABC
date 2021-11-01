# GABI (Genomic Analysis of Bacillus isolates)

### Genomic Analysis of Bacillus isolates 

#### This workflow is designed to compare between 

1. illumina based short-read whole genome sequencing data 
2. Oxford Nanopore (ONT) based whole genome sequencing data
3. hybrid assembly using both 1 and 2

* PSU HPC (aka ROAR) will be used for entire workflow

## Getting started

The goal of this workflow is to complete different genome assembly and downstream analysis of whole genome sequencing data for *Bacillus* isolates using different sequencing platforms (i.e., illumina and oxford nanopore (ONT)). Entire workflow is adapted to the Penn State high performace computing system, so called [ROAR](https://www.icds.psu.edu/computing-services/roar-user-guide/). 

#### Short-read WGS data assembly workflow (required package or tools)

1. Performs basic quality control (**fastqc**)
2. Trim the adapters and poor-quality bases (**trimmomatic**)
3. Assemble reads into contigs (**SPAdes**)
4. Genomic assemblies evaluation and comparison (**QUAST**)
5. Calculating average coverage of the genome (**BWA** and **Samtools**)

#### Long-read WGS data assembly workflow (required package or tools)

1. Performs high accuracy basecalling from FAST5 files (**guppy**)
2. Trim the adapters, barcodes and poor-quality bases (**guppy**)
3. (optional) base quality correction (**LorDEC**)
4. Assemble reads (**Flye**)
5. Polish and imporve assembly (**Racon**)
6. Genomic assemblies evaluation and comparison (**QUAST**)
7. Calculating average coverage of the genome (**BWA** and **Samtools**)

#### Hybrid assembly workflow (required package or tools)

* Start with trimmed reads from both short-read sequencing and long-read sequencing

1. Assemble reads into contigs (**Unicycler** OR **Tricycler + polishing**) 
2. Genomic assemblies evaluation and comparison (**QUAST**)
3. Calculating average coverage of the genome (**BWA** and **Samtools**)

#### Downstream analysis 

1. Detecct genes of interest of *Bacillus cereus* (**Btyper3**)
2. Identify core SNPs (Single Nucleotide Polymorphism) (**kSNP3**)
3. Control phylogenetic tree (**IQ-tree2**)
4. Identify high-quality SNPs using [FDA CFSAN SNP](https://snp-pipeline.readthedocs.io/en/latest/readme.html) pipeline (in [GalaxyTrakr](https://galaxytrakr.org/root/login?redirect=%2F))
* 

## Installation and configuration

#### Connect to Roar

#### Install miniconda3 

#### Set up conda environment with required packages - and additional progeam installation with initial configuration

#### List of required packages 

##### Short-read assembly

##### Long-read assembly

##### Hybrid assembly

##### Downstream analysis

## Workflow

##### Short-read assembly

##### Long-read assembly

##### Hybrid assembly
