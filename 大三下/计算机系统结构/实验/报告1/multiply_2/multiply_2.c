#include <stdlib.h>     
#include <time.h>       
#include <stdio.h>      
#include <sys/time.h>   
#include <arm_neon.h>   

#define N    1000
#define SEED    0x1234

double *g_a, *g_b, *g_c;

void gen_data(void)
{
    unsigned i;
    g_a = (double*)malloc(N * N * sizeof(double));
    g_b = (double*)malloc(N * N * sizeof(double));
    g_c = (double*)malloc(N * N * sizeof(double));
    if (g_a == NULL || g_b == NULL || g_c == NULL) {
        perror("Memory allocation through malloc failed");
        exit(EXIT_FAILURE);
    }
    for (i = 0; i < N*N; i++) {
        // 随机数填充矩阵a,b
        g_a[i] = (double)(SEED * 0.1);
        g_b[i] = (double)(SEED * 0.1);
    }
}

void free_data(void)
{
    free(g_a);
    free(g_b);
    free(g_c);
}

void multiply(void)
{
    unsigned i,j,k;
    for (i = 0; i < N; i++) {   // 矩阵a按行存储
        for (j = 0; j < N; j++) {   // 矩阵b按列存储
            for (k = 0; k < N; k++) {
                g_c[i*N+j] += g_a[i*N+k] * g_b[j*N+k];
            }
        }
    }
}

void print_data(void)
{
    // c的四个角
    printf("%f, %f, %f, %f\n", g_c[0], g_c[N-1], g_c[(N-1)*N], g_c[N*N-1]);
}

int main(void)
{
    double msecs;
    struct timeval before, after;

    gen_data();
    gettimeofday(&before, NULL);
    multiply();
    gettimeofday(&after, NULL);

    // 1000 is used to convert tv_sec and tv_usec to msec.
    msecs = (after.tv_sec - before.tv_sec) * 1000.0 + (after.tv_usec - before.tv_usec) / 1000.0;
    print_data();
    printf("Execution time = %2.3lf ms\n", msecs);

    free_data();
    return 0;
}