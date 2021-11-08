!/bin/bash
Usage: sh from_barcode_directory.sh <input directory which multiple sub-directory named as "barcode ##">

cd $1
wget https://github.com/tuc289/GABI/raw/main/Scripts/Incrementation_assembly.sh
for f in barcode*
do
cd $f
sh Incrementation_assembly.sh ./
cd ..
done

