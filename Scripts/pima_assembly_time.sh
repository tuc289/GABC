#!/bin/bash
# Purpose of this script is to check the time of initial process of PIMA
#Usage: pima_time.sh <input directory as barcode##, with all the fast5 file>


cat *.fastq > combined.fastq

echo "qcat quality check starts at $(date)" > ../qcat_start_time

qcat --guppy --min-score 65 --kit RBK004 -f combined.fastq -b $1 

echo "qcat qualit check ends at $(date)" > ../qcat_end_time

echo "Assembly reads starts at $(data)" > ../flye_start_time
export PATH=$PATH:/gpfs/group/jzk303/default/data/CDC_bacilli/programs/Flye/bin

flye --nano-hq barcode12.fastq --genome-size 5m -o ./ -t 20

echo "Assembly reads ends at $(date)" > ../flye_end_time

echo "Assembly polished starts at $(date)" > ../minimap2_start_time

minimap2 -x map-ont -t 20 assembly.fasta barcode12.fastq > temporary_path
racon -t 20 barcode12.fastq temporary_path assembly.fasta > polished_contigs.fasta

echo "Assembly polishing ends at $(date)" > ../minimap2_end_time

cat guppy_start_time guppy_finish_time qcat_start_time qcat_end_time flye_start_time flye_end_time minimap2_start_time minimap2_end_time > time_log




