# GABI (Genomic Analysis of Bacterial isolates)

### Genomic Analysis of Bacterial isolates workflow

#### This workflow is designed to complete genome assembly with different sequencing technology

1. [illumina](https://www.illumina.com/techniques/sequencing/dna-sequencing/whole-genome-sequencing.html) based short-read whole genome sequencing data 
2. [Oxford Nanopore (ONT)](https://nanoporetech.com/applications/dna-nanopore-sequencing) based whole genome sequencing data
3. hybrid assembly using both 1 and 2

## Table of Contents ##

1. [Getting started](#getting_started)
2. [Installation and Configuration](#install_and_configure)
3. [Workflow](#workflow)

<a name = "getting_started"></a>
## Getting started

The goal of this workflow is to complete different genome assembly and downstream analyses of the whole genome sequencing data for bacterial isolates using different sequencing platforms (i.e., illumina and oxford nanopore (ONT)). Entire workflow is adapted and tested to the Penn State high performace computing system, so called [ROAR](https://www.icds.psu.edu/computing-services/roar-user-guide/).

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
4. Identify high-quality SNPs using [FDA CFSAN SNP](https://snp-pipeline.readthedocs.io/en/latest/readme.html) pipeline (in **[GalaxyTrakr](https://galaxytrakr.org/root/login?redirect=%2F)**)
(GalaxyTrakr is not open to public - it is intended for use by GenomeTrakr laboratories and their collaborators to assist in the analysis of genomic data for foodborne pathogens)
5. Annonate plasmids (long-read assembly and hybrid assembly only) (**TBD**)
6. Detect antimicrobial resistance (AMR) genes (**Abricate**, **Megares**)
7. Whole genome annotation and pangenome analysis (**Prokka**, **Roary**, **Scoary**)

*and many more...*

<a name = "install_and_configure"></a>
## Installation and configuration

Since the entire workflow is counting on numerous different bioinformatics packages and/or tools, it is important to understand and install correctly for mitigating any potential issues. [Conda](https://docs.conda.io/en/latest/) is a wonderful tool for managing Package, dependency and environment. 

#### Connect to Roar

#### Install miniconda3 

#### Set up conda environment with required packages - and additional progeam installation with initial configuration

#### List of required packages 

##### Short-read assembly

##### Long-read assembly

##### Hybrid assembly

##### Downstream analysis

<a name = "workflow"></a>
## Workflow

##### Short-read assembly

##### Long-read assembly

##### Hybrid assembly
