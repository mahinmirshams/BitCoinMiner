#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "common.h"
#include "sha256.h"

void header(unsigned long *prevHash, unsigned char *input, int length, unsigned long timestamp, unsigned long difficulty, unsigned long nonce, unsigned long *res) {
    unsigned long *rootHash;
    sha256(input, length, &rootHash);

    int i;
    //version 02000000: 0000 0010
    for (i = 0; i < 32; i++) {
        res[i] = 0;
    }
    res[6] = 1;
    for (i = 0; i < 256; i++) {
        res[i + 32] = prevHash[i];
    }
    for (i = 0; i < 256; i++) {
        res[i + 288] = rootHash[i];
    }
    //end
    for (i = 0; i < 128; i++) {
        res[i + 544] = 0;
    }
    //timestamp : 00110101100010110000010101010011
    longToBinary(timestamp, res + 544);
    //difficulty
    longToBinary(difficulty, res + 576);
    //nonce
    longToBinary(nonce, res + 576);
}


void add(int *a, const int *b, int s) {

    int i;
    for (i = 0; i < s; i++) {
        a[i] += b[i];
        int j = i;
        while (a[j] > 1) {
            a[j] = 0;
            a[j + 1] += 1;
            j++;
        }
    }
}

int greaterThan(unsigned long *a, unsigned long *b, int length) {
    for (int i = 0; i < length; ++i) {
        if (*(a+i) < *(b+i)) return -1;
    }
    return 1;
}

int main() {
    char *input = (char *) "abcd";

    int i, j;

    unsigned long *hash_value;

    unsigned char msg[1024];

    int length = stringToBinary(input, msg);

    sha256(msg, length, &hash_value);

    unsigned char hash[32];
    binaryToBytes(hash_value, hash);

    printf("input sha256(\"%s\"):\n", input);
    for (i = 0; i < 32; i++) {
        printf("%02x", hash[i]);
    }
    printf("\n\n");

    unsigned long prevHash[256] = {1,0,1,1,1,1,0,0,1,0,1,1,1,0,1,0,1,1,0,1,1,1,0,0,1,0,1,1,1,1,1,0,0,0,0,0,1,1,0,0,0,1,1,1,0,1,1,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    unsigned long targetHash[256] = {1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    unsigned long nonce = 1;
    unsigned long headerHash[256] = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1};

    while (greaterThan(headerHash,targetHash, 256)) {
        header(prevHash, msg, length, 898303315, 1397813529, nonce, headerHash);
        nonce++;
//        break;
    }

    binaryToBytes(hash_value, hash);

    printf("header sha256:\n");
    for (i = 0; i < 32; i++) {
        printf("%02x", hash[i]);
    }

    return 0;
}
