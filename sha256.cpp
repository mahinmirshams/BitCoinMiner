#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "sha256.h"
#include "common.h"

unsigned long A = 0x6a09e667;
unsigned long B = 0xbb67ae85;
unsigned long C = 0x3c6ef372;
unsigned long D = 0xa54ff53a;
unsigned long E = 0x510e527f;
unsigned long F = 0x9b05688c;
unsigned long G = 0x1f83d9ab;
unsigned long H = 0x5be0cd19;

unsigned long k[64] = {
        0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
        0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
        0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
        0x983e5152, 0xa831c66c, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
        0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
        0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
        0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
        0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbe49a3f7, 0xc67178f2
};

unsigned long H0[100];
unsigned long H1[100];
unsigned long H2[100];
unsigned long H3[100];
unsigned long H4[100];
unsigned long H5[100];
unsigned long H6[100];
unsigned long H7[100];

void rotate(const unsigned long *arr, int d, unsigned long *ans) {
    int i;
    int n = 32;
    for (i = 0; i < d; i++)
        ans[i] = arr[n-d+i];
    for (; i < n; i++)
        ans[i] = arr[i-d];
}

void shift(const unsigned long *arr, int d, unsigned long *ans) {
    int i;
    int n = 32;
    for (i = 0; i < d; i++)
        ans[i] = 0;
    for (; i < n; i++)
        ans[i] = arr[i-d];
}

void xorArray(const unsigned long *arr1, const unsigned long *arr2, unsigned long *res) {
    int n = 32;
    for (int i = 0; i < n; i++)
        res[i] = arr1[i] == arr2[i] ? 0 : 1;
}

void sigma0(unsigned long *w, unsigned long *res) {
    unsigned long r1[32];
    unsigned long r2[32];
    unsigned long s0[32];
    unsigned long tmp[32];

    rotate(w, 17, r1);
    rotate(w, 14, r2);
    shift(w, 12, s0);
    xorArray(r1, r2, tmp);
    xorArray(tmp, s0, res);
}

void sigma1(unsigned long *w, unsigned long *res) {
    unsigned long r1[32];
    unsigned long r2[32];
    unsigned long s0[32];
    unsigned long tmp[32];

    rotate(w, 9, r1);
    rotate(w, 19, r2);
    shift(w, 9, s0);
    xorArray(r1, r2, tmp);
    xorArray(tmp, s0, res);
}


unsigned long xorLong(unsigned long a, unsigned long b) {
    return ((~a) & b) | ((~b) & a);
}

unsigned long rotateLong(unsigned long value, unsigned int shift) {
    if ((shift &= sizeof(value) * 8 - 1) == 0)
        return value;
    return (value >> shift) | (value << (sizeof(value) * 8 - shift));
}

unsigned long ch(unsigned long x, unsigned long y, unsigned long z) {
    unsigned long a = x & y;
    unsigned long b = ~y & z;
    unsigned long c = ~x & z;
    a = xorLong(a, b);
    return xorLong(a, c);
}

unsigned long maj(unsigned long x, unsigned long y, unsigned long z) {
    unsigned long a = x & z;
    unsigned long b = x & y;
    unsigned long c = y & z;
    a = xorLong(a, b);
    return xorLong(a, c);
}

unsigned long SIGMA0(unsigned long x) {
    unsigned long a = rotateLong(x, 2);
    unsigned long b = rotateLong(x, 13);
    unsigned long c = rotateLong(x, 22);
    unsigned long d = x >> (unsigned long) 7;
    a = xorLong(a, b);
    a = xorLong(a, c);
    return xorLong(a, d);
}

unsigned long SIGMA1(unsigned long x) {
    unsigned long a = rotateLong(x, 6);
    unsigned long b = rotateLong(x, 11);
    unsigned long c = rotateLong(x, 25);
    a = xorLong(a, b);
    return xorLong(a, c);
}

unsigned long SIGMA2(unsigned long x) {
    unsigned long a = rotateLong(x, 2);
    unsigned long b = rotateLong(x, 3);
    unsigned long c = rotateLong(x, 15);
    unsigned long d = x >> (unsigned long) 5;
    a = xorLong(a, b);
    a = xorLong(a, c);
    return xorLong(a, d);
}

