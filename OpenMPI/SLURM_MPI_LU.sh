#!/bin/bash

#SBATCH --partition=general-compute
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=6
#SBATCH --job-name=LU_MPI
#SBATCH --time=00:30:00
#SBATCH --mail-user=akashpra@buffalo.edu
#SBATCH --mail-type=ALL
#SBATCH --output=Result_MM_MPI.csv
#SBATCH --error=Result_MM_MPI.csv

echo "SLURN Enviroment Variables:"
echo "Job ID = "$SLURM_JOB_ID
echo "Job Name = "$SLURM_JOB_NAME
echo "Job Node List = "$SLURM_JOB_NODELIST
echo "Number of Nodes = "$SLURM_NNODES
echo "Tasks per Nodes = "$SLURM_NTASKS_PER_NODE
echo "CPUs per task = "$SLURM_CPUS_PER_TASK
echo "/scratch/jobid = "$SLURMTMPDIR
echo "submit Host = "$SLURM_SUBMIT_HOST
echo "Subimt Directory = "$SLURM_SUBMIT_DIR
echo 

module load intel
module load intel-mpi
module list
make

ulimit -s unlimited

#
export I_MPI_PMI_LIBRARY=/usr/lib64/libpmi.so #used for cooperating MPI with slurm.
srun ./LU_MPI $1
srun ./LU_MPI $2
srun ./LU_MPI $3
srun ./LU_MPI $4
srun ./LU_MPI $5
#
echo "All Dones!"
