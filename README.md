# I am committing changes

# Do you think it is working?

# GABI (Genomic Analysis of Bacterial Isolates)

### Genomic Analysis of Bacterial Isolates workflow

#### This workflow is designed to complete genome assembly with different sequencing technology

1. [illumina](https://www.illumina.com/techniques/sequencing/dna-sequencing/whole-genome-sequencing.html) based short-read whole genome sequencing data 
2. [Oxford Nanopore (ONT)](https://nanoporetech.com/applications/dna-nanopore-sequencing) based whole genome sequencing data
3. hybrid assembly using both 1 and 2

## Table of Contents ##

1. [Getting started](#getting_started)
2. [Installation and Configuration](#install_and_configure)
3. [Workflows](#workflow)

<a name = "getting_started"></a>
## Getting started

The goal of this workflow is to complete different genome assembly and downstream analyses of the whole genome sequencing data for bacterial isolates using different sequencing platforms (i.e., illumina and oxford nanopore (ONT)). Entire workflow is adapted and tested to the Penn State high performace computing system, so called [ROAR](https://www.icds.psu.edu/computing-services/roar-user-guide/).

#### Short-read WGS data assembly workflow (required package or tools)

1. Performs basic quality control [(**fastqc**)](https://github.com/s-andrews/FastQC)
2. Trim the adapters and poor-quality bases [(**trimmomatic**)](https://github.com/usadellab/Trimmomatic)
3. Assemble reads into contigs [(**SPAdes**)](https://github.com/ablab/spades)
4. Genomic assemblies evaluation and comparison [(**QUAST**)](https://github.com/ablab/quast)
5. Calculating average coverage of the genome ([**BWA**](https://github.com/lh3/bwa) and [**Samtools**](https://github.com/samtools/samtools))

* short-read assembly workflow was adapted from "FDSC 517 - Microbial genomic epidemiology" offered by Dr. Jasna Kovac 

#### Long-read WGS data assembly workflow (required package or tools)

1. Performs high accuracy basecalling from FAST5 files ([**guppy**](https://community.nanoporetech.com/protocols/Guppy-protocol/v/gpb_2003_v1_revaa_14dec2018/linux-guppy))
2. Trim the adapters, barcodes and poor-quality bases ([**guppy**](https://community.nanoporetech.com/protocols/Guppy-protocol/v/gpb_2003_v1_revaa_14dec2018/linux-guppy))
3. (optional) base quality correction ([**LorDEC**](http://www.atgc-montpellier.fr/lordec/))
4. Assemble reads ([**Flye**](https://github.com/fenderglass/Flye))
5. Polish and imporve assembly ([**Racon**](https://github.com/isovic/racon))
6. Genomic assemblies evaluation and comparison [(**QUAST**)](https://github.com/ablab/quast)
7. Calculating average coverage of the genome ([**BWA**](https://github.com/lh3/bwa) and [**Samtools**](https://github.com/samtools/samtools))

* Long-read assembly workflow was adapted from [PIMA (Plasmid, Integrations, Mutations, and Antibiotic resistance annonation pipeline)](https://github.com/abconley/pima)

#### Hybrid assembly workflow (required package or tools)

* Start with trimmed reads from both short-read sequencing and long-read sequencing

1. Assemble reads into contigs [(**Unicycler** OR **Tricycler + polishing**)](https://github.com/rrwick/Unicycler) 
2. Genomic assemblies evaluation and comparison [(**QUAST**)](https://github.com/ablab/quast)
3. Calculating average coverage of the genome ([**BWA**](https://github.com/lh3/bwa) and [**Samtools**](https://github.com/samtools/samtools))

#### Downstream analysis 

1. Detecct genes of interest of *Bacillus cereus* ([**Btyper3**](https://github.com/lmc297/BTyper3))
2. Identify core SNPs (Single Nucleotide Polymorphism) ([**kSNP3**](https://sourceforge.net/projects/ksnp/files/))
3. Control phylogenetic tree ([**IQ-tree2**](http://www.iqtree.org))
4. Identify high-quality SNPs using [FDA CFSAN SNP](https://snp-pipeline.readthedocs.io/en/latest/readme.html) pipeline (in **[GalaxyTrakr](https://galaxytrakr.org/root/login?redirect=%2F)**)
(GalaxyTrakr is not open to public - it is intended for use by GenomeTrakr laboratories and their collaborators to assist in the analysis of genomic data for foodborne pathogens)
5. Annonate plasmids (long-read assembly and hybrid assembly only) (**TBD**)
6. Detect antimicrobial resistance (AMR) genes ([**ABRicate**](https://github.com/tseemann/abricate), [**Megares**](https://megares.meglab.org)(An antimicrobial database))
7. Whole genome annotation and pangenome analysis ([**Prokka**](https://github.com/tseemann/prokka), [**Roary**](https://github.com/sanger-pathogens/Roary), [**Scoary**](https://github.com/AdmiralenOla/Scoary))

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
ssh [your PSU ID]@submit.aci.ics.psu.edu
```
  
  For more deatil, please check [Roar Supercoputer Users' Guide](https://www.icds.psu.edu/computing-services/roar-user-guide/)
  
 

#### Install miniconda3 

```
ID=[your PSU ID]
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh > miniconda-installer.sh
bash miniconda-installer.sh -b
```

change directory of installation as '/storage/work/$ID/'



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
cd /gpfs/scratch/$ID/
wget https://github.com/tuc289/GABI/raw/main/SRA_packages.txt 
conda install --yes --file SRA_packages.txt
rm SRA_packages.txt
```

**2. If you just need long read assembly (i.e., nanopore reads)**

``` 
cd /gpfs/scratch/$ID/
wget https://github.com/tuc289/GABI/raw/main/LRA_packages.txt
conda install --yes --file LRA_packages.txt
rm LRA_packages.txt
```

Unfortunately, ONT basecaller and barcode trimmer **guppy** is not available through conda installation. If you have an account from [Nanopore community](https://community.nanoporetech.com), you can find the download link from [download page](https://community.nanoporetech.com/downloads), or you can download using below commands 

**Please be aware that the provided link might *NOT* be linked to the latest version of the software**

```
cd /gpfs/scratch/$ID/
wget https://mirror.oxfordnanoportal.com/software/analysis/ont-guppy-cpu_5.0.16_linux64.tar.gz
tar -xf ont-guppy_cpu_5.0.16_linux64.tar.gz
cd ont-guppy-cpu
export PATH=$PATH:$(pwd) ## Add guppy to the PATH variable
```

**3. If you just need hybrid assembly**
```
cd /gpfs/scratch/$ID/
wget https://github.com/tuc289/GABI/raw/main/HBA_packages.txt
conda install --yes --file HBA_packages.txt
rm HBA_packages.txt
```

Unicycler is an hybrid assembly pipeline for bacterial genoms. This pipeline uses short-read assembly by (**SPAdes**) and long-read assembly by (**miniasm + Racon**) to complete hybrid assembly

```
cd /gpfs/scratch/$ID/
git clone https://github.com/rrwick/Unicycler.git
cd Unicycler
make
export PATH=$PATH:$(pwd) ## Add unicycler to the PATH variable
```
***Hopefully, it is all set to run the pipeline to assemble genomes!! ***

## Workflow

##### [Short-read assembly](https://github.com/tuc289/GABI/blob/main/short_read_assembly.md)

##### [Long-read assembly](https://github.com/tuc289/GABI/blob/main/long_read_assembly.md)

##### [Hybrid assembly](https://github.com/tuc289/GABI/blob/main/hybrid_assembly.md)

##### [Downstream assembly](https://github.com/tuc289/GABI/blob/main/downstream_analysis.md)