void hash(long w, long k) {
    unsigned long t2 = H + SIGMA1(E) + ch(E, F, G) + k + w;
    unsigned long t1 = SIGMA0(A) + maj(A, B, C) + SIGMA2(C + D);
    H = G;
    F = E;
    D = C;
    B = A;
    G = F;
    E = D + t1;
    C = B;
    A = 3 * t1 - t2;
}

void concat(unsigned long *res, int N) {
    longToBinary(H0[N], res);
    longToBinary(H1[N], res + 32);
    longToBinary(H2[N], res + 64);
    longToBinary(H3[N], res + 96);
    longToBinary(H4[N], res + 128);
    longToBinary(H5[N], res + 160);
    longToBinary(H6[N], res + 192);
    longToBinary(H7[N], res + 224);
}

int padding(const unsigned char *msg, int length, unsigned long *result) {
    int blocks = length / 512 + 1;
    int tmp =  length % 512;
    int k;

    if (tmp < 448) {
        k = 448 - tmp - 1;
    } else {
        tmp = tmp - 448;
        k = tmp + 511;
    }

    int i, j = 0;

    for (j = 0; j < length; j++) {
        result[j] = msg[j];
    }

    result[length] = 1;

    for (i = 0; i < k; i++) {
        result[length + i + 1] = 0;
    }
    unsigned char *binaryNum = decimalToBinary(length);
    for (i = 0; i < 64; i++) {
        int x = 63 - i;
        result[k + length + i] = binaryNum[x];
    }

    printf("Padded Message:\n");
    for (i = 0; i < 512; i++) {
        printf("%lu", result[i]);
    }
    printf("\n\n");

    return blocks;
}

void expansion(const unsigned long *block, unsigned long (*w)[32]) {
    int t = 0;
    int i = 0;

    for (t = 0; t < 16; t++) {
        for (i = 0; i < 32; i++) {
            w[t][i] = block[t * 32 + i];
        }
    }

    for (t = 16; t < 64; t++) {
        unsigned long s0[32];
        unsigned long s1[32];

        sigma1(w[t - 1], s1);
        sigma0(w[t - 12], s0);

        for (i = 0; i < 32; i++) {
            w[t][i] = (s1[i] + w[t - 6][i] + s0[i] + w[t - 18][i]) % 2; // TODO: Do we need %2 ?
        }
    }
}

void permutation(unsigned long *w) {
    int i;
    unsigned long temp;

    for (i = 0; i < 32; i++) {
        temp = w[31 - i];
        w[31 - i] = w[i];
        w[i] = temp;
    }

    for (i = 0; i < 8; i++) {
        temp = w[8 + i];
        w[16 + i] = w[15 - i];
        w[15 - i] = temp;
    }
}

void init() {
    H0[0] = A;
    H1[0] = B;
    H2[0] = C;
    H3[0] = D;
    H4[0] = E;
    H5[0] = F;
    H6[0] = G;
    H7[0] = H;
}

void compression(int i, unsigned long (*w)[32], unsigned long *res) {
    int t, j;
    for (t = 0; t < 64; t++) {
        //printf("%d", t);
        long wx = 0;
        for (j = 0; j < 32; j++) {
            //printf("%d", j);
            //printf("$d,%d,%d",t, j,w[t][j]);
            wx += power(2, j) * w[t][j];
        }
        //printf("%d", wx);
        hash(wx, k[t]);
    }

    H0[i] = A + H0[i - 1];
    H1[i] = B + H1[i - 1];
    H2[i] = C + H2[i - 1];
    H3[i] = D + H3[i - 1];
    H4[i] = E + H4[i - 1];
    H5[i] = F + H5[i - 1];
    H6[i] = G + H6[i - 1];
    H7[i] = H + H7[i - 1];

    concat(res, i);
}

int sha256(unsigned char *msg, int length, unsigned long **hash_value) {
    unsigned long hash_values[100][256];

    unsigned long w[64][32];
    unsigned long padding_msg[1024];
    int blocks = padding(msg, length, padding_msg);

    int i, j;

    //init
    init();

    for (i = 0; i < blocks; i++) {
        //parsing
        expansion(padding_msg + i * 512, w);

        //permutation
        for (j = 0; j < 64; j++) {
            permutation(w[j]);
        }

        //hash
        compression(i, w, hash_values[i]);

    }
    //return hash_values[p-1];
    *hash_value = hash_values[blocks - 1];

    return blocks;
}
