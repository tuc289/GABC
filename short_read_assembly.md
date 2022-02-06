# Short read assembly using SPAdes

## Table of Contents ##

1. [Performs basic quality check](#fastqc) [(**fastqc**)](https://github.com/s-andrews/FastQC)
2. [Trim the adapters and poor-quality bases](#trimmomatic) [(**trimmomatic**)](https://github.com/usadellab/Trimmomatic)
3. [Assemble reads into contigs](#spades) [(**SPAdes**)](https://github.com/ablab/spades)
4. [Genomic assemblies evaluation and comparison](#quast) [(**QUAST**)](https://github.com/ablab/quast)
5. [Calculating average coverage of the genome](#average_coverage) ([**BWA**](https://github.com/lh3/bwa) and [**Samtools**](https://github.com/samtools/samtools))

<a name = "fastqc"></a>
### Performs basic quality ckeck ###

FastQC provide a simple quality control results on raw sequence data from high throughput sequencing pipelines. fastq file(s) (or fastq.gz file) is required to run FastQC. This can be done before and after quality control to compare the results (i.e., barcode trimming and poor-quality bases elimination).

```
fastqc <input fastq (fastq.gz) file> -o fastq_results
done
```

The analysis in FastQC is performed by a series of analysis modules. The left hand side of the main interactive display or the top of the HTML report show a summary of the modules which were run, and a quick evaluation of whether the results of the module seem entirely normal (green tick), slightly abnormal (orange triangle) or very unusual (red cross).

It is important to stress that although the analysis results appear to give a pass/fail result, these evaluations must be taken in the context of what you expect from your library. A 'normal' sample as far as FastQC is concerned is random and diverse. Some experiments may be expected to produce libraries which are biased in particular ways. You should treat the summary evaluations therefore as pointers to where you should concentrate your attention and understand why your library may not look random and diverse.

![image](https://user-images.githubusercontent.com/62360632/152664898-81222c69-70c3-45aa-86cf-adaa51d524fc.png)

For each position a Box-Whisker type plot is drawn. The elements of the plot are as follows:

- The central red line is the median value
- The yellow box represents the inter-quartile range (25-75%)
- The upper and lower whiskers represent the 10% and 90% points
- The blue line represents the mean quality
- The y-axis on the graph shows the quality scores. The higher the score the better the base call. The background of the graph divides the y axis into very good quality calls (green), calls of reasonable quality (orange), and calls of poor quality (red). The quality of calls on most platforms will degrade as the run progresses, so it is common to see base calls falling into the orange area towards the end of a read.

You can merge multiple fastqc results into one concatenated results using multiqc

```
multiqc . -o ./
```

<a name = "trimmomatic"></a>
### Trim the adapters and poor-quality bases ###
Trimmomatic performs a number of useful trimming functions for illumina paired-end short reads data. This step includes i) get rid of barcode sequences from each reads, ii) remove low quality bases based on the Phred sequencing quality score, and iii) get rid of reads shorter than certain length

```
trimmomatic PE -phred33 input_1.fastq.gz input_2.fastq.gz 
                        output_trimmedP_1.fastq.gz output_trimmedP_2.fastq.gz 
                        output_trimmedS_1.fastq.gz output_trimmedS_2.fastq.gz 
                        -trimlog log ILLUMINACLIP:<adapter_file>:2:30:10 
                        LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 
```

- ILLUMINACLIP: Cut adapter and other illumina-specific sequences from the read.
- SLIDINGWINDOW: Perform a sliding window trimming, cutting once the average quality within the window falls below a threshold.
- LEADING: Cut bases off the start of a read, if below a threshold quality
- TRAILING: Cut bases off the end of a read, if below a threshold quality
- MINLEN: Drop the read if it is below a specified length

Reference : http://www.usadellab.org/cms/?page=trimmomatic

<a name = "spades"></a>
### Assemble reads into contigs ###

*de novo* assembly (as called as "reference free assembly") is a skill to assemble short nucleotide sequences into long assembled sequences (contigs) with out reference genome.

SPAdes (St. Petersburg genome assembler) is an assembly program with various assembly pipelines. SPAdes requires paired fastq file as input (fasta file can also be used but recommended). 

```
spades.py -k 99,127 --isolate -1 <input fastq file 1> -2 <input fastq file 2> -o <output directory> -t <number of threads> -m <amount of memory> 
```

<a name = "quast"></a>
### Genomic assemblies evaluation and comparison ###
QUAST (Quality Assessment Tool for Genome Assemblies) is a widely used bioinformatics tool for evaluating genome assemblies. A number of important output will be used to evaluate overall assemlies quality (e.g., N50, Number of contigs, Total length of the assembly, GC%).

![image](https://user-images.githubusercontent.com/62360632/143988245-29693950-a04d-4510-9501-ec9120871451.png)

**N50** is the shortest contig length that needs to be included for covering 50% of the genome. Meaning, Half of the genome sequence is covered by contigs larger than or equal the N50 contig size. Meaning, The sum of the lengths of all contigs of size N50 or longer contain at least 50 percent of the total genome sequence.

**GC-content** (or guanine-cytosine content) is the percentage of nitrogenous bases in a DNA or RNA molecule that are either guanine (G) or cytosine (C). This measure indicates the proportion of G and C bases out of an implied four total bases, also including adenine and thymine in DNA and adenine and uracil in RNA.

#### Running QUAST ####
```
quast -o <output directory> -i <contigs.fasta>
```
#### Output files ####
```
report.txt      summary table
report.tsv      tab-separated version, for parsing, or for spreadsheets (Google Docs, Excel, etc)  
report.tex      Latex version
report.pdf      PDF version, includes all tables and plots for some statistics
report.html     everything in an interactive HTML file
```


<a name = "average_coverage"></a>
### Calculating average coverage of the genome ###

Calculating average coverage of the genome is a process to align raw reads to the assembled contig. By doing this, we can calculate the average coverage by counting number of cumulate based in each position on the contigs.

First off, assembled contig need to be 'indexed', meaning that those sequences will be used as reference in calculating average coverage. Next, raw trimmed reads will be mapped to the indexed reference by bwa. Lastly, calculate average coverage after sorting those mapped reads. 

```
# Indexing contigs
bwa index <contigs.fasta>

# Mapping reads to the indexed contigs
bwa mem -t <number of threads> <contig.fasta file> <trimmed reads file 1 .fastq> <trimmed reads file .fastq> > <output>.sam

# Converting SAM file to BAM with samtools
samtools view -Sb <output>.sam -o <output>.bam
rm *.sam

#Sorting BAM file with samtools
samtools sort <output>.bam <output>_sorted.bam

#Indexing sorted BAM file
samtools index <output>_sorted.bam

#Finally to calculate average coverage
X=$(samtools depth $<output>_sorted.bam | awk '{sum+=$3} END { print sum/NR}');
echo "<output>_sorted.bam";
echo "$X";
echo "<output>_sorted.bam $X" >> average_coverage.txt
```


