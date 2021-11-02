#!/bin/bash
#Required packages - Tracy (0.6.1 or higher), BLAST+ [Both pacakges are available in bioconda channel]

cd $1

ls *.ab1 > input.txt
while read oldname; do
  newname=$(awk -F'_' '{ print $2 "_" $3 ".ab1" }' <<< ${oldname} | \
        awk '{ print $1 }');
  cp ${oldname} ${newname};
done<input.txt

for f in *_ITS1.ab1
do 
tracy assemble $f ${f%_ITS1.ab1}_ITS4.ab1 -o ${f%_ITS1.ab1}
rm $f
rm ${f%_ITS1.ab1}_ITS4.ab1
rm input.txt
mv ${f%_ITS1.ab1}.cons.fa ${f%_ITS1.ab1}.concensus.fasta
done

rm *.json
rm *.vertical
rm *.align.fa

for t in *.concensus.fasta
do
blastn -db nr -query $t -remote -out ${t%.concensus.fasta}.blast.txt
done



for f in *.txt
do; echo $f; sed -n '20,40p' $f; echo "\n";
done > blast_results_combined.txt
