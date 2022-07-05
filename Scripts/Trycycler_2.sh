#!/bin/bash

# Trycycler_2.sh <nanopore fastq file>
# This pipeline is created to automate initial process of Trycycler. Manual intervention needs to be done between Trycycler_1.sh and Trycycler_2.sh

# 1. Multiple Sequence alignment
prefix= ${1%_nanopore.fastq}

for f in ${prefix}_subsample/trycycler/cluster_*
do
	trycycler msa --cluster_dir $f --threads 20
done

# 2. Partitioning reads
trycycler partition --reads ${prefix}_filt.fastq --cluster_dirs ${prefix}_subsample/trycycler/cluster_* --threads 20

# 3. Generating a consensus
for f in ${prefix}_subsample/trycycler/cluster_*
trycycler consensus --cluster_dir $f --threads 20
done

cat ${prefix}_subsample/trycycler/cluster_*/7_final_consensus.fasta > ${prefix}_subsample/trycycler/consensus.fasta

# 4. Polishing after Trycycler
