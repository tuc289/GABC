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

Since the entire workflow is counting on numerous different bioinformatics packages and programs, it is important to understand and install correctly for mitigating any potential issues. [Conda](https://docs.conda.io/en/latest/) is a wonderful tool for managing Package, dependency and environment. Currently, installation will be done by manual [miniconda](https://docs.conda.io/en/latest/miniconda.html) configuration in user work directory, but it can be changed to build integrated module in ROAR for everyone. 

#### Connect to ROAR

1. Connect ROAR via interactive desktop - noVNC 
  - connect [ICS-ACI portal](portal.aci.ics.psu.edu) (portal.aci.ics.psu.edu)
  - Log in with PSU account name and password
  - Click "My Interactive Sessions"
  - Click "RHEL7 Interactive Desktop"
  - Set up the desktop setting (Allocation, Number of hours, Node type)
  - Launch the session (it may take a few minutes to initiate the session

2. Connect ROAR via terminal

```

ssh [PSU account name]@submit.aci.ics.psu.edu

```
  
  For more deatil, please check [Roar Supercoputer Users' Guide](https://www.icds.psu.edu/computing-services/roar-user-guide/)
  
 

#### Install miniconda3 

```

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh > miniconda-installer.sh
bash miniconda-installer.sh -b

```

change directory of installation as '/storage/work/[PSU account]/'



Close the terminal and open a new one to make conda activate. You can check the conda installation by typing


```
conda
conda update conda #update conda to the latest version
```

Add [bioconda](https://bioconda.github.io) and [conda-forge](https://conda-forge.org) channel to the conda package manager

```
conda config --add channels bioconda
conda config --add channels conda-forge
```

#### Set up conda environment with required packages - and additional programs installation with initial configuration

Create an environment

```
conda create -y --name gabi 
conda activate gabi
```

Now, you activate your environment called **'gabi'**
Let's try to install all the required package for i) short-read assembly, ii) long-read assembly, and iii) hybrid-assembly

**1. If you just need short read assembly (i.e., illumina reads)**

```
cd /gpfs/scratch/[PSU ACCOUNT]/
wget https://github.com/tuc289/GABI/raw/main/SRA_packages.txt 
conda install --yes --file SRA_packages.txt
rm SRA_packages.txt

```
**2. If you just need long read assembly (i.e., nanopore reads)**
``` 
cd /gpfs/scratch/[PSU ACCOUNT]/
wget https://github.com/tuc289/GABI/raw/main/LRA_packages.txt
conda install --yes --file LRA_packages.txt
rm LRA_packages.txt
```
Unfortunately, ONT basecaller and barcode trimmer **guppy** is not available through conda installation. If you have an account from [Nanopore community](https://community.nanoporetech.com), you can find the download link from [download page](https://community.nanoporetech.com/downloads), or you can download using below commands 

**Please be aware that the provided link might *NOT* be linked to the latest version of the software**

```
wget https://mirror.oxfordnanoportal.com/software/analysis/ont-guppy-cpu_5.0.16_linux64.tar.gz
tar -xf ont-guppy_cpu_5.0.16_linux64.tar.gz
cd ont-guppy-cpu
export PATH=$PATH:$(pwd) ## Add guppy to the PATH variable
```

**3. If you just need hybrid assembly**
```
cd /gpfs/scratch/[PSU ACCOUNT]/
wget https://github.com/tuc289/GABI/raw/main/HBA_packages.txt
conda install --yes --file HBA_packages.txt
rm HBA_packages.txt
```

Unicycler is an hybrid assembly pipeline for bacterial genoms. This pipeline uses short-read assembly by (**SPAdes**) and long-read assembly by (**miniasm + Racon**) to complete hybrid assembly

```
git clone https://github.com/rrwick/Unicycler.git
cd Unicycler
make
```

## Workflow

##### Short-read assembly

##### Long-read assembly

##### Hybrid assembly
