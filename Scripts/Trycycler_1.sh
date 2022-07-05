#!/bin/bash

# Trycycler_1.sh <nanopore fastq file>
# This pipeline is created to automate initial process of Trycycler. Manual intervention needs to be done between Trycycler_1.sh and Trycycler_2.sh
prefix= ${1%_nanopore.fastq}

# 1. Generating assemblies
# 1-1. Initial filtration
filtlong --min_length 1000 --keep_percent 95 $1 > ${prefix}_filt.fastq
# 1-2. subsampling reads
trycycler subsample --reads ${prefix}_filt.fastq --genome_size 5m --out_dir ${prefix}_subsample --threads 20

# 1-3. Assemblies

threads=20  # change as appropriate for your system

cd ${prefix}_subsamples
mkdir assemblies

flye --nano-hq sample_01.fastq --threads "$threads" --out-dir assembly_01 && cp assembly_01/assembly.fasta assemblies/assembly_01.fasta && rm -r assembly_01
miniasm_and_minipolish.sh sample_02.fastq "$threads" > assembly_02.gfa && any2fasta assembly_02.gfa > assemblies/assembly_02.fasta && rm assembly_02.gfa
raven --threads "$threads" sample_03.fastq > assemblies/assembly_03.fasta && rm raven.cereal

flye --nano-hq sample_04.fastq --threads "$threads" --out-dir assembly_04 && cp assembly_04/assembly.fasta assemblies/assembly_04.fasta && rm -r assembly_04
miniasm_and_minipolish.sh sample_05.fastq "$threads" > assembly_05.gfa && any2fasta assembly_05.gfa > assemblies/assembly_05.fasta && rm assembly_05.gfa
raven --threads "$threads" sample_06.fastq > assemblies/assembly_06.fasta && rm raven.cereal

flye --nano-hq sample_07.fastq --threads "$threads" --out-dir assembly_07 && cp assembly_07/assembly.fasta assemblies/assembly_07.fasta && rm -r assembly_07
miniasm_and_minipolish.sh sample_08.fastq "$threads" > assembly_08.gfa && any2fasta assembly_08.gfa > assemblies/assembly_08.fasta && rm assembly_08.gfa
raven --threads "$threads" sample_09.fastq > assemblies/assembly_09.fasta && rm raven.cereal

flye --nano-raw sample_10.fastq --threads "$threads" --out-dir assembly_10 && cp assembly_10/assembly.fasta assemblies/assembly_10.fasta && rm -r assembly_10
miniasm_and_minipolish.sh sample_11.fastq "$threads" > assembly_11.gfa && any2fasta assembly_11.gfa > assemblies/assembly_11.fasta && rm assembly_11.gfa
raven --threads "$threads" sample_12.fastq > assemblies/assembly_12.fasta && rm raven.cereal

cd ..


# 2. Clustering contigs
trycycler cluster --assemblies ${prefix}_subsample/assemblies/*.fasta --distance 0.0025 --threads 20 --reads ${prefix}_filt.fastq --out_dir ${prefix}_subsample/trycycler 

# 3. filtration of bad clusters (initial filtration, manual interpretaion is highly recommended)
mkdir ${prefix}_subsample/trycycler/BAD
for f in ${prefix}_subsample/trycycler/cluster_*
do
	if [ $(ls -l ${f}/1_contigs/*.fasta | wc -l) -lt 3 ];
	then
		mv $f ${prefix}_subsample/trycycler/BAD/
	fi
done

## OUTPUT - multiple directory named as cluter_### which has more than 3 contigs in the cluter


# 3. Reconcile contigs
for f in ${prefix}_subsample/trycycler/cluster_*
do
	trycycler reconcile --reads ${prefix}_filt.fastq --cluster_dir $f --threads 20 --min_identity 90 --max_indel_size 400
done


## End of the pipeline








