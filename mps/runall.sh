#!/bin/bash

declare -a sieve=("s0" "s1" "s2" "s3" "s4" "s5" "s6")



for s in "${sieve[@]}"
do
    echo sbatch -o $s.auto.txt run_sieve.sh $s
    sbatch -o $s.auto.txt run_sieve.sh $s
done



