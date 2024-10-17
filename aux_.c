#include <stdio.h>

void pwr(int arg1, int arg2) {
    int result = 1;
    for (int i = 0; i < arg2; i++) {
        result *= arg1;
    }
    printf("%d ^ %d = %d\n", arg1, arg2, result);
}

void mprn(int MEM[], int idx) {
    printf("MEM[%d] = %d\n", idx, MEM[idx]);
}

void eprn(int R[], int idx) {
    printf("R[%d] = %d\n", idx, R[idx]);
}