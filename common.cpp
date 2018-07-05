#include <stdio.h>
#include <cstring>
#include "common.h"

unsigned char binaryNum[64];

void longToBinary(unsigned long x, unsigned long *res) {
    int i;
    int length = 32;
    for (i = length - 1; i > -1; i--) {
        res[i] = x % 2;
        x /= 2;
    }
}

unsigned char *decimalToBinary(int n) {
    int i;
    for (i = 0; i < 64; i++) {
        binaryNum[i] = 0;
    }

    i = 0;
    while (n > 0) {
        binaryNum[i] = (unsigned char)(n % 2);
        n = n / 2;
        i++;
    }

    return binaryNum;
}

//return length of output binary msg
int stringToBinary(char *msg, unsigned char *res) {

    int i, j;
    for (i = 0; i < strlen(msg); i++) {

        int n = msg[i];
        unsigned char *binaryNum = decimalToBinary(n);

        for (j = 0; j < 8; j++) {
            int x = 7 - j;
            res[i * 8 + j] = binaryNum[x];
        }
    }
    return (int) strlen(msg) * 8;
}

long power(int x, int y) {
    int i;
    long res = 1;
    for (i = 0; i < y; i++) {
        res *= x;
    }
    return res;
}

void binaryToBytes(const unsigned long *binary, unsigned char *result) {
    int i, j;
    for (i = 0; i < 32; i++) {
        unsigned long byte = 0;
        for (j = 7; j >= 0; j--) {
            byte += power(2, 7 - j) * binary[i*8+j];
        }
        result[i] = (unsigned char)byte;
    }
}
