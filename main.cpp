#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "common.h"
#include "sha256.h"

void header(unsigned long *res, const unsigned long *prevHash, const unsigned long *rootHash) {
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
    longToBinary(898303315, res + 544);
    //difficulty
    longToBinary(1397813529, res + 576);
    //nonce ?
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

int main() {
    char *input = (char *) "abcd";

    //padding
    int padding_msg[1024];
    int res[32];
    int block[512];
    int i, j;

    unsigned long *hash_value;
    int header_values[640];

    unsigned char msg[1024];

    int length = stringToBinary(input, msg);

    /**long input_msg = 0;
    for(i=0; i<length; i++){
        input_msg += power(2, i)*msg[i];
    }**/
    int prevHash[256];
    int *rootHash;

    //long rootH;

    int blocks = sha256(msg, length, &hash_value);

    unsigned char hash[32];
    binaryToBytes(hash_value, hash);

    printf("sha256(\"%s\"):\n", input);
    for (i = 0; i < 32; i++) {
        printf("%02x", hash[i]);
    }
    printf("\n\n");

    /**long prevH = 0x17975b97c18ed1f7e255adf297599b55330edab87803c8170100000000000000;
    long_to_binary(prevH,prevHash,256);

    header(header_values,prevHash,rootHash);

    long target = 0x001af34ed4ed31309dfdaff345ff6a2370faddeaaeeff3f31ad3bc32dec3de31;
    //printf("tar:%ud",target);
    long nonce = 0;

    int bnonce[32];
    long hash = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    //long block_header_l = binary_to_long(header_values, 640);

    printf("here");
    while(hash>target){

        add(header_values+608, bnonce, 32); //msb should ckeck

        hash = sha256(sha256(header_values, 512, w, hash_values),
                      512, w, hash_values );
        nonce++;
        long_to_binary(nonce, bnonce, 32);
        printf("\n%d: %ud\n",nonce, hash);
    }**/

    //printf("\n%ud",hash);
    return 0;
}
