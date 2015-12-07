#!/bin/bash
#SBATCH --time=08:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=40000
#SBATCH --nodes=1

jsonfile=exp_${1}.json
echo $jsonfile
python sieve.py $jsonfile
