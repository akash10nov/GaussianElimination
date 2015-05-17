#!/bin/bash
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --job-name=MM_CUDA_1
#SBATCH --time=00:10:00
#SBATCH --mail-user=chaofeng@buffalo.edu
#SBATCH --output=Result_MM_CUDA_1.csv
#SBATCH --error=Result_MM_CUDA_1.out

echo "SLURM Environment Variables:"
echo "Job ID = "$SLURM_JOB_ID
echo "Job Name = "$SLURM_JOB_NAME
echo "Job Node List = "$SLURM_JOB_NODELIST
echo "Number of Nodes = "$SLURM_NNODES
echo "Tasks per node = "$SLURM_NTASKS_PER_NODE
echo "CPUs per task = "$SLURM_CPUS_PER_TASK
echo "/scratch/jobid = "$SLURMTMPDIR
echo "Submit Host = "$SLURM_SUBMIT_HOST
echo "Submit Directory = "$SLURM_SUBMIT_DIR
echo 
echo

ulimit -s unlimited
#

module load cuda
nvcc Matrix_Multiplication_CUDA_1_1T.cu -o Matrix_Multiplication_CUDA_1_1T -arch=sm_20

./Matrix_Multiplication_CUDA_1_1T $1
./Matrix_Multiplication_CUDA_1_1T $2
./Matrix_Multiplication_CUDA_1_1T $3
./Matrix_Multiplication_CUDA_1_1T $4
./Matrix_Multiplication_CUDA_1_1T $5
./Matrix_Multiplication_CUDA_1_1T $6
./Matrix_Multiplication_CUDA_1_1T $7
./Matrix_Multiplication_CUDA_1_1T $8
./Matrix_Multiplication_CUDA_1_1T $9
./Matrix_Multiplication_CUDA_1_1T 10000


#
echo "All Done!"
