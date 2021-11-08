!/bin/bash

wget 
for f in barcode*
do
cd $f
sh Incrementation_assembly.sh ./
cd ..
done

