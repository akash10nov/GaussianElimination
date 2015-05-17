#!/bin/bash

#SBATCH --partition=general-compute
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --job-name=Matrix_decomp_OpenMP
#SBATCH --time=00:5:50
#SBATCH --mail-user=akashpra@buffalo.edu
#SBATCH --mail-type=ALL
#SBATCH --output=Result_Matrix_decomp_OpenMP2.csv
#SBATCH --error=Result_Matrix_decomp_OpenMP2.csv

echo "$SLURM_NNODES , $SLURM_NTASKS_PER_NODE"
echo


ulimit -s unlimited
module load intel
#
./Matrix_decomp

#
