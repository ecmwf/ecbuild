#include "kernel_add.h"

// CUDA Kernel function to add the elements of two arrays on the GPU
__global__ void kernel_add(int n, float *x, float *y)
{
  for (int i = 0; i < n; i++)
      y[i] = x[i] + y[i];
}
