# Downstream analysis of WGS assembly

## Table of Contents ##

1. [Detecct genes of interest of *Bacillus cereus* ](#btyper)([**Btyper3**](https://github.com/lmc297/BTyper3))
2. [Identify core SNPs (Single Nucleotide Polymorphism)](#ksnp) ([**kSNP3**](https://sourceforge.net/projects/ksnp/files/))
3. [Control phylogenetic tree](#iqtree) ([**IQ-tree2**](http://www.iqtree.org))
4. [Identify high-quality SNPs using FDA CFSAN SNP pipeline](#snp) (in **[GalaxyTrakr](https://galaxytrakr.org/root/login?redirect=%2F)**)
5. [Annonate plasmids (long-read assembly and hybrid assembly only)](#plasmid) (**TBD**)
6. [Detect antimicrobial resistance (AMR) genes](#abricate) ([**ABRicate**](https://github.com/tseemann/abricate), [**Megares**](https://megares.meglab.org)(An antimicrobial database))
7. [Whole genome annotation and pangenome analysis](#prokka) ([**Prokka**](https://github.com/tseemann/prokka), [**Roary**](https://github.com/sanger-pathogens/Roary), [**Scoary**](https://github.com/AdmiralenOla/Scoary))

<a name = "btyper"></a>
## Detecct genes of interest of Bacillus cereus ##

Btyper3 is a *in silico* taxonomic classification of *Bacillus cereus* group isolates using assembled genomes. Btyper3 requires an assembled genome contigs in FASTA format. Btyper3 can be used to identify taxonomic classification using ANI (average nucleotide identity), align to the known virulence gene, perform Bt toxin gene alignment to the database, seven-gene multi-locus sequence typing (MLST), *panC* clade typing, and so on.


```
btyper3 -i <contigs.fasta> -o <output directory> 
```

Btyper3 generate a tab-seperated text file as a report with its species, subspecies, virulence genes, bt toxin genes, pubMLST_ST, adjusted panC group, and final taxon names. 

<a name = "ksnp"></a>
## Identify core SNPs (Single Nucleotide Polymorphism) ##



<a name = "iqtree"></a>
## Control phylogenetic tree ##

<a name = "snp"></a>
## Identify high-quality SNPs using FDA CFSAN SNP pipeline ##

<a name = "plasmid"></a>
## Annonate plasmids (long-read assembly and hybrid assembly only) ##

<a name = "abricate"></a>
## Detect antimicrobial resistance (AMR) genes ##

<a name = "prokka"></a>
## Whole genome annotation and pangenome analysis ##
