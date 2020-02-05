#pragma once

// CUDA Kernel function to add the elements of two arrays on the GPU
__global__ void kernel_add(int n, float *x, float *y);
