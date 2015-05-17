CC = nvcc
FLAGS = -arch sm_20


MM_CUDA_1_1T:Matrix_Multiplication_CUDA_1_1T.cu
	$(CC) $(FLAGS) Matrix_Multiplication_CUDA_1_1T.cu -o MM_CUDA_1_1T

.phony: clean
clean:
	rm -f MM_CUDA_1_1T
