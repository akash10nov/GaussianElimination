#!/bin/bash

#SBATCH --partition=general-compute
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --job-name=Matrix_decomp_OpenMP
#SBATCH --time=00:25:00
#SBATCH --mail-user=akashpra@buffalo.edu
#SBATCH --mail-type=ALL
#SBATCH --output=Result_Matrix_decomp_OpenMP.csv
#SBATCH --error=Result_Matrix_decomp_OpenMP.csv

echo "$SLURM_NNODES , $SLURM_NTASKS_PER_NODE"
echo


ulimit -s unlimited
module load intel
make
#
./Matrix_decomp

#
