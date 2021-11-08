#!/bin/bash

cd $1

#First decompress .gz to fastq to combine files
gzip -d *.gz
#This is to make multiple fastq file from the first read to the 4000n th reads 
#from fastq output of nanopore sequencer
#Add leading 000 for sorting files

## For fastcalling results - need to write HAC version of the script too ##
ls *_??.fastq > input.txt
while read oldname; do
  newname=$(awk -F'_' '{ print $1 "_" $2 "_" $3 "_" "0" $5}' <<< ${oldname} | \
        awk '{ print $1 }');
  mv ${oldname} ${newname};
done<input.txt
rm input.txt

ls *_[0-9].fastq > input.txt
while read oldname; do
  newname=$(awk -F'_' '{ print $1 "_" $2 "_" $3 "_" "00" $5}' <<< ${oldname} | \
        awk '{ print $1 }');
  mv ${oldname} ${newname};
done<input.txt
rm input.txt

#combine fastq file in every 4000 reads
START=1
FC=$(ls -l *.fastq| wc -l)
END=$(echo $FC)
mkdir accum_fastq
for i in $(seq $START $END)
do
	list=$(ls *.fastq| head -$i)
	cat $list > $i.fastq
	echo "Create .fastq file containing first $i x 4000 reads"
	mv $i.fastq accum_fastq/
done

cd accum_fastq
## De novo assembly - each fastq
export PATH=$PATH:/gpfs/group/jzk303/default/data/CDC_bacilli/programs/Flye/bin
mkdir assembly_fasta
mkdir assembly_graph
mkdir assembly_info
mkdir assembly_log

for f in *.fastq
do
	flye --nano-raw $f --genome-size 5m -o ./ -t 4 -i 5
	mv assembly.fasta assembly_fasta/${f%.fastq}_contigs.fasta
	mv assembly_graph.gfa assebmly_graph/${f%.fastq}_conttigs_graph.gfa
	mv assembly_graph.gv assembly_graph/${f%.fastq}_contigs_graph.gv
	mv assembly_info.txt assembly_info/${f%.fastq}_contgs_info.txt
	mv flye.log assembly_log/flye_${f%.fastq}.log
done
echo "Assembly completed - flye"
echo "Used command (flye --nano-raw [.fastq file] --genome-size 5m -o ./ -t 4 -i 5)" 

###Polish and improve assembly by Racon ###
cd assembly_fasta
for e in *.fasta
do
	bwa index $e
	bwa mem -t 4 $e ../${e%_contigs.fasta}.fastq > ${e%_contigs.fasta}.sam
	racon -m 8 -x 6 -g -8 -w 500 -t 4 ../${e%_contigs.fasta}.fastq ${e%_contigs.fasta}.sam $e >${e%.fasta}_polished.fasta
done

## Quast assembly evaluation
quast *._polished.fasta -o quast_results 
