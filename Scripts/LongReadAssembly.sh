#!/bin/bash
#This script is a bash script version of pima (just with data processing steps) - using default GPU utilization and default parameters, in Roar
#To-do list - to provide custom parameters of each program more conveniently
#Usage qsub -F "<input directory>" LongReadAssembly.sh

#PBS -A jzk303_d_g_gc_default
#PBS -l nodes=1:ppn=??:gpus=1 
#PBS -l walltime=??:??:??
#PBS -l pmem=??

conda activate <your directory with program installed>
export PATH=$PATH:/gpfs/group/jzk303/default/data/CDC_bacilli/programs/ont-guppy/bin
export PATH=/usr/local/cuda-9.1/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-9.1/lib64:$LD_LIBRARY_PATH


echo "Guppy basecalling starts at $(date)" > guppy_start_time
guppy_basecaller -i $1 -r -s -$1 --num_caller --num_callers 14 --gpu_runners_per_device 8 --x "cuda:0" --flowcell FLO-MIN106 --kit SQK-RBK004


## needs to be tested in 3/3/2022, then extend it to the other programs (i.e., qcat, flye, and so on...)
## GPU monitoring "nvidia-smi"

#how to smoothly apply PBS and .sh file together with many arguments?
#Is it better to create .sh file and run through .pbs, or other way around?