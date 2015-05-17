#!/bin/bash

#SBATCH --partition=general-compute
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --job-name=Matrix_decomp_OpenMP
#SBATCH --time=05:50:00
#SBATCH --mail-user=akashpra@buffalo.edu
#SBATCH --mail-type=ALL
#SBATCH --output=Result_Matrix_decomp_OpenMP8.csv
#SBATCH --error=Result_Matrix_decomp_OpenMP8.csv
echo "$SLURM_NNODES , $SLURM_NTASKS_PER_NODE"
echo


ulimit -s unlimited
module load intel
#
./Matrix_decomp

#
