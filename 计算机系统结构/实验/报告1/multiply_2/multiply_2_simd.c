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
    float64x2_t srca1,srca2,srcb1,srcb2,tmp1,tmp2,dst1,dst2;
    for (i = 0; i < N; i++) {   // 矩阵a按行存储
        for (j = 0; j < N; j++) {   // 矩阵b按列存储
            dst1 = vdupq_n_f64(0.0f);
            dst2 = vdupq_n_f64(0.0f);
            for (k = 0; k < (N & ((~(unsigned)0x3))); k+=4) {
                srca1 = vld1q_f64(g_a + i*N+k);
                srca2 = vld1q_f64(g_a + i*N+k+2);
                srcb1 = vld1q_f64(g_b + j*N+k);
                srcb2 = vld1q_f64(g_b + j*N+k+2);
                tmp1 = vmulq_f64(srca1, srcb1);
                tmp2 = vmulq_f64(srca2, srcb2);
                dst1 = vaddq_f64(tmp1,dst1);
                dst2 = vaddq_f64(tmp2,dst2);
            }
            g_c[i*N+j] = vgetq_lane_f64(dst1,0) + vgetq_lane_f64(dst1,1) + vgetq_lane_f64(dst2,0) + vgetq_lane_f64(dst2,0);
            for (; k < N; k++){
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