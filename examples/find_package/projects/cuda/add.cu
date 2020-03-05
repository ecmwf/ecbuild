#include "add.h"
#include "kernel_add.h"

void add(int n, float* x, float* y) {
    kernel_add<<<1, 1>>>(n, x, y);
}